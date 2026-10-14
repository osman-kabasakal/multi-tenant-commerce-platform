using System.Text.Json;

namespace SaasManager.Domain.Entities.Financial;

public class PaymentProvider : AuditableEntity
{
    public string Name { get; private set; } = null!;
    public string Code { get; private set; } = null!;
    public PaymentProviderType Type { get; private set; }
    public JsonDocument Configuration { get; private set; } = null!;
    public string ApiKey { get; private set; } = null!;
    public string ApiSecret { get; private set; } = null!;
    public string BaseUrl { get; private set; } = null!;
    public bool IsSandbox { get; private set; }
    public decimal CommissionRate { get; private set; }
    public decimal FixedFee { get; private set; }
    public string[] SupportedCurrencies { get; private set; } = null!;
    public int ProcessingTimeoutSeconds { get; private set; }
    public DateTime? LastHealthCheckAt { get; private set; }
    public bool IsHealthy { get; private set; }

    // Navigation Properties
    public ICollection<PaymentMethod> PaymentMethods { get; private set; }
    public ICollection<Payment> Payments { get; private set; } 

    // Constructor for EF Core
    protected PaymentProvider() {
        PaymentMethods = new List<PaymentMethod>();
        Payments = new List<Payment>();
    }

    public PaymentProvider(
        string name,
        string code,
        PaymentProviderType type,
        JsonDocument configuration,
        string apiKey,
        string apiSecret,
        string baseUrl,
        bool isSandbox,
        decimal commissionRate,
        decimal fixedFee,
        string[] supportedCurrencies,
        int processingTimeoutSeconds = 30)
    {
        Name = name;
        Code = code;
        Type = type;
        Configuration = configuration;
        ApiKey = apiKey;
        ApiSecret = apiSecret;
        BaseUrl = baseUrl;
        IsSandbox = isSandbox;
        CommissionRate = commissionRate;
        FixedFee = fixedFee;
        SupportedCurrencies = supportedCurrencies;
        ProcessingTimeoutSeconds = processingTimeoutSeconds;
        IsHealthy = true;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
            
        PaymentMethods = new List<PaymentMethod>();
        Payments = new List<Payment>();
    }

    // Domain methods
    public void UpdateConfiguration(JsonDocument configuration)
    {
        Configuration = configuration;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateCredentials(string apiKey, string apiSecret, string baseUrl)
    {
        ApiKey = apiKey;
        ApiSecret = apiSecret;
        BaseUrl = baseUrl;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateCommissionInfo(decimal commissionRate, decimal fixedFee)
    {
        CommissionRate = commissionRate;
        FixedFee = fixedFee;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateHealthStatus(bool isHealthy)
    {
        IsHealthy = isHealthy;
        LastHealthCheckAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
    }

    public void SetSandboxMode(bool isSandbox)
    {
        IsSandbox = isSandbox;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateSupportedCurrencies(string[] currencies)
    {
        SupportedCurrencies = currencies;
        UpdatedAt = DateTime.UtcNow;
    }

    public decimal CalculateTransactionFee(decimal amount)
    {
        return (amount * CommissionRate / 100) + FixedFee;
    }
}
