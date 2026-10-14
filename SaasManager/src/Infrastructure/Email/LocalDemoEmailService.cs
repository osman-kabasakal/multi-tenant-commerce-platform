using System.Text.Json;
using Microsoft.Extensions.Configuration;
using SaasManager.Application.Common.Interfaces.Email;

namespace SaasManager.Infrastructure.Email;

public sealed class LocalDemoEmailService(IConfiguration configuration) : IEmailService
{
    private Task Save(string to, string kind, string content)
    {
        var directory = configuration["LocalDemo:MailDirectory"]
            ?? throw new InvalidOperationException("Local mail directory is required.");
        Directory.CreateDirectory(directory);
        return File.WriteAllTextAsync(Path.Combine(directory, Guid.NewGuid() + ".json"),
            JsonSerializer.Serialize(new { to, kind, content }));
    }
    public Task SendVerificationEmailAsync(string to, string code) => Save(to, "verification", code);
    public Task SendWelcomeEmailAsync(string to, string name) => Save(to, "welcome", name);
}
