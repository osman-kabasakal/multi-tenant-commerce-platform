namespace SaasManager.Domain.Events.Registration;

public class BusinessRegistrationCompletedEvent : BaseEvent
{
    public Guid BusinessId { get; }

    public BusinessRegistrationCompletedEvent(Guid businessId)
    {
        BusinessId = businessId;
    }
}
