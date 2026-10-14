using Grand.Business.Core.Utilities.Checkout;
using Grand.Domain.Payments;
using Iyzipay.Model;

namespace Payments.Iyzico.Services;

public interface IIyzicoPayService
{
    Task<List<InstallmentDetail>> GetInstallmentDetailsByBinBumber(string binNumber, double price);
    Task<Card?> GetUserCard(string v);
    Task<List<Card>> GetStoredUserCards();
    Task<ProcessPaymentResult> ProcessPayment(PaymentTransaction paymentTransaction);
    Task ProcessThreeDsPayment(PaymentTransaction paymentTransaction);
    Task<RefundPaymentResult> Refund(RefundPaymentRequest refundPaymentRequest);
    Task<VoidPaymentResult> Void(PaymentTransaction paymentTransaction);
    Task<ProcessPaymentResult> HandlePaymentResponse(PaymentResource payment);
    Task<IList<string>> ValidatePaymentForm(IDictionary<string, string> model);
    Task<PaymentTransaction> SavePaymentInfo(IDictionary<string, string> model);
    Task<ThreedsPayment> CompletePayment(string v1, string v2);
}
