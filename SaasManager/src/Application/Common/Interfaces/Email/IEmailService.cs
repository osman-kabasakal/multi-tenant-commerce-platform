namespace SaasManager.Application.Common.Interfaces.Email;

public interface IEmailService
{
    Task SendVerificationEmailAsync(string to, string code);
    Task SendWelcomeEmailAsync(string to, string name);
}
