using Grand.Domain;

namespace Famizyo.Integration.Adisyo.Domain;

/// <summary>
/// Domain model for tracking GrandNode-Adisyo ProductAttributeValue ID mappings
/// </summary>
public class AdisyoFeatureValueMapping : BaseEntity
{
    /// <summary>
    /// Adisyo Feature ID
    /// </summary>
    public int AdisyoFeatureId { get; set; }
    
    /// <summary>
    /// GrandNode ProductAttributeValue ID
    /// </summary>
    public string GrandNodeProductAttributeValueId { get; set; } = string.Empty;
    
    /// <summary>
    /// Feature Name from Adisyo
    /// </summary>
    public string FeatureName { get; set; } = string.Empty;
    
    /// <summary>
    /// Additional Price for this feature value
    /// </summary>
    public decimal AdditionalPrice { get; set; }
}