namespace SaasManager.Domain.Events;

public class ConcurrencyConflictResolvedEvent : BaseEvent
{
    public Guid EntityId { get; set; }
    public string MetadataName { get; set; }
    public string ResolutionMessage { get; set; }

    public ConcurrencyConflictResolvedEvent(Guid entityId, string metadataName, string resolutionMessage)
    {
        EntityId = entityId;
        MetadataName = metadataName;
        ResolutionMessage = resolutionMessage;
        throw new NotImplementedException();
    }
}
