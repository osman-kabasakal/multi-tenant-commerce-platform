namespace SaasManager.Domain.Events.Registration;


public class MaxPaymentAttemptsReachedEvent(Guid GuestId) : BaseEvent
{
    public Guid GuestId { get; } = GuestId;
}
