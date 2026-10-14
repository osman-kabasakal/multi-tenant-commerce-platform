namespace SaasManager.Application.Common.Models.PaymentProviders;

public class CardTokenRequest
{
    public string CardHolderName { get; set; } = null!;
    public string CardNumber { get; set; } = null!;
    public string ExpiryMonth { get; set; } = null!;
    public string ExpiryYear { get; set; } = null!;
    public string Cvv { get; set; } = null!;
}


public class PaymentResponse
{
    public bool IsSuccess { get; set; }
    public string? PaymentId { get; set; }
    public string? ErrorMessage { get; set; }
    public string? RawResult { get; set; }
}


public class RefundResponse
{
    public bool IsSuccess { get; set; }
    
}

public class CreditCardModel
{
    public string? CardHolderName { get; set; }
    public string? CardNumber { get; set; }
    public string? ExpireMonth { get; set; }
    public string? ExpireYear { get; set; }
    public string? Cvc { get; set; }
}
