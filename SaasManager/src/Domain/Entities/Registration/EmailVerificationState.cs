using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Domain.Entities.Registration;

public class EmailVerificationState : RegistrationState
{
    // Properties
    public string? VerificationCode { get; private set; }
    public DateTime? CodeExpiresAt { get; private set; }
    public int VerificationAttempts { get; private set; }
    public string? LastErrorMessage { get; private set; }

    // Constructors
    public EmailVerificationState()
    { 
        // EF Core için protected constructor
    }

    public EmailVerificationState(GuestRegistration guest) : base(guest)
    {
    }

    // Domain Methods
    public void SetVerificationCode(string code)
    {
        if (string.IsNullOrWhiteSpace(code))
            throw new ArgumentException("Code cannot be empty", nameof(code));

        VerificationCode = code;
        CodeExpiresAt = DateTime.UtcNow.AddMinutes(5);
        VerificationAttempts = 0;
        LastErrorMessage = null;
        AddDomainEvent(new EmailVerificationCodeGeneratedEvent(GuestId, Guest.Email!, VerificationCode));
        Update();
    }

    public bool IsCodeValid(string code)
    {
        return !IsCodeExpired() && 
               VerificationCode == code && 
               VerificationAttempts < 3;
    }

    public bool IsCodeExpired()
    {
        return !CodeExpiresAt.HasValue || CodeExpiresAt.Value < DateTime.UtcNow;
    }

    public void IncrementAttempts(string errorMessage)
    {
        VerificationAttempts++;
        LastErrorMessage = errorMessage;
        
        Update();
    }

    public override int Priority => 0;
}
