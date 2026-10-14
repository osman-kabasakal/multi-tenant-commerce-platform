using Famizyo.Integration.Adisyo.Domain;
using Grand.Data;
using Microsoft.Extensions.Logging;

namespace Famizyo.Integration.Adisyo.Services;

public class AdisyoOrderMappingService : IAdisyoOrderMappingService
{
    private readonly IRepository<AdisyoOrderMapping> _repository;
    private readonly ILogger<AdisyoOrderMappingService> _logger;

    public AdisyoOrderMappingService(
        IRepository<AdisyoOrderMapping> repository,
        ILogger<AdisyoOrderMappingService> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task<AdisyoOrderMapping?> GetByGrandNodeOrderIdAsync(string grandNodeOrderId)
    {
        try
        {
            return await Task.FromResult(_repository.Table
                .FirstOrDefault(x => x.GrandNodeOrderId == grandNodeOrderId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting AdisyoOrderMapping by GrandNode order ID: {OrderId}", grandNodeOrderId);
            return null;
        }
    }

    public async Task<AdisyoOrderMapping?> GetByAdisyoOrderIdAsync(int adisyoOrderId)
    {
        try
        {
            return await Task.FromResult(_repository.Table
                .FirstOrDefault(x => x.AdisyoOrderId == adisyoOrderId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting AdisyoOrderMapping by Adisyo order ID: {OrderId}", adisyoOrderId);
            return null;
        }
    }

    public async Task InsertAsync(AdisyoOrderMapping mapping)
    {
        try
        {
            await _repository.InsertAsync(mapping);
            _logger.LogInformation("AdisyoOrderMapping inserted: GrandNode={GrandNodeOrderId}, Adisyo={AdisyoOrderId}", 
                mapping.GrandNodeOrderId, mapping.AdisyoOrderId);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error inserting AdisyoOrderMapping: {OrderId}", mapping.GrandNodeOrderId);
            throw;
        }
    }

    public async Task UpdateAsync(AdisyoOrderMapping mapping)
    {
        try
        {
            mapping.LastSyncDate = DateTime.UtcNow;
            await _repository.UpdateAsync(mapping);
            _logger.LogDebug("AdisyoOrderMapping updated: {OrderId}", mapping.GrandNodeOrderId);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating AdisyoOrderMapping: {OrderId}", mapping.GrandNodeOrderId);
            throw;
        }
    }

    public async Task DeleteAsync(AdisyoOrderMapping mapping)
    {
        try
        {
            await _repository.DeleteAsync(mapping);
            _logger.LogInformation("AdisyoOrderMapping deleted: {OrderId}", mapping.GrandNodeOrderId);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting AdisyoOrderMapping: {OrderId}", mapping.GrandNodeOrderId);
            throw;
        }
    }

    public async Task<List<AdisyoOrderMapping>> GetBySyncStatusAsync(string syncStatus)
    {
        try
        {
            return await Task.FromResult(_repository.Table
                .Where(x => x.SyncStatus == syncStatus)
                .ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting AdisyoOrderMapping by sync status: {Status}", syncStatus);
            return new List<AdisyoOrderMapping>();
        }
    }

    public async Task<List<AdisyoOrderMapping>> GetUpdatedAfterAsync(DateTime date)
    {
        try
        {
            return await Task.FromResult(_repository.Table
                .Where(x => x.LastSyncDate > date)
                .ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting AdisyoOrderMapping updated after: {Date}", date);
            return new List<AdisyoOrderMapping>();
        }
    }
}