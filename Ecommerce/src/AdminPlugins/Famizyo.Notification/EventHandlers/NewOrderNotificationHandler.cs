using Famizyo.Notification.Hubs;
using Famizyo.Notification.Services;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Business.Tenants.Events;
using Grand.Data;
using Grand.Domain.Orders;
using Grand.Domain.Tenants;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Events;
using Grand.Infrastructure.MultiTenant;
using MediatR;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;

namespace Famizyo.Notification.EventHandlers;

public class NewOrderNotificationHandler : INotificationHandler<NewTenantOrderEvent>
{
    private readonly IHubContext<NotificationHub> _hubContext;
    private readonly ILogger<NewOrderNotificationHandler> _logger;
    private readonly IKeycloakClientService _keycloakUserService;
    private readonly ICacheBase _cacheBase;
    private readonly KeycloakSettings _keycloakSetting;
    private readonly IServiceProvider _serviceProvider;

    public NewOrderNotificationHandler(
        IHubContext<NotificationHub> hubContext,
        ILogger<NewOrderNotificationHandler> logger,
        IKeycloakClientService keycloakUserService      ,
        ICacheBase cacheBase,
        KeycloakSettings keycloakSetting,
        IServiceProvider serviceProvider
        )
    {
        _hubContext = hubContext;
        _logger = logger;
        _keycloakUserService = keycloakUserService;
        _cacheBase = cacheBase;
        _keycloakSetting = keycloakSetting;
        _serviceProvider = serviceProvider;
    }

    public async Task Handle(NewTenantOrderEvent notification, CancellationToken cancellationToken)
    {
        try
        {
            var groups = await _cacheBase.GetAsync("groups", async () =>
            {
                //TODO: bu listeyi tenant managerdan çekmem lazım
                return await _keycloakUserService.GetKeycloakClientAsync().GetGroupHierarchyAsync(_keycloakSetting.Realm,
                    cancellationToken: cancellationToken);
            });
            var tenantDb = groups
                .Where(x => x.Attributes.ContainsKey("StoreMongoConnectionString") &&
                            x.Attributes["StoreMongoConnectionString"].Count() > 0 && x.Attributes.ContainsKey("StoreId") && x.Attributes["StoreId"].FirstOrDefault() == notification.Entity.StoreId).Select(x => new DataSettings() {
                    ConnectionString = x.Attributes["StoreMongoConnectionString"].First(),
                    DbProvider = DbProvider.MongoDB
                }).FirstOrDefault();
            
            var mongourl = new MongoUrl(tenantDb.ConnectionString);
            var databaseName = mongourl.DatabaseName;
            if (string.IsNullOrEmpty(databaseName))
                return;
            var database = new MongoClient(tenantDb.ConnectionString).GetDatabase(databaseName);
            using (var scope = _serviceProvider.GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()
                       .CreateScopeWithReplacement(database,notification.Entity.StoreId))
            {
                var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
                tenantIdentityAccessor.TenantId = notification.Entity.StoreId;
                var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
                dbContext.SetConnection(tenantDb.ConnectionString);
                if (!await dbContext.DatabaseExist())
                {
                    return;
                }
                var _orderNotificationService = scope.ServiceProvider.GetRequiredService<IOrderNotificationService>();
                var orderNotification = await _orderNotificationService.CreateOrderNotificationAsync(
                    notification.Entity.Id, 
                    notification.Entity.StoreId);
                
                var groupName = string.Format(NotificationDefaults.NotificationGroupFormat, notification.Entity.StoreId,
                    NotificationDefaults.NotificationNewOrderGroupName);

                // Send notification with both order ID and notification ID for tracking
                await _hubContext.Clients.Group(groupName)
                    .SendAsync(NotificationDefaults.NotificationClientNewOrderMethodName, 
                        notification.Entity.Id,
                        orderNotification.Id,
                        cancellationToken: cancellationToken);
            }
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error sending new order notification");
        }
    }
}