using System.Text.Json;
using Azure.Security.KeyVault.Secrets;
using Core.Utilities;
using FluentValidation.Results;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Exceptions;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.Security;
using SecurityException = SaasManager.Application.Common.Exceptions.SecurityException;

namespace SaasManager.Infrastructure.Security;

public class AzureKeyVaultCardProtector: ICardDataProtector
{
    private readonly SecretClient _secretClient;
    private readonly IKeyVaultService _keyVaultService;
    private readonly ILogger<AzureKeyVaultCardProtector> _logger;
    private const string CARD_KEY_NAME = "card-encryption-key";

    public AzureKeyVaultCardProtector(
        SecretClient secretClient,
        IKeyVaultService keyVaultService,
        ILogger<AzureKeyVaultCardProtector> logger)
    {
        _secretClient = secretClient;
        _keyVaultService = keyVaultService;
        _logger = logger;
    }

    public async Task<EncryptedCardData> EncryptAsync(CardData cardData)
    {
        try
        {
            if (!cardData.IsValid())
                throw new ValidationException([new ValidationFailure("","Invalid card data")]);

            // Key Vault'tan encryption key'i al
            var key = await _keyVaultService.GetLatestKeyAsync(CARD_KEY_NAME);

            // Kart numarasının son 4 hanesini kaydet
            var lastFour = cardData.Number.Substring(cardData.Number.Length - 4);
            
            // Kart tipini belirle (Visa, MasterCard, etc.)
            var cardType =cardData.Number.GetCardBrand();

            // PCI DSS gereksinimleri: Sadece kart numarasını ve CVV'yi şifrele
            var sensitiveData = new
            {
                cardData.Number,
                cardData.Cvv
            };

            var serializedData = JsonSerializer.Serialize(sensitiveData);
            var encryptedData = await _keyVaultService.EncryptAsync(key, serializedData);

            return new EncryptedCardData
            {
                EncryptedNumber = encryptedData,
                LastFourDigits = lastFour,
                CardType = cardType,
                ExpiryMonth = cardData.ExpiryMonth,
                ExpiryYear = cardData.ExpiryYear,
                CardHolderName = cardData.CardHolderName,
                KeyIdentifier = key.Properties.Version,
                MaskedNumber = cardData.Number.MaskCardNumber()
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error encrypting card data");
            throw new SecurityException("Failed to secure card data", ex);
        }
    }

    public async Task<CardData> DecryptAsync(EncryptedCardData encryptedData)
    {
        try
        {
            // Key versiyonuna göre doğru key'i al
            var key = await _keyVaultService.GetKeyVersionAsync(CARD_KEY_NAME, encryptedData.KeyIdentifier);
            
            var decryptedJson = await _keyVaultService.DecryptAsync(key, encryptedData.EncryptedNumber);
            var sensitiveData = JsonSerializer.Deserialize<dynamic>(decryptedJson);

            return new CardData
            {
                Number = sensitiveData?.Number as string ?? throw new InvalidOperationException(),
                Cvv = sensitiveData?.Cvv as string ?? throw new InvalidOperationException(),
                ExpiryMonth = encryptedData.ExpiryMonth,
                ExpiryYear = encryptedData.ExpiryYear,
                CardHolderName = encryptedData.CardHolderName
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error decrypting card data");
            throw new SecurityException("Failed to access secured card data", ex);
        }
    }

    public Task<string> GetLastFourDigitsAsync(EncryptedCardData encryptedData)
    {
        if (encryptedData == null)
            throw new ArgumentNullException(nameof(encryptedData));

        // LastFourDigits zaten şifrelenmemiş olarak tutulduğu için
        // direkt olarak dönebiliriz
        return Task.FromResult(encryptedData.LastFourDigits);
    }
    
    public Task<bool> ValidateAsync(CardData cardData)
    {
        if (cardData == null)
            throw new ArgumentNullException(nameof(cardData));

        try
        {
            // Luhn algoritması ile kart numarası validasyonu
            // if (!IsValidCardNumber(cardData.Number))
            //     return Task.FromResult(false);

            // Geçerlilik tarihi kontrolü
            if (!IsValidExpiryDate(cardData.ExpiryMonth, cardData.ExpiryYear))
                return Task.FromResult(false);

            // CVV uzunluk kontrolü (kart tipine göre 3 veya 4 haneli olabilir)
            if (!IsValidCvv(cardData.Cvv, cardData.Number.GetCardBrand()))
                return Task.FromResult(false);

            // Kart sahibi adı kontrolü
            if (string.IsNullOrWhiteSpace(cardData.CardHolderName))
                return Task.FromResult(false);

            return Task.FromResult(true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error validating card data");
            return Task.FromResult(false);
        }
    }

    private bool IsValidCardNumber(string cardNumber)
    {
        if (string.IsNullOrWhiteSpace(cardNumber))
            return false;

        // Sadece rakamları al
        var digits = cardNumber.Where(char.IsDigit).ToArray();

        if (digits.Length < 13 || digits.Length > 19)
            return false;

        // Luhn algoritması (mod 10)
        int sum = 0;
        bool isEven = false;

        // Sağdan sola doğru işlem yap
        for (int i = digits.Length - 1; i >= 0; i--)
        {
            int digit = digits[i] - '0';

            if (isEven)
            {
                digit *= 2;
                if (digit > 9)
                    digit -= 9;
            }

            sum += digit;
            isEven = !isEven;
        }

        return sum % 10 == 0;
    }

    private bool IsValidExpiryDate(string month, string year)
    {
        if (!int.TryParse(month, out int expiryMonth) || 
            !int.TryParse(year, out int expiryYear))
            return false;

        // 2 haneli yıl formatını 4 haneye çevir
        if (expiryYear < 100)
            expiryYear += 2000;

        var today = DateTime.UtcNow;
        var expiryDate = new DateTime(expiryYear, expiryMonth, 1).AddMonths(1).AddDays(-1);

        // Geçerlilik tarihi bugünden sonra olmalı
        return expiryDate > today;
    }

    private bool IsValidCvv(string cvv, string cardType)
    {
        if (string.IsNullOrWhiteSpace(cvv))
            return false;

        // Sadece rakamlardan oluşmalı
        if (!cvv.All(char.IsDigit))
            return false;

        // American Express için 4 haneli, diğerleri için 3 haneli
        return cardType == "AmericanExpress" 
            ? cvv.Length == 4 
            : cvv.Length == 3;
    }
}
