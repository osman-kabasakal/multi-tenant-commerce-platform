namespace SaasManager.Application.Common.Models.Security;

public record CardData
{
    public string Number { get; init; } = null!;
    public string Cvv { get; init; } = null!;
    public string ExpiryMonth { get; init; } = null!;
    public string ExpiryYear { get; init; } = null!;
    public string CardHolderName { get; init; } = null!;

    public bool IsValid()
    {
        return !string.IsNullOrEmpty(Number) 
               && Number.Length is >= 13 and <= 19
               && !string.IsNullOrEmpty(Cvv)
               && Cvv.Length is >= 3 and <= 4;
    }
}
