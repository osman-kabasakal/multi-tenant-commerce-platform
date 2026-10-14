using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Microsoft.Extensions.Logging;

namespace Famizyo.Simpra.Services;

/// <summary>
/// Composite service that orchestrates both GrandNode to Simpra and Simpra to GrandNode synchronization
/// </summary>
public class SimpraProductSyncService : ISimpraProductSyncService
{
    private readonly IGrandToSimpraSyncService _grandToSimpraSync;
    private readonly ISimpraToGrandSyncService _simpraToGrandSync;
    private readonly ISettingService _settingService;
    private readonly ILogger<SimpraProductSyncService> _logger;

    public SimpraProductSyncService(
        IGrandToSimpraSyncService grandToSimpraSync,
        ISimpraToGrandSyncService simpraToGrandSync,
        ISettingService settingService,
        ILogger<SimpraProductSyncService> logger)
    {
        _grandToSimpraSync = grandToSimpraSync;
        _simpraToGrandSync = simpraToGrandSync;
        _settingService = settingService;
        _logger = logger;
    }

    public async Task SyncProductsBidirectionalAsync()
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            if (!settings.EnableProductSync)
            {
                _logger.LogDebug("Product synchronization is disabled in settings");
                return;
            }

            _logger.LogInformation("Starting bidirectional product synchronization");

            // Sync from GrandNode to Simpra if enabled
            if (settings.ExportToSimpra)
            {
                _logger.LogDebug("Starting GrandNode to Simpra product synchronization");
                await _grandToSimpraSync.SyncProductsToSimpraAsync();
            }

            // Sync from Simpra to GrandNode if enabled
            if (settings.ImportFromSimpra)
            {
                _logger.LogDebug("Starting Simpra to GrandNode product synchronization");
                await _simpraToGrandSync.SyncProductsFromSimpraAsync();
            }

            _logger.LogInformation("Bidirectional product synchronization completed");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during bidirectional product synchronization");
        }
    }

    public async Task SyncProductPricesBidirectionalAsync()
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            if (!settings.EnableProductSync || !settings.SyncProductPrices)
            {
                _logger.LogDebug("Product price synchronization is disabled in settings");
                return;
            }

            _logger.LogInformation("Starting bidirectional product price synchronization");

            // Sync prices from GrandNode to Simpra if enabled
            if (settings.ExportToSimpra)
            {
                _logger.LogDebug("Starting GrandNode to Simpra price synchronization");
                await _grandToSimpraSync.SyncProductPricesToSimpraAsync();
            }

            // Sync prices from Simpra to GrandNode if enabled  
            if (settings.ImportFromSimpra)
            {
                _logger.LogDebug("Starting Simpra to GrandNode price synchronization");
                await _simpraToGrandSync.SyncProductPricesFromSimpraAsync();
            }

            _logger.LogInformation("Bidirectional product price synchronization completed");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during bidirectional product price synchronization");
        }
    }
}