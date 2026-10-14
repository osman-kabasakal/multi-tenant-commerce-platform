namespace SaasManager.Domain.Events.Registration;

public class EmailVerificationCodeVerifiedEvent(Guid guestId, string email) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public string Email { get; } = email;
    public DateTime VerifiedAt { get; } = DateTime.UtcNow;
}