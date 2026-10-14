using Grand.Data;
using Grand.Domain.Orders;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;

namespace Grand.Business.Tenants.Events;

public class OrderNoteEventHandler(ICacheBase cacheBase, IRepository<Order> orderRepository) :
INotificationHandler<EntityInserted<OrderNote>>,
INotificationHandler<EntityUpdated<OrderNote>>,
INotificationHandler<EntityDeleted<OrderNote>>
{
    public async Task Handle(EntityInserted<OrderNote> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.OrderId);
    }

    public async Task Handle(EntityUpdated<OrderNote> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.OrderId);
    }

    public async Task Handle(EntityDeleted<OrderNote> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.OrderId);
    }

    private async Task HandleCacheRemoval(string orderId)
    {
        if (!string.IsNullOrEmpty(orderId))
        {
            var order = await orderRepository.GetByIdAsync(orderId);
            if (order != null)
            {
                await cacheBase.RemoveAsync(GetCacheKey(order.CustomerId));
            }
        }
    }

    string GetCacheKey(string customerId) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.order/details");
}

