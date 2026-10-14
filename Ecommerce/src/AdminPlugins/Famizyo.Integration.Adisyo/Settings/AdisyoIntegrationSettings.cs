using Grand.Domain.Configuration;

namespace Famizyo.Integration.Adisyo.Settings;

public class AdisyoIntegrationSettings : ISettings
{
    public string? ApiKey { get; set; }
    public string? ApiSecret { get; set; }
    public string Consumer { get; set; } = "Sabir";
    public string BaseUrl { get; set; } = "https://ext.adisyo.com/api/External/v2";
    
    // Product synchronization settings
    public bool EnableProductSync { get; set; } = true;
    public string ProductMappingStrategy { get; set; } = "Name"; // Name or Code
    public string? SelectedCategoryIds { get; set; } // Comma-separated category IDs
    public int ProductSyncInterval { get; set; } = 60; // minutes
    public bool UpdateExistingProducts { get; set; } = true;
    public bool CreateNewProducts { get; set; } = true;
    public bool SyncProductPrices { get; set; } = true;
    public bool SyncProductFeatures { get; set; } = true;
    public bool PublishSyncedProducts { get; set; } = true;
    
    // Order settings - Updated based on API documentation
    public int OrderType { get; set; } = 3; // 1=Table, 3=TakeAway, 5=Retail
    public int PaymentMethodId { get; set; } = 53; // Default to Web Online payment
    
    // Sync settings
    public bool EnableOrderStatusSync { get; set; } = true;
    public int OrderStatusSyncInterval { get; set; } = 5; // minutes
    public bool EnableOrderCancellation { get; set; } = true;
    
    // Product feature mapping
    public string? IngredientPropertyName { get; set; } = "Malzemeler";
    public bool MapOtherPropertiesAsSpecifications { get; set; } = true;
    
    // Category display settings
    public string? SyncCategoryIds { get; set; } // Comma-separated Adisyo category IDs to sync
    public string? HomepageCategoryIds { get; set; } // Comma-separated Adisyo category IDs to show on homepage
    public string? FeaturedProductCategoryIds { get; set; } // Comma-separated Adisyo category IDs for featured products
    public string ProductLayoutId { get; set; }
    public string TaxCategoryId { get; set; }
    
    // Payment method mappings: GrandNode PaymentMethodSystemName -> Adisyo PaymentMethodId
    public string? PaymentMethodMappings { get; set; } // JSON serialized Dictionary<string, int>
    public string? ServiceFeeCategoryId { get; set; }
}