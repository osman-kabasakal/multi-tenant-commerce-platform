using Famizyo.Integration.Adisyo.Areas.Admin.Models;
using Famizyo.Integration.Adisyo.Services;
using Famizyo.Integration.Adisyo.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Web.Common.Controllers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace Famizyo.Integration.Adisyo.Areas.Admin.Controllers;

public class AdisyoIntegrationController : BaseAdminPluginController
{
    private readonly AdisyoIntegrationSettings _settings;
    private readonly ISettingService _settingService;
    private readonly IAdisyoApiService _adisyoApiService;
    private readonly IAdisyoProductSyncService _productSyncService;
    private readonly IProductLayoutService _productLayoutService;
    private readonly ITaxCategoryService _taxCategoryService;
    private readonly IPaymentService _paymentService;
    private readonly ILogger<AdisyoIntegrationController> _logger;

    public AdisyoIntegrationController(
        AdisyoIntegrationSettings settings,
        ISettingService settingService,
        IAdisyoApiService adisyoApiService,
        IAdisyoProductSyncService productSyncService,
        IProductLayoutService productLayoutService,
        ITaxCategoryService taxCategoryService,
        IPaymentService paymentService,
        ILogger<AdisyoIntegrationController> logger)
    {
        _settings = settings;
        _settingService = settingService;
        _adisyoApiService = adisyoApiService;
        _productSyncService = productSyncService;
        _productLayoutService = productLayoutService;
        _taxCategoryService = taxCategoryService;
        _paymentService = paymentService;
        _logger = logger;
    }

    [HttpGet]
    public async Task<IActionResult> Configure()
    {
        var model = new ConfigureViewModel
        {
            ApiKey = _settings.ApiKey,
            ApiSecret = _settings.ApiSecret,
            Consumer = _settings.Consumer,
            BaseUrl = _settings.BaseUrl,
            EnableProductSync = _settings.EnableProductSync,
            ProductMappingStrategy = _settings.ProductMappingStrategy,
            SelectedCategoryIdsString = _settings.SelectedCategoryIds,
            ProductSyncInterval = _settings.ProductSyncInterval,
            UpdateExistingProducts = _settings.UpdateExistingProducts,
            CreateNewProducts = _settings.CreateNewProducts,
            SyncProductPrices = _settings.SyncProductPrices,
            SyncProductFeatures = _settings.SyncProductFeatures,
            PublishSyncedProducts = _settings.PublishSyncedProducts,
            OrderType = _settings.OrderType,
            PaymentMethodId = _settings.PaymentMethodId,
            EnableOrderStatusSync = _settings.EnableOrderStatusSync,
            OrderStatusSyncInterval = _settings.OrderStatusSyncInterval,
            EnableOrderCancellation = _settings.EnableOrderCancellation,
            IngredientPropertyName = _settings.IngredientPropertyName,
            MapOtherPropertiesAsSpecifications = _settings.MapOtherPropertiesAsSpecifications,
            SyncCategoryIdsString = _settings.SyncCategoryIds,
            HomepageCategoryIdsString = _settings.HomepageCategoryIds,
            FeaturedProductCategoryIdsString = _settings.FeaturedProductCategoryIds,
            ProductLayoutId = _settings.ProductLayoutId,
            TaxCategoryId = _settings.TaxCategoryId,
            ServiceFeeCategoryId = _settings.ServiceFeeCategoryId,
        };

        // Load payment method mappings from settings
        if (!string.IsNullOrEmpty(_settings.PaymentMethodMappings))
        {
            try
            {
                model.PaymentMethodMappings = JsonSerializer.Deserialize<Dictionary<string, int>>(_settings.PaymentMethodMappings) ?? new Dictionary<string, int>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to deserialize payment method mappings");
                model.PaymentMethodMappings = new Dictionary<string, int>();
            }
        }

        // Load payment methods if API credentials are provided
        if (!string.IsNullOrEmpty(model.ApiKey) && !string.IsNullOrEmpty(model.ApiSecret))
        {
            try
            {
                var paymentTypes = await _adisyoApiService.GetPaymentTypesAsync();
                model.PaymentMethods = paymentTypes.Select(x => new SelectListItem
                {
                    Text = $"{x.Name} (ID: {x.Id})",
                    Value = x.Id.ToString()
                }).ToList();

                // Set Adisyo payment methods for mapping
                model.AdisyoPaymentMethods = paymentTypes.Select(x => new SelectListItem
                {
                    Text = x.Name,
                    Value = x.Id.ToString()
                }).ToList();

                var categories = await _adisyoApiService.GetProductsAsync();
                var categoryItems = categories.Select(x => new SelectListItem
                {
                    Text = x.CategoryName,
                    Value = x.CategoryId.ToString()
                }).ToList();
                
                // Set all category sources for MultiSelect dropdowns
                model.AdisyoCategories = categoryItems;
                model.AvailableCategories = categoryItems.ToList();
                model.AvailableSyncCategories = categoryItems.ToList();
                model.AvailableHomepageCategories = categoryItems.ToList();
                model.AvailableFeaturedCategories = categoryItems.ToList();

                model.ConnectionTestResult = true;
                model.ConnectionTestMessage = "Bağlantı başarılı! Ödeme yöntemleri ve kategoriler yüklendi.";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to load Adisyo data");
                model.ConnectionTestResult = false;
                model.ConnectionTestMessage = $"Bağlantı hatası: {ex.Message}";
            }
        }

        // Load Product Layouts
        try
        {
            var productLayouts = await _productLayoutService.GetAllProductLayouts();
            model.AvailableProductLayouts = productLayouts.Select(x => new SelectListItem
            {
                Text = x.Name,
                Value = x.Id
            }).OrderBy(x => x.Text).ToList();
            model.AvailableProductLayouts.Insert(0, new SelectListItem { Text = "Seçiniz", Value = "" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to load product layouts");
        }

        // Load Tax Categories
        try
        {
            var taxCategories = await _taxCategoryService.GetAllTaxCategories();
            model.AvailableTaxCategories = taxCategories.Select(x => new SelectListItem
            {
                Text = x.Name,
                Value = x.Id
            }).OrderBy(x => x.Text).ToList();
            model.AvailableTaxCategories.Insert(0, new SelectListItem { Text = "Seçiniz", Value = "" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to load tax categories");
        }

        // Load GrandNode active payment providers
        try
        {
            var activePaymentMethods = await _paymentService.LoadActivePaymentMethods();
            model.AvailablePaymentProviders = activePaymentMethods.Select(x => new SelectListItem
            {
                Text = x.FriendlyName,
                Value = x.SystemName
            }).OrderBy(x => x.Text).ToList();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to load active payment providers");
        }

        // Add default empty options
        model.PaymentMethods.Insert(0, new SelectListItem { Text = "Seçiniz", Value = "" });
        model.AdisyoCategories.Insert(0, new SelectListItem { Text = "Tüm Kategoriler", Value = "" });
        model.AdisyoPaymentMethods.Insert(0, new SelectListItem { Text = "Seçiniz", Value = "" });

        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Configure(ConfigureViewModel model)
    {
        if (!ModelState.IsValid)
        {
            return View(model);
        }

        var settings = new AdisyoIntegrationSettings
        {
            ApiKey = model.ApiKey,
            ApiSecret = model.ApiSecret,
            Consumer = model.Consumer,
            BaseUrl = model.BaseUrl,
            EnableProductSync = model.EnableProductSync,
            ProductMappingStrategy = model.ProductMappingStrategy,
            SelectedCategoryIds = model.SelectedCategoryIdsString,
            ProductSyncInterval = model.ProductSyncInterval,
            UpdateExistingProducts = model.UpdateExistingProducts,
            CreateNewProducts = model.CreateNewProducts,
            SyncProductPrices = model.SyncProductPrices,
            SyncProductFeatures = model.SyncProductFeatures,
            PublishSyncedProducts = model.PublishSyncedProducts,
            OrderType = model.OrderType,
            PaymentMethodId = model.PaymentMethodId,
            EnableOrderStatusSync = model.EnableOrderStatusSync,
            OrderStatusSyncInterval = model.OrderStatusSyncInterval,
            EnableOrderCancellation = model.EnableOrderCancellation,
            IngredientPropertyName = model.IngredientPropertyName,
            MapOtherPropertiesAsSpecifications = model.MapOtherPropertiesAsSpecifications,
            SyncCategoryIds = model.SyncCategoryIdsString,
            HomepageCategoryIds = model.HomepageCategoryIdsString,
            FeaturedProductCategoryIds = model.FeaturedProductCategoryIdsString,
            ProductLayoutId = model.ProductLayoutId,
            TaxCategoryId = model.TaxCategoryId,
            ServiceFeeCategoryId= model.ServiceFeeCategoryId,
            PaymentMethodMappings = JsonSerializer.Serialize(model.PaymentMethodMappings)
        };

        await _settingService.SaveSetting(settings);

        TempData["SuccessMessage"] = "Adisyo entegrasyon ayarları başarıyla kaydedildi.";
        return RedirectToAction("Configure");
    }

    [HttpPost]
    public async Task<IActionResult> TestConnection(ConfigureViewModel model)
    {
        try
        {
            // Temporarily save settings for testing
            var tempSettings = new AdisyoIntegrationSettings
            {
                ApiKey = model.ApiKey,
                ApiSecret = model.ApiSecret,
                Consumer = model.Consumer,
                BaseUrl = model.BaseUrl
            };

            await _settingService.SaveSetting(tempSettings);

            // Test API connection
            var paymentTypes = await _adisyoApiService.GetPaymentTypesAsync();
            
            return Json(new { success = true, message = $"Bağlantı başarılı! {paymentTypes.Count} ödeme yöntemi bulundu." });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Connection test failed");
            return Json(new { success = false, message = $"Bağlantı hatası: {ex.Message}" });
        }
    }

    [HttpPost]
    public async Task<IActionResult> SyncProducts()
    {
        try
        {
            if (string.IsNullOrEmpty(_settings.ApiKey) || string.IsNullOrEmpty(_settings.ApiSecret))
            {
                return Json(new { success = false, message = "API kimlik bilgileri yapılandırılmamış." });
            }

            if (!_settings.EnableProductSync)
            {
                return Json(new { success = false, message = "Ürün senkronizasyonu etkin değil." });
            }

            await _productSyncService.SyncProductsAndCategoriesAsync();

            return Json(new { success = true, message = "Ürün ve kategori senkronizasyonu başarıyla tamamlandı!" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Product sync failed");
            return Json(new { success = false, message = $"Ürün senkronizasyonu hatası: {ex.Message}" });
        }
    }

    [HttpPost]
    public async Task<IActionResult> TestProductSync()
    {
        try
        {
            if (string.IsNullOrEmpty(_settings.ApiKey) || string.IsNullOrEmpty(_settings.ApiSecret))
            {
                return Json(new { success = false, message = "API kimlik bilgileri yapılandırılmamış." });
            }

            var categories = await _adisyoApiService.GetProductsAsync();
            var totalProducts = categories.SelectMany(c => c.Products).Count();

            return Json(new { success = true, message = $"Test başarılı! {categories.Count} kategori ve {totalProducts} ürün bulundu." });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Product sync test failed");
            return Json(new { success = false, message = $"Test hatası: {ex.Message}" });
        }
    }
}