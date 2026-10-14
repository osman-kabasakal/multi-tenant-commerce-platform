using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Security;

namespace SaasManager.Infrastructure.Security;

/// <summary>The local demo never accepts, stores, or processes payment card data.</summary>
public sealed class DisabledDemoCardProtector : ICardDataProtector
{
    private static NotSupportedException Disabled() => new("Card payments are unavailable in the local demo.");
    public Task<EncryptedCardData> EncryptAsync(CardData cardData) => throw Disabled();
    public Task<CardData> DecryptAsync(EncryptedCardData data) => throw Disabled();
    public Task<string> GetLastFourDigitsAsync(EncryptedCardData data) => throw Disabled();
    public Task<bool> ValidateAsync(CardData data) => throw Disabled();
}
