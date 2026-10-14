namespace SaasManager.Domain.Events.Registration;

public class SubscriptionPlanSelectedEvent(Guid guestId, Guid planId, bool ısTrial) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public Guid PlanId { get; } = planId;
    public bool IsTrial { get; } = ısTrial;
}
