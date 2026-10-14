namespace SaasManager.Domain.Events.Registration;

public class GuestRegistrationCompletedEvent(Guid guestId) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public DateTime CompletedAt { get; } = DateTime.UtcNow;
}