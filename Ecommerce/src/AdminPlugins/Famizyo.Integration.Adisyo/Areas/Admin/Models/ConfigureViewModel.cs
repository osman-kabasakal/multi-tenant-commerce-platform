using Grand.Infrastructure.ModelBinding;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using AdisyoDefaults = global::Famizyo.Integration.Adisyo.AdisyoIntegrationDefaults;

namespace Famizyo.Integration.Adisyo.Areas.Admin.Models;

public class ConfigureViewModel
{
    [GrandResourceDisplayName(AdisyoDefaults.ApiKey)]
    public string? ApiKey { get; set; }

    [GrandResourceDisplayName(AdisyoDefaults.ApiSecret)]
    public string? ApiSecret { get; set; }

    [GrandResourceDisplayName(AdisyoDefaults.Consumer)]
    public string Consumer { get; set; } = "Sabir";

    [GrandResourceDisplayName(AdisyoDefaults.BaseUrl)]
    public string BaseUrl { get; set; } = "https://ext.adisyo.com/api/External/v2";

    [GrandResourceDisplayName(AdisyoDefaults.EnableProductSync)]
    public bool EnableProductSync { get; set; } = true;

    [GrandResourceDisplayName(AdisyoDefaults.ProductMappingStrategy)]
    public string ProductMappingStrategy { get; set; } = "Name";

    [GrandResourceDisplayName(AdisyoDefaults.SelectedCategoryIds)]
    [UIHint("MultiSelect")]
    public IList<string> SelectedCategoryIds { get; set; } = new List<string>();

    [GrandResourceDisplayName(AdisyoDefaults.ProductSyncInterval)]
    [Range(5, 1440, ErrorMessage = "Ürün senkronizasyon aralığı 5-1440 dakika arasında olmalıdır")]
    public int ProductSyncInterval { get; set; } = 60;

    [GrandResourceDisplayName(AdisyoDefaults.UpdateExistingProducts)]
    public bool UpdateExistingProducts { get; set; } = true;

    [GrandResourceDisplayName(AdisyoDefaults.CreateNewProducts)]
    public bool CreateNewProducts { get; set; } = true;

    [GrandResourceDisplayName(AdisyoDefaults.SyncProductPrices)]
    public bool SyncProductPrices { get; set; } = true;

    [GrandResourceDisplayName(AdisyoDefaults.SyncProductFeatures)]
    public bool SyncProductFeatures { get; set; } = true;

    [GrandResourceDisplayName(AdisyoDefaults.PublishSyncedProducts)]
    public bool PublishSyncedProducts { get; set; } = true;

    [GrandResourceDisplayName(AdisyoDefaults.OrderType)]
    public int OrderType { get; set; } = 3; // TakeAway

    [GrandResourceDisplayName(AdisyoDefaults.PaymentMethodId)]
    public int PaymentMethodId { get; set; } = 53; // Web Online

    [GrandResourceDisplayName(AdisyoDefaults.EnableOrderStatusSync)]
    public bool EnableOrderStatusSync { get; set; } = true;

    [GrandResourceDisplayName(AdisyoDefaults.OrderStatusSyncInterval)]
    [Range(1, 60, ErrorMessage = "Senkronizasyon aralığı 1-60 dakika arasında olmalıdır")]
    public int OrderStatusSyncInterval { get; set; } = 5;

    [GrandResourceDisplayName(AdisyoDefaults.EnableOrderCancellation)]
    public bool EnableOrderCancellation { get; set; } = true;

    [GrandResourceDisplayName(AdisyoDefaults.IngredientPropertyName)]
    public string? IngredientPropertyName { get; set; } = "Malzemeler";

    [GrandResourceDisplayName(AdisyoDefaults.MapOtherPropertiesAsSpecifications)]
    public bool MapOtherPropertiesAsSpecifications { get; set; } = true;

    // Category Settings - Using UIHint for MultiSelect
    [GrandResourceDisplayName(AdisyoDefaults.SyncCategoryIds)]
    [UIHint("MultiSelect")]
    public IList<string> SyncCategoryIds { get; set; } = new List<string>();

    [GrandResourceDisplayName(AdisyoDefaults.HomepageCategoryIds)]
    [UIHint("MultiSelect")]
    public IList<string> HomepageCategoryIds { get; set; } = new List<string>();

    [GrandResourceDisplayName(AdisyoDefaults.FeaturedProductCategoryIds)]
    [UIHint("MultiSelect")]
    public IList<string> FeaturedProductCategoryIds { get; set; } = new List<string>();

    [GrandResourceDisplayName(AdisyoDefaults.ProductLayoutId)]
    public string ProductLayoutId { get; set; }

    [GrandResourceDisplayName(AdisyoDefaults.TaxCategoryId)]
    public string TaxCategoryId { get; set; }
    
    [GrandResourceDisplayName(AdisyoDefaults.ServiceFeeCategoryId)]
    public string ServiceFeeCategoryId { get; set; }

    // Helper properties for converting between IList<string> and comma-separated strings
    public string SelectedCategoryIdsString
    {
        get => string.Join(",", SelectedCategoryIds);
        set => SelectedCategoryIds = string.IsNullOrEmpty(value) ? new List<string>() : value.Split(',').Select(x => x.Trim()).ToList();
    }

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

    // Payment Method Mapping
    [GrandResourceDisplayName(AdisyoDefaults.PaymentMethodMappings)]
    public Dictionary<string, int> PaymentMethodMappings { get; set; } = new();

    // Dropdown lists
    public List<SelectListItem> OrderTypes { get; set; } = new()
    {
        new SelectListItem { Text = "Masa Siparişi", Value = "1" },
        new SelectListItem { Text = "Paket Sipariş", Value = "3" },
        new SelectListItem { Text = "Kasadan Satış", Value = "5" }
    };

    public List<SelectListItem> ProductMappingStrategies { get; set; } = new()
    {
        new SelectListItem { Text = "İsim Bazlı", Value = "Name" },
        new SelectListItem { Text = "Kod Bazlı", Value = "Code" }
    };

    public List<SelectListItem> PaymentMethods { get; set; } = new();
    public List<SelectListItem> AvailableProductLayouts { get; set; } = new();
    public List<SelectListItem> AvailableTaxCategories { get; set; } = new();
    
    // Available payment providers from GrandNode
    public List<SelectListItem> AvailablePaymentProviders { get; set; } = new();
    
    // Available Adisyo payment methods
    public List<SelectListItem> AdisyoPaymentMethods { get; set; } = new();
    
    // Data sources for MultiSelect dropdowns
    public IList<SelectListItem> AvailableCategories { get; set; } = new List<SelectListItem>();
    public IList<SelectListItem> AvailableSyncCategories { get; set; } = new List<SelectListItem>();
    public IList<SelectListItem> AvailableHomepageCategories { get; set; } = new List<SelectListItem>();
    public IList<SelectListItem> AvailableFeaturedCategories { get; set; } = new List<SelectListItem>();
    
    // Legacy property for backward compatibility
    public List<SelectListItem> AdisyoCategories { get; set; } = new();

    // Connection test results
    public bool? ConnectionTestResult { get; set; }
    public string? ConnectionTestMessage { get; set; }
}