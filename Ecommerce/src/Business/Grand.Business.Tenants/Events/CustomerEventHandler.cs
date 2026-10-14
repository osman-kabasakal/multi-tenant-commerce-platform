using Grand.Domain.Customers;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;

namespace Grand.Business.Tenants.Events;

public class CustomerEventHandler(ICacheBase cacheBase) :
INotificationHandler<EntityInserted<Customer>>,
INotificationHandler<EntityUpdated<Customer>>,
INotificationHandler<EntityDeleted<Customer>>
{
    public async Task Handle(EntityInserted<Customer> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id);
    }

    public async Task Handle(EntityUpdated<Customer> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id);
    }

    public async Task Handle(EntityDeleted<Customer> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id);
    }

    private async Task HandleCacheRemoval(string customerId)
    {
        if (!string.IsNullOrEmpty(customerId))
        {
                await cacheBase.RemoveByPrefix(GetCacheKey(customerId,"account"));
                await cacheBase.RemoveByPrefix(GetCacheKey(customerId,"wishlist"));
                await cacheBase.RemoveByPrefix(GetCacheKey(customerId,"shoppingcart"));
                await cacheBase.RemoveByPrefix(GetCacheKey(customerId,"actioncart"));

        }
    }

    string GetCacheKey(string customerId,string slug) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.{slug}");
}
