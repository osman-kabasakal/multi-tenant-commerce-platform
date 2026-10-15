using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SaasManager.Application.Common.Interfaces.Security;

namespace SaasManager.Infrastructure.Security;

public static class CardProtectionServices
{
    public static IServiceCollection AddCardProtection(this IServiceCollection services, IConfiguration configuration)
    {
        // Selecting the new format is opt-in. No existing ciphertext/key is read, rewritten or rotated here.
        switch (configuration["CardProtection:Provider"] ?? "Disabled")
        {
            case "Disabled": services.AddScoped<ICardDataProtector, DisabledCardDataProtector>(); break;
            case "Platform": services.AddScoped<ICardDataProtector, PlatformCardDataProtector>(); break;
            default: throw new InvalidOperationException("Choose CardProtection:Provider Disabled or Platform explicitly.");
        }
        return services;
    }
}

public sealed class DisabledCardDataProtector : ICardDataProtector
{
    private static NotSupportedException Disabled() => new("Card processing is disabled; configure a card protection and payment provider explicitly.");
    public Task<SaasManager.Application.Common.Models.Security.EncryptedCardData> EncryptAsync(SaasManager.Application.Common.Models.Security.CardData cardData) => throw Disabled();
    public Task<SaasManager.Application.Common.Models.Security.CardData> DecryptAsync(SaasManager.Application.Common.Models.Security.EncryptedCardData data) => throw Disabled();
    public Task<string> GetLastFourDigitsAsync(SaasManager.Application.Common.Models.Security.EncryptedCardData data) => throw Disabled();
    public Task<bool> ValidateAsync(SaasManager.Application.Common.Models.Security.CardData data) => throw Disabled();
}
