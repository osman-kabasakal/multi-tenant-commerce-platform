using Grand.Domain.Customers;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;
using System;

namespace Grand.Business.Tenants.Events;

public class CustomerNotesEventHandler(ICacheBase cacheBase) :
INotificationHandler<EntityInserted<CustomerNote>>,
INotificationHandler<EntityUpdated<CustomerNote>>,
INotificationHandler<EntityDeleted<CustomerNote>>
{
    public async Task Handle(EntityInserted<CustomerNote> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId, notification.Entity?.DisplayToCustomer);
    }

    public async Task Handle(EntityUpdated<CustomerNote> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId, notification.Entity?.DisplayToCustomer);
    }

    public async Task Handle(EntityDeleted<CustomerNote> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId, notification.Entity?.DisplayToCustomer);
    }

    private async Task HandleCacheRemoval(string customerId, bool? condition)
    {
        if (!string.IsNullOrEmpty(customerId) && condition == true)
        {
            await cacheBase.RemoveAsync(GetCacheKey(customerId));
        }
    }

    string GetCacheKey(string customerId) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.account/notes");
}

