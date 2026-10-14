using System.Net;
using System.Net.Mail;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Email;

namespace SaasManager.Infrastructure.Email;

public class EmailService: IEmailService
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<EmailService> _logger;

    public EmailService(IConfiguration configuration, ILogger<EmailService> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    public async Task SendVerificationEmailAsync(string to, string code)
    {
        try
        {
            using SmtpMailClient smtpClient = new SmtpMailClient(_configuration["Email:Username"]!,
                _configuration["Email:Password"]!,
                _configuration["Email:Host"]!,
                int.Parse(_configuration["Email:Port"]!));
            
            var message = new MailMessage
            {
                From = new MailAddress(_configuration["Email:From"]!, _configuration["Email:FromName"]),
                Subject = "Email Doğrulama Kodu",
                Body = $@"
                    <html>
                    <body style='font-family: Arial, sans-serif;'>
                        <h2>Email Adresinizi Doğrulayın</h2>
                        <p>Merhaba,</p>
                        <p>Email doğrulama kodunuz: <strong style='font-size: 24px;'>{code}</strong></p>
                        <p>Bu kod 5 dakika süreyle geçerlidir.</p>
                        <p>Eğer bu işlemi siz yapmadıysanız, lütfen bu emaili dikkate almayın.</p>
                        <br>
                        <p>Saygılarımızla,<br>SaaS E-ticaret Platformu</p>
                    </body>
                    </html>",
                IsBodyHtml = true
            };
            
            message.To.Add(to);
            
            await smtpClient.TryAlternativePortAsync(
                to,
                message.Subject,
                message.Body,
                isHtml:true
                );
            
            _logger.LogInformation("Verification email sent to {Email}", to);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error sending verification email to {Email}", to);
            throw;
        }
    }

    public async Task SendWelcomeEmailAsync(string to, string name)
    {
        try
        {
            using SmtpMailClient smtpClient = new SmtpMailClient(_configuration["Email:Username"]!,
                _configuration["Email:Password"]!,
                _configuration["Email:Host"]!,
                int.Parse(_configuration["Email:Port"]!));
            
            var message = new MailMessage
            {
                From = new MailAddress(_configuration["Email:From"]!, _configuration["Email:FromName"]!),
                Subject = "Hoş Geldiniz",
                Body = $@"
                    <html>
                    <body style='font-family: Arial, sans-serif;'>
                        <h2>Hoş Geldiniz!</h2>
                        <p>Merhaba {name},</p>
                        <p>Platformumuza hoş geldiniz. Hesabınız başarıyla oluşturuldu.</p>
                        <p>Herhangi bir sorunuz olursa bizimle iletişime geçebilirsiniz.</p>
                        <br>
                        <p>Saygılarımızla,<br>SaaS E-ticaret Platformu</p>
                    </body>
                    </html>",
                IsBodyHtml = true
            };
            
            message.To.Add(to);
            
            await smtpClient.SendEmailAsync(
                to,
                message.Subject,
                message.Body,
                isHtml:true
            );
            
            _logger.LogInformation("Welcome email sent to {Email}", to);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error sending welcome email to {Email}", to);
            throw;
        }
    }
}
