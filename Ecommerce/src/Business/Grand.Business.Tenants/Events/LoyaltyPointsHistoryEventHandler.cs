using Grand.Domain.Orders;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;

namespace Grand.Business.Tenants.Events;

public class LoyaltyPointsHistoryEventHandler(ICacheBase cacheBase) :
INotificationHandler<EntityInserted<LoyaltyPointsHistory>>,
INotificationHandler<EntityUpdated<LoyaltyPointsHistory>>,
INotificationHandler<EntityDeleted<LoyaltyPointsHistory>>
{
    public async Task Handle(EntityInserted<LoyaltyPointsHistory> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId);
    }

    public async Task Handle(EntityUpdated<LoyaltyPointsHistory> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId);
    }

    public async Task Handle(EntityDeleted<LoyaltyPointsHistory> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId);
    }

    private async Task HandleCacheRemoval(string customerId)
    {
        if (!string.IsNullOrEmpty(customerId))
        {
            await cacheBase.RemoveByPrefix(GetCacheKey(customerId));
        }
    }

    string GetCacheKey(string customerId) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.order/customerloyaltypoints");
}

