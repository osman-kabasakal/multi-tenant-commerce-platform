using Grand.Domain;

namespace Famizyo.Integration.Adisyo.Domain;

/// <summary>
/// Domain model for tracking GrandNode-Adisyo ProductAttribute ID mappings
/// </summary>
public class AdisyoProductAttributeMapping : BaseEntity
{
    /// <summary>
    /// Adisyo Feature Group ID
    /// </summary>
    public int AdisyoFeatureGroupId { get; set; }
    
    /// <summary>
    /// GrandNode ProductAttribute ID
    /// </summary>
    public string GrandNodeProductAttributeId { get; set; } = string.Empty;
    
    /// <summary>
    /// Feature Group Name from Adisyo
    /// </summary>
    public string FeatureGroupName { get; set; } = string.Empty;
    
    /// <summary>
    /// Feature Header Type (Tekli Seçim / Çoklu Seçim)
    /// </summary>
    public string FeatureHeaderType { get; set; } = string.Empty;
    
    /// <summary>
    /// Necessary Count from Adisyo
    /// </summary>
    public int NecessaryCount { get; set; }
}