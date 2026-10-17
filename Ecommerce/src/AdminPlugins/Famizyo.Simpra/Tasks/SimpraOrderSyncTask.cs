using Famizyo.Simpra.Services;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Orders;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using MongoDB.Driver.Linq;

namespace Famizyo.Simpra.Tasks;

public class SimpraOrderSyncTask : IScheduleTask
{
    private readonly IRepository<Order> _orderRepository;
    private readonly ISettingService _settingService;
    private readonly IServiceProvider _services;
    private readonly ILogger<SimpraOrderSyncTask> _logger;

    public SimpraOrderSyncTask(
        IRepository<Order> orderRepository,
        ISettingService settingService,
        IServiceProvider services,
        ILogger<SimpraOrderSyncTask> logger)
    {
        _orderRepository = orderRepository;
        _settingService = settingService;
        _services = services;
        _logger = logger;
    }

    public async Task Execute()
    {
        try
        {
            _logger.LogInformation("Starting Simpra order synchronization task");
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            if (string.IsNullOrEmpty(settings.AccessToken))
            {
                _logger.LogWarning("Simpra API access token not configured, skipping sync");
                return;
            }
            
            if (!settings.EnableOrderStatusSync)
            {
                _logger.LogDebug("Order status sync is disabled");
                return;
            }
            
            var simpraOrderService = _services.GetRequiredService<ISimpraOrderService>();

            // Send new orders to Simpra (only orders in Preparing status)
            await SendPendingOrdersToSimpraAsync(simpraOrderService);

            // Sync order status from Simpra to GrandNode
            await simpraOrderService.SyncOrderStatusAsync();
            
            _logger.LogInformation("Simpra order synchronization task completed successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError("Simpra synchronization failed ({ErrorType})", ex.GetType().Name);
            throw;
        }
    }

    private async Task SendPendingOrdersToSimpraAsync(ISimpraOrderService simpraOrderService)
    {
        try
        {
            // Get orders in Preparing status that haven't been sent to Simpra yet
            var pendingOrders = await _orderRepository.Table
                .Where(o => o.OrderStatusId == (int)OrderStatusSystem.Processing)
                .Where(o => o.UserFields.All(ga => ga.Key != "SimpraCheckId"))
                .ToListAsync();

            _logger.LogInformation("Found {Count} pending orders to send to Simpra", pendingOrders.Count);

            foreach (var order in pendingOrders)
            {
                try
                {
                    if (await simpraOrderService.CanSendOrderToSimpraAsync(order))
                    {
                        await simpraOrderService.SendOrderToSimpraAsync(order);
                        _logger.LogDebug("Order {OrderId} sent to Simpra successfully", order.Id);
                    }
                    else
                    {
                        _logger.LogDebug("Order {OrderId} cannot be sent to Simpra", order.Id);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error sending order {OrderId} to Simpra", order.Id);
                    // Continue with next order
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing pending orders for Simpra");
        }
    }
}