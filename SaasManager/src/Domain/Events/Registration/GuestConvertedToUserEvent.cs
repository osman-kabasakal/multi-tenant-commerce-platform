using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Domain.Events.Registration;

public class GuestConvertedToUserEvent(
    GuestRegistration item
): BaseEvent
{
    public GuestRegistration Item { get; } = item;
}