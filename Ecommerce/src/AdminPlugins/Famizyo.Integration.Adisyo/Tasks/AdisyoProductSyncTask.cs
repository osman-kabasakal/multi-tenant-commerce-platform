using Famizyo.Integration.Adisyo.Services;
using Famizyo.Integration.Adisyo.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Orders;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using MongoDB.Driver.Linq;

namespace Famizyo.Integration.Adisyo.Tasks;

public class AdisyoProductSyncTask : IScheduleTask
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ISettingService _settingService;
    private readonly IAdisyoProductSyncService _adisyoProductSyncService;
    private readonly IRepository<Order> _orderRepository;
    private readonly IAdisyoOrderService _adisyoOrderService;
    private readonly ILogger<AdisyoProductSyncTask> _logger;

    public AdisyoProductSyncTask(IServiceProvider serviceProvider,
        ISettingService  settingService,
        IAdisyoProductSyncService  adisyoProductSyncService,
        IRepository<Order> orderRepository,
        IAdisyoOrderService adisyoOrderService,
        ILogger<AdisyoProductSyncTask> logger)
    {
        _serviceProvider = serviceProvider;
        _settingService = settingService;
        _adisyoProductSyncService = adisyoProductSyncService;
        _orderRepository = orderRepository;
        _adisyoOrderService = adisyoOrderService;
        _logger = logger;
    }

    public async Task Execute()
    {
        try
        {
            _logger.LogInformation("Starting Adisyo product synchronization task");

            var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
            
            if (string.IsNullOrEmpty(settings.ApiKey) || string.IsNullOrEmpty(settings.ApiSecret))
            {
                _logger.LogWarning("Adisyo API credentials not configured, skipping product sync");
                return;
            }

            if (!settings.EnableProductSync)
            {
                _logger.LogDebug("Product synchronization is disabled");
                return;
            }

            await _adisyoProductSyncService.SyncProductsAndCategoriesAsync();
            
            
            //Send processing orders
            await SendOrders();
            
            _logger.LogInformation("Adisyo product synchronization task completed successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error executing Adisyo product sync task");
        }
    }
    
    
    private async Task SendOrders()
    {
        var processOrders =
            await _orderRepository.Table.Where(x =>
                (x.OrderStatusId == (int)OrderStatusSystem.Processing) && !x.Deleted).ToListAsync();

        foreach (var order in processOrders)
        {
            if ( await _adisyoOrderService.CanSendOrderToAdisyoAsync(order))
            {
                try
                {
                    await _adisyoOrderService.SendOrderToAdisyoAsync(order);
                }
                catch (Exception e)
                {
                    _logger.LogError(e, "Error sending order {OrderId} to Adisyo", order.Id);
                }
            }
        }
    }
}