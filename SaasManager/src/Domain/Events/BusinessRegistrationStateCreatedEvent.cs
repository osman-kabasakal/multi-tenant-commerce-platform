namespace SaasManager.Domain.Events;

public class BusinessRegistrationStateCreatedEvent(Guid guestId) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
}
