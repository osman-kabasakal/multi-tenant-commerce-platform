using Grand.Domain.Catalog;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;

namespace Grand.Business.Tenants.Events;

public class ProductReviewEventHandler(ICacheBase cacheBase) :
INotificationHandler<EntityInserted<ProductReview>>,
INotificationHandler<EntityUpdated<ProductReview>>,
INotificationHandler<EntityDeleted<ProductReview>>
{
    public async Task Handle(EntityInserted<ProductReview> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId, true);
    }

    public async Task Handle(EntityUpdated<ProductReview> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId, true);
    }

    public async Task Handle(EntityDeleted<ProductReview> notification, CancellationToken cancellationToken)
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

    string GetCacheKey(string customerId) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.account/reviews");
}
