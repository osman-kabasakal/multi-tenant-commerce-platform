using Famizyo.Simpra.Models;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Domain.Catalog;
using Microsoft.Extensions.Logging;
using Grand.Data;
using Grand.Domain.Common;
using System.Text.Json;

namespace Famizyo.Simpra.Services;

public class GrandToSimpraSyncService : IGrandToSimpraSyncService
{
    private readonly ISimpraApiService _simpraApiService;
    private readonly IProductService _productService;
    private readonly ISettingService _settingService;
    private readonly IProductAttributeService _productAttributeService;
    private readonly IRepository<Product> _productRepository;
    private readonly ICategoryService _categoryService;
    private readonly ILogger<GrandToSimpraSyncService> _logger;

    public GrandToSimpraSyncService(
        ISimpraApiService simpraApiService,
        IProductService productService,
        ISettingService settingService,
        IProductAttributeService productAttributeService,
        IRepository<Product> productRepository,
        ICategoryService categoryService,
        ILogger<GrandToSimpraSyncService> logger)
    {
        _simpraApiService = simpraApiService;
        _productService = productService;
        _settingService = settingService;
        _productAttributeService = productAttributeService;
        _productRepository = productRepository;
        _categoryService = categoryService;
        _logger = logger;
    }

    public async Task SyncProductsToSimpraAsync()
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            // Only sync if product sync is enabled and export to Simpra is enabled
            if (!settings.EnableProductSync || !settings.ExportToSimpra)
            {
                _logger.LogDebug("Product synchronization to Simpra is disabled in settings");
                return;
            }

            if (string.IsNullOrEmpty(settings.AccessToken))
            {
                _logger.LogWarning("Simpra access token not configured, skipping product sync");
                return;
            }

            _logger.LogInformation("Starting product synchronization to Simpra");

            // Get products to sync based on category filter
            var productsToSync = await GetProductsToSyncAsync(settings);
            
            foreach (var product in productsToSync)
            {
                try
                {
                    if (ShouldSyncProduct(product))
                    {
                        await SyncProductToSimpraAsync(product);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error syncing product {ProductId} to Simpra", product.Id);
                }
            }

            _logger.LogInformation("Product synchronization to Simpra completed");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during product synchronization to Simpra");
        }
    }

    public async Task SyncProductPricesToSimpraAsync()
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            if (!settings.EnableProductSync || !settings.SyncProductPrices)
            {
                return;
            }

            _logger.LogInformation("Starting product price synchronization to Simpra");

            // Get products that are already synced to Simpra
            var syncedProducts = await GetSyncedProductsAsync();

            foreach (var product in syncedProducts)
            {
                try
                {
                    var simpraMenuItemId = GetSimpraMenuItemId(product);
                    if (!string.IsNullOrEmpty(simpraMenuItemId))
                    {
                        var menuItemRequest = await ConvertProductToMenuItemAsync(product);
                        await _simpraApiService.UpdateMenuItemAsync(simpraMenuItemId, menuItemRequest);
                        
                        _logger.LogDebug("Updated price for product {ProductId} in Simpra", product.Id);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error updating price for product {ProductId} in Simpra", product.Id);
                }
            }

            _logger.LogInformation("Product price synchronization to Simpra completed");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during product price synchronization to Simpra");
        }
    }

    public async Task<SimpraMenuItemRequest> ConvertProductToMenuItemAsync(Product product)
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        
        // Get menu item group ID - check all product categories
        string? menuItemGroupId = null;
        
        // First, try to get menu item group ID from product categories
        foreach (var productCategory in product.ProductCategories)
        {
            menuItemGroupId = await GetSimpraMenuItemGroupIdAsync(productCategory.CategoryId);
            if (!string.IsNullOrEmpty(menuItemGroupId))
            {
                break; // Use the first category that has a menu item group ID
            }
        }
        
        // If still no menu item group ID, try with empty category ID (will use default from settings)
        if (string.IsNullOrEmpty(menuItemGroupId))
        {
            menuItemGroupId = await GetSimpraMenuItemGroupIdAsync("");
        }
        
        // If still null, throw exception as menu item group is required
        if (string.IsNullOrEmpty(menuItemGroupId))
        {
            throw new InvalidOperationException($"Cannot sync product {product.Name} to Simpra: No menu item group ID available. " +
                "Please configure a default menu item group ID in settings or assign a Simpra menu item group ID to the product's category.");
        }

        var menuItem = new SimpraMenuItemRequest
        {
            //PropertyIds = new List<string>(), // Will be populated based on business requirements
            Name = product.Name,
            Price = product.Price, // Convert to cents/kuruş
            TaxId = GetTaxCategoryForProduct(product, settings), // Use configured tax category
            MenuItemGroupId = menuItemGroupId, // Now guaranteed to have a value
            Barcodes = !string.IsNullOrEmpty(product.Sku) ? new List<string> { product.Sku } : null,
            Quantity = 1, // Default quantity
            ReceipeMenuItem = true, // Default to false
            Translations = new List<SimpraTranslationRequest>
            {
                new SimpraTranslationRequest
                {
                    Locale = "tr",
                    Text = product.Name
                },
                new SimpraTranslationRequest
                {
                    Locale = "en", 
                    Text = product.Name
                }
            },
            ReportTagIds = new List<string>() // Will be populated based on business requirements
        };

        return menuItem;
    }

    public async Task<string?> GetSimpraMenuItemGroupIdAsync(string categoryId)
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            // If a category ID is provided, check if it has a Simpra menu item group ID in UserFields
            if (!string.IsNullOrEmpty(categoryId))
            {
                var category = await _categoryService.GetCategoryById(categoryId);
                if (category != null)
                {
                    // Check if category has SimpraMenuItemGroupId in UserFields
                    var simpraMenuItemGroupId = category.UserFields
                        .FirstOrDefault(uf => uf.Key == "SimpraMenuItemGroupId")?.Value;
                    
                    if (!string.IsNullOrEmpty(simpraMenuItemGroupId))
                    {
                        _logger.LogDebug("Found Simpra menu item group ID {MenuItemGroupId} in category {CategoryId} UserFields", 
                            simpraMenuItemGroupId, categoryId);
                        return simpraMenuItemGroupId;
                    }
                }
            }
            
            // If no specific menu item group ID found in category, use the default from settings
            if (!string.IsNullOrEmpty(settings.DefaultSimpraMenuItemGroupId))
            {
                _logger.LogDebug("Using default Simpra menu item group ID {MenuItemGroupId} from settings", 
                    settings.DefaultSimpraMenuItemGroupId);
                return settings.DefaultSimpraMenuItemGroupId;
            }
            
            // Fallback: Return the first available menu item group
            var menuItemGroupsResponse = await _simpraApiService.GetMenuItemGroupsAsync();
            
            if (menuItemGroupsResponse.Success && menuItemGroupsResponse.Data?.Any() == true)
            {
                var firstGroupId = menuItemGroupsResponse.Data.First().Id;
                _logger.LogWarning("No default menu item group configured, using first available: {MenuItemGroupId}", firstGroupId);
                return firstGroupId;
            }

            _logger.LogWarning("No Simpra menu item groups available");
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting Simpra menu item group for category {CategoryId}", categoryId);
            return null;
        }
    }

    public bool ShouldSyncProduct(Product product)
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        
        if (!settings.EnableProductSync)
            return false;

        if (!product.Published)
            return false;

        // Check category filter
        if (!string.IsNullOrEmpty(settings.SyncCategoryIds))
        {
            var syncCategoryIds = settings.SyncCategoryIds.Split(',').Select(x => x.Trim()).ToList();
            var productCategoryIds = product.ProductCategories.Select(pc => pc.CategoryId).ToList();
            
            if (!syncCategoryIds.Any(scId => productCategoryIds.Contains(scId)))
            {
                return false;
            }
        }
        
        if(product.UserFields.Any(x=>x.Key=="ImportedFromSimpra" && x.Value == "true"))
        {
            // Skip products that were imported from Simpra
            return false;
        }

        return true;
    }

    public async Task<List<SimpraCondimentGroup>> GetCondimentGroupsForProductAsync(Product product)
    {
        var condimentGroups = new List<SimpraCondimentGroup>();

        try
        {
            // Convert product attributes to condiment groups
            if (product.ProductAttributeMappings?.Any() == true)
            {
                foreach (var attributeMapping in product.ProductAttributeMappings)
                {
                    var productAttribute = await _productAttributeService.GetProductAttributeById(attributeMapping.ProductAttributeId);
                    var condimentGroup = new SimpraCondimentGroup
                    {
                        Id = productAttribute?.Id ?? Guid.NewGuid().ToString(),
                        Multiple = attributeMapping.AttributeControlTypeId == AttributeControlType.Checkboxes,
                        UpdatedAt = DateTimeOffset.UtcNow.ToUnixTimeSeconds(),
                        Translations = new List<SimpraTranslation>
                        {
                            new SimpraTranslation
                            {
                                Name = productAttribute?.Name ?? "Options",
                                Locale = "tr"
                            }
                        }
                    };

                    condimentGroups.Add(condimentGroup);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating condiment groups for product {ProductId}", product.Id);
        }

        return condimentGroups;
    }

    /// <summary>
    /// Checks if a category should be shown on homepage based on settings
    /// </summary>
    public bool ShouldShowCategoryOnHomepage(string categoryId, SimpraSettings settings)
    {
        if (string.IsNullOrEmpty(settings.HomepageCategoryIds))
            return false;
            
        var homepageCategoryIds = settings.HomepageCategoryIds
            .Split(',')
            .Select(id => id.Trim())
            .Where(id => !string.IsNullOrEmpty(id))
            .ToHashSet();
            
        return homepageCategoryIds.Contains(categoryId);
    }

    /// <summary>
    /// Checks if a product should be featured based on its categories and settings
    /// </summary>
    public bool ShouldFeatureProduct(Product product, SimpraSettings settings)
    {
        if (string.IsNullOrEmpty(settings.FeaturedProductCategoryIds))
            return false;
            
        var featuredCategoryIds = settings.FeaturedProductCategoryIds
            .Split(',')
            .Select(id => id.Trim())
            .Where(id => !string.IsNullOrEmpty(id))
            .ToHashSet();
            
        var productCategoryIds = product.ProductCategories.Select(pc => pc.CategoryId).ToList();
        return productCategoryIds.Any(pcId => featuredCategoryIds.Contains(pcId));
    }

    /// <summary>
    /// Gets the tax category ID to use for product based on settings
    /// </summary>
    public string GetTaxCategoryForProduct(Product product, SimpraSettings settings)
    {
        // Use configured tax category if available, otherwise use product's current tax category
        var simpraTaxId = GetMappedTaxCategoryId(product.TaxCategoryId, settings);
        if (!string.IsNullOrEmpty(simpraTaxId))
        {
            return simpraTaxId;
        }
        if (!string.IsNullOrEmpty(settings.TaxCategoryId))
        {
            return settings.TaxCategoryId;
        }
        
        return product.TaxCategoryId ?? "";
    }
    
    /// <summary>
    /// Gets the mapped GrandNode tax category ID for a given Simpra tax ID
    /// </summary>
    private string? GetMappedTaxCategoryId(string grandTaxId, SimpraSettings settings)
    {
        if (string.IsNullOrEmpty(grandTaxId) || string.IsNullOrEmpty(settings.TaxCategoryMappings))
        {
            return null;
        }

        try
        {
            var taxMappings = JsonSerializer.Deserialize<Dictionary<string, string>>(settings.TaxCategoryMappings);
            
            if (taxMappings != null)
            {
                var taxMappingReversed = new Dictionary<string, string>(taxMappings.GroupBy(x => x.Value)
                    .Select(x => new KeyValuePair<string, string>(x.Key, x.First().Key)));
                    

                if (taxMappingReversed.TryGetValue(grandTaxId, out var simpraCategoryId))
                {
                    _logger.LogDebug("Found tax mapping: Simpra tax ID {SimpraTaxId} -> GrandNode tax category ID {GrandNodeTaxCategoryId}", 
                        simpraCategoryId, grandTaxId);
                    return simpraCategoryId;
                }
            }
            
            _logger.LogDebug("No tax mapping found for Grand tax ID {SimpraTaxId}", grandTaxId);
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error parsing tax category mappings for Grand tax ID {SimpraTaxId}", grandTaxId);
            return null;
        }
    }

    /// <summary>
    /// Gets the product layout ID to use based on settings
    /// </summary>
    public string GetProductLayoutForProduct(Product product, SimpraSettings settings)
    {
        // Use configured product layout if available, otherwise use product's current layout
        if (!string.IsNullOrEmpty(settings.ProductLayoutId))
        {
            return settings.ProductLayoutId;
        }
        
        return product.ProductLayoutId ?? "";
    }

    private async Task<List<Product>> GetProductsToSyncAsync(SimpraSettings settings)
    {
        // Filter by categories if specified
        List<string> categoryIds = new List<string>();
        if (!string.IsNullOrEmpty(settings.SyncCategoryIds))
        {
            categoryIds = settings.SyncCategoryIds.Split(',').Select(x => x.Trim()).ToList();
        }

        // Only active products
        var query = await _productService.SearchProducts(
            categoryIds: categoryIds,
            showHidden: false
        );
        return query.products.ToList();
    }

    private async Task<List<Product>> GetSyncedProductsAsync()
    {
        // Get products that have been synced to Simpra (have SimpraMenuItemId in GenericAttributes)
        return await Task.FromResult(_productRepository.Table
            .Where(p => p.UserFields.Any(ga => ga.Key == "SimpraMenuItemId"))
            .ToList());
    }

    private async Task SyncProductToSimpraAsync(Product product)
    {
        try
        {
            var existingMenuItemId = GetSimpraMenuItemId(product);
            var menuItemRequest = await ConvertProductToMenuItemAsync(product);

            if (!string.IsNullOrEmpty(existingMenuItemId))
            {
                // Update existing menu item
                await _simpraApiService.UpdateMenuItemAsync(existingMenuItemId, menuItemRequest);
                _logger.LogDebug("Updated product {ProductId} in Simpra", product.Id);
            }
            else
            {
                // Create new menu item
                var response = await _simpraApiService.CreateMenuItemAsync(menuItemRequest);
                if (response.Success && response.Data != null)
                {
                    await StoreSimpraMenuItemIdAsync(product, response.Data.Id);
                    _logger.LogDebug("Created product {ProductId} in Simpra with ID {MenuItemId}", 
                        product.Id, response.Data.Id);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error syncing product {ProductId} to Simpra", product.Id);
            throw;
        }
    }

    private string? GetSimpraMenuItemId(Product product)
    {
        var menuItemIdString = product.UserFields
            .FirstOrDefault(x => x.Key == "SimpraMenuItemId")?.Value;

        if (!string.IsNullOrEmpty(menuItemIdString))
        {
            return menuItemIdString;
        }

        return null;
    }

    private async Task StoreSimpraMenuItemIdAsync(Product product, string simpraMenuItemId)
    {
        product.UserFields.Add(new UserField()
        {
            Key = "SimpraMenuItemId",
            Value = simpraMenuItemId
        });

        await _productService.UpdateProduct(product);
    }
}