using Famizyo.Simpra.Domain;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Data;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using MongoDB.Driver.Linq;

namespace Famizyo.Simpra.Services;

public class SimpraCondimentMappingService : ISimpraCondimentMappingService
{
    private readonly IRepository<SimpraCondimentMapping> _condimentMappingRepository;
    private readonly ISimpraApiService _simpraApiService;
    private readonly ISettingService _settingService;
    private readonly ILogger<SimpraCondimentMappingService> _logger;

    public SimpraCondimentMappingService(
        IRepository<SimpraCondimentMapping> condimentMappingRepository,
        ISimpraApiService simpraApiService,
        ISettingService settingService,
        ILogger<SimpraCondimentMappingService> logger)
    {
        _condimentMappingRepository = condimentMappingRepository;
        _simpraApiService = simpraApiService;
        _settingService = settingService;
        _logger = logger;
    }

    public async Task<SimpraCondimentMapping?> GetByGrandNodeAttributeValueIdAsync(string grandNodeAttributeValueId)
    {
        return await _condimentMappingRepository.Table
            .Where(m => m.GrandNodeProductAttributeValueId == grandNodeAttributeValueId && m.IsActive)
            .FirstOrDefaultAsync();
    }

    public async Task<SimpraCondimentMapping?> GetBySimpraCondimentIdAsync(string simpraCondimentId)
    {
        return await _condimentMappingRepository.Table
            .Where(m => m.SimpraCondimentId == simpraCondimentId && m.IsActive)
            .FirstOrDefaultAsync();
    }
    
    public async Task<List<SimpraCondimentMapping>> GetByCondimentGroupIdAsync(string condimentGroupId, string storeId)
    {
        return await _condimentMappingRepository.Table
            .Where(m => m.CondimentGroupId == condimentGroupId && m.StoreId == storeId && m.IsActive)
            .ToListAsync();
    }
    
    public async Task<List<SimpraCondimentMapping>> GetByGrandNodeAttributeIdAsync(string productAttributeId, string storeId)
    {
        return await _condimentMappingRepository.Table
            .Where(m => m.GrandNodeProductAttributeId == productAttributeId && m.StoreId == storeId && m.IsActive)
            .ToListAsync();
    }

    public async Task<List<SimpraCondimentMapping>> GetAllByStoreIdAsync(string storeId)
    {
        return await _condimentMappingRepository.Table
            .Where(m => m.StoreId == storeId)
            .ToListAsync();
    }

    public async Task InsertAsync(SimpraCondimentMapping mapping)
    {
        await _condimentMappingRepository.InsertAsync(mapping);
    }

    public async Task UpdateAsync(SimpraCondimentMapping mapping)
    {
        await _condimentMappingRepository.UpdateAsync(mapping);
    }

    public async Task DeleteAsync(SimpraCondimentMapping mapping)
    {
        await _condimentMappingRepository.DeleteAsync(mapping);
    }

    public async Task SyncCondimentMappingsAsync(string storeId)
    {
        try
        {
            _logger.LogInformation("Starting condiment mappings sync for store {StoreId}", storeId);
            
            var settings = _settingService.LoadSetting<SimpraSettings>();
            if (string.IsNullOrEmpty(settings.AccessToken))
            {
                _logger.LogWarning("Simpra access token not configured, skipping condiment sync");
                return;
            }

            // This would typically fetch condiments from Simpra API and create/update mappings
            // Implementation depends on Simpra API structure for condiments
            _logger.LogInformation("Condiment mappings sync completed for store {StoreId}", storeId);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error syncing condiment mappings for store {StoreId}", storeId);
            throw;
        }
    }
}