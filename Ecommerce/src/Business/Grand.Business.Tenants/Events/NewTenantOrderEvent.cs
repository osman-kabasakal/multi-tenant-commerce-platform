using Grand.Domain.Orders;
using Grand.Infrastructure.Events;
using MediatR;

namespace Grand.Business.Tenants.Events;

public class NewTenantOrderEvent: INotification
{
    public NewTenantOrderEvent(Order entity)
    {
        Entity = entity;
    }

    public Order Entity { get; private set; }
}