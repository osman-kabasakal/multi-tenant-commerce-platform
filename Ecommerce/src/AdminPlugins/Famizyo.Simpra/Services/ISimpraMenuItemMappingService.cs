using Famizyo.Simpra.Domain;

namespace Famizyo.Simpra.Services;

public interface ISimpraMenuItemMappingService
{
    /// <summary>
    /// Gets menu item mapping by GrandNode Product ID
    /// </summary>
    Task<SimpraMenuItemMapping?> GetByGrandNodeProductIdAsync(string grandNodeProductId);
    
    /// <summary>
    /// Gets menu item mapping by Simpra Menu Item ID
    /// </summary>
    Task<SimpraMenuItemMapping?> GetBySimpraMenuItemIdAsync(string simpraMenuItemId);
    
    /// <summary>
    /// Gets all menu item mappings for a store
    /// </summary>
    Task<List<SimpraMenuItemMapping>> GetAllByStoreIdAsync(string storeId);
    
    /// <summary>
    /// Gets mappings that need sync (pending or failed)
    /// </summary>
    Task<List<SimpraMenuItemMapping>> GetPendingSyncMappingsAsync(string storeId);
    
    /// <summary>
    /// Inserts a new menu item mapping
    /// </summary>
    Task InsertAsync(SimpraMenuItemMapping mapping);
    
    /// <summary>
    /// Updates an existing menu item mapping
    /// </summary>
    Task UpdateAsync(SimpraMenuItemMapping mapping);
    
    /// <summary>
    /// Deletes a menu item mapping
    /// </summary>
    Task DeleteAsync(SimpraMenuItemMapping mapping);
    
    /// <summary>
    /// Synchronizes menu item mappings with Simpra API
    /// </summary>
    Task SyncMenuItemMappingsAsync(string storeId);
}