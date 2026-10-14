namespace SaasManager.Domain.Events.Registration;

public class MaxVerificationAttemptsReachedEvent(Guid guestId) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public DateTime OccurredAt { get; } = DateTime.UtcNow;
}
