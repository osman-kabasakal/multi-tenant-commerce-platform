using System.Globalization;
using System.Security.Cryptography;
using System.Text.Json;
using Core.Utilities;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Application.Common.Security;

namespace SaasManager.Infrastructure.Security;

/// <summary>Explicit v1 card envelope using the selected shared encryption engine. CVV is never persisted.</summary>
public sealed class PlatformCardDataProtector(ITenantEncryptionService encryption, IWorkContext context) : ICardDataProtector
{
    private const string Prefix = "pcard:v1:";
    private const string Identifier = "platform-card-v1";
    private sealed record Payload(string BusinessId, string Number, string Month, string Year, string Holder);

    private string Business()
    {
        var id = BusinessOwnerContext.BusinessId(context);
        if (id == null || id == Guid.Empty) throw new InvalidOperationException("A registration business is required for card protection.");
        return id.Value.ToString("N");
    }

    public async Task<EncryptedCardData> EncryptAsync(CardData cardData)
    {
        if (!await ValidateAsync(cardData)) throw new ArgumentException("Invalid card data.");
        var business = Business();
        var payload = new Payload(business, cardData.Number, cardData.ExpiryMonth, cardData.ExpiryYear, cardData.CardHolderName);
        var cipher = await encryption.EncryptAsync(JsonSerializer.Serialize(payload), "saas-cards/v1/" + business);
        return new EncryptedCardData {
            EncryptedNumber = Prefix + cipher, KeyIdentifier = Identifier,
            LastFourDigits = cardData.Number[^4..], MaskedNumber = cardData.Number.MaskCardNumber(),
            CardType = cardData.Number.GetCardBrand(), ExpiryMonth = cardData.ExpiryMonth,
            ExpiryYear = cardData.ExpiryYear, CardHolderName = cardData.CardHolderName
        };
    }

    public async Task<CardData> DecryptAsync(EncryptedCardData data)
    {
        ArgumentNullException.ThrowIfNull(data);
        if (data.KeyIdentifier != Identifier || string.IsNullOrEmpty(data.EncryptedNumber) || !data.EncryptedNumber.StartsWith(Prefix, StringComparison.Ordinal))
            throw new CryptographicException("Unsupported card envelope. Existing card data requires its original provider and an explicit migration.");
        var business = Business();
        var json = await encryption.DecryptAsync(data.EncryptedNumber[Prefix.Length..], "saas-cards/v1/" + business);
        var value = JsonSerializer.Deserialize<Payload>(json) ?? throw new CryptographicException("Invalid card envelope.");
        if (value.BusinessId != business || value.Number.Length < 4 || value.Number[^4..] != data.LastFourDigits ||
            value.Month != data.ExpiryMonth || value.Year != data.ExpiryYear || value.Holder != data.CardHolderName ||
            value.Number.MaskCardNumber() != data.MaskedNumber || value.Number.GetCardBrand() != data.CardType)
            throw new CryptographicException("Card envelope metadata does not match its authenticated contents.");
        return new CardData { Number = value.Number, ExpiryMonth = value.Month, ExpiryYear = value.Year, CardHolderName = value.Holder, Cvv = "" };
    }

    public Task<string> GetLastFourDigitsAsync(EncryptedCardData data)
    {
        ArgumentNullException.ThrowIfNull(data);
        return Task.FromResult(data.LastFourDigits);
    }

    public Task<bool> ValidateAsync(CardData card)
    {
        if (BusinessOwnerContext.BusinessId(context) == null || card == null || string.IsNullOrWhiteSpace(card.CardHolderName) || card.CardHolderName.Length > 200 ||
            card.Number == null || card.Number.Length is < 13 or > 19 || !card.Number.All(char.IsAsciiDigit) ||
            card.Cvv == null || card.Cvv.Length is < 3 or > 4 || !card.Cvv.All(char.IsAsciiDigit) ||
            !int.TryParse(card.ExpiryMonth, NumberStyles.None, CultureInfo.InvariantCulture, out var month) || month is < 1 or > 12 ||
            !int.TryParse(card.ExpiryYear, NumberStyles.None, CultureInfo.InvariantCulture, out var year) || card.ExpiryYear.Length is not (2 or 4))
            return Task.FromResult(false);
        if (year < 100) year += 2000;
        var today = DateTime.UtcNow;
        if (year < today.Year || year == today.Year && month < today.Month || year > today.Year + 30) return Task.FromResult(false);
        var sum = 0; var doubled = false;
        for (var i = card.Number.Length - 1; i >= 0; i--)
        {
            var digit = card.Number[i] - '0';
            if (doubled) { digit *= 2; if (digit > 9) digit -= 9; }
            sum += digit; doubled = !doubled;
        }
        return Task.FromResult(sum % 10 == 0);
    }
}
