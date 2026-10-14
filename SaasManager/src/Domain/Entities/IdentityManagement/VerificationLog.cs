using SaasManager.Domain.Events.IdentityManagement;

namespace SaasManager.Domain.Entities.IdentityManagement;

public class VerificationLog : AuditableEntity
{
    private VerificationType _type;
    public Guid GuestRegistrationId { get; private set; }
    public VerificationType Type
    {
        get => _type;
        private set
        {
            switch (value)
            {
                case VerificationType.Email:
                    AddDomainEvent(new EmailVerificationInitiatedEvent(this));
                    break;
                case VerificationType.Phone:
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(value), value, null);
            }
            
            _type = value;
        }
    }

    public string Code { get; private set; } = null!;
    public DateTime SentAt { get; private set; }
    public DateTime? VerifiedAt { get; private set; }
    public bool IsVerified { get; private set; }
    public int AttemptCount { get; private set; }
    public DateTime? LastAttemptAt { get; private set; }
    public string? LastErrorMessage { get; private set; } = null!;
    public DateTime ExpiresAt { get; private set; }

    // Navigation Property
    public GuestRegistration GuestRegistration { get; private set; } = null!;

    // Constructor for EF Core
    protected VerificationLog() { }

    public VerificationLog(
        Guid guestRegistrationId,
        VerificationType type,
        string code,
        int expirationMinutes = 5)
    {
        GuestRegistrationId = guestRegistrationId;
        Type = type;
        Code = code;
        SentAt = DateTime.UtcNow;
        IsVerified = false;
        AttemptCount = 0;
        ExpiresAt = DateTime.UtcNow.AddMinutes(expirationMinutes);
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
        CreatedBy = guestRegistrationId;
    }

    // Domain methods
    public bool VerifyCode(string submittedCode)
    {
        if (IsExpired())
        {
            LastErrorMessage = "Doğrulama kodu süresi dolmuş.";
            return false;
        }

        if (AttemptCount >= 3)
        {
            LastErrorMessage = "Maksimum deneme sayısı aşıldı.";
            return false;
        }

        AttemptCount++;
        LastAttemptAt = DateTime.UtcNow;

        if (Code != submittedCode)
        {
            LastErrorMessage = "Geçersiz doğrulama kodu.";
            UpdatedAt = DateTime.UtcNow;
            return false;
        }

        IsVerified = true;
        VerifiedAt = DateTime.UtcNow;
        LastErrorMessage = null;
        UpdatedAt = DateTime.UtcNow;
        return true;
    }

    public bool IsExpired()
    {
        return DateTime.UtcNow > ExpiresAt;
    }

    public bool CanResend()
    {
        return !IsVerified && (DateTime.UtcNow - SentAt).TotalMinutes >= 1;
    }

    public void UpdateCode(string newCode, int expirationMinutes = 5)
    {
        if (!IsVerified)
        {
            Code = newCode;
            SentAt = DateTime.UtcNow;
            ExpiresAt = DateTime.UtcNow.AddMinutes(expirationMinutes);
            AttemptCount = 0;
            LastAttemptAt = null;
            LastErrorMessage = null;
            UpdatedAt = DateTime.UtcNow;
        }
    }
}
