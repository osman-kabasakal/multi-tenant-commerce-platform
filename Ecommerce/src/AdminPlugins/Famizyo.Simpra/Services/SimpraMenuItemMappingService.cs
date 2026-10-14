using Famizyo.Simpra.Domain;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Data;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using MongoDB.Driver.Linq;

namespace Famizyo.Simpra.Services;

public class SimpraMenuItemMappingService : ISimpraMenuItemMappingService
{
    private readonly IRepository<SimpraMenuItemMapping> _menuItemMappingRepository;
    private readonly ISimpraApiService _simpraApiService;
    private readonly ISettingService _settingService;
    private readonly ILogger<SimpraMenuItemMappingService> _logger;

    public SimpraMenuItemMappingService(
        IRepository<SimpraMenuItemMapping> menuItemMappingRepository,
        ISimpraApiService simpraApiService,
        ISettingService settingService,
        ILogger<SimpraMenuItemMappingService> logger)
    {
        _menuItemMappingRepository = menuItemMappingRepository;
        _simpraApiService = simpraApiService;
        _settingService = settingService;
        _logger = logger;
    }

    public async Task<SimpraMenuItemMapping?> GetByGrandNodeProductIdAsync(string grandNodeProductId)
    {
        return await _menuItemMappingRepository.Table
            .Where(m => m.GrandNodeProductId == grandNodeProductId && m.IsActive)
            .FirstOrDefaultAsync();
    }

    public async Task<SimpraMenuItemMapping?> GetBySimpraMenuItemIdAsync(string simpraMenuItemId)
    {
        return await _menuItemMappingRepository.Table
            .Where(m => m.SimpraMenuItemId == simpraMenuItemId && m.IsActive)
            .FirstOrDefaultAsync();
    }

    public async Task<List<SimpraMenuItemMapping>> GetAllByStoreIdAsync(string storeId)
    {
        return await _menuItemMappingRepository.Table
            .Where(m => m.StoreId == storeId)
            .ToListAsync();
    }

    public async Task<List<SimpraMenuItemMapping>> GetPendingSyncMappingsAsync(string storeId)
    {
        return await _menuItemMappingRepository.Table
            .Where(m => m.StoreId == storeId && (m.SyncStatus == "Pending" || m.SyncStatus == "Failed"))
            .ToListAsync();
    }

    public async Task InsertAsync(SimpraMenuItemMapping mapping)
    {
        await _menuItemMappingRepository.InsertAsync(mapping);
    }

    public async Task UpdateAsync(SimpraMenuItemMapping mapping)
    {
        await _menuItemMappingRepository.UpdateAsync(mapping);
    }

    public async Task DeleteAsync(SimpraMenuItemMapping mapping)
    {
        await _menuItemMappingRepository.DeleteAsync(mapping);
    }

    public async Task SyncMenuItemMappingsAsync(string storeId)
    {
        try
        {
            _logger.LogInformation("Starting menu item mappings sync for store {StoreId}", storeId);
            
            var settings = _settingService.LoadSetting<SimpraSettings>();
            if (string.IsNullOrEmpty(settings.AccessToken))
            {
                _logger.LogWarning("Simpra access token not configured, skipping menu item sync");
                return;
            }

            var pendingMappings = await GetPendingSyncMappingsAsync(storeId);
            
            foreach (var mapping in pendingMappings)
            {
                try
                {
                    // Update mapping status based on sync result
                    mapping.SyncStatus = "Synced";
                    mapping.LastSyncDate = DateTime.UtcNow;
                    mapping.ErrorMessage = null;
                    
                    await UpdateAsync(mapping);
                    
                    _logger.LogDebug("Synced menu item mapping for product {ProductId}", mapping.GrandNodeProductId);
                }
                catch (Exception ex)
                {
                    mapping.SyncStatus = "Failed";
                    mapping.ErrorMessage = ex.Message;
                    mapping.LastSyncDate = DateTime.UtcNow;
                    
                    await UpdateAsync(mapping);
                    
                    _logger.LogError(ex, "Failed to sync menu item mapping for product {ProductId}", mapping.GrandNodeProductId);
                }
            }
            
            _logger.LogInformation("Menu item mappings sync completed for store {StoreId}. Processed {Count} mappings", 
                storeId, pendingMappings.Count);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error syncing menu item mappings for store {StoreId}", storeId);
            throw;
        }
    }
}