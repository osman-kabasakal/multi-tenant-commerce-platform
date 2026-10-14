namespace SaasManager.Domain.Events;

public class EntityCreatedEvent<T> : BaseEvent
where T: BaseEntity
{
    public EntityCreatedEvent(
        T entity
        )
    {
        Entity = entity;
    }

    public T Entity { get; set; }
}



public class EntityUpdatedEvent<T> : BaseEvent
    where T: BaseEntity
{
    public EntityUpdatedEvent(
        T entity
    )
    {
        Entity = entity;
    }

    public T Entity { get; set; }
}


public class EntityDeletedEvent<T> : BaseEvent
    where T: BaseEntity
{
    public EntityDeletedEvent(
        T entity
    )
    {
        Entity = entity;
    }

    public T Entity { get; set; }
}
