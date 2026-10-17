using Famizyo.Notification.Hubs;
using Famizyo.Notification.Services;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Domain.Stores;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;

namespace Famizyo.Notification.Tasks;

/// <summary>
/// Task for resending notifications that have not been viewed or interacted with
/// </summary>
public class ResendUnseenNotificationsTask : IScheduleTask
{
    private readonly IOrderNotificationService _orderNotificationService;
    private readonly IConfiguration _configuration;
    private readonly IStoreService _storeService;
    private readonly IHubContext<NotificationHub> _hubContext;
    private readonly ILogger<ResendUnseenNotificationsTask> _logger;

    public ResendUnseenNotificationsTask(
        IOrderNotificationService orderNotificationService,
        IStoreService storeService,
        IHubContext<NotificationHub> hubContext,
        ILogger<ResendUnseenNotificationsTask> logger,
        IConfiguration configuration)
    {
        _orderNotificationService = orderNotificationService;
        _storeService = storeService;
        _hubContext = hubContext;
        _logger = logger;
        _configuration = configuration;
    }

    /// <summary>
    /// Executes the task to resend unseen notifications
    /// </summary>
    public async Task Execute()
    {
        if (_configuration.GetValue<bool>("Provisioning:ManagedRuntime") && _configuration["PlatformSignalR:Provider"] != "Redis")
            throw new InvalidOperationException("Managed notification tasks require shared Redis SignalR before recording send attempts.");
        try
        {
            // Get all stores
            var stores = await _storeService.GetAllStores();
            
            foreach (var store in stores)
            {
                await ResendNotificationsForStore(store);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError("Notification task failed: {ErrorType}", ex.GetType().Name);
            throw;
        }
    }

    private async Task ResendNotificationsForStore(Store store)
    {
        try
        {
            // Get all unviewed/non-interacted notifications for this store
            var notifications = await _orderNotificationService.GetNotificationsToResendAsync(store.Id);
            
            if (!notifications.Any())
                return;
                
            _logger.LogInformation("Found {Count} unseen notifications to resend for store {StoreId}", 
                notifications.Count, store.Id);
                
            // Group name for SignalR notifications
            var groupName = string.Format(NotificationDefaults.NotificationGroupFormat, 
                store.Id, NotificationDefaults.NotificationNewOrderGroupName);
                
            // Resend each notification
            foreach (var notification in notifications)
            {
                await _hubContext.Clients.Group(groupName)
                    .SendAsync(NotificationDefaults.NotificationClientNewOrderMethodName, 
                        notification.OrderId, notification.Id);
                        
                // Update the send count
                await _orderNotificationService.IncrementSendCountAsync(notification.Id);
                
                _logger.LogDebug("Resent notification {NotificationId} for order {OrderId} in store {StoreId}", 
                    notification.Id, notification.OrderId, store.Id);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError("Notification resend failed for store {StoreId}: {ErrorType}", store.Id, ex.GetType().Name);
            throw;
        }
    }

}