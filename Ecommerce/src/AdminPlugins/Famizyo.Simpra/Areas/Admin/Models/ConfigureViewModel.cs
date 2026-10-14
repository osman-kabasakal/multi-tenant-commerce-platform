using Famizyo.Simpra.Settings;
using Grand.Domain.Orders;
using Grand.Infrastructure.ModelBinding;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace Famizyo.Simpra.Areas.Admin.Models;

public class ConfigureViewModel
{
    public ConfigureViewModel()
    {
        PaymentMethodMappings = new Dictionary<string, string>();
        TaxCategoryMappings = new Dictionary<string, string>();
        ServiceChargeMappings = new Dictionary<string, string>();
        SyncCategoryIds = new List<string>();
        HomepageCategoryIds = new List<string>();
        FeaturedProductCategoryIds = new List<string>();
        ImportSimpraCategories = new List<string>();
        EnvironmentOptions = new List<SelectListItem>();
        ProductMappingStrategyOptions = new List<SelectListItem>();
        SimpraPaymentMethods = new List<SelectListItem>();
        AvailableRevenueCenters = new List<SelectListItem>();
        AvailableSalesChannels = new List<SelectListItem>();
        AvailableEmployees = new List<SelectListItem>();
        AvailableGrandNodeCategories = new List<SelectListItem>();
        AvailableSimpraCategories = new List<SelectListItem>();
        AvailableGrandNodeTaxCategories = new List<SelectListItem>();
        AvailableSimpraTaxCategories = new List<SelectListItem>();
        AvailableProductLayouts = new List<SelectListItem>();
        AvailablePaymentProviders = new List<SelectListItem>();
        AvailableSimpraPaymentTypes = new List<SelectListItem>();
        AvailableSimpraMenuItemGroups = new List<SelectListItem>();
        AvailableSimpraServiceCharges = new List<SelectListItem>();
        AvailableCheckoutAttributes = new List<CheckoutAttribute>();
    }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.AccessToken")]
    [Required(ErrorMessage = "Access Token gereklidir")]
    public string AccessToken { get; set; } = "";

    [GrandResourceDisplayName("Plugins.Simpra.Fields.Environment")]
    public SimpraEnvironment SimpraEnvironment { get; set; } = SimpraEnvironment.Qa;

    [GrandResourceDisplayName("Plugins.Simpra.Fields.EnableProductSync")]
    public bool EnableProductSync { get; set; } = false;

    [GrandResourceDisplayName("Plugins.Simpra.Fields.SyncProductPrices")]
    public bool SyncProductPrices { get; set; } = true;

    [GrandResourceDisplayName("Plugins.Simpra.Fields.RevenueCenterId")]
    public string? RevenueCenterId { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.SalesChannelId")]
    public string? SalesChannelId { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.EmployeeId")]
    public string? EmployeeId { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.PropertyId")]
    public string? PropertyId { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.EnableOrderStatusSync")]
    public bool EnableOrderStatusSync { get; set; } = true;

    [GrandResourceDisplayName("Plugins.Simpra.Fields.OrderStatusSyncInterval")]
    [Range(1, 720, ErrorMessage = "Senkronizasyon aralığı 1-720 dakika arasında olmalıdır")]
    public int OrderStatusSyncInterval { get; set; } = 5;

    [GrandResourceDisplayName("Plugins.Simpra.Fields.RedisChannelPrefix")]
    public string RedisChannelPrefix { get; set; } = "simpra";

    [GrandResourceDisplayName("Plugins.Simpra.Fields.PaymentMethodMappings")]
    public Dictionary<string, string> PaymentMethodMappings { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.TaxCategoryMappings")]
    public Dictionary<string, string> TaxCategoryMappings { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.ServiceChargeMappings")]
    public Dictionary<string, string> ServiceChargeMappings { get; set; }

    // Synchronization direction settings
    [GrandResourceDisplayName("Plugins.Simpra.Fields.ExportToSimpra")]
    public bool ExportToSimpra { get; set; } = true;

    [GrandResourceDisplayName("Plugins.Simpra.Fields.ImportFromSimpra")]
    public bool ImportFromSimpra { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.ImportPhotoFromSimpra")]
    public bool ImportPhotoFromSimpra { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.ForceUpdateSku")]
    public bool ForceUpdateSku { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.DefaultImportCategoryId")]
    public string? DefaultImportCategoryId { get; set; }

    // Category Management - GrandNode categories for export to Simpra
    [GrandResourceDisplayName("Plugins.Simpra.Fields.SyncCategoryIds")]
    public IList<string> SyncCategoryIds { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.HomepageCategoryIds")]
    public IList<string> HomepageCategoryIds { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.FeaturedProductCategoryIds")]
    public IList<string> FeaturedProductCategoryIds { get; set; }

    // Simpra categories for import to GrandNode
    [GrandResourceDisplayName("Plugins.Simpra.Fields.ImportSimpraCategories")]
    public IList<string> ImportSimpraCategories { get; set; }

    // Product Configuration
    [GrandResourceDisplayName("Plugins.Simpra.Fields.ProductLayoutId")]
    public string? ProductLayoutId { get; set; }

    [GrandResourceDisplayName("Plugins.Simpra.Fields.TaxCategoryId")]
    public string? TaxCategoryId { get; set; }
    
    [GrandResourceDisplayName("Plugins.Simpra.Fields.DefaultSimpraMenuItemGroupId")]
    public string? DefaultSimpraMenuItemGroupId { get; set; }

    // Dropdown lists
    public List<SelectListItem> EnvironmentOptions { get; set; }
    public List<SelectListItem> ProductMappingStrategyOptions { get; set; }
    public List<SelectListItem> SimpraPaymentMethods { get; set; }
    public List<SelectListItem> AvailableRevenueCenters { get; set; }
    public List<SelectListItem> AvailableSalesChannels { get; set; }
    public List<SelectListItem> AvailableEmployees { get; set; }
    
    // Category dropdown lists for bidirectional sync
    public List<SelectListItem> AvailableGrandNodeCategories { get; set; } // For GrandNode → Simpra sync
    public List<SelectListItem> AvailableSimpraCategories { get; set; }    // For Simpra → GrandNode sync
    
    // Tax category dropdown lists
    public List<SelectListItem> AvailableGrandNodeTaxCategories { get; set; } // For mapping
    public List<SelectListItem> AvailableSimpraTaxCategories { get; set; }    // For Simpra tax categories
    
    // Product configuration
    public List<SelectListItem> AvailableProductLayouts { get; set; }
    
    // Available payment providers from GrandNode
    public List<SelectListItem> AvailablePaymentProviders { get; set; }
    
    // Available Simpra payment methods
    public List<SelectListItem> AvailableSimpraPaymentTypes { get; set; }
    
    // Available Simpra menu item groups
    public List<SelectListItem> AvailableSimpraMenuItemGroups { get; set; }
    
    // Available Simpra service charges
    public List<SelectListItem> AvailableSimpraServiceCharges { get; set; }
    
    // Available checkout attributes for service charge mapping
    public List<CheckoutAttribute> AvailableCheckoutAttributes { get; set; }

    // Connection test results
    public bool? ConnectionTestResult { get; set; }
    public string? ConnectionTestMessage { get; set; }

    // Helper properties for converting between IList<string> and comma-separated strings
    public string SyncCategoryIdsString
    {
        get => string.Join(",", SyncCategoryIds);
        set => SyncCategoryIds = string.IsNullOrEmpty(value) ? new List<string>() : value.Split(',').Select(x => x.Trim()).ToList();
    }

    public string HomepageCategoryIdsString
    {
        get => string.Join(",", HomepageCategoryIds);
        set => HomepageCategoryIds = string.IsNullOrEmpty(value) ? new List<string>() : value.Split(',').Select(x => x.Trim()).ToList();
    }

    public string FeaturedProductCategoryIdsString
    {
        get => string.Join(",", FeaturedProductCategoryIds);
        set => FeaturedProductCategoryIds = string.IsNullOrEmpty(value) ? new List<string>() : value.Split(',').Select(x => x.Trim()).ToList();
    }

    public string ImportSimpraCategoriesString
    {
        get => string.Join(",", ImportSimpraCategories);
        set => ImportSimpraCategories = string.IsNullOrEmpty(value) ? new List<string>() : value.Split(',').Select(x => x.Trim()).ToList();
    }
}