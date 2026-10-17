using System.Net;
using System.Net.Security;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using Grand.Business.Core.Interfaces.Messages;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Business.Messages.Services;
using Grand.Domain.Messages;
using Grand.Domain.Stores;
using Grand.Infrastructure;
using Moq;
using Platform.Security;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace LocalDemo.Tests;

[TestClass]
public class SmtpTransportTests
{
    [TestMethod]
    public async Task StartTlsDiscardsInjectedPlaintextCapabilitiesBeforeReadingTheTlsResponse()
    {
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(15));
        using var rsa = RSA.Create(2048);
        var request = new CertificateRequest("CN=localhost", rsa, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
        using var certificate = request.CreateSelfSigned(DateTimeOffset.UtcNow.AddMinutes(-1), DateTimeOffset.UtcNow.AddMinutes(10));
        using var listener = new TcpListener(IPAddress.Loopback, 0);
        listener.Start();
        var port = ((IPEndPoint)listener.LocalEndpoint).Port;
        var server = ServeAsync(listener, certificate, timeout.Token);
        using var client = new SmtpClient();
        // Trust only this test's in-memory certificate; production uses normal certificate validation.
        client.ServerCertificateValidationCallback = (_, peer, _, _) => peer != null &&
            peer.GetCertHashString() == certificate.GetCertHashString();
        try
        {
            await client.ConnectAsync("127.0.0.1", port, SecureSocketOptions.StartTls, timeout.Token);
            Assert.IsTrue(client.IsSecure);
            Assert.IsTrue(client.AuthenticationMechanisms.Contains("SCRAM-SHA-256"), "TLS capabilities must come from the authenticated stream.");
            Assert.IsFalse(client.AuthenticationMechanisms.Contains("PLAIN"));
            Assert.IsFalse(client.AuthenticationMechanisms.Contains("LOGIN"));
            await client.DisconnectAsync(false, timeout.Token);
            await server;
        }
        finally
        {
            await timeout.CancelAsync();
            listener.Stop();
            try { await server; }
            catch (Exception) when (timeout.IsCancellationRequested) { }
        }
    }

    [TestMethod]
    public async Task TheRealTenantEmailSenderUsesOnlyTheCurrentStoresSecret()
    {
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(15));
        using var listener = new TcpListener(IPAddress.Loopback, 0);
        listener.Start();
        const string store = "111111111111111111111111";
        var password = Convert.ToHexString(RandomNumberGenerator.GetBytes(24));
        var secrets = new Mock<ITenantSecrets>(MockBehavior.Strict);
        secrets.Setup(value => value.GetAsync(store, TenantSecretNames.StoreSmtpPassword, default)).ReturnsAsync(password);
        var context = new Mock<IWorkContext>();
        context.SetupGet(value => value.CurrentStore).Returns(new Store { Id = store });
        var sender = new EmailSender(Mock.Of<IDownloadService>(), Mock.Of<IMimeMappingService>(), secrets.Object, context.Object);
        var account = new EmailAccount { Host = "127.0.0.1", Port = ((IPEndPoint)listener.LocalEndpoint).Port,
            Username = "fixture-user", Password = "platform-secret:" + TenantSecretNames.StoreSmtpPassword,
            SecureSocketOptionsId = (int)SecureSocketOptions.None };
        // This account and plaintext connection exist only inside this owned loopback fixture.
        var server = ReceiveMessageAsync(listener, password, timeout.Token);
        try
        {
            await sender.SendEmail(account, "Owned tenant mail", "<p>Owned loopback body</p>",
                "sender@example.invalid", "Fixture", "recipient@example.invalid", "Recipient").WaitAsync(timeout.Token);
            var message = await server;
            StringAssert.Contains(message, "Subject: Owned tenant mail");
            StringAssert.Contains(message, "Owned loopback body");
            secrets.Verify(value => value.GetAsync(store, TenantSecretNames.StoreSmtpPassword, default), Times.Once);
            secrets.VerifyNoOtherCalls();
        }
        finally
        {
            await timeout.CancelAsync();
            listener.Stop();
            try { await server; }
            catch (Exception) when (timeout.IsCancellationRequested) { }
        }
    }

    [TestMethod]
    public async Task ManagedSmtpWithoutAStoreContextIsRejectedBeforeConnecting()
    {
        var secrets = new Mock<ITenantSecrets>(MockBehavior.Strict);
        var sender = new EmailSender(Mock.Of<IDownloadService>(), Mock.Of<IMimeMappingService>(), secrets.Object, Mock.Of<IWorkContext>());
        var account = new EmailAccount { Host = "127.0.0.1", Port = 0,
            Password = "platform-secret:" + TenantSecretNames.StoreSmtpPassword };
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => sender.SendEmail(account,
            "Owned fixture", "Unused", "sender@example.invalid", "Fixture", "recipient@example.invalid", "Recipient"));
        secrets.VerifyNoOtherCalls();
    }

    private static async Task<string> ReceiveMessageAsync(TcpListener listener, string password, CancellationToken cancellationToken)
    {
        using var connection = await listener.AcceptTcpClientAsync(cancellationToken);
        using var stream = connection.GetStream();
        await SendAsync(stream, "220 owned-smtp-fixture ESMTP\r\n", cancellationToken);
        Assert.IsTrue((await LineAsync(stream, cancellationToken)).StartsWith("EHLO ", StringComparison.Ordinal));
        await SendAsync(stream, "250-owned-smtp-fixture\r\n250 AUTH PLAIN\r\n", cancellationToken);
        var auth = await LineAsync(stream, cancellationToken);
        Assert.IsTrue(auth.StartsWith("AUTH PLAIN ", StringComparison.Ordinal));
        Assert.IsTrue(Encoding.UTF8.GetString(Convert.FromBase64String(auth[11..])) == "\0fixture-user\0" + password);
        await SendAsync(stream, "235 Authentication successful\r\n", cancellationToken);
        Assert.IsTrue((await LineAsync(stream, cancellationToken)).StartsWith("MAIL FROM:<sender@example.invalid>", StringComparison.Ordinal));
        await SendAsync(stream, "250 Sender accepted\r\n", cancellationToken);
        Assert.IsTrue((await LineAsync(stream, cancellationToken)).StartsWith("RCPT TO:<recipient@example.invalid>", StringComparison.Ordinal));
        await SendAsync(stream, "250 Recipient accepted\r\n", cancellationToken);
        Assert.AreEqual("DATA", await LineAsync(stream, cancellationToken));
        await SendAsync(stream, "354 Send owned fixture\r\n", cancellationToken);
        var message = new StringBuilder();
        for (var count = 0; ; count++)
        {
            var line = await LineAsync(stream, cancellationToken);
            if (line == ".") break;
            if (count > 1000) throw new InvalidDataException("Unbounded SMTP fixture message.");
            message.AppendLine(line);
        }
        await SendAsync(stream, "250 Message accepted\r\n", cancellationToken);
        Assert.AreEqual("QUIT", await LineAsync(stream, cancellationToken));
        await SendAsync(stream, "221 Goodbye\r\n", cancellationToken);
        return message.ToString();
    }

    private static async Task ServeAsync(TcpListener listener, X509Certificate2 certificate, CancellationToken cancellationToken)
    {
        using var connection = await listener.AcceptTcpClientAsync(cancellationToken);
        using var plain = connection.GetStream();
        await SendAsync(plain, "220 owned-smtp-fixture ESMTP\r\n", cancellationToken);
        Assert.IsTrue((await LineAsync(plain, cancellationToken)).StartsWith("EHLO ", StringComparison.Ordinal));
        await SendAsync(plain, "250-owned-smtp-fixture\r\n250-STARTTLS\r\n250 AUTH SCRAM-SHA-256\r\n", cancellationToken);
        Assert.AreEqual("STARTTLS", await LineAsync(plain, cancellationToken));
        // One write places the fake post-TLS capability response after the real STARTTLS response.
        await SendAsync(plain, "220 Ready\r\n250-injected-plaintext\r\n250-AUTH PLAIN LOGIN\r\n250 PIPELINING\r\n", cancellationToken);
        using var tls = new SslStream(plain, leaveInnerStreamOpen: true);
        await tls.AuthenticateAsServerAsync(new SslServerAuthenticationOptions { ServerCertificate = certificate }, cancellationToken);
        Assert.IsTrue((await LineAsync(tls, cancellationToken)).StartsWith("EHLO ", StringComparison.Ordinal));
        await SendAsync(tls, "250-owned-smtp-fixture\r\n250-AUTH SCRAM-SHA-256\r\n250 SIZE 10485760\r\n", cancellationToken);
    }

    private static async Task SendAsync(Stream stream, string value, CancellationToken cancellationToken)
    {
        await stream.WriteAsync(Encoding.ASCII.GetBytes(value), cancellationToken);
        await stream.FlushAsync(cancellationToken);
    }

    private static async Task<string> LineAsync(Stream stream, CancellationToken cancellationToken)
    {
        var bytes = new List<byte>();
        var buffer = new byte[1];
        while (await stream.ReadAsync(buffer, cancellationToken) == 1)
        {
            if (buffer[0] == (byte)'\n') return Encoding.ASCII.GetString(bytes.ToArray()).TrimEnd('\r');
            bytes.Add(buffer[0]);
            if (bytes.Count > 4096) throw new InvalidDataException("Unbounded SMTP fixture line.");
        }
        throw new EndOfStreamException("SMTP fixture closed before its expected command.");
    }
}
