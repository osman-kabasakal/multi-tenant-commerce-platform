namespace SaasManager.Application.Common.Models.PaymentProviders;

public class CardTokenResponse
{
    public string Token { get; set; } = null!;
    public string LastFour { get; set; } = null!;
    public string CardBrand { get; set; } = null!;
    public string CardType { get; set; } = null!;
    public DateTime ExpiryDate { get; set; }

    public Dictionary<string, string> CustomProperties { get; set; } = new Dictionary<string, string>();
}
