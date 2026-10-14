using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.Registration;

public class BusinessRegistrationState : RegistrationState
{
    // Validation için tracking properties
    public string? ValidatedTaxNumber { get; private set; }
    public DateTime? LastTaxValidationAttempt { get; private set; }
    public string? LastValidationError { get; private set; }
    public int ValidationAttempts { get; private set; }

    // Navigation property
    public Guid? BusinessId { get; private set; }
    public Business? Business { get; private set; }

    // EF Core için protected constructor
    public BusinessRegistrationState() { }

    public BusinessRegistrationState(GuestRegistration guest) : base(guest)
    {
        AddDomainEvent(new BusinessRegistrationStateCreatedEvent(guest.Id));
    }

    // Domain Methods
    public void SetTaxValidation(string taxNumber, bool isValid, string? errorMessage = null)
    {
        LastTaxValidationAttempt = DateTime.UtcNow;
        ValidationAttempts++;

        if (isValid)
        {
            ValidatedTaxNumber = taxNumber;
            LastValidationError = null;
        }
        else
        {
            LastValidationError = errorMessage;
        }

        Update();
    }

    public void LinkBusiness(Business business)
    {
        BusinessId = business.Id;
        Business = business;
        Update();
    }

    // Helper Methods
    public bool CanAttemptValidation()
    {
        return ValidationAttempts < 3 && 
               (!LastTaxValidationAttempt.HasValue || 
                DateTime.UtcNow.Subtract(LastTaxValidationAttempt.Value).TotalMinutes >= 5);
    }

    public bool IsValidationRequired(string taxNumber)
    {
        return ValidatedTaxNumber != taxNumber;
    }

    public override int Priority => 1;
}
