using Famizyo.Simpra.Services;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;

namespace Famizyo.Simpra.Tasks;

public class SimpraProductSyncTask : IScheduleTask
{
    private readonly ISettingService _settingService;
    private readonly IServiceProvider _services;
    private readonly ILogger<SimpraProductSyncTask> _logger;

    public SimpraProductSyncTask(
        ISettingService settingService,
        IServiceProvider services,
        ILogger<SimpraProductSyncTask> logger)
    {
        _settingService = settingService;
        _services = services;
        _logger = logger;
    }

    public async Task Execute()
    {
        try
        {
            _logger.LogInformation("Starting Simpra product synchronization task");
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            if (string.IsNullOrEmpty(settings.AccessToken))
            {
                _logger.LogWarning("Simpra API access token not configured, skipping product sync");
                return;
            }
            
            if (!settings.EnableProductSync)
            {
                _logger.LogDebug("Product synchronization is disabled");
                return;
            }

            var simpraProductSyncService = _services.GetRequiredService<ISimpraProductSyncService>();

            // Sync products to Simpra
            await simpraProductSyncService.SyncProductsBidirectionalAsync();

            // Sync product prices if enabled
            if (settings.SyncProductPrices)
            {
                await simpraProductSyncService.SyncProductPricesBidirectionalAsync();
            }
            
            _logger.LogInformation("Simpra product synchronization task completed successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError("Simpra synchronization failed ({ErrorType})", ex.GetType().Name);
            throw;
        }
    }
}