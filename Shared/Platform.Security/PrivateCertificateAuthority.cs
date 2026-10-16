using System.Security.Cryptography.X509Certificates;

namespace Platform.Security;

/// <summary>Explicit per-client CA trust without replacing TLS name or signature validation.</summary>
public static class PrivateCertificateAuthority
{
    public static SocketsHttpHandler? CreateHandler(string? certificateFile)
    {
        if (string.IsNullOrWhiteSpace(certificateFile)) return null;
        if (!Path.IsPathFullyQualified(certificateFile) || !File.Exists(certificateFile) || new FileInfo(certificateFile).Length>65536)
            throw new InvalidOperationException("Supply an absolute readable private-CA certificate file.");
        var root=new X509Certificate2(certificateFile);
        if (!root.Extensions.OfType<X509BasicConstraintsExtension>().Any(x=>x.CertificateAuthority) || root.NotBefore.ToUniversalTime()>DateTime.UtcNow || root.NotAfter.ToUniversalTime()<=DateTime.UtcNow)
            throw new InvalidOperationException("The configured trust anchor must be a current CA certificate.");
        var handler=new SocketsHttpHandler {AllowAutoRedirect=false};
        handler.SslOptions.CertificateChainPolicy=new X509ChainPolicy {TrustMode=X509ChainTrustMode.CustomRootTrust,DisableCertificateDownloads=true,
            RevocationMode=handler.SslOptions.CertificateRevocationCheckMode,CustomTrustStore={root},
            ApplicationPolicy={new System.Security.Cryptography.Oid("1.3.6.1.5.5.7.3.1")}};
        return handler;
    }
}
