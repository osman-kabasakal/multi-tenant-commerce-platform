using Famizyo.Simpra.Models;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Domain.Catalog;
using Microsoft.Extensions.Logging;
using Grand.Data;
using Grand.Domain.Common;
using System.Net.Http;
using Famizyo.Simpra.Domain;
using System.Text.Json;

namespace Famizyo.Simpra.Services;

public class SimpraToGrandSyncService : ISimpraToGrandSyncService
{
    private readonly ISimpraApiService _simpraApiService;
    private readonly IProductService _productService;
    private readonly ISettingService _settingService;
    private readonly IProductAttributeService _productAttributeService;
    private readonly ICategoryService _categoryService;
    private readonly IRepository<Product> _productRepository;
    private readonly IRepository<Category> _categoryRepository;
    private readonly IPictureService _pictureService;
    private readonly ISimpraCondimentMappingService _condimentMappingService;
    private readonly ILogger<SimpraToGrandSyncService> _logger;

    public SimpraToGrandSyncService(
        ISimpraApiService simpraApiService,
        IProductService productService,
        ISettingService settingService,
        IProductAttributeService productAttributeService,
        ICategoryService categoryService,
        IRepository<Product> productRepository,
        IRepository<Category> categoryRepository,
        IPictureService pictureService,
        ISimpraCondimentMappingService condimentMappingService,
        ILogger<SimpraToGrandSyncService> logger)
    {
        _simpraApiService = simpraApiService;
        _productService = productService;
        _settingService = settingService;
        _productAttributeService = productAttributeService;
        _categoryService = categoryService;
        _productRepository = productRepository;
        _categoryRepository = categoryRepository;
        _pictureService = pictureService;
        _condimentMappingService = condimentMappingService;
        _logger = logger;
    }

    public async Task SyncProductsFromSimpraAsync()
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            if (!settings.EnableProductSync || !settings.ImportFromSimpra)
            {
                _logger.LogDebug("Product import from Simpra is disabled in settings");
                return;
            }

            if (string.IsNullOrEmpty(settings.AccessToken))
            {
                _logger.LogWarning("Simpra access token not configured, skipping product import");
                return;
            }

            _logger.LogInformation("Starting product import from Simpra");

            // First, sync categories from Simpra menu item groups
            await SyncCategoriesFromSimpraAsync();

            // Parse allowed category IDs for product filtering
            var allowedCategoryIds = !string.IsNullOrEmpty(settings.ImportSimpraCategories) 
                ? settings.ImportSimpraCategories.Split(',', StringSplitOptions.RemoveEmptyEntries)
                    .Select(x => x.Trim()).ToList()
                : null;

            // Then, get menu items from Simpra using the PropertyId from settings
            var menuItemsResponse = await _simpraApiService.GetMenuItemsAsync(
                propertyIds: settings.PropertyId
            );
            
            if (menuItemsResponse.Success && menuItemsResponse.Data?.Any() == true)
            {
                foreach (var menuItem in menuItemsResponse.Data)
                {
                    try
                    {
                        // Filter by category if configured
                        if (allowedCategoryIds != null && !allowedCategoryIds.Contains(menuItem.MenuItemGroupId))
                        {
                            _logger.LogDebug("Skipping menu item {MenuItemId} - category {CategoryId} not in allowed categories list", 
                                menuItem.Id, menuItem.MenuItemGroupId);
                            continue;
                        }

                        await ImportMenuItemFromSimpraAsync(menuItem);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Error importing menu item {MenuItemId} from Simpra", menuItem.Id);
                    }
                }
            }

            _logger.LogInformation("Product import from Simpra completed");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during product import from Simpra");
        }
    }

    public async Task SyncCategoriesFromSimpraAsync()
    {
        try
        {
            _logger.LogInformation("Starting category synchronization from Simpra");

            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            // Parse allowed category IDs from settings
            var allowedCategoryIds = !string.IsNullOrEmpty(settings.ImportSimpraCategories) 
                ? settings.ImportSimpraCategories.Split(',', StringSplitOptions.RemoveEmptyEntries)
                    .Select(x => x.Trim()).ToList()
                : null;

            // Get menu item groups from Simpra
            var menuItemGroupsResponse = await _simpraApiService.GetMenuItemGroupsAsync();
            
            if (menuItemGroupsResponse.Success && menuItemGroupsResponse.Data?.Any() == true)
            {
                foreach (var menuItemGroup in menuItemGroupsResponse.Data)
                {
                    try
                    {
                        // Filter by allowed categories if configured
                        if (allowedCategoryIds != null && !allowedCategoryIds.Contains(menuItemGroup.Id))
                        {
                            _logger.LogDebug("Skipping menu item group {GroupId} - not in allowed categories list", menuItemGroup.Id);
                            continue;
                        }

                        await CreateOrUpdateCategoryFromMenuItemGroupAsync(menuItemGroup);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Error creating/updating category for menu item group {GroupId}", menuItemGroup.Id);
                    }
                }
            }

            _logger.LogInformation("Category synchronization from Simpra completed");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during category synchronization from Simpra");
        }
    }

    public async Task SyncProductPricesFromSimpraAsync()
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            if (!settings.EnableProductSync || !settings.ImportFromSimpra || !settings.SyncProductPrices)
            {
                return;
            }

            _logger.LogInformation("Starting product price import from Simpra");

            // Get products that were imported from Simpra
            var importedProducts = _productRepository.Table
                .Where(p => p.UserFields.Any(uf => uf.Key == "ImportedFromSimpra" && uf.Value == "true"))
                .ToList();

            foreach (var product in importedProducts)
            {
                try
                {
                    var simpraMenuItemIdString = product.UserFields.FirstOrDefault(uf => uf.Key == "SimpraMenuItemId")?.Value;
                    if (!string.IsNullOrEmpty(simpraMenuItemIdString))
                    {
                        // Get price from item definitions endpoint
                        var itemDefinition = await GetItemDefinitionForMenuItemAsync(simpraMenuItemIdString);
                        if (itemDefinition != null)
                        {
                            product.Price = (double)itemDefinition.PriceDecimal;
                            product.UpdatedOnUtc = DateTime.UtcNow;
                            
                            await _productService.UpdateProduct(product);
                            
                            _logger.LogDebug("Updated price for product {ProductId} from Simpra", product.Id);
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error updating price for product {ProductId} from Simpra", product.Id);
                }
            }

            _logger.LogInformation("Product price import from Simpra completed");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during product price import from Simpra");
        }
    }

    public async Task<SimpraItemDefinition?> GetItemDefinitionForMenuItemAsync(string menuItemId)
    {
        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            if (string.IsNullOrEmpty(settings.RevenueCenterId))
            {
                _logger.LogWarning("Revenue center ID is not configured, cannot get item definition for menu item {MenuItemId}", menuItemId);
                return null;
            }

            var itemDefinitionsResponse = await _simpraApiService.GetItemDefinitionsAsync(
                sourceType: "MenuItem",
                sourceId: menuItemId,
                targetId: settings.RevenueCenterId,
                propertyIds: settings.PropertyId,
                status: "active"
            );

            if (itemDefinitionsResponse.Success && itemDefinitionsResponse.Data?.Any() == true)
            {
                // Return the first matching item definition
                return itemDefinitionsResponse.Data.FirstOrDefault();
            }

            _logger.LogWarning("No item definition found for menu item {MenuItemId} in revenue center {RevenueCenterId}", 
                menuItemId, settings.RevenueCenterId);
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting item definition for menu item {MenuItemId}", menuItemId);
            return null;
        }
    }

    public async Task ImportProductImageFromSimpraAsync(Product product, SimpraMenuItemImage imageInfo)
    {
        try
        {
            // Choose the best available image URL (prefer medium or large size)
            var simpraSettings =  _settingService.LoadSetting<SimpraSettings>();
            var baseUrl = simpraSettings.SimpraEnvironment switch
            {
                SimpraEnvironment.Production => "https://api.simpra.app/",
                SimpraEnvironment.Uat => "https://api-uat.simpra.app/",
                SimpraEnvironment.Qa => "https://api-qa.simpra.app/",
                _ => throw new ArgumentOutOfRangeException(nameof(simpraSettings.SimpraEnvironment), "Invalid environment setting")
            };
            string? imageUrl = imageInfo.LargeImageUrl ?? imageInfo.SmallImageUrl ??  imageInfo.LargeImageUrl;
            
            if (string.IsNullOrEmpty(imageUrl))
            {
                _logger.LogWarning("No valid image URL found for Simpra menu item image {ImageId}", imageInfo.Id);
                return;
            }

            // if (imageInfo.RawUrlPath != null)
            // {
            //     var imageHost = Uri.TryCreate(imageUrl!, UriKind.Absolute, out var uri) ? uri.Host : null;
            //     if (imageHost != null)
            //     {
            //        var imageHostBuilder = new UriBuilder(schemeName: uri.Scheme, hostName: uri.Host);
            //        imageHostBuilder.Path = imageInfo.RawUrlPath;
            //        imageUrl = imageHostBuilder.ToString();
            //     }
            // }

            // Check if image is already synced by comparing URL in UserFields
            var currentSimpraImageField = product.UserFields.FirstOrDefault(x => x.Key == "SimpraImageUrl");
            if (currentSimpraImageField?.Value == imageUrl)
            {
                _logger.LogDebug("Product image already synced for {ProductName} (ID: {ProductId})",
                    product.Name, product.Id);
                return;
            }

            if (currentSimpraImageField != null)
            {
                product.UserFields.Remove(currentSimpraImageField);
            }
            
            // Remove existing ProductPictures if any (following Adisyo pattern)
            foreach (var productPicture in product.ProductPictures.ToList())
            {
                var existingPicture = await _pictureService.GetPictureById(productPicture.PictureId);
                if (existingPicture != null)
                {
                    await _pictureService.DeletePicture(existingPicture);
                    await _productService.DeleteProductPicture(productPicture, product.Id);
                }
            }

            _logger.LogDebug("Downloading image from Simpra: {ImageUrl} for product {ProductId}", imageUrl, product.Id);

            // Download the image from Simpra
            using var httpClient = new HttpClient();
            httpClient.Timeout = TimeSpan.FromSeconds(30);
            httpClient.DefaultRequestHeaders.Add("Simpra-Access-Token", simpraSettings.AccessToken);
            
            var imageBytes = await httpClient.GetByteArrayAsync(imageUrl);
            
            if (imageBytes == null || imageBytes.Length == 0)
            {
                _logger.LogWarning("Downloaded image is empty for product {ProductId} from URL {ImageUrl}", product.Id, imageUrl);
                return;
            }

            // Save product image using IPictureService (following Adisyo pattern)
            var picture = await _pictureService.InsertPicture(imageBytes,
                GetMimeType(imageInfo.RawUrlPath??""),
                _pictureService.GetPictureSeName(product.Name),
                reference: Reference.Product,
                objectId: product.Id);

            // Create ProductPicture association
            await _productService.InsertProductPicture(
                new ProductPicture {
                    PictureId = picture.Id,
                    DisplayOrder = 0
                },
                product.Id
            );
            
            // Store Simpra image tracking information in UserFields
            product.UserFields.Add(new UserField {
                Key = "SimpraImageUrl",
                Value = imageUrl
            });
            
            var imageIdField = product.UserFields.FirstOrDefault(uf => uf.Key == "SimpraImageId");
            if (imageIdField != null)
            {
                imageIdField.Value = imageInfo.Id;
            }
            else
            {
                product.UserFields.Add(new UserField
                {
                    Key = "SimpraImageId",
                    Value = imageInfo.Id
                });
            }
            
            await _productService.UpdateProduct(product);

            _logger.LogDebug("Successfully imported and saved image for product {ProductName} (ID: {ProductId}). Image size: {ImageSize} bytes", 
                product.Name, product.Id, imageBytes.Length);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error importing image for product {ProductId} from Simpra", product.Id);
        }
    }

    private async Task CreateOrUpdateCategoryFromMenuItemGroupAsync(SimpraMenuItemGroup menuItemGroup)
    {
        try
        {
            // Check if category already exists by ExternalId
            var existingCategory = _categoryRepository.Table
                .FirstOrDefault(c => c.ExternalId == menuItemGroup.Id);

            if (existingCategory != null)
            {
                // Update existing category
                await UpdateCategoryFromMenuItemGroupAsync(existingCategory, menuItemGroup);
                _logger.LogDebug("Updated category {CategoryId} from Simpra menu item group {GroupId}", 
                    existingCategory.Id, menuItemGroup.Id);
            }
            else
            {
                // Create new category
                var newCategory = await CreateCategoryFromMenuItemGroupAsync(menuItemGroup);
                _logger.LogDebug("Created new category {CategoryId} from Simpra menu item group {GroupId}", 
                    newCategory.Id, menuItemGroup.Id);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing menu item group {GroupId}", menuItemGroup.Id);
            throw;
        }
    }

    private async Task<Category> CreateCategoryFromMenuItemGroupAsync(SimpraMenuItemGroup menuItemGroup)
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        
        // Check if this category should be shown on homepage
        var homepageCategoryIds = !string.IsNullOrEmpty(settings.HomepageCategoryIds) 
            ? settings.HomepageCategoryIds.Split(',', StringSplitOptions.RemoveEmptyEntries)
                .Select(x => x.Trim()).ToList()
            : null;
        
        bool showOnHomePage = homepageCategoryIds?.Contains(menuItemGroup.Id) == true;

        var category = new Category
        {
            Name = menuItemGroup.Name,
            Description = $"Category imported from Simpra (ID: {menuItemGroup.Id})",
            ExternalId = menuItemGroup.Id, // Set Simpra menu item group ID as ExternalId
            Published = menuItemGroup.Active,
            ShowOnHomePage = showOnHomePage, // Set based on HomepageCategoryIds setting
            IncludeInMenu = true,
            PageSize = 12,
            AllowCustomersToSelectPageSize = true,
            PageSizeOptions = "6,3,9,18,20",
            DisplayOrder = 0,
            CreatedOnUtc = DateTime.UtcNow,
            UpdatedOnUtc = DateTime.UtcNow,
            UserFields = new List<UserField>
            {
                new UserField
                {
                    Key = "SimpraMenuItemGroupId",
                    Value = menuItemGroup.Id
                },
                new UserField
                {
                    Key = "ImportedFromSimpra",
                    Value = "true"
                },
                new UserField
                {
                    Key = "SimpraParentId",
                    Value = menuItemGroup.ParentMigId ?? ""
                }
            }
        };

        // Set parent category if exists
        if (!string.IsNullOrEmpty(menuItemGroup.ParentMigId))
        {
            var parentCategory = _categoryRepository.Table
                .Where(c => c.ExternalId == menuItemGroup.ParentMigId)
                .FirstOrDefault();
            
            if (parentCategory != null)
            {
                category.ParentCategoryId = parentCategory.Id;
            }
        }

        await _categoryService.InsertCategory(category);
        return category;
    }

    private async Task UpdateCategoryFromMenuItemGroupAsync(Category category, SimpraMenuItemGroup menuItemGroup)
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        
        // Check if this category should be shown on homepage
        var homepageCategoryIds = !string.IsNullOrEmpty(settings.HomepageCategoryIds) 
            ? settings.HomepageCategoryIds.Split(',', StringSplitOptions.RemoveEmptyEntries)
                .Select(x => x.Trim()).ToList()
            : null;
        
        bool showOnHomePage = homepageCategoryIds?.Contains(category.Id) == true;

        category.Name = menuItemGroup.Name;
        category.Published = menuItemGroup.Active;
        category.ShowOnHomePage = showOnHomePage; // Update based on HomepageCategoryIds setting
        category.UpdatedOnUtc = DateTime.UtcNow;

        // Update parent category if changed
        if (!string.IsNullOrEmpty(menuItemGroup.ParentMigId))
        {
            var parentCategory = _categoryRepository.Table
                .FirstOrDefault(c => c.ExternalId == menuItemGroup.ParentMigId);
            
            if (parentCategory != null)
            {
                category.ParentCategoryId = parentCategory.Id;
            }
        }
        else
        {
            category.ParentCategoryId = "";
        }

        await _categoryService.UpdateCategory(category);
    }

    private async Task ImportMenuItemFromSimpraAsync(SimpraMenuItemResponse menuItem)
    {
        try
        {
            // Check if product already exists in GrandNode
            var existingProduct = await FindExistingProductBySimpraIdAsync(menuItem.Id,menuItem.Sku);
            
            if (existingProduct != null)
            {
                // Update existing product
                await UpdateProductFromMenuItemAsync(existingProduct, menuItem);
                _logger.LogDebug("Updated product {ProductId} from Simpra menu item {MenuItemId}", 
                    existingProduct.Id, menuItem.Id);
            }
            else
            {
                // Create new product
                var newProduct = await CreateProductFromMenuItemAsync(menuItem);
                _logger.LogDebug("Created new product {ProductId} from Simpra menu item {MenuItemId}", 
                    newProduct.Id, menuItem.Id);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error importing menu item {MenuItemId} from Simpra", menuItem.Id);
            throw;
        }
    }

    private async Task<Product?> FindExistingProductBySimpraIdAsync(string simpraMenuItemId, string? menuItemSku)
    {
        return _productRepository.Table
            .Where(p => p.UserFields.Any(uf => uf.Key == "SimpraMenuItemId" && uf.Value == simpraMenuItemId) || p.Sku == menuItemSku)
            .FirstOrDefault();
    }

    private async Task<Product> CreateProductFromMenuItemAsync(SimpraMenuItemResponse menuItem)
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        
        // Get price from item definitions endpoint for the current revenue center
        double productPrice = 0;
        var itemDefinition = await GetItemDefinitionForMenuItemAsync(menuItem.Id);
        if (itemDefinition != null)
        {
            productPrice = (double)itemDefinition.PriceDecimal;
        }

        var product = new Product
        {
            Name = menuItem.Name,
            ShortDescription = "",
            FullDescription = "",
            Sku = menuItem.Sku ?? $"SIMPRA-{menuItem.Id}",
            Price = productPrice,
            Published = menuItem.Active,
            ProductTypeId = (int)ProductType.SimpleProduct,
            OldPrice = 0,
            ProductCost = 0,
            MarkAsNew = false,
            Weight = 0,
            Length = 0,
            Width = 0,
            Height = 0,
            VisibleIndividually = true,
            ShowOnHomePage = false,
            AllowCustomerReviews = true,
            ManageInventoryMethodId = (int)ManageInventoryMethod.DontManageStock,
            StockQuantity = 10000,
            NotifyAdminForQuantityBelow = 1,
            AllowOutOfStockSubscriptions = false,
            OrderMinimumQuantity = 1,
            OrderMaximumQuantity = 10000,
            AllowedQuantities = "",
            NotReturnable = false,
            DisableBuyButton = false,
            DisableWishlistButton = false,
            AvailableForPreOrder = false,
            CallForPrice = false,
            CreatedOnUtc = DateTime.UtcNow,
            UpdatedOnUtc = DateTime.UtcNow,
            IsShipEnabled = true,
            BackorderModeId = BackorderMode.NoBackorders,
            UserFields = new List<UserField>
            {
                new UserField
                {
                    Key = "SimpraMenuItemId",
                    Value = menuItem.Id
                },
                new UserField
                {
                    Key = "ImportedFromSimpra",
                    Value = "true"
                },
                new UserField
                {
                    Key = "SimpraLastSync",
                    Value = DateTime.UtcNow.ToString("O")
                }
            }
        };

        // Set ProductLayoutId from settings if configured
        if (!string.IsNullOrEmpty(settings.ProductLayoutId))
        {
            product.ProductLayoutId = settings.ProductLayoutId;
        }

        // Set TaxCategoryId from item definition using tax mappings
        if (itemDefinition != null && !string.IsNullOrEmpty(itemDefinition.TaxId))
        {
            var taxCategoryId = GetMappedTaxCategoryId(itemDefinition.TaxId, settings);
            if (!string.IsNullOrEmpty(taxCategoryId))
            {
                product.TaxCategoryId = taxCategoryId;
            }
            else if (!string.IsNullOrEmpty(settings.TaxCategoryId))
            {
                // Fallback to default tax category if no mapping found
                product.TaxCategoryId = settings.TaxCategoryId;
            }
        }
        else if (!string.IsNullOrEmpty(settings.TaxCategoryId))
        {
            // Use default tax category if no tax_id from Simpra
            product.TaxCategoryId = settings.TaxCategoryId;
        }

        // Assign category based on menu_item_group_id
        await AssignCategoryToProductFromSimpraAsync(product, menuItem.MenuItemGroupId, settings);
        
        await _productService.InsertProduct(product);

        // Create product attributes from condiment groups
        await CreateProductAttributesFromCondimentGroupsAsync(product, menuItem.CondimentGroups);

        // Import product image if enabled and image exists
        if (settings.ImportPhotoFromSimpra && menuItem.ItemImage != null)
        {
            await ImportProductImageFromSimpraAsync(product, menuItem.ItemImage);
        }

        await _productService.UpdateProduct(product);
        return product;
    }

    private async Task UpdateProductFromMenuItemAsync(Product product, SimpraMenuItemResponse menuItem)
    {
        var settings = _settingService.LoadSetting<SimpraSettings>();
        
        // Update basic product information
        product.Name = menuItem.Name;
        product.ShortDescription = "";
        product.FullDescription = "";
        product.Published = menuItem.Active;
        product.UpdatedOnUtc = DateTime.UtcNow;

        // Update ProductLayoutId from settings if configured
        if (!string.IsNullOrEmpty(settings.ProductLayoutId))
        {
            product.ProductLayoutId = settings.ProductLayoutId;
        }

        // Update price and tax category if enabled - get from item definitions endpoint
        var itemDefinition = await GetItemDefinitionForMenuItemAsync(menuItem.Id);
        
        if (settings.SyncProductPrices && itemDefinition != null)
        {
            product.Price = (double)itemDefinition.PriceDecimal;
        }

        // Update TaxCategoryId from item definition using tax mappings
        if (itemDefinition != null && !string.IsNullOrEmpty(itemDefinition.TaxId))
        {
            var taxCategoryId = GetMappedTaxCategoryId(itemDefinition.TaxId, settings);
            if (!string.IsNullOrEmpty(taxCategoryId))
            {
                product.TaxCategoryId = taxCategoryId;
            }
            else if (!string.IsNullOrEmpty(settings.TaxCategoryId))
            {
                // Fallback to default tax category if no mapping found
                product.TaxCategoryId = settings.TaxCategoryId;
            }
        }
        else if (!string.IsNullOrEmpty(settings.TaxCategoryId))
        {
            // Use default tax category if no tax_id from Simpra
            product.TaxCategoryId = settings.TaxCategoryId;
        }

        // Update SKU if not exists or if forced update is enabled
        if (string.IsNullOrEmpty(product.Sku) || settings.ForceUpdateSku)
        {
            product.Sku = menuItem.Sku ?? $"SIMPRA-{menuItem.Id}";
        }

        // Update sync timestamp
        var syncField = product.UserFields.FirstOrDefault(uf => uf.Key == "SimpraLastSync");
        if (syncField != null)
        {
            syncField.Value = DateTime.UtcNow.ToString("O");
        }
        else
        {
            product.UserFields.Add(new UserField
            {
                Key = "SimpraLastSync",
                Value = DateTime.UtcNow.ToString("O")
            });
        }

        // Update product image if enabled and image exists
        if (settings.ImportPhotoFromSimpra && menuItem.ItemImage != null)
        {
            await ImportProductImageFromSimpraAsync(product, menuItem.ItemImage);
        }

        // Update product attributes from condiment groups
        await UpdateProductAttributesFromCondimentGroupsAsync(product, menuItem.CondimentGroups);
        
        

        await _productService.UpdateProduct(product);
    }

    private async Task AssignCategoryToProductFromSimpraAsync(Product product, string menuItemGroupId, SimpraSettings settings)
    {
        try
        {
            // Parse featured product category IDs from settings
            var featuredProductCategoryIds = !string.IsNullOrEmpty(settings.FeaturedProductCategoryIds) 
                ? settings.FeaturedProductCategoryIds.Split(',', StringSplitOptions.RemoveEmptyEntries)
                    .Select(x => x.Trim()).ToList()
                : null;

            bool isFeaturedProduct = featuredProductCategoryIds?.Contains(menuItemGroupId) == true;

            // Find category by ExternalId (which is the Simpra menu_item_group_id)
            var category = _categoryRepository.Table
                .Where(c => c.ExternalId == menuItemGroupId)
                .FirstOrDefault();

            if (category != null)
            {
                product.ProductCategories.Add(new ProductCategory
                {
                    CategoryId = category.Id,
                    IsFeaturedProduct = isFeaturedProduct, // Set based on FeaturedProductCategoryIds setting
                    DisplayOrder = 0
                });

                _logger.LogDebug("Assigned product {ProductId} to category {CategoryId} ({CategoryName}) based on Simpra menu item group {GroupId}, Featured: {IsFeatured}", 
                    product.Id, category.Id, category.Name, menuItemGroupId, isFeaturedProduct);
            }
            else
            {
                // Fallback to default category if configured
                if (!string.IsNullOrEmpty(settings.DefaultImportCategoryId))
                {
                    product.ProductCategories.Add(new ProductCategory
                    {
                        CategoryId = settings.DefaultImportCategoryId,
                        IsFeaturedProduct = false, // Default category products are not featured
                        DisplayOrder = 0
                    });

                    _logger.LogWarning("No category found for Simpra menu item group {GroupId}, assigned to default category {DefaultCategoryId}", 
                        menuItemGroupId, settings.DefaultImportCategoryId);
                }
                else
                {
                    _logger.LogWarning("No category found for Simpra menu item group {GroupId} and no default category configured", menuItemGroupId);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error assigning category to product from Simpra menu item group {GroupId}", menuItemGroupId);
        }
    }

    private async Task CreateProductAttributesFromCondimentGroupsAsync(Product product, List<SimpraMenuItemCondimentGroup>? condimentGroups)
    {
        if (condimentGroups == null || !condimentGroups.Any())
        {
            return;
        }

        try
        {
            var settings = _settingService.LoadSetting<SimpraSettings>();
            
            foreach (var condimentGroup in condimentGroups)
            {
                try
                {
                    // Create or get product attribute for this condiment group
                    var productAttribute = await GetOrCreateProductAttributeAsync(condimentGroup.Name);
                    
                    if (productAttribute != null)
                    {
                        // Store condiment group ID in user fields for future reference
                        var groupIdField = productAttribute.UserFields.FirstOrDefault(uf => uf.Key == "SimpraCondimentGroupId");
                        if (groupIdField != null)
                        {
                            groupIdField.Value = condimentGroup.CondimentGroupId;
                        }
                        else
                        {
                            productAttribute.UserFields.Add(new UserField
                            {
                                Key = "SimpraCondimentGroupId",
                                Value = condimentGroup.CondimentGroupId
                            });
                        }
                        await _productAttributeService.UpdateProductAttribute(productAttribute);
                        
                        // Create or get product attribute mapping for this product
                        var attributeMapping = await GetOrCreateProductAttributeMappingAsync(
                            condimentGroup, productAttribute, product.Id);

                        // Sync ProductAttributeValues for this condiment group using proper ProductAttributeService methods
                        await SyncProductAttributeValuesFromCondimentsAsync(
                            condimentGroup, product.Id, attributeMapping, productAttribute, settings);

                        // Note: ProductAttributeMapping is already added to the product via ProductAttributeService

                        _logger.LogDebug("Created product attribute mapping for condiment group {GroupName} with {Count} condiments", 
                            condimentGroup.Name, attributeMapping.ProductAttributeValues.Count);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error creating product attribute for condiment group {GroupName}", condimentGroup.Name);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating product attributes from condiment groups for product {ProductId}", product.Id);
        }
    }

    private async Task<ProductAttribute?> GetOrCreateProductAttributeAsync(string attributeName)
    {
        try
        {
            // Check if product attribute already exists by name first
            var allAttributes = await _productAttributeService.GetAllProductAttributes();
            var existingAttribute = allAttributes.FirstOrDefault(a => a.Name.Equals(attributeName, StringComparison.OrdinalIgnoreCase));
            
            ProductAttribute productAttribute;
            
            if (existingAttribute != null)
            {
                // Use existing ProductAttribute
                productAttribute = existingAttribute;
                
                // Update existing ProductAttribute if needed
                bool isModified = false;
                
                if (productAttribute.Name != attributeName)
                {
                    productAttribute.Name = attributeName;
                    isModified = true;
                }
                
                if (isModified)
                {
                    await _productAttributeService.UpdateProductAttribute(productAttribute);
                }
            }
            else
            {
                // Create new ProductAttribute
                productAttribute = await CreateNewProductAttributeAsync(attributeName);
            }
            
            return productAttribute;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting or creating product attribute {AttributeName}", attributeName);
            return null;
        }
    }
    
    private async Task<ProductAttribute> CreateNewProductAttributeAsync(string attributeName)
    {
        var productAttribute = new ProductAttribute
        {
            Name = attributeName,
            Description = $"Attribute imported from Simpra condiment group: {attributeName}",
            LimitedToStores = false,
            UserFields = new List<UserField>
            {
                new UserField
                {
                    Key = "ImportedFromSimpra",
                    Value = "true"
                }
            }
        };

        await _productAttributeService.InsertProductAttribute(productAttribute);
        
        _logger.LogDebug("Created new ProductAttribute: {AttributeName} (ID: {AttributeId})", productAttribute.Name, productAttribute.Id);
        
        return productAttribute;
    }

    private async Task UpdateProductAttributesFromCondimentGroupsAsync(Product product, List<SimpraMenuItemCondimentGroup>? condimentGroups)
    {
        try
        {
            // Clear existing attribute mappings - simplest approach is to remove all and recreate
            product.ProductAttributeMappings.Clear();
            
            // Re-create attribute mappings with updated condiment groups
            await CreateProductAttributesFromCondimentGroupsAsync(product, condimentGroups);
            
            _logger.LogDebug("Updated product attributes for product {ProductId}", product.Id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating product attributes for product {ProductId}", product.Id);
        }
    }

    /// <summary>
    /// Creates or gets ProductAttributeMapping for a product and condiment group
    /// Following Adisyo pattern
    /// </summary>
    private async Task<ProductAttributeMapping> GetOrCreateProductAttributeMappingAsync(
        SimpraMenuItemCondimentGroup condimentGroup,
        ProductAttribute productAttribute,
        string grandNodeProductId)
    {
        // Get product
        var product = _productRepository.Table.FirstOrDefault(p => p.Id == grandNodeProductId);
        if (product == null)
        {
            throw new InvalidOperationException($"Product not found: {grandNodeProductId}");
        }

        // Check if mapping already exists
        var existingMapping = product.ProductAttributeMappings
            .FirstOrDefault(pam => pam.ProductAttributeId == productAttribute.Id);

        if (existingMapping != null)
        {
            // Update existing mapping if needed
            bool isModified = false;

            if (existingMapping.IsRequired != condimentGroup.Required)
            {
                existingMapping.IsRequired = condimentGroup.Required;
                isModified = true;
            }

            var controlType = condimentGroup.Multiple ? AttributeControlType.Checkboxes : AttributeControlType.DropdownList;
            if (existingMapping.AttributeControlTypeId != controlType)
            {
                existingMapping.AttributeControlTypeId = controlType;
                isModified = true;
            }

            if (existingMapping.ValidationMinLength != condimentGroup.MinCount)
            {
                existingMapping.ValidationMinLength = condimentGroup.MinCount;
                isModified = true;
            }
            
            if (existingMapping.ValidationMaxLength != condimentGroup.MaxCount)
            {
                existingMapping.ValidationMaxLength = condimentGroup.MaxCount;
                isModified = true;
            }

            if (isModified)
            {
                await _productAttributeService.UpdateProductAttributeMapping(existingMapping, grandNodeProductId);
                _logger.LogDebug("Updated ProductAttributeMapping for attribute {AttributeName} on product {ProductId}",
                    productAttribute.Name, grandNodeProductId);
            }

            return existingMapping;
        }
        else
        {
            // Create new mapping
            var newMapping = new ProductAttributeMapping {
                ProductAttributeId = productAttribute.Id,
                TextPrompt = condimentGroup.Name,
                IsRequired = condimentGroup.Required,
                ShowOnCatalogPage = true,
                Combination = true,
                AttributeControlTypeId = condimentGroup.Multiple ? AttributeControlType.Checkboxes : AttributeControlType.DropdownList,
                ValidationMinLength = condimentGroup.MinCount,
                ValidationMaxLength = condimentGroup.MaxCount,
                DisplayOrder = 1
            };

            await _productAttributeService.InsertProductAttributeMapping(newMapping, grandNodeProductId);

            _logger.LogDebug("Created new ProductAttributeMapping for attribute {AttributeName} on product {ProductId}",
                productAttribute.Name, grandNodeProductId);

            return newMapping;
        }
    }
    
    /// <summary>
    /// Syncs ProductAttributeValues for condiments in a condiment group
    /// Following Adisyo pattern for value management
    /// </summary>
    private async Task SyncProductAttributeValuesFromCondimentsAsync(
        SimpraMenuItemCondimentGroup condimentGroup,
        string grandNodeProductId,
        ProductAttributeMapping productAttributeMapping,
        ProductAttribute productAttribute,
        SimpraSettings settings)
    {
        var currentValues = productAttributeMapping.ProductAttributeValues.ToList();
        var valuesToKeep = new List<ProductAttributeValue>();
        var displayOrder = 0;

        // Fetch condiments for this condiment group
        var condimentsResponse = await _simpraApiService.GetCondimentsAsync(status: "active");
        if (condimentsResponse.Success && condimentsResponse.Data != null)
        {
            // Filter condiments by condiment group ID
            var groupCondiments = condimentsResponse.Data
                .Where(c => c.CondimentGroupId == condimentGroup.CondimentGroupId)
                .ToList();

            foreach (var condiment in groupCondiments)
            {
                // Get price from item definitions
                decimal price = 0;
                if (condiment.ItemDefinitions != null && condiment.ItemDefinitions.Any())
                {
                    var itemDefinitionsResponse = await _simpraApiService.GetItemDefinitionsAsync(
                        sourceType: "Condiment",
                        sourceId: condiment.Id,
                        targetId: settings.RevenueCenterId,
                        propertyIds: settings.PropertyId,
                        status: "active"
                    );
                    
                    if (!itemDefinitionsResponse.Success || itemDefinitionsResponse.Data == null || !itemDefinitionsResponse.Data.Any())
                    {
                        _logger.LogWarning("No item definitions found for condiment {CondimentName} (ID: {CondimentId})",
                            condiment.Name, condiment.Id);
                        continue;
                    }
                    
                    // Find item definition for the configured revenue center
                    var itemDef = itemDefinitionsResponse.Data.FirstOrDefault();
                    
                    if (itemDef == null)
                    {
                        // Fallback to any available price
                        itemDef = condiment.ItemDefinitions.FirstOrDefault();
                    }

                    if (itemDef != null)
                    {
                        price = itemDef.PriceDecimal;
                    }
                }

                // Check if value already exists
                //TODO: SimpraCondimentMapping ile kontrol edilecek
                var existingValue = currentValues.FirstOrDefault(v => v.Name == condiment.Name);

                if (existingValue != null)
                {
                    // Update existing value
                    bool isModified = false;

                    if (Math.Abs(existingValue.PriceAdjustment - (double)price) > 0.01)
                    {
                        existingValue.PriceAdjustment = (double)price;
                        isModified = true;
                    }

                    if (existingValue.DisplayOrder != displayOrder)
                    {
                        existingValue.DisplayOrder = displayOrder;
                        isModified = true;
                    }

                    if (isModified)
                    {
                        await _productAttributeService.UpdateProductAttributeValue(existingValue, grandNodeProductId,
                            productAttributeMapping.Id);
                    }

                    valuesToKeep.Add(existingValue);
                }
                else
                {
                    // Create new value
                    var newValue = new ProductAttributeValue {
                        AttributeValueTypeId = AttributeValueType.Simple,
                        Name = condiment.Name,
                        PriceAdjustment = (double)price,
                        IsPreSelected = false,
                        DisplayOrder = displayOrder
                    };

                    await _productAttributeService.InsertProductAttributeValue(newValue, grandNodeProductId,
                        productAttributeMapping.Id);
                    valuesToKeep.Add(newValue);

                    // Store mapping for tracking
                    var condimentMapping = new SimpraCondimentMapping {
                        SimpraCondimentId = condiment.Id,
                        GrandNodeProductAttributeId = productAttribute.Id,
                        GrandNodeProductAttributeValueId = newValue.Id,
                        CondimentName = condiment.Name,
                        AdditionalPrice = price,
                        CondimentGroupId = condimentGroup.CondimentGroupId,
                        IsActive = condiment.Active,
                        StoreId = "",
                        LastSyncDate = DateTime.UtcNow
                    };

                    await _condimentMappingService.InsertAsync(condimentMapping);
                }

                displayOrder++;
            }
        }

        // Remove values that are no longer relevant
        foreach (var valueToRemove in currentValues.Where(v => !valuesToKeep.Contains(v)))
        {
            await _productAttributeService.DeleteProductAttributeValue(valueToRemove, grandNodeProductId,
                productAttributeMapping.Id);

            // Remove mapping record
            var mappingToRemove = await _condimentMappingService.GetByGrandNodeAttributeValueIdAsync(valueToRemove.Id);
            if (mappingToRemove != null)
            {
                await _condimentMappingService.DeleteAsync(mappingToRemove);
            }
        }

        _logger.LogDebug("Synced {Count} ProductAttributeValues for condiment group {GroupName}",
            valuesToKeep.Count, condimentGroup.Name);
    }

    private string GetMimeType(string imageUrl)
    {
        var extension = Path.GetExtension(imageUrl);
        return extension switch
        {
            ".jpg" or ".jpeg" => "image/jpeg",
            ".png" => "image/png",
            ".gif" => "image/gif",
            ".bmp" => "image/bmp",
            ".tiff" => "image/tiff",
            _ => "image/jpeg"
        };
    }

    /// <summary>
    /// Gets the mapped GrandNode tax category ID for a given Simpra tax ID
    /// </summary>
    private string? GetMappedTaxCategoryId(string simpraTaxId, SimpraSettings settings)
    {
        if (string.IsNullOrEmpty(simpraTaxId) || string.IsNullOrEmpty(settings.TaxCategoryMappings))
        {
            return null;
        }

        try
        {
            var taxMappings = JsonSerializer.Deserialize<Dictionary<string, string>>(settings.TaxCategoryMappings);
            if (taxMappings != null && taxMappings.TryGetValue(simpraTaxId, out var grandNodeTaxCategoryId))
            {
                _logger.LogDebug("Found tax mapping: Simpra tax ID {SimpraTaxId} -> GrandNode tax category ID {GrandNodeTaxCategoryId}", 
                    simpraTaxId, grandNodeTaxCategoryId);
                return grandNodeTaxCategoryId;
            }
            
            _logger.LogDebug("No tax mapping found for Simpra tax ID {SimpraTaxId}", simpraTaxId);
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error parsing tax category mappings for Simpra tax ID {SimpraTaxId}", simpraTaxId);
            return null;
        }
    }
}