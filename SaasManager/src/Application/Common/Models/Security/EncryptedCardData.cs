namespace SaasManager.Application.Common.Models.Security;

public record EncryptedCardData
{
    public string EncryptedNumber { get; set; } = null!;
    public string MaskedNumber { get; set; } = null!;
    public string LastFourDigits { get; init; }= null!;
    public string CardType { get; init; }= null!;
    public string ExpiryMonth { get; init; }= null!;
    public string ExpiryYear { get; init; }= null!;
    public string CardHolderName { get; init; }= null!;
    public string KeyIdentifier { get; init; } = null!; // Key Vault'ta kullanılan key'in versiyonu
}
