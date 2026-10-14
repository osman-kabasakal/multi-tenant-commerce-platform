namespace SaasManager.Domain.Events.Registration;

public class EmailVerificationCodeGeneratedEvent(Guid guestId, string email, string verificationToken) : BaseEvent
{
    public Guid GuestId { get; } = guestId;
    public string Email { get; } = email;
    public string VerificationToken { get; } = verificationToken;
    public DateTime GeneratedAt { get; } = DateTime.UtcNow;
}
