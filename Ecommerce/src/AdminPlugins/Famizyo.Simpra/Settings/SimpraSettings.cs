using Grand.Domain.Configuration;

namespace Famizyo.Simpra.Settings;

public enum SimpraEnvironment
{
    Production,
    Uat,
    Qa
}

public class SimpraSettings: ISettings
{
    // API Configuration
    public string AccessToken { get; set; }
    public SimpraEnvironment SimpraEnvironment { get; set; } = SimpraEnvironment.Qa;
    
    // Product Synchronization Settings
    public bool EnableProductSync { get; set; }
    public bool ExportToSimpra { get; set; } = true; // GrandNode → Simpra
    public bool ImportFromSimpra { get; set; }       // Simpra → GrandNode
    public bool SyncProductPrices { get; set; } = true;
    public bool ImportPhotoFromSimpra { get; set; }
    public bool ForceUpdateSku { get; set; }
    public string? DefaultImportCategoryId { get; set; }
    
    // Revenue Center Configuration
    public string? RevenueCenterId { get; set; }
    public string? SalesChannelId { get; set; }
    public string? EmployeeId { get; set; }
    public string? PropertyId { get; set; } // Property ID from selected Revenue Center
    
    // Order Settings
    public bool EnableOrderStatusSync { get; set; } = true;
    public int OrderStatusSyncInterval { get; set; } = 5; // minutes
    
    // Redis Configuration
    public string RedisChannelPrefix { get; set; } = "simpra";
    
    // Payment Mappings
    public string? PaymentMethodMappings { get; set; } // JSON serialized Dictionary<string, int>
    
    // Service Charge Mappings
    public string? ServiceChargeMappings { get; set; } // JSON serialized Dictionary<string, string> - Fee types to Simpra service charge IDs
    
    // Tax Category Mappings
    public string? TaxCategoryMappings { get; set; } // JSON serialized Dictionary<string, string> - Simpra tax_id to GrandNode TaxCategoryId
    
    // Category Management for bidirectional sync
    public string? SyncCategoryIds { get; set; } // GrandNode categories to sync to Simpra (comma-separated)
    public string? HomepageCategoryIds { get; set; } // Categories to display on homepage (comma-separated)
    public string? FeaturedProductCategoryIds { get; set; } // Categories for featured products (comma-separated)
    public string? ImportSimpraCategories { get; set; } // Simpra categories to import to GrandNode (comma-separated)
    
    // Product Configuration
    public string? ProductLayoutId { get; set; } // Layout template for synced products
    public string? TaxCategoryId { get; set; } // Tax category assignment for synced products
    public string? DefaultSimpraMenuItemGroupId { get; set; } // Default Simpra menu item group ID for products
}