using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Domain.Events.Registration;

public class GuestEmailUpdatedEvent(
    GuestRegistration item
    ): BaseEvent
{
    public GuestRegistration Item { get; } = item;
}
