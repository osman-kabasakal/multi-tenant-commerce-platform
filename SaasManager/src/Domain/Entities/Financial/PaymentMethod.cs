using System.Text.Json;
using Microsoft.Extensions.Diagnostics.Metrics;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.Financial;

public class PaymentMethod : AuditableEntity
{
    public Guid BusinessId { get; private set; }
    public Guid ProviderId { get; private set; }
    public string Token { get; private set; } = null!;
    public string LastFour { get; private set; } = null!;
    public string CardBrand { get; private set; } = null!;
    public string CardholderName { get; private set; } = null!;
    public DateTime ExpiryDate { get; private set; }
    public bool IsDefault { get; private set; }
    public bool IsValid { get; private set; }
    public DateTime? LastSuccessfulPaymentAt { get; private set; }
    
    public JsonDocument PaymentProviderData { get; private set; } = null!;

    // Navigation Properties
    public Business Business { get; private set; } = null!;
    public PaymentProvider Provider { get; private set; } = null!;
    public ICollection<Payment> SubscriptionPayments { get; private set; }

    // Constructor for EF Core
    protected PaymentMethod()
    {
        SubscriptionPayments = new List<Payment>();
    }

    public PaymentMethod(
        Guid businessId,
        Guid providerId,
        string token,
        string lastFour,
        string cardBrand,
        string cardholderName,
        DateTime expiryDate)
    {
        BusinessId = businessId;
        ProviderId = providerId;
        Token = token;
        LastFour = lastFour;
        CardBrand = cardBrand;
        CardholderName = cardholderName;
        ExpiryDate = expiryDate;
        IsDefault = false;
        IsValid = true;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
        SubscriptionPayments = new List<Payment>();
    }

    // Domain methods
    public void SetAsDefault()
    {
        IsDefault = true;
        UpdatedAt = DateTime.UtcNow;
    }

    public void MarkAsInvalid()
    {
        IsValid = false;
        UpdatedAt = DateTime.UtcNow;
    }

    public void RecordSuccessfulPayment(JsonDocument paymentProviderData)
    {
        LastSuccessfulPaymentAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
        PaymentProviderData = paymentProviderData;
        IsValid = true;
    }

    public bool IsExpired()
    {
        return DateTime.UtcNow > ExpiryDate;
    }
}
