using System.Text.Json;

namespace SaasManager.Domain.Entities.Billing;

public class SubscriptionPlan : AuditableEntity
{
    public string Name { get; private set; } = null!;
    public string Code { get; private set; } = null!;
    public decimal Price { get; private set; }
    public int MaxProducts { get; private set; }
    public int MaxUsers { get; private set; }
    public int MaxMonthlyOrders { get; private set; }
    public bool HasPos { get; private set; }
    public bool HasCourier { get; private set; }
    public JsonDocument Features { get; private set; } = null!;
    public int TrialDays { get; private set; }
    public string Description { get; private set; } = null!;
    public decimal SetupFee { get; private set; }
    public bool IsPublic { get; private set; }
    public int MaxCouriers { get; private set; }
    public int MaxLocations { get; private set; }
    public int SupportPriority { get; private set; }

    // Navigation Properties
    public ICollection<BusinessSubscription> BusinessSubscriptions { get; private set; }

    // Constructor for EF Core
    protected SubscriptionPlan()
    {
        BusinessSubscriptions = new List<BusinessSubscription>();
    }

    public SubscriptionPlan(
        string name,
        string code,
        decimal price,
        int maxProducts,
        int maxUsers,
        int maxMonthlyOrders,
        bool hasPos,
        bool hasCourier,
        JsonDocument features,
        int trialDays,
        string description,
        decimal setupFee,
        bool isPublic,
        int maxCouriers,
        int maxLocations,
        int supportPriority)
    {
        Name = name;
        Code = code;
        Price = price;
        MaxProducts = maxProducts;
        MaxUsers = maxUsers;
        MaxMonthlyOrders = maxMonthlyOrders;
        HasPos = hasPos;
        HasCourier = hasCourier;
        Features = features;
        TrialDays = trialDays;
        Description = description;
        SetupFee = setupFee;
        IsPublic = isPublic;
        MaxCouriers = maxCouriers;
        MaxLocations = maxLocations;
        SupportPriority = supportPriority;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
            
        BusinessSubscriptions = new List<BusinessSubscription>();
    }

    // Domain methods
    public void UpdateDetails(
        string name,
        string description,
        decimal price,
        decimal setupFee)
    {
        Name = name;
        Description = description;
        Price = price;
        SetupFee = setupFee;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateLimits(
        int maxProducts,
        int maxUsers,
        int maxMonthlyOrders,
        int maxCouriers,
        int maxLocations)
    {
        MaxProducts = maxProducts;
        MaxUsers = maxUsers;
        MaxMonthlyOrders = maxMonthlyOrders;
        MaxCouriers = maxCouriers;
        MaxLocations = maxLocations;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateFeatures(
        bool hasPos,
        bool hasCourier,
        JsonDocument features)
    {
        HasPos = hasPos;
        HasCourier = hasCourier;
        Features = features;
        UpdatedAt = DateTime.UtcNow;
        Update();
    }

    public void UpdateAccessibility(
        bool isPublic,
        int trialDays,
        int supportPriority)
    {
        IsPublic = isPublic;
        TrialDays = trialDays;
        SupportPriority = supportPriority;
        UpdatedAt = DateTime.UtcNow;
        Update();
    }

    public void UpdateCode(string code)
    {
        Code = code;
        Update();
    }
}
