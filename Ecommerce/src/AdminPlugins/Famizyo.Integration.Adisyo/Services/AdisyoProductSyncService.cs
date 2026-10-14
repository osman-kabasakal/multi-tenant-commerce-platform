using Famizyo.Integration.Adisyo.Domain;
using Famizyo.Integration.Adisyo.Models;
using Famizyo.Integration.Adisyo.Settings;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Data;
using Grand.Domain.Catalog;
using Grand.Domain.Common;
using Microsoft.Extensions.Logging;

namespace Famizyo.Integration.Adisyo.Services;

public class AdisyoProductSyncService : IAdisyoProductSyncService
{
    private readonly IAdisyoApiService _adisyoApiService;
    private readonly ICategoryService _categoryService;
    private readonly IProductService _productService;
    private readonly IProductCategoryService _productCategoryService;
    private readonly IProductAttributeService _productAttributeService;
    private readonly ISettingService _settingService;
    private readonly IRepository<Category> _categoryRepository;
    private readonly IRepository<Product> _productRepository;
    private readonly IPictureService _pictureService;
    private readonly IRepository<AdisyoProductAttributeMapping> _attributeMappingRepository;
    private readonly IRepository<AdisyoFeatureValueMapping> _featureValueMappingRepository;
    private readonly ILogger<AdisyoProductSyncService> _logger;

    public AdisyoProductSyncService(
        IAdisyoApiService adisyoApiService,
        ICategoryService categoryService,
        IProductService productService,
        IProductCategoryService productCategoryService,
        IProductAttributeService productAttributeService,
        ISettingService settingService,
        IRepository<Category> categoryRepository,
        IRepository<Product> productRepository,
        IPictureService pictureService,
        IRepository<AdisyoProductAttributeMapping> attributeMappingRepository,
        IRepository<AdisyoFeatureValueMapping> featureValueMappingRepository,
        ILogger<AdisyoProductSyncService> logger)
    {
        _adisyoApiService = adisyoApiService;
        _categoryService = categoryService;
        _productService = productService;
        _productCategoryService = productCategoryService;
        _productAttributeService = productAttributeService;
        _settingService = settingService;
        _categoryRepository = categoryRepository;
        _productRepository = productRepository;
        _pictureService = pictureService;
        _attributeMappingRepository = attributeMappingRepository;
        _featureValueMappingRepository = featureValueMappingRepository;
        _logger = logger;
    }

    public async Task SyncProductsAndCategoriesAsync()
    {
        try
        {
            _logger.LogInformation("Starting Adisyo product and category synchronization");

            if (!await CanSyncProductsAsync())
            {
                _logger.LogWarning("Product sync is not enabled or API credentials are missing");
                return;
            }

            var allCategories = await GetProductCategoriesAsync();
            _logger.LogInformation("Retrieved {Count} categories from Adisyo", allCategories.Count);

            // Filter categories based on settings
            var syncSettings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
            var categories = FilterCategoriesToSync(allCategories, syncSettings);
            _logger.LogInformation("Filtered to {Count} categories for synchronization", categories.Count);

            var syncStats = new {
                CategoriesProcessed = 0,
                CategoriesCreated = 0,
                CategoriesUpdated = 0,
                ProductsProcessed = 0,
                ProductsCreated = 0,
                ProductsUpdated = 0
            };

            foreach (var category in categories)
            {
                try
                {
                    _logger.LogDebug("Processing category: {CategoryName} (ID: {CategoryId})",
                        category.CategoryName, category.CategoryId);

                    var categoryId = await SyncCategoryAsync(category);

                    await EnsureCategoryImageAsync(categoryId, category);
                    syncStats = syncStats with { CategoriesProcessed = syncStats.CategoriesProcessed + 1 };

                    foreach (var product in category.Products)
                    {
                        try
                        {
                            var productId = await SyncProductAsync(product, categoryId);
                            if (!string.IsNullOrEmpty(productId))
                            {
                                await EnsureProductImageAsyns(productId, product);
                                // Ensure product-category relationship exists
                                await EnsureProductCategoryRelationshipAsync(productId, categoryId);

                                // Sync features if enabled
                                var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
                                if (settings.SyncProductFeatures)
                                {
                                    await SyncProductFeaturesAsync(product, productId);
                                }

                                syncStats = syncStats with { ProductsProcessed = syncStats.ProductsProcessed + 1 };
                            }
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex, "Error syncing product {ProductName} (ID: {ProductId})",
                                product.ProductName, product.ProductId);
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error syncing category {CategoryName} (ID: {CategoryId})",
                        category.CategoryName, category.CategoryId);
                }
            }

            _logger.LogInformation("Adisyo sync completed. Stats: {Stats}", syncStats);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during Adisyo product synchronization");
            throw;
        }
    }

    private async Task EnsureCategoryImageAsync(string categoryId, AdisyoProductCategory category)
    {
        var cat = await _categoryService.GetCategoryById(categoryId);
        if (cat == null)
        {
            _logger.LogWarning("Category not found for ID: {CategoryId}", categoryId);
            return;
        }

        if (string.IsNullOrWhiteSpace(category.PhotoUrl))
        {
            _logger.LogDebug("No photo URL for category {CategoryName} (ID: {CategoryId})",
                category.CategoryName, categoryId);
            return;
        }

        var currentAdisyoCategoryImage = cat.UserFields.FirstOrDefault(x => x.Key == "adisyo-category-image");
        if (currentAdisyoCategoryImage?.Value != category.PhotoUrl)
        {
            if (!string.IsNullOrEmpty(cat.PictureId))
            {
                var existingPicture = await _pictureService.GetPictureById(cat.PictureId);
                if (existingPicture != null)
                    await _pictureService.DeletePicture(existingPicture);
                if (currentAdisyoCategoryImage != null)
                    cat.UserFields.Remove(currentAdisyoCategoryImage);
            }

            var imageData = await _adisyoApiService.GetImageWithUrl(category.PhotoUrl);
            if (imageData != null && imageData.Length > 0)
            {
                // Save category image
                var picture = await _pictureService.InsertPicture(imageData,
                    GetMimeTypes(category.PhotoUrl),
                    _pictureService.GetPictureSeName(category.CategoryName),
                    reference: Reference.Category,
                    objectId: categoryId);

                cat.PictureId = picture.Id;
                cat.UserFields.Add(new UserField {
                    Key = "adisyo-category-image",
                    Value = category.PhotoUrl
                });

                await _categoryService.UpdateCategory(cat);
                _logger.LogDebug("Saved image for category {CategoryName} (ID: {CategoryId})",
                    category.CategoryName, categoryId);
            }
            else
            {
                _logger.LogWarning(
                    "No image data found for category {CategoryName} (ID: {CategoryId})",
                    category.CategoryName, categoryId);
            }
        }
    }

    private async Task EnsureProductImageAsyns(string productId, AdisyoProduct product)
    {
        if (!string.IsNullOrWhiteSpace(productId) && !string.IsNullOrWhiteSpace(product.PhotoUrl))
        {
            var productEntity = await _productService.GetProductById(productId);
            
            if (productEntity == null)
            {
                _logger.LogWarning("Product not found for ID: {ProductId}", productId);
                return;
            }
            
            
            var currentAdisyoCategoryImage = productEntity.UserFields.FirstOrDefault(x => x.Key == "adisyo-category-image");
            if (currentAdisyoCategoryImage?.Value == product.PhotoUrl)
            {
                _logger.LogDebug("Product image already synced for {ProductName} (ID: {ProductId})",
                    product.ProductName, productId);
                return;
            }

            if (currentAdisyoCategoryImage != null)
            {
                productEntity.UserFields.Remove(currentAdisyoCategoryImage);
            }
            
            // Remove existing pictures if any
            foreach (var productPicture in productEntity.ProductPictures.ToList())
            {
                var existingPicture = await _pictureService.GetPictureById(productPicture.PictureId);
                if (existingPicture != null)
                {
                    await _pictureService.DeletePicture(existingPicture);
                    await _productService.DeleteProductPicture(productPicture, productId);
                }
            }
            
            
            var imageData = await _adisyoApiService.GetImageWithUrl(product.PhotoUrl);
            if (imageData != null && imageData.Length > 0)
            {
                // Save product image
                var picture = await _pictureService.InsertPicture(imageData,
                    GetMimeTypes(product.PhotoUrl),
                    _pictureService.GetPictureSeName(product.ProductName),
                    reference: Reference.Product,
                    objectId: productId);

                await _productService.InsertProductPicture(
                    new ProductPicture {
                        PictureId = picture.Id,
                        DisplayOrder = 0
                    },
                    productId
                );
                
                productEntity.UserFields.Add(new UserField {
                    Key = "adisyo-category-image",
                    Value = product.PhotoUrl
                });
                await _productService.UpdateProduct(productEntity);
                
                _logger.LogDebug("Saved image for product {ProductName} (ID: {ProductId})",
                    product.ProductName, productId);
            }
            else
            {
                _logger.LogWarning(
                    "No image data found for product {ProductName} (ID: {ProductId})",
                    product.ProductName, productId);
            }
        }
    }

    public async Task<string> SyncCategoryAsync(AdisyoProductCategory category)
    {
        try
        {
            var externalId = $"adisyo-{category.CategoryId}";

            // Try to find existing category by external ID
            var existingCategory = _categoryRepository.Table.FirstOrDefault(x => x.ExternalId == externalId);

            if (existingCategory != null)
            {
                // Update existing category
                var isModified = false;
                var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();

                if (existingCategory.Name != category.CategoryName)
                {
                    existingCategory.Name = category.CategoryName;
                    isModified = true;
                }

                var shouldShowOnHomePage = ShouldShowCategoryOnHomepage(category?.CategoryId??0, settings);
                if (existingCategory.ShowOnHomePage != shouldShowOnHomePage)
                {
                    existingCategory.ShowOnHomePage = shouldShowOnHomePage;
                    isModified = true;
                }

                if (isModified)
                {
                    await _categoryService.UpdateCategory(existingCategory);
                    _logger.LogDebug("Updated existing category: {CategoryName}", category.CategoryName);
                }

                return existingCategory.Id;
            }
            else
            {
                // Create new category with homepage settings
                var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
                var showOnHomePage = ShouldShowCategoryOnHomepage(category?.CategoryId??0, settings);

                var newCategory = new Category {
                    Name = category.CategoryName,
                    ExternalId = externalId,
                    Published = true,
                    ShowOnHomePage = showOnHomePage,
                    IncludeInMenu = true,
                    AllowCustomersToSelectPageSize = true,
                    PageSizeOptions = "6, 3, 9,20",
                    DefaultSort = 0,
                };

                await _categoryService.InsertCategory(newCategory);

                // SEO URL generation will be handled by GrandNode automatically

                _logger.LogInformation("Created new category: {CategoryName} with ID: {CategoryId}",
                    category.CategoryName, newCategory.Id);

                return newCategory.Id;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error syncing category {CategoryName}", category.CategoryName);
            throw;
        }
    }

    public async Task<string> SyncProductAsync(AdisyoProduct product, string categoryId)
    {
        try
        {
            var externalId = $"adisyo-{product.ProductUnits.FirstOrDefault()?.ProductUnitId}";

            // Try to find existing product by external ID
            var existingProduct = _productRepository.Table.FirstOrDefault(x =>
                x.ExternalId == externalId || x.Sku == product.ProductCode ||
                x.Name.ToLowerInvariant().Equals(product.ProductName.ToLowerInvariant()));

            if (existingProduct != null)
            {
                // Update existing product
                var isModified = false;

                if (existingProduct.Name != product.ProductName)
                {
                    existingProduct.Name = product.ProductName;
                    isModified = true;
                }

                // Get price based on settings OrderType
                var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
                var targetPrice = GetProductPrice(product, settings.OrderType);
                if (Math.Abs(existingProduct.Price - targetPrice) > 0.01)
                {
                    existingProduct.Price = targetPrice;
                    isModified = true;
                }

                if (product.ProductCode != existingProduct.Sku)
                {
                    existingProduct.Sku = product.ProductCode;
                    isModified = true;
                }
                
                if (externalId != existingProduct.ExternalId)
                {
                    existingProduct.ExternalId = externalId;
                    isModified = true;
                }

                if (isModified)
                {
                    existingProduct.UpdatedOnUtc = DateTime.UtcNow;
                    await _productRepository.UpdateOneAsync((x)=>x.Id == existingProduct.Id, UpdateBuilder<Product>.Create().Set(x=>x.ExternalId,externalId));
                    await _productService.UpdateProduct(existingProduct);
                    _logger.LogDebug("Updated existing product: {ProductName}", product.ProductName);
                }

                return existingProduct.Id;
            }
            else
            {
                // Get price based on settings OrderType
                var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
                var productPrice = GetProductPrice(product, settings.OrderType);

                // Create new product
                var newProduct = new Product {
                    Name = product.ProductName,
                    ShortDescription =
                        product.ProductName, // Use product name as description since no description field exists
                    FullDescription = product.ProductName,
                    ExternalId = externalId,
                    Sku = product.ProductCode,
                    ProductTypeId = (int)ProductType.SimpleProduct,
                    Price = productPrice,
                    ProductLayoutId = settings.ProductLayoutId,
                    TaxCategoryId = settings.TaxCategoryId,
                    OldPrice = 0,
                    ProductCost = 0,
                    MarkAsNew = false,
                    Weight = 0,
                    Length = 0,
                    Width = 0,
                    Height = 0,
                    Published = true,
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
                };

                await _productService.InsertProduct(newProduct);

                // Product-Category relationship will be handled manually later
                // SEO URL generation will be handled by GrandNode automatically

                _logger.LogInformation("Created new product: {ProductName} with ID: {ProductId}",
                    product.ProductName, newProduct.Id);

                return newProduct.Id;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error syncing product {ProductName}", product.ProductName);
            throw;
        }
    }

    public async Task SyncProductFeaturesAsync(AdisyoProduct product, string grandNodeProductId)
    {
        try
        {
            _logger.LogInformation("Syncing sophisticated features for product {ProductName} (ID: {ProductId})",
                product.ProductName, grandNodeProductId);

            // Get sophisticated feature groups from Adisyo API
            var featuresResponse = await _adisyoApiService.GetFeatureGroupsAsync();

            var processedFeatureGroups = 0;

            foreach (var featureGroup in featuresResponse.FeatureGroups)
            {
                try
                {
                    // Check if any features in this group relate to this product
                    var relevantFeatures = featureGroup.Features
                        .Where(f => (f.RelatedProducts?.Any(rp => rp.ProductId == product.ProductId) ?? false))
                        .ToList();

                    if (relevantFeatures.Any())
                    {
                        await SyncFeatureGroupToProductAsync(featureGroup, relevantFeatures, product,
                            grandNodeProductId);
                        processedFeatureGroups++;
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex,
                        "Error syncing feature group {FeatureGroupName} (ID: {FeatureGroupId}) for product {ProductName}",
                        featureGroup.FeaturesGroupName, featureGroup.FeatureGroupId, product.ProductName);
                }
            }

            _logger.LogDebug("Synced {Count} feature groups for product {ProductName}",
                processedFeatureGroups, product.ProductName);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error syncing features for product {ProductName}", product.ProductName);
            throw;
        }
    }

    private double GetProductPrice(AdisyoProduct product, int orderType)
    {
        try
        {
            // Get the first product unit
            var firstUnit = product.ProductUnits?.FirstOrDefault();
            if (firstUnit == null)
            {
                _logger.LogWarning("No product units found for product {ProductId}", product.ProductId);
                return 0;
            }

            // Find price for the specific order type
            var targetPrice = firstUnit.Prices?.FirstOrDefault(p => p.OrderType == orderType);
            if (targetPrice is  {Price: > 0} )
            {
                return targetPrice?.Price??0;
            }

            // If no price found for the specific order type, use the first available price
            var fallbackPrice = firstUnit.Prices?.FirstOrDefault();
            if (fallbackPrice is {Price: >0})
            {
                _logger.LogWarning(
                    "No price found for order type {OrderType} for product {ProductId}, using fallback price",
                    orderType, product.ProductId);
                return fallbackPrice?.Price??0;
            }

            _logger.LogWarning("No prices found for product {ProductId}", product.ProductId);
            return 0;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting price for product {ProductId}", product.ProductId);
            return 0;
        }
    }

    public async Task<List<AdisyoProductCategory>> GetProductCategoriesAsync()
    {
        try
        {
            return await _adisyoApiService.GetProductCategoriesAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting product categories from Adisyo API");
            throw;
        }
    }

    private async Task EnsureProductCategoryRelationshipAsync(string productId, string categoryId)
    {
        try
        {
            // Check if the product-category relationship already exists
            var existingRelationships = await _productCategoryService.GetProductCategoriesByCategoryId(categoryId);
            var existingRelationship = existingRelationships.FirstOrDefault(pc => pc.ProductId == productId);

            // Get category external ID to check if it should be featured
            var category = _categoryRepository.Table.FirstOrDefault(c => c.Id == categoryId);
            var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
            var isFeatured = category != null && ShouldBeFeaturedProduct(category, settings);

            if (existingRelationship == null)
            {
                // Create new product-category relationship
                var productCategory = new ProductCategory {
                    CategoryId = categoryId,
                    IsFeaturedProduct = isFeatured,
                    DisplayOrder = 0
                };

                await _productCategoryService.InsertProductCategory(productCategory, productId);
                _logger.LogDebug(
                    "Created product-category relationship for product {ProductId} and category {CategoryId} (Featured: {IsFeatured})",
                    productId, categoryId, isFeatured);
            }
            else if (existingRelationship.IsFeaturedProduct != isFeatured)
            {
                // Update existing relationship if featured status changed
                existingRelationship.IsFeaturedProduct = isFeatured;
                await _productCategoryService.UpdateProductCategory(existingRelationship, productId);
                _logger.LogDebug(
                    "Updated product-category featured status for product {ProductId} and category {CategoryId} (Featured: {IsFeatured})",
                    productId, categoryId, isFeatured);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex,
                "Error creating product-category relationship for product {ProductId} and category {CategoryId}",
                productId, categoryId);
            throw;
        }
    }

    public async Task<bool> CanSyncProductsAsync()
    {
        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();

        if (string.IsNullOrEmpty(settings.ApiKey) || string.IsNullOrEmpty(settings.ApiSecret))
        {
            _logger.LogWarning("Adisyo API credentials not configured");
            return false;
        }

        if (!settings.EnableProductSync)
        {
            _logger.LogDebug("Product synchronization is disabled in settings");
            return false;
        }

        return true;
    }


    /// <summary>
    /// Sophisticated feature group synchronization using ProductAttribute and ProductAttributeMapping
    /// Based on TrendyolIntegration implementation patterns
    /// </summary>
    private async Task SyncFeatureGroupToProductAsync(
        AdisyoFeatureGroupDetail featureGroup,
        List<AdisyoFeatureDetail> relevantFeatures,
        AdisyoProduct product,
        string grandNodeProductId)
    {
        try
        {
            _logger.LogDebug(
                "Syncing feature group {FeatureGroupName} (ID: {FeatureGroupId}) for product {ProductName}",
                featureGroup.FeaturesGroupName, featureGroup.FeatureGroupId, product.ProductName);

            var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();

            // Check if this feature group should be treated as ProductAttribute (not ingredient)
            var isIngredientProperty = !string.IsNullOrEmpty(settings.IngredientPropertyName) &&
                                       featureGroup.FeaturesGroupName.Equals(settings.IngredientPropertyName,
                                           StringComparison.OrdinalIgnoreCase);

            if (isIngredientProperty)
            {
                // Handle as ProductSpecification if it's the ingredient property
                if (settings.MapOtherPropertiesAsSpecifications)
                {
                    await SyncFeatureGroupAsProductSpecificationAsync(featureGroup, relevantFeatures, product,
                        grandNodeProductId);
                }

                return;
            }

            // Create or get ProductAttribute for this feature group
            var productAttribute = await GetOrCreateProductAttributeAsync(featureGroup);

            // Create or update ProductAttributeMapping for this product
            var productAttributeMapping = await GetOrCreateProductAttributeMappingAsync(
                featureGroup, productAttribute, grandNodeProductId);

            // Sync ProductAttributeValues
            await SyncProductAttributeValuesAsync(featureGroup, relevantFeatures, product,
                grandNodeProductId, productAttributeMapping, productAttribute);

            _logger.LogDebug(
                "Successfully synced feature group {FeatureGroupName} as ProductAttribute for product {ProductName}",
                featureGroup.FeaturesGroupName, product.ProductName);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex,
                "Error syncing feature group {FeatureGroupName} (ID: {FeatureGroupId}) for product {ProductName}",
                featureGroup.FeaturesGroupName, featureGroup.FeatureGroupId, product.ProductName);
            throw;
        }
    }

    /// <summary>
    /// Creates or gets existing ProductAttribute for an Adisyo feature group
    /// </summary>
    private async Task<ProductAttribute> GetOrCreateProductAttributeAsync(AdisyoFeatureGroupDetail featureGroup)
    {
        // Check if we have an existing mapping
        var existingMapping = _attributeMappingRepository.Table
            .FirstOrDefault(am => am.AdisyoFeatureGroupId == featureGroup.FeatureGroupId);

        ProductAttribute productAttribute;

        if (existingMapping != null)
        {
            // Get existing ProductAttribute
            productAttribute =
                await _productAttributeService.GetProductAttributeById(existingMapping.GrandNodeProductAttributeId);

            if (productAttribute == null)
            {
                // Mapping exists but ProductAttribute was deleted, create new one
                productAttribute = await CreateNewProductAttributeAsync(featureGroup);
                existingMapping.GrandNodeProductAttributeId = productAttribute.Id;
                existingMapping.UpdatedOnUtc = DateTime.UtcNow;
                await _attributeMappingRepository.UpdateAsync(existingMapping);
            }
            else
            {
                // Update existing ProductAttribute if needed
                bool isModified = false;

                if (productAttribute.Name != featureGroup.FeaturesGroupName)
                {
                    productAttribute.Name = featureGroup.FeaturesGroupName;
                    isModified = true;
                }

                if (isModified)
                {
                    await _productAttributeService.UpdateProductAttribute(productAttribute);
                    existingMapping.FeatureGroupName = featureGroup.FeaturesGroupName;
                    existingMapping.FeatureHeaderType = featureGroup.FeatureHeaderType;
                    existingMapping.NecessaryCount = featureGroup?.NecessaryCount??0;
                    existingMapping.UpdatedOnUtc = DateTime.UtcNow;
                    await _attributeMappingRepository.UpdateAsync(existingMapping);
                }
            }
        }
        else
        {
            // Create new ProductAttribute and mapping
            productAttribute = await CreateNewProductAttributeAsync(featureGroup);

            // Create mapping record
            var mapping = new AdisyoProductAttributeMapping {
                AdisyoFeatureGroupId = featureGroup?.FeatureGroupId??0,
                GrandNodeProductAttributeId = productAttribute.Id,
                FeatureGroupName = featureGroup?.FeaturesGroupName,
                FeatureHeaderType = featureGroup?.FeatureHeaderType,
                NecessaryCount = featureGroup?.NecessaryCount??0
            };

            await _attributeMappingRepository.InsertAsync(mapping);
        }

        return productAttribute;
    }

    /// <summary>
    /// Creates a new ProductAttribute for an Adisyo feature group
    /// </summary>
    private async Task<ProductAttribute> CreateNewProductAttributeAsync(AdisyoFeatureGroupDetail featureGroup)
    {
        var productAttribute = new ProductAttribute {
            Name = featureGroup.FeaturesGroupName,
            LimitedToStores = false,
            PredefinedProductAttributeValues = new List<PredefinedProductAttributeValue>()
        };

        await _productAttributeService.InsertProductAttribute(productAttribute);

        _logger.LogDebug("Created new ProductAttribute: {AttributeName} (ID: {AttributeId})",
            productAttribute.Name, productAttribute.Id);

        return productAttribute;
    }

    /// <summary>
    /// Creates or gets ProductAttributeMapping for a product and feature group
    /// </summary>
    private async Task<ProductAttributeMapping> GetOrCreateProductAttributeMappingAsync(
        AdisyoFeatureGroupDetail featureGroup,
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

            var isRequired = featureGroup.NecessaryCount > 0;
            if (existingMapping.IsRequired != isRequired)
            {
                existingMapping.IsRequired = isRequired;
                isModified = true;
            }

            var controlType = DetermineAttributeControlType(featureGroup);
            if (existingMapping.AttributeControlTypeId != controlType)
            {
                existingMapping.AttributeControlTypeId = controlType;
                isModified = true;
            }

            if (existingMapping.TextPrompt != featureGroup.FeaturesGroupName)
            {
                existingMapping.TextPrompt = featureGroup.FeaturesGroupName;
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
                TextPrompt = featureGroup.FeaturesGroupName,
                IsRequired = featureGroup.NecessaryCount > 0,
                ShowOnCatalogPage = true,
                Combination = true,
                AttributeControlTypeId = DetermineAttributeControlType(featureGroup),
                DisplayOrder = 1
            };

            await _productAttributeService.InsertProductAttributeMapping(newMapping, grandNodeProductId);

            _logger.LogDebug("Created new ProductAttributeMapping for attribute {AttributeName} on product {ProductId}",
                productAttribute.Name, grandNodeProductId);

            return newMapping;
        }
    }

    /// <summary>
    /// Determines the appropriate AttributeControlType based on featureHeaderType
    /// Based on user requirements: "Tekli Seçim" = Dropdown, "Çoklu Seçim" = CheckBox
    /// </summary>
    private AttributeControlType DetermineAttributeControlType(AdisyoFeatureGroupDetail featureGroup)
    {
        return featureGroup.FeatureHeaderType.ToLowerInvariant() switch {
            "tekli seçim" => AttributeControlType.DropdownList,
            "çoklu seçim" => AttributeControlType.Checkboxes,
            _ => AttributeControlType.DropdownList // Default to dropdown
        };
    }

    /// <summary>
    /// Syncs ProductAttributeValues for a feature group
    /// Implements necessaryCount logic for first value selection
    /// </summary>
    private async Task SyncProductAttributeValuesAsync(
        AdisyoFeatureGroupDetail featureGroup,
        List<AdisyoFeatureDetail> relevantFeatures,
        AdisyoProduct product,
        string grandNodeProductId,
        ProductAttributeMapping productAttributeMapping,
        ProductAttribute productAttribute)
    {
        var currentValues = productAttributeMapping.ProductAttributeValues.ToList();
        var valuesToKeep = new List<ProductAttributeValue>();
        var displayOrder = 0;

        foreach (var feature in relevantFeatures)
        {
            var relatedProduct = feature.RelatedProducts.FirstOrDefault(rp => rp.ProductId == product.ProductId);
            if (relatedProduct == null) continue;

            // Check if value already exists
            var existingValue = currentValues.FirstOrDefault(v => v.Name == feature.FeatureName);

            // Determine if this should be pre-selected based on necessaryCount logic
            var isPreSelected = featureGroup.NecessaryCount == 1 && displayOrder == 0;

            if (existingValue != null)
            {
                // Update existing value
                bool isModified = false;

                if (Math.Abs(existingValue.PriceAdjustment - (double)relatedProduct.AdditionalPrice) > 0.01)
                {
                    existingValue.PriceAdjustment = (double)relatedProduct.AdditionalPrice;
                    isModified = true;
                }

                if (existingValue.IsPreSelected != isPreSelected)
                {
                    existingValue.IsPreSelected = isPreSelected;
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
                    Name = feature.FeatureName,
                    PriceAdjustment = (double)relatedProduct.AdditionalPrice,
                    IsPreSelected = isPreSelected,
                    DisplayOrder = displayOrder
                };

                await _productAttributeService.InsertProductAttributeValue(newValue, grandNodeProductId,
                    productAttributeMapping.Id);
                valuesToKeep.Add(newValue);

                // Store mapping for tracking
                var featureValueMapping = new AdisyoFeatureValueMapping {
                    AdisyoFeatureId = feature?.FeatureId??0,
                    GrandNodeProductAttributeValueId = newValue.Id,
                    FeatureName = feature.FeatureName,
                    AdditionalPrice = relatedProduct?.AdditionalPrice??0
                };

                await _featureValueMappingRepository.InsertAsync(featureValueMapping);
            }

            displayOrder++;
        }

        // Remove values that are no longer relevant
        foreach (var valueToRemove in currentValues.Where(v => !valuesToKeep.Contains(v)))
        {
            await _productAttributeService.DeleteProductAttributeValue(valueToRemove, grandNodeProductId,
                productAttributeMapping.Id);

            // Remove mapping record
            var mappingToRemove = _featureValueMappingRepository.Table
                .FirstOrDefault(fvm => fvm.GrandNodeProductAttributeValueId == valueToRemove.Id);
            if (mappingToRemove != null)
            {
                await _featureValueMappingRepository.DeleteAsync(mappingToRemove);
            }
        }

        _logger.LogDebug("Synced {Count} ProductAttributeValues for feature group {FeatureGroupName}",
            valuesToKeep.Count, featureGroup.FeaturesGroupName);
    }

    /// <summary>
    /// Syncs feature group as ProductSpecification (for ingredient properties)
    /// </summary>
    private async Task SyncFeatureGroupAsProductSpecificationAsync(
        AdisyoFeatureGroupDetail featureGroup,
        List<AdisyoFeatureDetail> relevantFeatures,
        AdisyoProduct product,
        string grandNodeProductId)
    {
        try
        {
            _logger.LogDebug("Syncing feature group {FeatureGroupName} as ProductSpecification for product {ProductId}",
                featureGroup.FeaturesGroupName, grandNodeProductId);

            var grandNodeProduct = _productRepository.Table.FirstOrDefault(p => p.Id == grandNodeProductId);
            if (grandNodeProduct == null) return;

            var externalId = $"adisyo-spec-group-{featureGroup.FeatureGroupId}";
            var existingSpec = grandNodeProduct.ProductSpecificationAttributes
                .FirstOrDefault(psa => psa.SpecificationAttributeId == externalId);

            var featureNames = relevantFeatures.Select(f => f.FeatureName).ToList();
            var specificationValue = string.Join(", ", featureNames);

            if (existingSpec != null)
            {
                if (existingSpec.CustomValue != specificationValue)
                {
                    existingSpec.CustomValue = specificationValue;
                    await _productService.UpdateProduct(grandNodeProduct);
                }
            }
            else
            {
                var newSpec = new ProductSpecificationAttribute {
                    SpecificationAttributeId = externalId,
                    CustomValue = specificationValue,
                    AllowFiltering = false,
                    ShowOnProductPage = true,
                    DisplayOrder = 0
                };

                grandNodeProduct.ProductSpecificationAttributes.Add(newSpec);
                await _productService.UpdateProduct(grandNodeProduct);
            }

            _logger.LogDebug("Synced feature group {FeatureGroupName} as ProductSpecification",
                featureGroup.FeaturesGroupName);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error syncing feature group {FeatureGroupName} as ProductSpecification",
                featureGroup.FeaturesGroupName);
            throw;
        }
    }

    /// <summary>
    /// Filters categories to sync based on settings
    /// </summary>
    private List<AdisyoProductCategory> FilterCategoriesToSync(List<AdisyoProductCategory> allCategories,
        AdisyoIntegrationSettings settings)
    {
        if (string.IsNullOrEmpty(settings.SyncCategoryIds))
        {
            return allCategories; // Sync all categories if no filter is set
        }

        var categoryIdsToSync = settings.SyncCategoryIds
            .Split(',')
            .Select(id => id.Trim())
            .Where(id => int.TryParse(id, out _))
            .Select(int.Parse)
            .ToHashSet();

        return allCategories.Where(c => categoryIdsToSync.Contains(c?.CategoryId??0)).ToList();
    }

    /// <summary>
    /// Determines if a category should be shown on homepage
    /// </summary>
    private bool ShouldShowCategoryOnHomepage(int adisyoCategoryId, AdisyoIntegrationSettings settings)
    {
        if (string.IsNullOrEmpty(settings.HomepageCategoryIds))
        {
            return false; // Don't show on homepage by default
        }

        var homepageCategoryIds = settings.HomepageCategoryIds
            .Split(',')
            .Select(id => id.Trim())
            .Where(id => int.TryParse(id, out _))
            .Select(int.Parse)
            .ToHashSet();

        return homepageCategoryIds.Contains(adisyoCategoryId);
    }

    /// <summary>
    /// Determines if products in a category should be featured
    /// </summary>
    private bool ShouldBeFeaturedProduct(Category category, AdisyoIntegrationSettings settings)
    {
        if (string.IsNullOrEmpty(settings.FeaturedProductCategoryIds))
        {
            return false; // Don't feature products by default
        }

        // Extract Adisyo category ID from external ID
        if (string.IsNullOrEmpty(category.ExternalId) || !category.ExternalId.StartsWith("adisyo-"))
        {
            return false;
        }

        var adisyoCategoryIdStr = category.ExternalId.Substring("adisyo-".Length);
        if (!int.TryParse(adisyoCategoryIdStr, out var adisyoCategoryId))
        {
            return false;
        }

        var featuredCategoryIds = settings.FeaturedProductCategoryIds
            .Split(',')
            .Select(id => id.Trim())
            .Where(id => int.TryParse(id, out _))
            .Select(int.Parse)
            .ToHashSet();

        return featuredCategoryIds.Contains(adisyoCategoryId);
    }


    private string GetMimeTypes(string image_url)
    {
        var extension = Path.GetExtension(image_url);
        switch (extension)
        {
            case ".jpg":
            case ".jpeg":
                return "image/jpeg";
            case ".png":
                return "image/png";
            case ".gif":
                return "image/gif";
            case ".bmp":
                return "image/bmp";
            case ".tiff":
                return "image/tiff";
            default:
                return "image/jpeg";
        }
    }
}