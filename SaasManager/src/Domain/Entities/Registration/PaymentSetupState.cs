using SaasManager.Domain.Entities.Financial;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Domain.Entities.Registration;

public class PaymentSetupState : RegistrationState
{
    // Properties
    public decimal? PreAuthAmount { get; private set; }
    public string? AuthorizationCode { get; private set; }
    public DateTime? LastAttemptAt { get; private set; }
    public string? LastErrorMessage { get; private set; }
    public int AuthorizationAttempts { get; private set; }
    
    public Guid? PaymentMethodId { get; private set; }
    
    public PaymentMethod? PaymentMethod { get; private set; }

    // Constructors
    public PaymentSetupState()
    {
        // EF Core için protected constructor
    }

    public PaymentSetupState(GuestRegistration guest) : base(guest)
    {
    }

    // Domain Methods
    public void SetPreAuthDetails(decimal amount, string authCode)
    {
        if (amount <= 0)
            throw new ArgumentException("Amount must be greater than zero", nameof(amount));

        if (string.IsNullOrWhiteSpace(authCode))
            throw new ArgumentException("Authorization code cannot be empty", nameof(authCode));

        PreAuthAmount = amount;
        AuthorizationCode = authCode;
        LastAttemptAt = DateTime.UtcNow;
        LastErrorMessage = null;
        AddDomainEvent(new PaymentPreAuthCompletedEvent(GuestId, amount, authCode));
        Update();
    }

    public void RecordFailedAttempt(string errorMessage)
    {
        AuthorizationAttempts++;
        LastAttemptAt = DateTime.UtcNow;
        LastErrorMessage = errorMessage;

        if (AuthorizationAttempts >= 3)
        {
            AddDomainEvent(new MaxPaymentAttemptsReachedEvent(GuestId));
        }

        Update();
    }

    public bool CanAttemptAuthorization()
    {
        return AuthorizationAttempts < 3 && 
               (!LastAttemptAt.HasValue || 
                DateTime.UtcNow.Subtract(LastAttemptAt.Value).TotalMinutes >= 5);
    }
    
    
    public void SetPaymentMethod(PaymentMethod paymentMethod)
    {
        if (paymentMethod == null)
            throw new ArgumentNullException(nameof(paymentMethod));


        PaymentMethodId = paymentMethod.Id;
        PaymentMethod = paymentMethod;

        AddDomainEvent(new PaymentMethodSetEvent(GuestId, paymentMethod.Id));
        Update();
    }

    public override int Priority => 3;
}
