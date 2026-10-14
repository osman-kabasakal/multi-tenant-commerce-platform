namespace SaasManager.Domain.Events.Registration;

public class MaxSubscriptionAttemptsReachedEvent(Guid guestId) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
}