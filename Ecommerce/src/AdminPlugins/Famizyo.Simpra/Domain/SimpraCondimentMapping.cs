using Grand.Domain;

namespace Famizyo.Simpra.Domain;

/// <summary>
/// Domain model for tracking GrandNode-Simpra ProductAttributeValue to Condiment mappings
/// </summary>
public class SimpraCondimentMapping : BaseEntity
{
    /// <summary>
    /// Simpra Condiment ID
    /// </summary>
    public string SimpraCondimentId { get; set; } = string.Empty;
    
    /// <summary>
    /// GrandNode ProductAttributeValue ID
    /// </summary>
    public string GrandNodeProductAttributeValueId { get; set; } = string.Empty;
    
    /// <summary>
    /// GrandNode ProductAttribute ID (for the condiment group)
    /// </summary>
    public string GrandNodeProductAttributeId { get; set; } = string.Empty;
    
    /// <summary>
    /// Condiment Name from Simpra
    /// </summary>
    public string CondimentName { get; set; } = string.Empty;
    
    /// <summary>
    /// Additional Price for this condiment
    /// </summary>
    public decimal AdditionalPrice { get; set; }
    
    /// <summary>
    /// Condiment Group ID in Simpra
    /// </summary>
    public string CondimentGroupId { get; set; } = string.Empty;
    
    /// <summary>
    /// Whether this condiment is active
    /// </summary>
    public bool IsActive { get; set; } = true;
    
    /// <summary>
    /// Store ID for multi-store support
    /// </summary>
    public string StoreId { get; set; } = string.Empty;
    
    /// <summary>
    /// Last sync date with Simpra
    /// </summary>
    public DateTime LastSyncDate { get; set; }
}