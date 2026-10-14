using System.ComponentModel.DataAnnotations.Schema;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Domain.Entities.IdentityManagement;

public class GuestRegistration : AuditableEntity
{
    public string? Email { get; private set; }
    public string Fullname => $"{Firstname} {Lastname}";
    public string? Firstname { get; set; }
    public string? Lastname { get; set; }
    public bool IsEmailVerified { get; private set; }
    public string? Phone { get; private set; }
    public string? GuestToken { get; private set; }
    public string? KeycloakUserId { get; private set; }
    public DateTime? ConvertedToUserAt { get; private set; }
    public Guid? ConvertedBusinessId { get; private set; }
    public Business? ConvertedBusiness { get; private set; }

    // Registration states
    private readonly List<RegistrationState> _registrationStates = new();
    public IReadOnlyCollection<RegistrationState> RegistrationStates => 
        _registrationStates.AsReadOnly();

    // Constructors
    protected GuestRegistration()
    {
        // EF Core için protected constructor
    }

    public GuestRegistration(string? email = null, string? phone = null)
        : this()
    {
        Email = email;
        Phone = phone;
        AddDomainEvent(new GuestRegistrationCreatedEvent(this));
    }

    // Domain Methods
    public void SetEmail(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            throw new ArgumentException("Email cannot be empty", nameof(email));

        if (Email != email)
        {
            Email = email;
            IsEmailVerified = false;
            AddDomainEvent(new GuestEmailUpdatedEvent(this));
        }
    }

    public void SetPhone(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone))
            throw new ArgumentException("Phone cannot be empty", nameof(phone));

        if (Phone != phone)
        {
            Phone = phone;
            AddDomainEvent(new GuestPhoneUpdatedEvent(item:this));
        }
    }

    public void SetGuestToken(string token)
    {
        if (string.IsNullOrWhiteSpace(token))
            throw new ArgumentException("Token cannot be empty", nameof(token));

        GuestToken = token;
        Update();
    }

    public void MarkEmailAsVerified()
    {
        if (!IsEmailVerified)
        {
            IsEmailVerified = true;
            AddDomainEvent(new GuestEmailVerifiedEvent(this));
            Update();
        }
    }

    public void ConvertToBusiness(Business business)
    {
        if (business == null)
            throw new ArgumentNullException(nameof(business));

        ConvertedBusinessId = business.Id;
        ConvertedBusiness = business;
        AddDomainEvent(new GuestConvertedToBusinessEvent(item:this));
        Update();
    }

    public void MarkAsConverted(string keycloakUserId)
    {
        if (string.IsNullOrWhiteSpace(keycloakUserId))
            throw new ArgumentException("KeycloakUserId cannot be empty", nameof(keycloakUserId));

        KeycloakUserId = keycloakUserId;
        ConvertedToUserAt = DateTime.UtcNow;
        Update();
    }

    // Helper Methods
    public bool CanVerifyEmail() => !string.IsNullOrEmpty(Email) && !IsEmailVerified;
    
    [NotMapped]
    public bool IsConverted => KeycloakUserId != null;
    
    public bool HasBusinessRegistration => ConvertedBusinessId.HasValue;
}
