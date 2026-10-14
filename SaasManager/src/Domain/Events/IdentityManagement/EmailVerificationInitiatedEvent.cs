using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Domain.Events.IdentityManagement;

public class EmailVerificationInitiatedEvent(VerificationLog item) : BaseEvent
{
    public VerificationLog İtem { get; } = item;
}
