namespace SaasManager.Application.Common.Models.PaymentProviders.IyzicoProvider;

public class IyzicoPaymentResult
{
    public bool IsSuccess { get; set; }
    public string? PaymentId { get; set; }
    public string? ErrorMessage { get; set; }
    public string? RawResult { get; set; }
}
