using SaasManager.Application.Common.Models.PaymentProviders;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Financial;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.Common.Interfaces.PaymentProviders;

public interface IPaymentProviderFactory
{
    IPaymentProvider GetProvider(string providerCode);
    IPaymentProvider GetDefaultProvider();
    IEnumerable<IPaymentProvider> GetAllProviders();
}

public interface IPaymentProvider
{
    Guid Id { get; }
    string Name { get; }
    string Code { get; }
    PaymentProviderType Type { get; }
    bool IsActive { get; }
    string ConfigurationFingerprint { get; }
    
    Task<CardTokenResponse> CreateCardTokenAsync(CardData request);
    Task<PaymentResponse> ProcessPaymentAsync(BusinessSubscription request, CardData cardModel);
    Task<RefundResponse> ProcessRefundAsync(Payment request);
    Task<bool> ValidateCardAsync(CardData request);
    
    Task<bool> ActivateSubscriptionAsync(PaymentResponse paymentDetail);
}
