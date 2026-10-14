using SaasManager.Application.Common.Models.Security;

namespace SaasManager.Application.Common.Interfaces.Security;

public interface ICardDataProtector
{
    Task<EncryptedCardData> EncryptAsync(CardData cardData);
    Task<CardData> DecryptAsync(EncryptedCardData encryptedData);
    Task<string> GetLastFourDigitsAsync(EncryptedCardData encryptedData);
    Task<bool> ValidateAsync(CardData cardData);
}
