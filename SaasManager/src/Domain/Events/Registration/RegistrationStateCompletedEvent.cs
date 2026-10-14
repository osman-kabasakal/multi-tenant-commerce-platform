namespace SaasManager.Domain.Events.Registration;

public class RegistrationStateCompletedEvent(Guid stateId, string stateKey) : BaseEvent
{
    public Guid StateId { get; } = stateId;
    public string StateKey { get; } = stateKey;
    public DateTime CompletedAt { get; } = DateTime.UtcNow;
}