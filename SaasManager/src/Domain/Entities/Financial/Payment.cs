using System.Text.Json;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.Financial;

public class Payment : AuditableEntity
{
    public Guid BusinessId { get; private set; }
    public Guid SubscriptionId { get; private set; }
    public Guid PaymentMethodId { get; private set; }
    public Guid ProviderId { get; private set; }
    public decimal Amount { get; private set; }
    public string Currency { get; private set; } = null!;
    public PaymentStatus Status { get; private set; }
    public string ProviderTransactionId { get; private set; } = null!;
    public JsonDocument ProviderResponse { get; private set; } = null!;
    public PaymentType Type { get; private set; }
    public int RetryCount { get; private set; }
    public string ErrorCode { get; private set; } = null!;
    public string ErrorMessage { get; private set; } = null!;

    // Navigation Properties
    public Business Business { get; private set; } = null!;
    public BusinessSubscription Subscription { get; private set; } = null!;
    public PaymentMethod PaymentMethod { get; private set; } = null!;
    public PaymentProvider Provider { get; private set; } = null!;

    // Constructor for EF Core
    protected Payment() { }

    public Payment(
        Guid businessId,
        Guid subscriptionId,
        Guid paymentMethodId,
        Guid providerId,
        decimal amount,
        string currency,
        PaymentType type)
    {
        BusinessId = businessId;
        SubscriptionId = subscriptionId;
        PaymentMethodId = paymentMethodId;
        ProviderId = providerId;
        Amount = amount;
        Currency = currency;
        Type = type;
        Status = PaymentStatus.Pending;
        RetryCount = 0;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    // Domain methods
    public void UpdateStatus(PaymentStatus newStatus)
    {
        Status = newStatus;
        UpdatedAt = DateTime.UtcNow;
    }

    public void SetProviderResponse(
        string transactionId,
        JsonDocument response)
    {
        ProviderTransactionId = transactionId;
        ProviderResponse = response;
        UpdatedAt = DateTime.UtcNow;
    }

    public void IncrementRetryCount()
    {
        RetryCount++;
        UpdatedAt = DateTime.UtcNow;
    }

    public void SetError(string code, string message)
    {
        ErrorCode = code;
        ErrorMessage = message;
        Status = PaymentStatus.Failed;
        UpdatedAt = DateTime.UtcNow;
    }

    public bool CanRetry()
    {
        return Status == PaymentStatus.Failed
               && RetryCount < 3
               && (DateTime.UtcNow - CreatedAt).TotalHours < 24;
    }
}
