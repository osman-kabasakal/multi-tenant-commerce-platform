using System.Net;
using System.Net.Mail;

namespace SaasManager.Infrastructure.Email;

public class SmtpMailClient(string senderEmail, 
    string password,
    string smtpHost,
    int smtpPort) : IDisposable
{
    private readonly SmtpClient _smtpClient = new()
    {
        Host = smtpHost,
        Port = smtpPort, // Eğer çalışmazsa 587 denenebilir
        EnableSsl = true,
        DeliveryMethod = SmtpDeliveryMethod.Network,
        UseDefaultCredentials = false,
        Credentials = new NetworkCredential(senderEmail, password),
        Timeout = 2000 // 30 saniye timeout
    };

    private bool _disposed;

    //
    // // SSL/TLS sertifika doğrulama callback'i
    // ServicePointManager.ServerCertificateValidationCallback = 
    //     delegate(object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };
    // Eğer çalışmazsa 587 denenebilir
    // 30 saniye timeout

    public async Task<(bool Success, string Message)> SendEmailAsync(
        string to, 
        string subject, 
        string body, 
        bool isHtml = false)
    {
        try
        {
            using var mailMessage = new MailMessage
            {
                From = new MailAddress(senderEmail),
                Subject = subject,
                Body = body,
                IsBodyHtml = isHtml
            };
            
            mailMessage.To.Add(to);

            // Debug bilgisi
            Console.WriteLine($"Attempting to send email from {senderEmail} to {to}");
            
            await _smtpClient.SendMailAsync(mailMessage);
            Console.WriteLine("Email sent successfully");
            
            return (true, "Email başarıyla gönderildi");
        }
        catch (SmtpException ex)
        {
            var error = $"SMTP Error: {ex.StatusCode} - {ex.Message}";
            Console.WriteLine(error);
            return (false, error);
        }
        catch (Exception ex)
        {
            var error = $"Error sending email: {ex.Message}";
            Console.WriteLine(error);
            return (false, error);
        }
    }

    public async Task<(bool Success, string Message)> TryAlternativePortAsync(
        string to, 
        string subject, 
        string body, 
        bool isHtml = false)
    {
        // İlk port başarısız olursa alternatif portları dene
        int[] alternativePorts = { 587, 25 };

        foreach (var port in alternativePorts)
        {
            try
            {
                _smtpClient.Port = port;
                Console.WriteLine($"Trying port {port}...");
                
                var result = await SendEmailAsync(to, subject, body, isHtml);
                if (result.Success)
                {
                    return (true, $"Email port {port} üzerinden başarıyla gönderildi");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Port {port} failed: {ex.Message}");
                continue;
            }
        }

        return (false, "Tüm portlar denendi fakat email gönderilemedi");
    }

    protected virtual void Dispose(bool disposing)
    {
        if (!_disposed)
        {
            if (disposing)
            {
                _smtpClient?.Dispose();
            }
            _disposed = true;
        }
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }
}
