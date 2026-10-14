using Grand.Data;
using Grand.Domain.Orders;
using Grand.Domain.Shipping;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;

namespace Grand.Business.Tenants.Events;

public class ShipmentEventHandler(ICacheBase cacheBase, IRepository<Order> orderRepository) :
INotificationHandler<EntityInserted<Shipment>>,
INotificationHandler<EntityUpdated<Shipment>>,
INotificationHandler<EntityDeleted<Shipment>>
{
    public async Task Handle(EntityInserted<Shipment> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.OrderId);
    }

    public async Task Handle(EntityUpdated<Shipment> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.OrderId);
    }

    public async Task Handle(EntityDeleted<Shipment> notification, CancellationToken cancellationToken)
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

