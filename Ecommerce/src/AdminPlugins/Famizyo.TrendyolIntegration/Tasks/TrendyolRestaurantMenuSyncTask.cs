using Famizyo.TrendyolIntegration.Models;
using Famizyo.TrendyolIntegration.Services;
using Famizyo.TrendyolIntegration.Settings;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Catalog;
using Grand.Domain.Seo;
using Grand.Domain.Stores;
using Grand.Domain.Tax;
using Microsoft.Extensions.Logging;
using MongoDB.Driver.Linq;
using System.Collections.Generic;

namespace Famizyo.TrendyolIntegration.Tasks;

public class TrendyolRestaurantMenuSyncTask : IScheduleTask
{
    private readonly TrendyolIntegrationSettings _trendyolIntegrationSettings;
    private readonly IRepository<ProductLayout> _productLayoutRepository;
    private readonly IRepository<TaxCategory> _taxCategoryRepository;
    private readonly IRepository<SpecificationAttribute> _specificationRepository;
    private readonly IRepository<Store> _storeRepository;
    private readonly IRepository<Product> _productRepository;
    private readonly ICategoryService _categoryService;
    private readonly IRepository<Category> _categoryRepository;
    private readonly SeoSettings _seoSettings;
    private readonly ISpecificationAttributeService _specificationAttributeService;
    private readonly IProductAttributeService _productAttributeService;
    private readonly ILogger<TrendyolRestaurantMenuSyncTask> _logger;
    private readonly IProductService _productService;
    private readonly IProductCategoryService _productCategoryService;

    private TrendyolMenuModel? _trendyolMenuModel;
    private SpecificationAttribute? _ingredientSpecificationAttribute;
    private ProductLayout? _productLayout;
    private const string _ingredientName = "Malzemeler";
    private const string _extraIngredientAttrName = "Ekstra Malzeme";

    public TrendyolRestaurantMenuSyncTask(
        TrendyolIntegrationSettings trendyolIntegrationSettings,
        IRepository<ProductLayout> productLayoutRepository,
        IRepository<TaxCategory> taxCategoryRepository,
        IRepository<SpecificationAttribute> specificationRepository,
        IRepository<Store> storeRepository,
        IRepository<Product> productRepository,
        ICategoryService categoryService,
        IRepository<Category> categoryRepository,
        SeoSettings seoSettings,
        ISpecificationAttributeService specificationAttributeService,
        IProductAttributeService productAttributeService,
        ILogger<TrendyolRestaurantMenuSyncTask> logger,
        IProductService productService,
        IProductCategoryService productCategoryService)
    {
        _trendyolIntegrationSettings = trendyolIntegrationSettings;
        _productLayoutRepository = productLayoutRepository;
        _taxCategoryRepository = taxCategoryRepository;
        _specificationRepository = specificationRepository;
        _storeRepository = storeRepository;
        _productRepository = productRepository;
        _categoryService = categoryService;
        _categoryRepository = categoryRepository;
        _seoSettings = seoSettings;
        _specificationAttributeService = specificationAttributeService;
        _productAttributeService = productAttributeService;
        _logger = logger;
        _productService = productService;
        _productCategoryService = productCategoryService;
    }

    public async Task Execute()
    {
        if (!HasActiveSetting())
            return;

        var productModel = await GetTrendyolMenuModelAsync();
        if (productModel == null)
            return;

        var modifierGroups = productModel.modifierGroups;
        var allAttributes = await _productAttributeService.GetAllProductAttributes();

        var modiferGroupAttributeMapping = await ProcessModifierGroupsAsync(modifierGroups, allAttributes);
        var extraIngredientAttr = await ProcessExtraIngredientsAsync(productModel, allAttributes);
        
        var allSpecificationAttributes = await _specificationAttributeService.GetSpecificationAttributes();
        var allAttributeOptions =
            allSpecificationAttributes.SelectMany(x => x.SpecificationAttributeOptions.Select(spo => spo.Id));
        var nullSpecOptions = _productRepository.Table
            .Where(p => p.ProductSpecificationAttributes.Any(x =>
                !allAttributeOptions.Contains(x.SpecificationAttributeOptionId)))
            .GroupBy(x => x.Id,
                (key, g) => new {
                    Id = key,
                    ProductSpecificationAttributes = g.SelectMany(x => x.ProductSpecificationAttributes).ToList()
                })
            .Select(p => new {
                ProductId = p.Id,
                NullSpecs = p.ProductSpecificationAttributes.Where(x =>
                    !allAttributeOptions.Contains(x.SpecificationAttributeOptionId)),
            })
            .ToList();
        foreach (var spec in nullSpecOptions)
        {
            foreach (var productSpecificationAttribute in spec.NullSpecs)
            {
                await _specificationAttributeService.DeleteProductSpecificationAttribute(productSpecificationAttribute,
                    spec.ProductId);
            }
        }
        
        await SyncProductsAsync(productModel, modiferGroupAttributeMapping, extraIngredientAttr);

        
    }

    private async Task<Dictionary<int, ProductAttribute>> ProcessModifierGroupsAsync(
        List<ModifierGroup>? modifierGroups,
        IList<ProductAttribute> allAttributes)
    {
        var modiferGroupAttributeMapping = new Dictionary<int, ProductAttribute>();
        if (modifierGroups == null)
            return modiferGroupAttributeMapping;


        var savedIngredient = await GetIngredientSpecificationAttributeAsync();
        var ingredientsToSpecifications = await IngredientsToSpecificationsAsync();

        if (savedIngredient.SpecificationAttributeOptions.Aggregate(0,
                (acc, x) => acc + savedIngredient.SpecificationAttributeOptions.Count(sao => sao.SeName == x.SeName)) >
            savedIngredient.SpecificationAttributeOptions.Count)
        {
            foreach (var oneMoreTimeSao in savedIngredient.SpecificationAttributeOptions)
            {
                await _specificationAttributeService.DeleteSpecificationAttributeOption(oneMoreTimeSao);
            }

            _ingredientSpecificationAttribute = null;
            savedIngredient = await GetIngredientSpecificationAttributeAsync();
        }

        if (ingredientsToSpecifications != null && savedIngredient != null)
        {
            var definedSpecs = ingredientsToSpecifications.Select(ispec => ispec.Value.SeName).ToList();
            var removedSpecifications = savedIngredient.SpecificationAttributeOptions
                .Where(x => !definedSpecs.Contains(x.SeName));
            foreach (var removedSpecification in removedSpecifications)
            {
                await _specificationAttributeService.DeleteSpecificationAttributeOption(removedSpecification);
            }

            _ingredientSpecificationAttribute = null;
            savedIngredient = await GetIngredientSpecificationAttributeAsync();

            foreach (var attributeOption in ingredientsToSpecifications)
            {
                if (savedIngredient!.SpecificationAttributeOptions.Any(x => x.SeName == attributeOption.Value.SeName))
                    continue;
                savedIngredient.SpecificationAttributeOptions.Add(attributeOption.Value);
            }

            await _specificationAttributeService.UpdateSpecificationAttribute(savedIngredient);
        }

        foreach (var modifierGroup in modifierGroups)
        {
            var savedModifierGroup = await ProcessModifierGroupAsync(modifierGroup, allAttributes);
            modiferGroupAttributeMapping.Add(modifierGroup.id, savedModifierGroup);
        }

        return modiferGroupAttributeMapping;
    }

    private async Task<ProductAttribute> ProcessModifierGroupAsync(ModifierGroup modifierGroup,
        IList<ProductAttribute> allAttributes)
    {
        var productAttributeSename = SeoExtensions.GetSeName($"{modifierGroup.name} {modifierGroup.id}",
            _seoSettings.ConvertNonWesternChars,
            _seoSettings.AllowUnicodeCharsInUrls,
            _seoSettings.SeoCharConversion);

        var savedModifierGroup = allAttributes.FirstOrDefault(x => x.SeName == productAttributeSename);
        if (savedModifierGroup == null)
        {
            savedModifierGroup = new ProductAttribute {
                Name = modifierGroup.name,
                SeName = productAttributeSename,
                LimitedToStores = false,
                PredefinedProductAttributeValues = new List<PredefinedProductAttributeValue>()
            };
            await _productAttributeService.InsertProductAttribute(savedModifierGroup);
        }
        else
        {
            foreach (var option in savedModifierGroup.PredefinedProductAttributeValues.ToList())
            {
                savedModifierGroup.PredefinedProductAttributeValues.Remove(option);
            }
        }

        foreach (var option in modifierGroup.modifierProducts)
        {
            var tProduct = await GetTrendyolProduct(option.id);
            if (tProduct == null)
                continue;

            var savedOption = new PredefinedProductAttributeValue() {
                Name = GetOptionNameFromTrendyol(tProduct.name),
                PriceAdjustment = Convert.ToDouble((int)(option.price ?? 0)),
                DisplayOrder = option.position,
            };
            savedModifierGroup.PredefinedProductAttributeValues.Add(savedOption);
        }

        await _productAttributeService.UpdateProductAttribute(savedModifierGroup);
        return savedModifierGroup;
    }

    private async Task<ProductAttribute> ProcessExtraIngredientsAsync(
        TrendyolMenuModel productModel,
        IList<ProductAttribute> allAttributes)
    {
        var extraIngredientAttrSeName = SeoExtensions.GetSeName(_extraIngredientAttrName,
            _seoSettings.ConvertNonWesternChars,
            _seoSettings.AllowUnicodeCharsInUrls,
            _seoSettings.SeoCharConversion);

        var extraIngredientAttr = allAttributes.FirstOrDefault(x => x.SeName == extraIngredientAttrSeName);
        if (extraIngredientAttr == null)
        {
            extraIngredientAttr = new ProductAttribute {
                Name = _extraIngredientAttrName,
                SeName = extraIngredientAttrSeName,
                PredefinedProductAttributeValues = new List<PredefinedProductAttributeValue>(),
                LimitedToStores = false,
            };
            await _productAttributeService.InsertProductAttribute(extraIngredientAttr);
        }
        else
        {
            extraIngredientAttr.PredefinedProductAttributeValues ??= new List<PredefinedProductAttributeValue>();
            foreach (var option in (extraIngredientAttr.PredefinedProductAttributeValues?.ToList() ?? []))
            {
                extraIngredientAttr.PredefinedProductAttributeValues!.Remove(option);
            }
        }

        var ingredientAttr = productModel.ingredients.Where(x => (x.price ?? 0) > 0)
            .Select(x =>
            {
                x.name = GetOptionNameFromTrendyol(x.name);
                return x;
            })
            .DistinctBy(x => new { x.name, x.price })
            .Select(x =>
                new KeyValuePair<int, PredefinedProductAttributeValue>(x.id,
                    new PredefinedProductAttributeValue {
                        Name = GetOptionNameFromTrendyol(x.name),
                        PriceAdjustment = Convert.ToDouble(x.price ?? 0),
                        DisplayOrder = 0,
                    })
            ).ToList();

        foreach (var extraAttr in ingredientAttr)
        {
            extraIngredientAttr.PredefinedProductAttributeValues!.Add(extraAttr.Value);
        }

        await _productAttributeService.UpdateProductAttribute(extraIngredientAttr);
        return extraIngredientAttr;
    }

    private async Task SyncProductsAsync(
        TrendyolMenuModel productModel,
        Dictionary<int, ProductAttribute> modiferGroupAttributeMapping,
        ProductAttribute extraIngredientAttr)
    {
        var taxCategory = _taxCategoryRepository.Table.Single(tc => tc.Name == "Temel Gıda Ürünleri");

        // Process categories and map products to categories
        var categoryMappings = await ProcessCategoriesAsync(productModel);

        // Process all products
        await ProcessAllProductsAsync(productModel, categoryMappings, taxCategory, modiferGroupAttributeMapping,
            extraIngredientAttr);
    }

    private async Task<Dictionary<int, List<Category>>> ProcessCategoriesAsync(TrendyolMenuModel productModel)
    {
        var categoryMappings = new Dictionary<int, List<Category>>();
        var sections = productModel.sections.ToList();

        // Process regular sections
        foreach (var section in sections)
        {
            var catName = GetOptionNameFromTrendyol(section.name);
            var category = await GetOrCreateCategoryAsync(catName, section);

            // Add each product in this section to the category mapping
            foreach (var product in section.products)
            {
                if (!categoryMappings.ContainsKey(product.id))
                {
                    categoryMappings[product.id] = new List<Category>();
                }

                if (!categoryMappings[product.id].Any(c => c.Id == category.Id))
                {
                    categoryMappings[product.id].Add(category);
                }
            }
        }

        // Process uncategorized products
        var tempProducts = productModel.products.ToList();

        // Remove products that are already in sections
        tempProducts.RemoveAll(tp =>
            productModel.modifierGroups.SelectMany(x => x.modifierProducts.Select(a => a.id)).Contains(tp.id));
        tempProducts.RemoveAll(tp =>
            productModel.sections.SelectMany(x => x.products.Select(a => a.id)).Contains(tp.id));

        if (tempProducts.Count > 0)
        {
            var section = new TrendyolMenuSection() {
                id = 0,
                name = "Kategorisiz Ürünler",
                position = 0,
                products = tempProducts,
                status = "PASSIVE",
            };

            var catName = GetOptionNameFromTrendyol(section.name);
            var category = await GetOrCreateCategoryAsync(catName, section);

            // Add each uncategorized product to the category mapping
            foreach (var product in tempProducts)
            {
                if (!categoryMappings.ContainsKey(product.id))
                {
                    categoryMappings[product.id] = new List<Category>();
                }

                if (!categoryMappings[product.id].Any(c => c.Id == category.Id))
                {
                    categoryMappings[product.id].Add(category);
                }
            }
        }

        return categoryMappings;
    }

    private async Task ProcessAllProductsAsync(
        TrendyolMenuModel productModel,
        Dictionary<int, List<Category>> categoryMappings,
        TaxCategory taxCategory,
        Dictionary<int, ProductAttribute> modiferGroupAttributeMapping,
        ProductAttribute extraIngredientAttr)
    {
        var allExistingProducts = _productRepository.Table
            .Where(p => !string.IsNullOrEmpty(p.ExternalId))
            .ToList();

        var savedIngredient = await GetIngredientSpecificationAttributeAsync();
        var processedProductIds = new HashSet<int>();

        // Process all products from Trendyol
        foreach (var tProd in productModel.products)
        {
            processedProductIds.Add(tProd.id);

            // Check if product exists by external ID
            var existingProduct = allExistingProducts
                .FirstOrDefault(p => p.ExternalId == tProd.id.ToString());

            if (existingProduct != null)
            {
                // Update existing product
                await UpdateProductAsync(tProd, existingProduct, taxCategory, categoryMappings,
                    savedIngredient, modiferGroupAttributeMapping, extraIngredientAttr, productModel);
            }
            else
            {
                // Create new product
                if (categoryMappings.TryGetValue(tProd.id, out var categories) && categories.Any())
                {
                    var primaryCategory = categories.First();
                    var showOnHomePage = primaryCategory.ExternalId.Trim() =="0";

                    var product = await CreateProductAsync(tProd, taxCategory, primaryCategory, showOnHomePage);

                    // Add additional categories
                    foreach (var additionalCategory in categories.Skip(1))
                    {
                        product.ProductCategories.Add(new ProductCategory() {
                            CategoryId = additionalCategory.Id,
                            IsFeaturedProduct = false
                        });
                    }

                    await _productService.UpdateProduct(product);

                    // Add product ingredients, modifiers and extra ingredients
                    await AddProductIngredientsAsync(tProd, product, savedIngredient);
                    await AddProductModifierGroupsAsync(tProd, product, productModel, modiferGroupAttributeMapping);
                    await AddProductExtraIngredientsAsync(tProd, product, productModel, extraIngredientAttr);
                }
            }
        }
    }

    private async Task UpdateProductAsync(
        TrendyolProduct tProd,
        Product existingProduct,
        TaxCategory taxCategory,
        Dictionary<int, List<Category>> categoryMappings,
        SpecificationAttribute? savedIngredient,
        Dictionary<int, ProductAttribute> modiferGroupAttributeMapping,
        ProductAttribute extraIngredientAttr,
        TrendyolMenuModel productModel)
    {
        bool isModified = false;

        // Check for basic property changes
        if (existingProduct.Name != tProd.name)
        {
            existingProduct.Name = tProd.name;
            isModified = true;
        }

        if (existingProduct.ShortDescription != tProd.description)
        {
            existingProduct.ShortDescription = tProd.description;
            isModified = true;
        }

        double newPrice = Convert.ToDouble(tProd.sellingPrice ?? 0);
        if (Math.Abs(existingProduct.Price - newPrice) > 0.001)
        {
            existingProduct.Price = newPrice;
            isModified = true;
        }

        double newOldPrice = Convert.ToDouble(tProd.originalPrice ?? 0);
        if (Math.Abs(existingProduct.OldPrice - newOldPrice) > 0.001)
        {
            existingProduct.OldPrice = 0;
            isModified = true;
        }

        if (existingProduct.Published != (tProd.status == "ACTIVE"))
        {
            existingProduct.Published = (tProd.status == "ACTIVE");
            isModified = true;
        }

        // Update categories
        if (categoryMappings.TryGetValue(tProd.id, out var categories) && categories.Any())
        {
            var currentCategoryIds = existingProduct.ProductCategories.Select(pc => pc.CategoryId).ToHashSet();
            var newCategoryIds = categories.Select(c => c.Id).ToHashSet();

            // Add missing categories
            foreach (var category in categories)
            {
                if (!currentCategoryIds.Contains(category.Id))
                {
                    var notExistingCategory = new ProductCategory() {
                        CategoryId = category.Id,
                        IsFeaturedProduct = existingProduct.ProductCategories.Count == 0 // First category is featured
                    };
                    await _productCategoryService.InsertProductCategory(notExistingCategory,existingProduct.Id);
                    
                    existingProduct.ProductCategories.Add(notExistingCategory);
                }
            }

            // Remove categories that are no longer associated
            foreach (var pc in existingProduct.ProductCategories)
            {
                if (!newCategoryIds.Contains(pc.CategoryId))
                {
                    existingProduct.ProductCategories.Remove(pc);
                    await _productCategoryService.DeleteProductCategory(pc, existingProduct.Id);
                }
            }

            // Update "ShowOnHomePage" based on categories

            if (categories.Any(x => x.ExternalId == _trendyolIntegrationSettings.BestSellerSectionId.ToString()))
            {
                if (existingProduct.BestSeller != true)
                {
                    existingProduct.BestSeller = true;
                    isModified = true;
                }
            }else if (existingProduct.BestSeller)
            {
                existingProduct.BestSeller = false;
                isModified = true;
            }
            
            if (categories.Any(x => x.ExternalId == _trendyolIntegrationSettings.NewSectionId.ToString()))
            {
                if (existingProduct.MarkAsNew != true)
                {
                    existingProduct.MarkAsNew = true;
                    isModified = true;
                }
            }else if (existingProduct.MarkAsNew)
            {
                existingProduct.MarkAsNew = false;
                isModified = true;
            }
        }

        // Save changes to basic properties if modified
        if (isModified)
        {
            await _productService.UpdateProduct(existingProduct);
        }

        // Update specifications (ingredients)
        await UpdateProductIngredientsAsync(tProd, existingProduct, savedIngredient);

        // Update product attributes (modifier groups)
        await UpdateProductModifierGroupsAsync(tProd, existingProduct, productModel, modiferGroupAttributeMapping);

        // Update extra ingredients
        await UpdateProductExtraIngredientsAsync(tProd, existingProduct, productModel, extraIngredientAttr);
    }

    private async Task UpdateProductIngredientsAsync(
        TrendyolProduct tProd,
        Product product,
        SpecificationAttribute? savedIngredient)
    {
        if (savedIngredient == null)
            return;

        // Get current specification attributes for this product
        var existingSpecs = product.ProductSpecificationAttributes;
        var existingIngredientSpecs = existingSpecs
            .Where(s => s.SpecificationAttributeId == savedIngredient.Id)
            .ToList();

        var existingIngredientIds = new HashSet<int>();
        foreach (var spec in existingIngredientSpecs)
        {
            var option = savedIngredient.SpecificationAttributeOptions
                .FirstOrDefault(o => o.Id == spec.SpecificationAttributeOptionId);

            if (option != null)
            {
                var ingredient = _trendyolMenuModel?.ingredients
                    .FirstOrDefault(i => GetOptionNameFromTrendyol(i.name) == option.Name);

                if (ingredient != null)
                {
                    existingIngredientIds.Add(ingredient.id);
                }
            }
        }

        // Add missing ingredients
        foreach (var ingredientId in tProd.ingredients)
        {
            if (!existingIngredientIds.Contains(ingredientId))
            {
                var ingredientOption = GetIngredientSpecificationAttributeOption(ingredientId, savedIngredient);
                if (ingredientOption == null)
                    continue;

                var specificationAttribute =
                    await _specificationAttributeService
                        .GetSpecificationAttributeByOptionId(ingredientOption.Id);

                await _specificationAttributeService.InsertProductSpecificationAttribute(
                    new ProductSpecificationAttribute {
                        AttributeTypeId = SpecificationAttributeType.Option,
                        SpecificationAttributeId = specificationAttribute.Id,
                        SpecificationAttributeOptionId = _specificationRepository.Table
                            .Single(x => x.Id == specificationAttribute.Id).SpecificationAttributeOptions
                            .Single(x => x.SeName == ingredientOption.SeName).Id,
                        AllowFiltering = true,
                        ShowOnProductPage = true,
                        DisplayOrder = 0
                    }, product.Id);
            }
        }

        // Remove ingredients that are no longer associated
        foreach (var spec in existingIngredientSpecs)
        {
            var option = savedIngredient.SpecificationAttributeOptions
                .FirstOrDefault(o => o.Id == spec.SpecificationAttributeOptionId);

            if (option != null)
            {
                var ingredient = _trendyolMenuModel?.ingredients
                    .FirstOrDefault(i => GetOptionNameFromTrendyol(i.name) == option.Name);

                if (ingredient != null && !tProd.ingredients.Contains(ingredient.id))
                {
                    await _specificationAttributeService.DeleteProductSpecificationAttribute(spec, product.Id);
                }
            }
            else
            {
                await _specificationAttributeService.DeleteProductSpecificationAttribute(spec, product.Id);
            }
        }
    }

    private async Task UpdateProductModifierGroupsAsync(
        TrendyolProduct tProd,
        Product product,
        TrendyolMenuModel productModel,
        Dictionary<int, ProductAttribute> modiferGroupAttributeMapping)
    {
        // Get current product attribute mappings
        var existingAttributes = product.ProductAttributeMappings;

        // Get current modifier groups
        var existingModifierGroupIds = new HashSet<int>();
        foreach (var attr in existingAttributes)
        {
            foreach (var kvp in modiferGroupAttributeMapping)
            {
                if (kvp.Value.Id == attr.ProductAttributeId)
                {
                    existingModifierGroupIds.Add(kvp.Key);
                    break;
                }
            }
        }

        // Add missing modifier groups
        foreach (var groupId in tProd.modifierGroups.Select(mg => mg.id))
        {
            if (!existingModifierGroupIds.Contains(groupId) &&
                modiferGroupAttributeMapping.TryGetValue(groupId, out var modifierGroupAttr))
            {
                var prodModifierGroupDetail = await GetTrendyolModifierGroup(groupId);
                if (prodModifierGroupDetail == null)
                    continue;

                var attributeControlType = DetermineAttributeControlType(prodModifierGroupDetail);

                var productAttributeMapping = new ProductAttributeMapping {
                    ProductAttributeId = modifierGroupAttr.Id,
                    TextPrompt = modifierGroupAttr.Name,
                    IsRequired = prodModifierGroupDetail.min > 0,
                    ShowOnCatalogPage = true,
                    Combination = true,
                    AttributeControlTypeId = attributeControlType,
                    DisplayOrder = 1,
                };

                await _productAttributeService.InsertProductAttributeMapping(productAttributeMapping, product.Id);

                await AddModifierProductAttributeValuesAsync(productAttributeMapping, prodModifierGroupDetail,
                    modifierGroupAttr, product.Id);
            }
            else if (existingModifierGroupIds.Contains(groupId))
            {
                // Update existing modifier group
                var notDefinedModifierGroupAttr = modiferGroupAttributeMapping[groupId];
                var prodModifierGroupDetail = await GetTrendyolModifierGroup(groupId);
                if (prodModifierGroupDetail == null)
                    continue;

                var attributeMapping =
                    existingAttributes.FirstOrDefault(a => a.ProductAttributeId == notDefinedModifierGroupAttr.Id);
                if (attributeMapping != null)
                {
                    bool isModified = false;

                    // Update attribute mapping properties
                    if (attributeMapping.TextPrompt != notDefinedModifierGroupAttr.Name)
                    {
                        attributeMapping.TextPrompt = notDefinedModifierGroupAttr.Name;
                        isModified = true;
                    }

                    if (attributeMapping.IsRequired != (prodModifierGroupDetail.min > 0))
                    {
                        attributeMapping.IsRequired = prodModifierGroupDetail.min > 0;
                        isModified = true;
                    }

                    var newControlType = DetermineAttributeControlType(prodModifierGroupDetail);
                    if (attributeMapping.AttributeControlTypeId != newControlType)
                    {
                        attributeMapping.AttributeControlTypeId = newControlType;
                        isModified = true;
                    }

                    if (isModified)
                    {
                        await _productAttributeService.UpdateProductAttributeMapping(attributeMapping, product.Id);
                    }

                    // Update attribute values
                    await UpdateModifierProductAttributeValuesAsync(attributeMapping, prodModifierGroupDetail,
                        notDefinedModifierGroupAttr, product.Id);
                }
            }
        }

        // Remove modifier groups that are no longer associated
        foreach (var attr in existingAttributes)
        {
            bool isModifierGroupAttr = false;
            int modifierGroupId = 0;

            foreach (var kvp in modiferGroupAttributeMapping)
            {
                if (kvp.Value.Id == attr.ProductAttributeId)
                {
                    isModifierGroupAttr = true;
                    modifierGroupId = kvp.Key;
                    break;
                }
            }

            if (isModifierGroupAttr && !tProd.modifierGroups.Any(mg => mg.id == modifierGroupId))
            {
                await _productAttributeService.DeleteProductAttributeMapping(attr, product.Id);
            }
        }
    }

    private async Task UpdateModifierProductAttributeValuesAsync(
        ProductAttributeMapping attributeMapping,
        ModifierGroup modifierGroup,
        ProductAttribute modifierGroupAttr,
        string productId)
    {
        // Get current attribute values
        var existingValues = attributeMapping.ProductAttributeValues;

        // Track existing value IDs for options
        var existingOptionNameMap = new Dictionary<string, ProductAttributeValue>();
        foreach (var value in existingValues)
        {
            existingOptionNameMap[value.Name] = value;
        }

        // Update or add new values
        foreach (var option in modifierGroup.modifierProducts)
        {
            var tProduct = await GetTrendyolProduct(option.id);
            if (tProduct == null)
                continue;

            var optionName = GetOptionNameFromTrendyol(tProduct.name);
            var predefinedAttribute = modifierGroupAttr.PredefinedProductAttributeValues
                .FirstOrDefault(x => x.Name == optionName);

            if (predefinedAttribute == null)
                continue;

            bool isPreSelected = DetermineIsPreSelected(modifierGroup, option);

            if (existingOptionNameMap.TryGetValue(optionName, out var existingValue))
            {
                // Update existing value
                bool isModified = false;

                if (Math.Abs(existingValue.PriceAdjustment - predefinedAttribute.PriceAdjustment) > 0.001)
                {
                    existingValue.PriceAdjustment = predefinedAttribute.PriceAdjustment;
                    isModified = true;
                }

                if (existingValue.IsPreSelected != isPreSelected)
                {
                    existingValue.IsPreSelected = isPreSelected;
                    isModified = true;
                }

                if (existingValue.DisplayOrder != option.position)
                {
                    existingValue.DisplayOrder = option.position;
                    isModified = true;
                }

                if (isModified)
                {
                    await _productAttributeService.UpdateProductAttributeValue(existingValue, productId,
                        attributeMapping.Id);
                }
            }
            else
            {
                // Add new value
                var newValue = new ProductAttributeValue {
                    AttributeValueTypeId = AttributeValueType.Simple,
                    Name = predefinedAttribute.Name,
                    PriceAdjustment = predefinedAttribute.PriceAdjustment,
                    IsPreSelected = isPreSelected,
                    DisplayOrder = option.position,
                };

                await _productAttributeService.InsertProductAttributeValue(newValue, productId, attributeMapping.Id);
            }
        }

        // Remove values that are no longer in the modifier group
        foreach (var existingValue in existingValues)
        {
            bool stillExists = false;

            foreach (var option in modifierGroup.modifierProducts)
            {
                var tProduct = await GetTrendyolProduct(option.id);
                if (tProduct != null && existingValue.Name == GetOptionNameFromTrendyol(tProduct.name))
                {
                    stillExists = true;
                    break;
                }
            }

            if (!stillExists)
            {
                await _productAttributeService.DeleteProductAttributeValue(existingValue, productId,
                    attributeMapping.Id);
            }
        }
    }

    private async Task UpdateProductExtraIngredientsAsync(
        TrendyolProduct tProd,
        Product product,
        TrendyolMenuModel productModel,
        ProductAttribute extraIngredientAttr)
    {
        if (tProd.extraIngredients.Count == 0)
        {
            // Remove any existing extra ingredient attribute if there are no extra ingredients
            var existingAttributes = product.ProductAttributeMappings;
            var extraIngredientMapping = existingAttributes
                .FirstOrDefault(a => a.ProductAttributeId == extraIngredientAttr.Id);

            if (extraIngredientMapping != null)
            {
                await _productAttributeService.DeleteProductAttributeMapping(extraIngredientMapping, product.Id);
            }

            return;
        }

        // Get or create the extra ingredient attribute mapping
        var attributes = product.ProductAttributeMappings;
        var attributeMapping = attributes.FirstOrDefault(a => a.ProductAttributeId == extraIngredientAttr.Id);

        if (attributeMapping == null)
        {
            // Create new mapping
            attributeMapping = new ProductAttributeMapping {
                ProductAttributeId = extraIngredientAttr.Id,
                TextPrompt = extraIngredientAttr.Name,
                IsRequired = false,
                ShowOnCatalogPage = true,
                Combination = true,
                AttributeControlTypeId = AttributeControlType.Checkboxes,
                DisplayOrder = 1,
            };

            await _productAttributeService.InsertProductAttributeMapping(attributeMapping, product.Id);
        }

        // Get current attribute values
        var existingValues = attributeMapping.ProductAttributeValues;
        var existingExtraIngredientIds = new HashSet<int>();

        foreach (var value in existingValues)
        {
            var ingredient = productModel.ingredients.FirstOrDefault(i =>
                GetOptionNameFromTrendyol(i.name) == value.Name &&
                Math.Abs(Convert.ToDouble(i.price ?? 0) - value.PriceAdjustment) < 0.001);

            if (ingredient != null)
            {
                existingExtraIngredientIds.Add(ingredient.id);
            }
        }

        // Add missing extra ingredients
        foreach (var extraIngredientId in tProd.extraIngredients)
        {
            if (!existingExtraIngredientIds.Contains(extraIngredientId))
            {
                var extraIngredientOption =
                    GetExtraAttributeValue(extraIngredientId, productModel, extraIngredientAttr);

                if (extraIngredientOption != null)
                {
                    var savedOption = new ProductAttributeValue {
                        AttributeValueTypeId = AttributeValueType.Simple,
                        Name = extraIngredientOption.Name,
                        PriceAdjustment = extraIngredientOption.PriceAdjustment,
                        IsPreSelected = false,
                        DisplayOrder = extraIngredientOption.DisplayOrder,
                    };

                    await _productAttributeService.InsertProductAttributeValue(savedOption, product.Id,
                        attributeMapping.Id);
                }
            }
        }

        // Remove extra ingredients that are no longer associated
        foreach (var value in existingValues)
        {
            var ingredient = productModel.ingredients.FirstOrDefault(i =>
                GetOptionNameFromTrendyol(i.name) == value.Name &&
                Math.Abs(Convert.ToDouble(i.price ?? 0) - value.PriceAdjustment) < 0.001);

            if (ingredient != null && !tProd.extraIngredients.Contains(ingredient.id))
            {
                await _productAttributeService.DeleteProductAttributeValue(value, product.Id, attributeMapping.Id);
            }
        }
    }

    private async Task<Category> GetOrCreateCategoryAsync(
        string catName,
        TrendyolMenuSection section)
    {
        var category = await _categoryRepository.GetOneAsync(x => x.ExternalId == section.id.ToString());
        if (category == null)
        {
            var categoryEntity = new Category {
                Name = catName,
                Published = section.status == "ACTIVE",
                DefaultSort = 0,
                AllowCustomersToSelectPageSize = true,
                PageSizeOptions = "6,3,9,18,20",
                FeaturedProductsOnHomePage = true,
                ExternalId = section.id.ToString(),
                ShowOnSearchBox = true
            };

            await _categoryService.InsertCategory(categoryEntity);
            category = categoryEntity;
        }
        else
        {
            category.Published = section.status == "ACTIVE";
            category.ExternalId = section.id.ToString();
            await _categoryService.UpdateCategory(category);
        }

        return category;
    }

    private async Task<Product> CreateProductAsync(
        TrendyolProduct tProd,
        TaxCategory taxCategory,
        Category category,
        bool showOnHomePage)
    {
        if (string.IsNullOrEmpty(category.ExternalId))
        {
            category.ExternalId = "0";
        }

        var product = new Product() {
            ProductTypeId = ProductType.SimpleProduct,
            VisibleIndividually = true,
            ShortDescription = tProd.description,
            FullDescription = "",
            ProductLayoutId = (await GetProductLayoutAsync())?.Id,
            ExternalId = tProd.id.ToString(),
            AllowCustomerReviews = true,
            IsShipEnabled = true,
            ShowOnHomePage = false,
            Weight = 2,
            Length = 2,
            Width = 2,
            Height = 3,
            TaxCategoryId = taxCategory.Id,
            ManageInventoryMethodId = ManageInventoryMethod.DontManageStock,
            StockQuantity = 10000,
            NotifyAdminForQuantityBelow = 1,
            AllowOutOfStockSubscriptions = false,
            StockAvailability = true,
            LowStockActivityId = LowStockActivity.DisableBuyButton,
            BackorderModeId = BackorderMode.NoBackorders,
            OrderMinimumQuantity = 1,
            OrderMaximumQuantity = 10000,
            Published = tProd.status == "ACTIVE",
            ProductCategories = {
                new ProductCategory() {
                    CategoryId = category.Id,
                    IsFeaturedProduct = true
                }
            },
            BestSeller = _trendyolIntegrationSettings.BestSellerSectionId ==
                         int.Parse(category.ExternalId ?? "0"),
            MarkAsNew = _trendyolIntegrationSettings.NewSectionId ==
                        int.Parse(category.ExternalId ?? "0"),
            Name = tProd.name,
            Price = Convert.ToDouble(tProd.sellingPrice ?? 0),
            OldPrice = 0,
        };

        await _productService.InsertProduct(product);
        return product;
    }

    private async Task AddProductIngredientsAsync(
        TrendyolProduct tProd,
        Product product,
        SpecificationAttribute? savedIngredient)
    {
        if (savedIngredient == null)
            return;

        foreach (var ingredient in tProd.ingredients)
        {
            var ingredientOption = GetIngredientSpecificationAttributeOption(ingredient, savedIngredient);
            if (ingredientOption == null)
                continue;

            var specificationAttribute =
                await _specificationAttributeService
                    .GetSpecificationAttributeByOptionId(ingredientOption.Id);

            await _specificationAttributeService.InsertProductSpecificationAttribute(
                new ProductSpecificationAttribute {
                    AttributeTypeId = SpecificationAttributeType.Option,
                    SpecificationAttributeId = specificationAttribute.Id,
                    SpecificationAttributeOptionId = _specificationRepository.Table
                        .Single(x => x.Id == specificationAttribute.Id).SpecificationAttributeOptions
                        .Single(x => x.SeName == ingredientOption.SeName).Id,
                    AllowFiltering = true,
                    ShowOnProductPage = true,
                    DisplayOrder = 0
                }, product.Id);
        }
    }

    private async Task AddProductModifierGroupsAsync(
        TrendyolProduct tProd,
        Product product,
        TrendyolMenuModel productModel,
        Dictionary<int, ProductAttribute> modiferGroupAttributeMapping)
    {
        foreach (var prodModifierGroup in tProd.modifierGroups)
        {
            var prodModifierGroupDetail = await GetTrendyolModifierGroup(prodModifierGroup.id);
            if (prodModifierGroupDetail == null || !modiferGroupAttributeMapping.ContainsKey(prodModifierGroup.id))
                continue;

            var modifierGroupAttr = modiferGroupAttributeMapping[prodModifierGroup.id];
            var attributeControlType = DetermineAttributeControlType(prodModifierGroupDetail);

            var productAttributeMapping = new ProductAttributeMapping {
                ProductAttributeId = modifierGroupAttr.Id,
                TextPrompt = modifierGroupAttr.Name,
                IsRequired = prodModifierGroupDetail.min > 0,
                ShowOnCatalogPage = true,
                Combination = true,
                AttributeControlTypeId = attributeControlType,
                DisplayOrder = 1,
            };

            await _productAttributeService.InsertProductAttributeMapping(productAttributeMapping, product.Id);

            await AddModifierProductAttributeValuesAsync(productAttributeMapping, prodModifierGroupDetail,
                modifierGroupAttr, product.Id);
        }
    }

    private AttributeControlType DetermineAttributeControlType(ModifierGroup modifierGroup)
    {
        return modifierGroup switch {
            {
                min: 1,
                max: 1,
                modifierProducts.Count: > 1
            } => AttributeControlType.DropdownList,
            {
                min: 1,
                max: 1,
                modifierProducts.Count: 1
            } => AttributeControlType.ReadonlyCheckboxes,
            {
                min: 0,
                max: 1,
                modifierProducts.Count: > 1
            } => AttributeControlType.DropdownList,
            {
                min: 0,
                max: 1,
                modifierProducts.Count: 1
            } => AttributeControlType.ReadonlyCheckboxes,
            _ => AttributeControlType.Checkboxes
        };
    }

    private async Task AddModifierProductAttributeValuesAsync(
        ProductAttributeMapping productAttributeMapping,
        ModifierGroup modifierGroup,
        ProductAttribute modifierGroupAttr,
        string productId)
    {
        foreach (var option in modifierGroup.modifierProducts)
        {
            var tProduct = await GetTrendyolProduct(option.id);
            if (tProduct == null)
                continue;

            var predefinedAttribute =
                modifierGroupAttr.PredefinedProductAttributeValues.FirstOrDefault(x =>
                    x.Name == GetOptionNameFromTrendyol(tProduct.name));

            if (predefinedAttribute == null)
                continue;

            var isPreSelected = DetermineIsPreSelected(modifierGroup, option);

            var savedOption = new ProductAttributeValue {
                AttributeValueTypeId = AttributeValueType.Simple,
                Name = predefinedAttribute.Name,
                PriceAdjustment = predefinedAttribute.PriceAdjustment,
                IsPreSelected = isPreSelected,
                DisplayOrder = option.position,
            };

            await _productAttributeService.InsertProductAttributeValue(savedOption, productId,
                productAttributeMapping.Id);
        }
    }

    private bool DetermineIsPreSelected(ModifierGroup modifierGroup, ModifierProduct option)
    {
        return modifierGroup switch {
            {
                min: 1,
                max: 1,
                modifierProducts.Count: > 1
            } => !modifierGroup.modifierProducts.Any(x => x.position < option.position),
            {
                min: 1,
                max: 1,
                modifierProducts.Count: 1
            } => true,
            {
                min: 0,
                max: 1,
                modifierProducts.Count: > 1
            } => false,
            {
                min: 0,
                max: 1,
                modifierProducts.Count: 1
            } => true,
            _ => false
        };
    }

    private async Task AddProductExtraIngredientsAsync(
        TrendyolProduct tProd,
        Product product,
        TrendyolMenuModel productModel,
        ProductAttribute extraIngredientAttr)
    {
        if (tProd.extraIngredients.Count == 0)
            return;

        var productAttributeMapping = new ProductAttributeMapping {
            ProductAttributeId = extraIngredientAttr.Id,
            TextPrompt = extraIngredientAttr.Name,
            IsRequired = false,
            ShowOnCatalogPage = true,
            Combination = true,
            AttributeControlTypeId = AttributeControlType.Checkboxes,
            DisplayOrder = 1,
        };

        await _productAttributeService.InsertProductAttributeMapping(productAttributeMapping, product.Id);

        foreach (var extraIngredient in tProd.extraIngredients)
        {
            var extraIngredientOption = GetExtraAttributeValue(extraIngredient, productModel, extraIngredientAttr);

            if (extraIngredientOption != null)
            {
                var savedOption = new ProductAttributeValue {
                    AttributeValueTypeId = AttributeValueType.Simple,
                    Name = extraIngredientOption.Name,
                    PriceAdjustment = extraIngredientOption.PriceAdjustment,
                    IsPreSelected = false,
                    DisplayOrder = extraIngredientOption.DisplayOrder,
                };

                await _productAttributeService.InsertProductAttributeValue(savedOption, product.Id,
                    productAttributeMapping.Id);
            }
        }
    }

    #region Helper Methods

    private async Task<TrendyolMenuModel?> GetTrendyolMenuModelAsync()
    {
        if (!HasActiveSetting())
            return null;

        try
        {
            if (_trendyolMenuModel != null)
            {
                return _trendyolMenuModel;
            }

            var menuClient = new TrendyolMenuClient(
                _trendyolIntegrationSettings,
                _trendyolIntegrationSettings.StoreId ?? 0
            );

            _trendyolMenuModel = await menuClient.Process(null);

            return _trendyolMenuModel;
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error getting trendyol menu");
            return null;
        }
    }

    private string _ingredientSeName => SeoExtensions.GetSeName(_ingredientName,
        _seoSettings.ConvertNonWesternChars,
        _seoSettings.AllowUnicodeCharsInUrls,
        _seoSettings.SeoCharConversion);

    private async Task<SpecificationAttribute?> GetIngredientSpecificationAttributeAsync()
    {
        if (_ingredientSpecificationAttribute != null)
            return _ingredientSpecificationAttribute;

        _ingredientSpecificationAttribute =
            await _specificationAttributeService.GetSpecificationAttributeBySeName(_ingredientSeName);

        if (_ingredientSpecificationAttribute == null)
        {
            _ingredientSpecificationAttribute = new SpecificationAttribute {
                Name = _ingredientName,
                SeName = _ingredientSeName,
                DisplayOrder = 0,
                LimitedToStores = false,
            };

            await _specificationAttributeService.InsertSpecificationAttribute(_ingredientSpecificationAttribute);
        }


        return _ingredientSpecificationAttribute;
    }

    private async Task<TrendyolProduct?> GetTrendyolProduct(int id)
    {
        return (await GetTrendyolMenuModelAsync())?.products.FirstOrDefault(x => x.id == id);
    }

    private async Task<ModifierGroup?> GetTrendyolModifierGroup(int id)
    {
        return (await GetTrendyolMenuModelAsync())?.modifierGroups.FirstOrDefault(x => x.id == id);
    }

    private string GetOptionNameFromTrendyol(string trendyolOptionName) => string.Join(' ',
        trendyolOptionName.ToLowerInvariant().Split(' ').Where(n => !string.IsNullOrEmpty(n))
            .Select((n) => string.Join("", n[0].ToString().ToUpper(), string.Join("", n[1..]))).ToList());

    private async Task<List<KeyValuePair<int, SpecificationAttributeOption>>?> IngredientsToSpecificationsAsync()
    {
        var ingredientsToSpecifications = (await GetTrendyolMenuModelAsync())?.ingredients
            .Where(x => (x.price ?? 0) <= 0).Select(x =>
            {
                x.name = GetOptionNameFromTrendyol(x.name);
                return x;
            }).DistinctBy(x => new { x.name, x.price }).Select(x => new KeyValuePair<int, SpecificationAttributeOption>(
                x.id,
                new SpecificationAttributeOption {
                    Name = x.name,
                    SeName = SeoExtensions.GenerateSlug(x.name + " " + x.id, _seoSettings.ConvertNonWesternChars,
                        _seoSettings.AllowUnicodeCharsInUrls,
                        _seoSettings.AllowSlashChar,
                        _seoSettings.SeoCharConversion),
                })
            ).ToList();
        return ingredientsToSpecifications;
    }

    private async Task<ProductLayout?> GetProductLayoutAsync()
    {
        if (_productLayout != null)
            return _productLayout;
        _productLayout = await _productLayoutRepository.Table.FirstOrDefaultAsync(pt => pt.Name == "Simple product");
        return _productLayout;
    }

    private bool HasActiveSetting()
    {
        return !(
            string.IsNullOrEmpty(_trendyolIntegrationSettings.ApiKey) ||
            string.IsNullOrEmpty(_trendyolIntegrationSettings.ApiSecret) ||
            string.IsNullOrEmpty(_trendyolIntegrationSettings.SaticiId) ||
            (_trendyolIntegrationSettings.StoreId ?? 0) == 0
        );
    }

    private PredefinedProductAttributeValue? GetExtraAttributeValue(
        int id,
        TrendyolMenuModel productModel,
        ProductAttribute extraIngredientAttr)
    {
        return extraIngredientAttr.PredefinedProductAttributeValues!.FirstOrDefault(a =>
            a.Name == GetOptionNameFromTrendyol(
                productModel.ingredients.FirstOrDefault(x => x.id == id)?.name ?? "") &&
            Math.Abs(a.PriceAdjustment -
                     Convert.ToDouble(productModel.ingredients!.FirstOrDefault(x => x.id == id)?.price ?? 0)) == 0);
    }

    private SpecificationAttributeOption? GetIngredientSpecificationAttributeOption(
        int id,
        SpecificationAttribute savedIngredient)
    {
        var menuModel = _trendyolMenuModel;
        if (menuModel == null)
            return null;

        return savedIngredient.SpecificationAttributeOptions.FirstOrDefault(a =>
            a.Name == GetOptionNameFromTrendyol(
                menuModel.ingredients.FirstOrDefault(x => x.id == id)?.name ?? ""));
    }

    #endregion
}