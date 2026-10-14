namespace SaasManager.Domain.Events.Registration;

public class GuestRegistrationFailedEvent(
    Guid guestId,
    string stateKey,
    string reason) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public string StateKey { get; } = stateKey;
    public string Reason { get; } = reason;
    public DateTime OccurredAt { get; } = DateTime.UtcNow;
}