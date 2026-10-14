using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Events.Registration;

namespace SaasManager.Domain.Entities.Registration;

public abstract class RegistrationState : AuditableEntity
{
    // Properties
    public Guid GuestId { get; private set; }
    public DateTime? CompletedAt { get; private set; }
    public string StateKey => GetType().Name;
    
    public abstract int Priority { get; }

    // Navigation Properties
    public GuestRegistration Guest { get; private set; } = null!;
    
    public RegistrationState()
    {
        
    }

    // Constructors
    public RegistrationState(GuestRegistration guest)
    {
        if (guest == null)
            throw new ArgumentNullException(nameof(guest));

        Guest = guest;
        GuestId = guest.Id;
        AddDomainEvent(new RegistrationStateStartedEvent(GuestId, StateKey));
    }

    public void SetGuest(GuestRegistration guest)
    {
        Guest = guest;
        GuestId = guest.Id;
        AddDomainEvent(new RegistrationStateStartedEvent(GuestId, StateKey));
    }

    // Domain Methods
    public void Complete()
    {
        if (!IsCompleted)
        {
            CompletedAt = DateTime.UtcNow;
            AddDomainEvent(new RegistrationStateCompletedEvent(Id, StateKey));
            Update();
        }
    }

    // Properties
    public bool IsCompleted => CompletedAt.HasValue;
}
