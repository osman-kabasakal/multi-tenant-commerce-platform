using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Domain.Events.Registration;

public class GuestPhoneUpdatedEvent(GuestRegistration item) : BaseEvent
{
    public GuestRegistration İtem { get; } = item;
}
