using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;
using StackExchange.Redis;
using System.Text.Json;
using Order = Grand.Domain.Orders.Order;

namespace Grand.Business.Tenants.Events;
internal class NewOrderRedisMessage
{
    public string StoreId { get; set; }
    public string OrderId { get; set; }
}
public class OrderEventHandler(ICacheBase cacheBase,
    IConnectionMultiplexer connectionMultiplexer) :
INotificationHandler<EntityInserted<Order>>,
INotificationHandler<EntityUpdated<Order>>,
INotificationHandler<EntityDeleted<Order>>
{
    public async Task Handle(EntityInserted<Order> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId);
        if (notification.Entity != null)
            await connectionMultiplexer.GetSubscriber().PublishAsync(RedisChannel.Literal("NEW_ORDER"),
                JsonSerializer.Serialize(new NewOrderRedisMessage() {
                    StoreId = notification.Entity.StoreId,
                    OrderId = notification.Entity.Id
                }));
    }

    public async Task Handle(EntityUpdated<Order> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.CustomerId);
    }

    public async Task Handle(EntityDeleted<Order> notification, CancellationToken cancellationToken)
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

    string GetCacheKey(string customerId) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.order/");
}

