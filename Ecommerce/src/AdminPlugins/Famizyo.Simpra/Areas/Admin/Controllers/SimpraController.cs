using Famizyo.Simpra.Areas.Admin.Models;
using Famizyo.Simpra.Services;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Business.Core.Interfaces.Checkout.CheckoutAttributes;
using Grand.Business.Core.Interfaces.Checkout.Payments;
using Grand.Data;
using Grand.Domain.Orders;
using Grand.Web.Common.Controllers;
using Grand.Web.Common.Filters;
using Grand.Web.Common.Security.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Text.Json;
using Grand.Web.Common.Extensions;
using Microsoft.Extensions.Logging;
using MongoDB.Driver.Linq;

namespace Famizyo.Simpra.Areas.Admin.Controllers;

public class SimpraController : BaseAdminPluginController
{
    private readonly ISettingService _settingService;
    private readonly ITranslationService _translationService;
    private readonly ISimpraApiService _simpraApiService;
    private readonly ICategoryService _categoryService;
    private readonly ITaxCategoryService _taxCategoryService;
    private readonly IProductLayoutService _productLayoutService;
    private readonly IPaymentService _paymentService;
    private readonly ISimpraToGrandSyncService _simpraToGrandSyncService;
    private readonly ISimpraOrderService _simpraOrderService;
    private readonly IRepository<Order> _orderRepository;
    private readonly ILogger<SimpraController> _logger;
    private readonly ICheckoutAttributeService _checkoutAttributeService;
    private readonly IGrandToSimpraSyncService _grandToSimpraSyncService;
    private readonly ISimpraProductSyncService _simpraProductSyncService;

    public SimpraController(
        ISettingService settingService,
        ITranslationService translationService,
        ISimpraApiService simpraApiService,
        ICategoryService categoryService,
        ITaxCategoryService taxCategoryService,
        IProductLayoutService productLayoutService,
        IPaymentService paymentService,
        ISimpraToGrandSyncService simpraToGrandSyncService,
        ISimpraOrderService simpraOrderService,
        IRepository<Order> orderRepository,
        ILogger<SimpraController> logger,
        ICheckoutAttributeService checkoutAttributeService,
        IGrandToSimpraSyncService grandToSimpraSyncService,
        ISimpraProductSyncService simpraProductSyncService)
    {
        _settingService = settingService;
        _translationService = translationService;
        _simpraApiService = simpraApiService;
        _categoryService = categoryService;
        _taxCategoryService = taxCategoryService;
        _productLayoutService = productLayoutService;
        _paymentService = paymentService;
        _simpraToGrandSyncService = simpraToGrandSyncService;
        _simpraOrderService = simpraOrderService;
        _orderRepository = orderRepository;
        _logger = logger;
        _checkoutAttributeService = checkoutAttributeService;
        _grandToSimpraSyncService = grandToSimpraSyncService;
        _simpraProductSyncService = simpraProductSyncService;
    }

    public async Task<IActionResult> Configure()
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        var model = await PrepareConfigureViewModelAsync(settings);
        return View(model);
    }

    public async Task<IActionResult> Test()
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        var model = await PrepareConfigureViewModelAsync(settings);
        return View(model);
    }

    public async Task<IActionResult> Configure_Simple()
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        var model = await PrepareConfigureViewModelAsync(settings);
        return View(model);
    }

    [HttpPost]
    [ArgumentNameFilter(KeyName = "save-continue", Argument = "continueEditing")]
    public async Task<IActionResult> Configure(ConfigureViewModel model, bool continueEditing)
    {
        if (ModelState.IsValid)
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            // API Configuration
            settings.AccessToken = model.AccessToken;
            settings.SimpraEnvironment = model.SimpraEnvironment;
            
            // Product Synchronization Settings
            settings.EnableProductSync = model.EnableProductSync;
            settings.ExportToSimpra = model.ExportToSimpra;
            settings.ImportFromSimpra = model.ImportFromSimpra;
            settings.SyncProductPrices = model.SyncProductPrices;
            settings.ImportPhotoFromSimpra = model.ImportPhotoFromSimpra;
            settings.ForceUpdateSku = model.ForceUpdateSku;
            settings.DefaultImportCategoryId = model.DefaultImportCategoryId;
            
            // Revenue Center Configuration
            settings.RevenueCenterId = model.RevenueCenterId;
            settings.SalesChannelId = model.SalesChannelId;
            settings.EmployeeId = model.EmployeeId;
            settings.PropertyId = model.PropertyId;
            
            // Order Settings
            settings.EnableOrderStatusSync = model.EnableOrderStatusSync;
            settings.OrderStatusSyncInterval = model.OrderStatusSyncInterval;
            
            // Redis Configuration
            settings.RedisChannelPrefix = model.RedisChannelPrefix;
            
            // Payment Mappings
            settings.PaymentMethodMappings = JsonSerializer.Serialize(model.PaymentMethodMappings);
            
            // Tax Category Mappings
            settings.TaxCategoryMappings = JsonSerializer.Serialize(model.TaxCategoryMappings);
            
            // Service Charge Mappings
            settings.ServiceChargeMappings = JsonSerializer.Serialize(model.ServiceChargeMappings);
            
            // Category Management
            settings.SyncCategoryIds = string.Join(",", model.SyncCategoryIds);
            settings.HomepageCategoryIds = string.Join(",", model.HomepageCategoryIds);
            settings.FeaturedProductCategoryIds = string.Join(",", model.FeaturedProductCategoryIds);
            settings.ImportSimpraCategories = string.Join(",", model.ImportSimpraCategories);
            
            // Product Configuration
            settings.ProductLayoutId = model.ProductLayoutId;
            settings.TaxCategoryId = model.TaxCategoryId;
            settings.DefaultSimpraMenuItemGroupId = model.DefaultSimpraMenuItemGroupId;

            await _settingService.SaveSetting(settings);

            Success(_translationService.GetResource("Admin.Plugins.Saved"));

            return RedirectToAction("Configure");
        }

        // If we got this far, something failed, redisplay form
        model = await PrepareConfigureViewModelAsync(_settingService.LoadSetting<SimpraSettings>(), model);
        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> TestConnection()
    {
        try
        {
            var isConnected = await _simpraApiService.TestConnectionAsync();
            if (isConnected)
            {
                return Json(new { success = true, message = "Bağlantı başarılı!" });
            }
            else
            {
                return Json(new { success = false, message = "Bağlantı başarısız. API ayarlarınızı kontrol edin." });
            }
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = $"Bağlantı hatası: {ex.Message}" });
        }
    }

    [HttpPost]
    public async Task<IActionResult> LoadSimpraData()
    {
        try
        {
            var revenueCenters = new List<SelectListItem>();
            var salesChannels = new List<SelectListItem>();
            var employees = new List<SelectListItem>();

            // Get revenue centers
            var revenueCentersResponse = await _simpraApiService.GetRevenueCentersAsync();
            if (revenueCentersResponse.Success && revenueCentersResponse.Data != null)
            {
                revenueCenters = revenueCentersResponse.Data
                    .Where(rc => rc.Active)
                    .Select(rc => new SelectListItem
                    {
                        Text = rc.Name,
                        Value = rc.Id
                    }).ToList();
            }

            // Get sales channels
            var salesChannelsResponse = await _simpraApiService.GetSalesChannelsAsync();
            if (salesChannelsResponse.Success && salesChannelsResponse.Data != null)
            {
                salesChannels = salesChannelsResponse.Data
                    .Select(sc => new SelectListItem
                    {
                        Text = sc.Name,
                        Value = sc.Id
                    }).ToList();
            }

            // Get employees
            var employeesResponse = await _simpraApiService.GetEmployeesAsync();
            if (employeesResponse.Success && employeesResponse.Data != null)
            {
                employees = employeesResponse.Data
                    .Select(emp => new SelectListItem
                    {
                        Text = emp.Name,
                        Value = emp.Id
                    }).ToList();
            }

            return Json(new { 
                success = true, 
                revenueCenters = revenueCenters,
                salesChannels = salesChannels,
                employees = employees,
                revenueCentersWithPropertyIds = revenueCentersResponse.Data?.Select(rc => new { 
                    id = rc.Id, 
                    propertyId = rc.PropertyId,
                    type = rc.Type 
                }).ToList()
            });
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = $"Veri yükleme hatası: {ex.Message}" });
        }
    }

    #region Manual Sync Operations

    [HttpPost]
    public async Task<IActionResult> SyncProductsFromSimpra()
    {
        try
        {
            await _simpraToGrandSyncService.SyncProductsFromSimpraAsync();
            return Json(new { success = true, message = "Simpra'dan ürün aktarımı başarıyla tamamlandı." });
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = $"Ürün aktarımı sırasında hata oluştu: {ex.Message}" });
        }
    }

    [HttpPost]
    public async Task<IActionResult> SyncProductsToSimpra()
    {
        try
        {
            await _grandToSimpraSyncService.SyncProductsToSimpraAsync();
            return Json(new { success = true, message = "GrandNode'dan Simpra'ya ürün aktarımı başarıyla tamamlandı." });
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = $"Ürün aktarımı sırasında hata oluştu: {ex.Message}" });
        }
    }

    [HttpPost]
    public async Task<IActionResult> SyncCategoriesFromSimpra()
    {
        try
        {
            await _simpraToGrandSyncService.SyncCategoriesFromSimpraAsync();
            return Json(new { success = true, message = "Simpra'dan kategori aktarımı başarıyla tamamlandı." });
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = $"Kategori aktarımı sırasında hata oluştu: {ex.Message}" });
        }
    }

    [HttpPost]
    public async Task<IActionResult> SyncProductPrices()
    {
        try
        {
            await _simpraToGrandSyncService.SyncProductPricesFromSimpraAsync();
            return Json(new { success = true, message = "Simpra'dan fiyat güncellemesi başarıyla tamamlandı." });
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = $"Fiyat güncellemesi sırasında hata oluştu: {ex.Message}" });
        }
    }

    [HttpPost]
    public async Task<IActionResult> SyncOrderStatuses()
    {
        try
        {
            await _simpraOrderService.SyncOrderStatusAsync();
            return Json(new { success = true, message = "Sipariş durum senkronizasyonu başarıyle tamamlandı." });
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = $"Sipariş durum senkronizasyonu sırasında hata oluştu: {ex.Message}" });
        }
    }

    [HttpPost]
    public async Task<IActionResult> ExportPendingOrders()
    {
        try
        {
            // Get orders in Preparing status that haven't been sent to Simpra yet
            var pendingOrders = await _orderRepository.Table
                .Where(o => o.OrderStatusId == (int)OrderStatusSystem.Processing)
                .Where(o => o.UserFields.All(ga => ga.Key != "SimpraCheckId"))
                .ToListAsync();

            _logger.LogInformation("Found {Count} pending orders to send to Simpra", pendingOrders.Count);

            foreach (var order in pendingOrders)
            {
                try
                {
                    if (await _simpraOrderService.CanSendOrderToSimpraAsync(order))
                    {
                        await _simpraOrderService.SendOrderToSimpraAsync(order);
                        _logger.LogDebug("Order {OrderId} sent to Simpra successfully", order.Id);
                    }
                    else
                    {
                        _logger.LogDebug("Order {OrderId} cannot be sent to Simpra", order.Id);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error sending order {OrderId} to Simpra", order.Id);
                    // Continue with next order
                }
            }
            
            return Json(new { success = true, message = "Sipariş aktarımı başarıyla tamamlandı." });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing pending orders for Simpra");
            return Json(new { success = false, message = $"Sipariş aktarımı sırasında hata oluştu: {ex.Message}" });
            
        }
    }

    #endregion

    private async Task<ConfigureViewModel> PrepareConfigureViewModelAsync(SimpraSettings settings, ConfigureViewModel? existingModel = null)
    {
        var model = existingModel ?? new ConfigureViewModel();

        // API Configuration
        model.AccessToken = settings.AccessToken;
        model.SimpraEnvironment = settings.SimpraEnvironment;
        
        // Product Synchronization Settings
        model.EnableProductSync = settings.EnableProductSync;
        model.ExportToSimpra = settings.ExportToSimpra;
        model.ImportFromSimpra = settings.ImportFromSimpra;
        model.SyncProductPrices = settings.SyncProductPrices;
        model.ImportPhotoFromSimpra = settings.ImportPhotoFromSimpra;
        model.ForceUpdateSku = settings.ForceUpdateSku;
        model.DefaultImportCategoryId = settings.DefaultImportCategoryId;
        
        // Revenue Center Configuration
        model.RevenueCenterId = settings.RevenueCenterId;
        model.SalesChannelId = settings.SalesChannelId;
        model.EmployeeId = settings.EmployeeId;
        model.PropertyId = settings.PropertyId;
        
        // Order Settings
        model.EnableOrderStatusSync = settings.EnableOrderStatusSync;
        model.OrderStatusSyncInterval = settings.OrderStatusSyncInterval;
        
        // Redis Configuration
        model.RedisChannelPrefix = settings.RedisChannelPrefix ?? "simpra";
        
        // Category Management
        if (!string.IsNullOrEmpty(settings.SyncCategoryIds))
        {
            model.SyncCategoryIds = settings.SyncCategoryIds.Split(',').Select(x => x.Trim()).ToList();
        }
        if (!string.IsNullOrEmpty(settings.HomepageCategoryIds))
        {
            model.HomepageCategoryIds = settings.HomepageCategoryIds.Split(',').Select(x => x.Trim()).ToList();
        }
        if (!string.IsNullOrEmpty(settings.FeaturedProductCategoryIds))
        {
            model.FeaturedProductCategoryIds = settings.FeaturedProductCategoryIds.Split(',').Select(x => x.Trim()).ToList();
        }
        if (!string.IsNullOrEmpty(settings.ImportSimpraCategories))
        {
            model.ImportSimpraCategories = settings.ImportSimpraCategories.Split(',').Select(x => x.Trim()).ToList();
        }
        
        // Product Configuration
        model.ProductLayoutId = settings.ProductLayoutId;
        model.TaxCategoryId = settings.TaxCategoryId;
        model.DefaultSimpraMenuItemGroupId = settings.DefaultSimpraMenuItemGroupId;

        model.AvailableProductLayouts = (await _productLayoutService.GetAllProductLayouts()).Select(x=> new SelectListItem() {
            Text = x.Name,
            Value = x.Id,
            Selected = x.Id == settings.ProductLayoutId
        }).ToList(); 

        // Parse payment method mappings
        if (!string.IsNullOrEmpty(settings.PaymentMethodMappings))
        {
            try
            {
                model.PaymentMethodMappings = JsonSerializer.Deserialize<Dictionary<string, string>>(settings.PaymentMethodMappings) 
                                            ?? new Dictionary<string, string>();
            }
            catch
            {
                model.PaymentMethodMappings = new Dictionary<string, string>();
            }
        }

        // Parse tax category mappings
        if (!string.IsNullOrEmpty(settings.TaxCategoryMappings))
        {
            try
            {
                model.TaxCategoryMappings = JsonSerializer.Deserialize<Dictionary<string, string>>(settings.TaxCategoryMappings) 
                                          ?? new Dictionary<string, string>();
            }
            catch
            {
                model.TaxCategoryMappings = new Dictionary<string, string>();
            }
        }

        // Parse service charge mappings
        if (!string.IsNullOrEmpty(settings.ServiceChargeMappings))
        {
            try
            {
                model.ServiceChargeMappings = JsonSerializer.Deserialize<Dictionary<string, string>>(settings.ServiceChargeMappings) 
                                           ?? new Dictionary<string, string>();
            }
            catch
            {
                model.ServiceChargeMappings = new Dictionary<string, string>();
            }
        }
        
        
        
        

        // Prepare dropdown lists
        await PrepareDropdownListsAsync(model);

        return model;
    }

    private async Task PrepareDropdownListsAsync(ConfigureViewModel model)
    {
        // Environment options
        model.EnvironmentOptions = new List<SelectListItem>
        {
            new SelectListItem { Text = "Production", Value = SimpraEnvironment.Production.ToString() },
            new SelectListItem { Text = "UAT", Value = SimpraEnvironment.Uat.ToString() },
            new SelectListItem { Text = "QA", Value = SimpraEnvironment.Qa.ToString() }
        };

        // Load GrandNode categories for GrandNode → Simpra sync
        try
        {
            var grandNodeCategories = await _categoryService.GetAllCategories(showHidden: true);
            model.AvailableGrandNodeCategories = grandNodeCategories.Where(x=>x.UserFields.Any(uf=>uf.Key=="ImportedFromSimpra" && uf.Value=="true")).Select(c => new SelectListItem
            {
                Text = c.Name,
                Value = c.Id
            }).ToList();
        }
        catch (Exception)
        {
            model.AvailableGrandNodeCategories = new List<SelectListItem>();
        }

        // Load GrandNode tax categories
        try
        {
            var grandNodeTaxCategories = await _taxCategoryService.GetAllTaxCategories();
            model.AvailableGrandNodeTaxCategories = grandNodeTaxCategories.Select(tc => new SelectListItem
            {
                Text = tc.Name,
                Value = tc.Id
            }).ToList();
        }
        catch (Exception)
        {
            model.AvailableGrandNodeTaxCategories = new List<SelectListItem>();
        }

        // Load GrandNode payment providers
        try
        {
            var paymentProviders = await _paymentService.LoadActivePaymentMethods();
            model.AvailablePaymentProviders = paymentProviders.Select(pp => new SelectListItem
            {
                Text = pp.FriendlyName,
                Value = pp.SystemName
            }).ToList();
        }
        catch (Exception)
        {
            model.AvailablePaymentProviders = new List<SelectListItem>();
        }

        // Try to get data from Simpra API
        try
        {
            // Get Simpra menu item groups (categories) for Simpra → GrandNode sync
            var menuItemGroupsResponse = await _simpraApiService.GetMenuItemGroupsAsync();
            if (menuItemGroupsResponse.Success && menuItemGroupsResponse.Data != null)
            {
                model.AvailableSimpraCategories = menuItemGroupsResponse.Data.Select(g => new SelectListItem
                {
                    Text = g.Name,
                    Value = g.Id
                }).ToList();
                
                // Also populate AvailableSimpraMenuItemGroups for default menu item group selection
                model.AvailableSimpraMenuItemGroups = menuItemGroupsResponse.Data.Select(g => new SelectListItem
                {
                    Text = g.Name,
                    Value = g.Id
                }).ToList();
            }

            // Get Simpra tax categories
            var taxesResponse = await _simpraApiService.GetTaxesAsync();
            if (taxesResponse.Success && taxesResponse.Data != null)
            {
                model.AvailableSimpraTaxCategories = taxesResponse.Data
                    .Where(t => t.Active)
                    .Select(t => new SelectListItem
                    {
                        Text = t.Name,
                        Value = t.Id
                    }).ToList();
            }

            // Get payment types
            var paymentTypesResponse = await _simpraApiService.GetPaymentTypesAsync();
            if (paymentTypesResponse.Success && paymentTypesResponse.Data != null)
            {
                model.AvailableSimpraPaymentTypes = paymentTypesResponse.Data
                    .Where(pt => pt.Active)
                    .Select(pt => new SelectListItem
                    {
                        Text = pt.Name,
                        Value = pt.Id
                    }).ToList();
            }

            // Get revenue centers
            var revenueCentersResponse = await _simpraApiService.GetRevenueCentersAsync();
            if (revenueCentersResponse.Success && revenueCentersResponse.Data != null)
            {
                model.AvailableRevenueCenters = revenueCentersResponse.Data
                    .Where(rc => rc.Active)
                    .Select(rc => new SelectListItem
                    {
                        Text = rc.Name,
                        Value = rc.Id
                    }).ToList();
            }

            // Get sales channels
            var salesChannelsResponse = await _simpraApiService.GetSalesChannelsAsync();
            if (salesChannelsResponse.Success && salesChannelsResponse.Data != null)
            {
                model.AvailableSalesChannels = salesChannelsResponse.Data
                    .Select(sc => new SelectListItem
                    {
                        Text = sc.Name,
                        Value = sc.Id
                    }).ToList();
            }

            // Get employees
            var employeesResponse = await _simpraApiService.GetEmployeesAsync();
            if (employeesResponse.Success && employeesResponse.Data != null)
            {
                model.AvailableEmployees = employeesResponse.Data
                    .Select(emp => new SelectListItem
                    {
                        Text = emp.Name,
                        Value = emp.Id
                    }).ToList();
            }

            // Get service charges
            var serviceChargesResponse = await _simpraApiService.GetServiceChargesAsync();
            if (serviceChargesResponse.Success && serviceChargesResponse.Data != null)
            {
                model.AvailableSimpraServiceCharges = serviceChargesResponse.Data
                    .Select(sc => new SelectListItem
                    {
                        Text = sc.Name,
                        Value = sc.Id
                    }).ToList();
            }

            var checkOutAttributes = await _checkoutAttributeService.GetAllCheckoutAttributes();
            if (checkOutAttributes != null && checkOutAttributes.Any())
            {
                model.AvailableCheckoutAttributes = checkOutAttributes.ToList();
            }
            else
            {
                model.AvailableCheckoutAttributes = new List<CheckoutAttribute>();
            }
            
        }
        catch (Exception)
        {
            // If API calls fail, continue with empty lists
            model.AvailableSimpraCategories = new List<SelectListItem>();
            model.AvailableSimpraMenuItemGroups = new List<SelectListItem>();
            model.AvailableSimpraTaxCategories = new List<SelectListItem>();
            model.AvailableSimpraPaymentTypes = new List<SelectListItem>();
            model.AvailableRevenueCenters = new List<SelectListItem>();
            model.AvailableSalesChannels = new List<SelectListItem>();
            model.AvailableEmployees = new List<SelectListItem>();
            model.AvailableSimpraServiceCharges = new List<SelectListItem>();
        }
    }
}