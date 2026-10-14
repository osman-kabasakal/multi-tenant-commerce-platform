using Grand.Domain;

namespace Famizyo.Simpra.Domain;

/// <summary>
/// Domain model for tracking GrandNode-Simpra Product to Menu Item mappings
/// </summary>
public class SimpraMenuItemMapping : BaseEntity
{
    /// <summary>
    /// Simpra Menu Item ID
    /// </summary>
    public string SimpraMenuItemId { get; set; }
    
    /// <summary>
    /// GrandNode Product ID
    /// </summary>
    public string GrandNodeProductId { get; set; } = string.Empty;
    
    /// <summary>
    /// Menu Item Name from Simpra
    /// </summary>
    public string MenuItemName { get; set; } = string.Empty;
    
    /// <summary>
    /// SKU of the product
    /// </summary>
    public string ProductSku { get; set; } = string.Empty;
    
    /// <summary>
    /// Price in Simpra (in decimal format)
    /// </summary>
    public decimal SimpraPrice { get; set; }
    
    /// <summary>
    /// Menu Item Group ID in Simpra
    /// </summary>
    public string MenuItemGroupId { get; set; } = string.Empty;
    
    /// <summary>
    /// Whether this mapping is active
    /// </summary>
    public bool IsActive { get; set; } = true;
    
    /// <summary>
    /// Store ID for multi-store support
    /// </summary>
    public string StoreId { get; set; } = string.Empty;
    
    /// <summary>
    /// Sync status (Pending, Synced, Failed)
    /// </summary>
    public string SyncStatus { get; set; } = "Pending";
    
    /// <summary>
    /// Last sync date with Simpra
    /// </summary>
    public DateTime LastSyncDate { get; set; }
    
    /// <summary>
    /// Error message if sync failed
    /// </summary>
    public string? ErrorMessage { get; set; }
}