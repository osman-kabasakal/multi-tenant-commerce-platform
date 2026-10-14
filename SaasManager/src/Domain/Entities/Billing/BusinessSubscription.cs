using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.Billing;

public class BusinessSubscription : AuditableEntity
{
    public Guid BusinessId { get; private set; }
    public Guid PlanId { get; private set; }
    public DateTime StartDate { get; private set; }
    public DateTime EndDate { get; private set; }
    public SubscriptionStatus Status { get; private set; }
    public decimal Amount { get; private set; }
    public PaymentPeriod Period { get; private set; }
    public bool IsTrial { get; private set; }
    public DateTime? TrialEndsAt { get; private set; }
    public Guid? PreviousPlanId { get; private set; }

    // Navigation Properties
    public Business Business { get; private set; } = null!;
    public SubscriptionPlan Plan { get; private set; } = null!;
    public SubscriptionPlan? PreviousPlan { get; private set; } = null!;

    // Constructor for EF Core
    protected BusinessSubscription() { }

    public BusinessSubscription(
        Guid businessId,
        Guid planId,
        DateTime startDate,
        DateTime endDate,
        decimal amount,
        PaymentPeriod period,
        bool isTrial = false,
        DateTime? trialEndsAt = null,
        Guid? previousPlanId = null)
    {
        BusinessId = businessId;
        PlanId = planId;
        StartDate = startDate;
        EndDate = endDate;
        Amount = amount;
        Period = period;
        Status = SubscriptionStatus.Active;
        IsTrial = isTrial;
        TrialEndsAt = trialEndsAt;
        PreviousPlanId = previousPlanId;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    // Domain methods
    public void Extend(DateTime newEndDate)
    {
        EndDate = newEndDate;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateStatus(SubscriptionStatus newStatus)
    {
        Status = newStatus;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateAmount(decimal newAmount)
    {
        Amount = newAmount;
        UpdatedAt = DateTime.UtcNow;
    }

    public void EndTrial()
    {
        if (IsTrial)
        {
            IsTrial = false;
            TrialEndsAt = DateTime.UtcNow;
            UpdatedAt = DateTime.UtcNow;
        }
    }

    public bool IsExpired()
    {
        return DateTime.UtcNow > EndDate;
    }

    public bool IsTrialExpired()
    {
        return IsTrial && TrialEndsAt.HasValue && DateTime.UtcNow > TrialEndsAt;
    }

    public void Cancel(DateTime? effectiveDate = null)
    {
        Status = SubscriptionStatus.Cancelled;
        if (effectiveDate.HasValue)
        {
            EndDate = effectiveDate.Value;
        }

        UpdatedAt = DateTime.UtcNow;
    }
}
