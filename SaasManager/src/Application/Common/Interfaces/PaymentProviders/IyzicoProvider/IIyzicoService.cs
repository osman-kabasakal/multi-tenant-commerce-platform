using Iyzipay.Request;
using SaasManager.Application.Common.Models.PaymentProviders.IyzicoProvider;

namespace SaasManager.Application.Common.Interfaces.PaymentProviders.IyzicoProvider;

public interface IIyzicoService
{
    Task<IyzicoPaymentResult> CreatePaymentPreAuthAsync(CreatePaymentRequest request);
    Task<IyzicoPaymentResult> CancelPreAuthAsync(string paymentId);
}
