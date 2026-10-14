using Famizyo.Simpra.Domain;

namespace Famizyo.Simpra.Services;

public interface ISimpraCondimentMappingService
{
    /// <summary>
    /// Gets condiment mapping by GrandNode ProductAttributeValue ID
    /// </summary>
    Task<SimpraCondimentMapping?> GetByGrandNodeAttributeValueIdAsync(string grandNodeAttributeValueId);
    
    /// <summary>
    /// Gets condiment mapping by Simpra Condiment ID
    /// </summary>
    Task<SimpraCondimentMapping?> GetBySimpraCondimentIdAsync(string simpraCondimentId);
    
    /// <summary>
    /// Gets all condiment mappings by Simpra Condiment Group ID
    /// </summary>
    Task<List<SimpraCondimentMapping>> GetByCondimentGroupIdAsync(string condimentGroupId, string storeId);
    
    /// <summary>
    /// Gets all condiment mappings by GrandNode ProductAttribute ID
    /// </summary>
    Task<List<SimpraCondimentMapping>> GetByGrandNodeAttributeIdAsync(string productAttributeId, string storeId);
    
    /// <summary>
    /// Gets all condiment mappings for a store
    /// </summary>
    Task<List<SimpraCondimentMapping>> GetAllByStoreIdAsync(string storeId);
    
    /// <summary>
    /// Inserts a new condiment mapping
    /// </summary>
    Task InsertAsync(SimpraCondimentMapping mapping);
    
    /// <summary>
    /// Updates an existing condiment mapping
    /// </summary>
    Task UpdateAsync(SimpraCondimentMapping mapping);
    
    /// <summary>
    /// Deletes a condiment mapping
    /// </summary>
    Task DeleteAsync(SimpraCondimentMapping mapping);
    
    /// <summary>
    /// Synchronizes condiment mappings with Simpra API
    /// </summary>
    Task SyncCondimentMappingsAsync(string storeId);
}