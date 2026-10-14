namespace SaasManager.Domain.Events.Registration;

public class RegistrationStateStartedEvent(
    Guid guestId,
    string stateKey,
    string? previousStateKey = null)
    : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public string StateKey { get; } = stateKey;
    public string? PreviousStateKey { get; } = previousStateKey;
    public DateTime StartedAt { get; } = DateTime.UtcNow;
}