using Famizyo.Integration.Adisyo.Services;
using Famizyo.Integration.Adisyo.Settings;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Orders;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using MongoDB.Driver.Linq;

namespace Famizyo.Integration.Adisyo.Tasks;

public class AdisyoOrderSyncTask : IScheduleTask
{
    private readonly IRepository<Order> _orderRepository;
    private readonly ISettingService _settingService;
    private readonly IAdisyoOrderService _adisyoOrderService;
    private readonly ILogger<AdisyoOrderSyncTask> _logger;

    public AdisyoOrderSyncTask(
        IRepository<Order>  orderRepository,
        ISettingService settingService,
        IAdisyoOrderService adisyoOrderService,
        ILogger<AdisyoOrderSyncTask> logger)
    {
        _orderRepository = orderRepository;
        _settingService = settingService;
        _adisyoOrderService = adisyoOrderService;
        _logger = logger;
    }

    public async Task Execute()
    {
        try
        {
            _logger.LogInformation("Starting Adisyo order synchronization task");
            var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
            
            if (string.IsNullOrEmpty(settings.ApiKey) || string.IsNullOrEmpty(settings.ApiSecret))
            {
                _logger.LogWarning("Adisyo API credentials not configured, skipping sync");
                return;
            }
            
            if (!settings.EnableOrderStatusSync)
            {
                _logger.LogDebug("Order status sync is disabled");
                return;
            }
            
            
            // sync sending orders
            await _adisyoOrderService.SyncOrderStatusAsync();

            await _adisyoOrderService.SyncCompletedOrdersAsync();
            
            _logger.LogInformation("Adisyo order synchronization task completed successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error executing Adisyo order sync task");
        }
    }

}