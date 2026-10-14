using Grand.Data;
using Grand.Domain.Customers;
using Grand.Domain.Orders;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;
using MongoDB.Driver.Linq;

namespace Grand.Business.Tenants.Events;

public class ShoppingCartItemEventHandler(ICacheBase cacheBase, IRepository<Customer> customerRepository) :
INotificationHandler<EntityInserted<ShoppingCartItem>>,
INotificationHandler<EntityUpdated<ShoppingCartItem>>,
INotificationHandler<EntityDeleted<ShoppingCartItem>>
{
    public async Task Handle(EntityInserted<ShoppingCartItem> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id, notification.Entity?.ShoppingCartTypeId ?? ShoppingCartType.ShoppingCart);
    }

    public async Task Handle(EntityUpdated<ShoppingCartItem> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id, notification.Entity?.ShoppingCartTypeId ?? ShoppingCartType.ShoppingCart);
    }

    public async Task Handle(EntityDeleted<ShoppingCartItem> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id, notification.Entity?.ShoppingCartTypeId ?? ShoppingCartType.ShoppingCart);
    }

    private async Task HandleCacheRemoval(string shoppingCartId, ShoppingCartType shoppingCartType)
    {
        if (!string.IsNullOrEmpty(shoppingCartId))
        {
            var customer = await customerRepository.Table.FirstOrDefaultAsync(x => x.ShoppingCartItems.Any(a => a.Id == shoppingCartId));
            if (customer != null)
            {
                var slug = shoppingCartType switch {
                    ShoppingCartType.ShoppingCart => "shoppingcart",
                    ShoppingCartType.Wishlist => "wishlist",
                    _ => "actioncart"
                };
                await cacheBase.RemoveByPrefix(GetCacheKey(customer.Id, slug));
                await cacheBase.RemoveByPrefix(GetCacheKey(customer.Id, "actioncart"));
            }
        }
    }

    string GetCacheKey(string customerId, string slug) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.{slug}");
}
