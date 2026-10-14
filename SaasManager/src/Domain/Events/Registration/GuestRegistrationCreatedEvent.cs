namespace SaasManager.Domain.Entities.IdentityManagement;

public class GuestRegistrationCreatedEvent(GuestRegistration guestRegistration) : BaseEvent
{
    public GuestRegistration GuestRegistration { get; } = guestRegistration;
}
