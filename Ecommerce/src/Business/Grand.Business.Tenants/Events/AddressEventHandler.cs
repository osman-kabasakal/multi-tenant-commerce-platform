using Grand.Data;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Events;
using MediatR;
using MongoDB.Driver.Linq;

namespace Grand.Business.Tenants.Events;

public class AddressEventHandler(ICacheBase cacheBase, IRepository<Customer> customerRepository) :
INotificationHandler<EntityInserted<Address>>,
INotificationHandler<EntityUpdated<Address>>,
INotificationHandler<EntityDeleted<Address>>
{
    public async Task Handle(EntityInserted<Address> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id);
    }

    public async Task Handle(EntityUpdated<Address> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id);
    }

    public async Task Handle(EntityDeleted<Address> notification, CancellationToken cancellationToken)
    {
        await HandleCacheRemoval(notification.Entity?.Id);
    }

    private async Task HandleCacheRemoval(string addressId)
    {
        if (!string.IsNullOrEmpty(addressId))
        {
            var customer = await customerRepository.Table.FirstOrDefaultAsync(x=>x.Addresses.Any(a=>a.Id == addressId));
            if (customer != null)
            {
                await cacheBase.RemoveAsync(GetCacheKey(customer.Id));
            }
        }
    }

    string GetCacheKey(string customerId) => string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{customerId}.account/addresses");
}
