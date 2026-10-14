using Grand.Domain.Documents;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;

namespace Grand.Business.Tenants.Events;

public class DocumentEventHandler(ICacheBase cacheBase) :
INotificationHandler<EntityInserted<Document>>,
INotificationHandler<EntityUpdated<Document>>,
INotificationHandler<EntityDeleted<Document>>
{
    public async Task Handle(EntityInserted<Document> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId, notification.Entity?.Published);
    }

    public async Task Handle(EntityUpdated<Document> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId, notification.Entity?.Published);
    }

    public async Task Handle(EntityDeleted<Document> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId, true);
    }

    private async Task HandleCacheRemoval(string customerId, bool? condition)
    {
        if (!string.IsNullOrEmpty(customerId) && condition == true)
        {
            await cacheBase.RemoveAsync(GetCacheKey(customerId));
        }
    }

    string GetCacheKey(string customerId) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.account/documents");
}
