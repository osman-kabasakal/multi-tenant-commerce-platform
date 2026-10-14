namespace SaasManager.Application.Common.Models.SubscriptionPlans;

public class SubscriptionPlanDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public string Description { get; set; } = string.Empty;
    public List<string> Features { get; set; } = new();
    public int MaxProducts { get; set; }
    public int MaxUsers { get; set; }
    public int MaxMonthlyOrders { get; set; }
    public bool HasPos { get; set; }
    public bool HasCourier { get; set; }
    public bool IsPublic { get; set; }
    public int TrialDays { get; set; }
    public decimal SetupFee { get; set; }
    public int MaxCouriers { get; set; }
    public int MaxLocations { get; set; }
    public int SupportPriority { get; set; }
}
