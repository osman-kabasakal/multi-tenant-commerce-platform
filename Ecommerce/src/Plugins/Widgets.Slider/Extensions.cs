using Grand.Business.Core.Interfaces.Catalog.Brands;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Catalog.Collections;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Seo;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Domain.Localization;
using Grand.Infrastructure;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Mapper;
using Grand.Web.Common.Extensions;
using Grand.Web.Common.Models;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using System.Text.Json;
using Widgets.Slider.Domain;
using Widgets.Slider.Models;

namespace Widgets.Slider;

public static class MyExtensions
{
    public static SlideModel ToModel(this PictureSlider entity, IDateTimeService dateTimeService)
    {
        var slideModel = entity.MapTo<PictureSlider, SlideModel>();
        slideModel.StartDateUtc = entity.StartDateUtc.ConvertToUserTime(dateTimeService);
        slideModel.EndDateUtc = entity.EndDateUtc.ConvertToUserTime(dateTimeService);
        return slideModel;
    }

    public static PictureSlider ToEntity(this SlideModel model, IDateTimeService dateTimeService)
    {
        var pictureSlider = model.MapTo<SlideModel, PictureSlider>();
        pictureSlider.StartDateUtc = model.StartDateUtc.ConvertToUtcTime(dateTimeService);
        pictureSlider.EndDateUtc = model.EndDateUtc.ConvertToUtcTime(dateTimeService);
        return pictureSlider;
    }

    public static PictureSlider ToEntity(this SlideModel model, PictureSlider destination,
        IDateTimeService dateTimeService)
    {
        var pictureSlider = model.MapTo(destination);
        pictureSlider.StartDateUtc = model.StartDateUtc.ConvertToUtcTime(dateTimeService);
        pictureSlider.EndDateUtc = model.EndDateUtc.ConvertToUtcTime(dateTimeService);
        return pictureSlider;
    }

    public static SlideListModel ToListModel(this PictureSlider entity)
    {
        return entity.MapTo<PictureSlider, SlideListModel>();
    }

    public static List<TranslationEntity> ToLocalizedProperty<T>(this IList<T> list) where T : ILocalizedModelLocal
    {
        var local = new List<TranslationEntity>();
        foreach (var item in list)
        {
            var interfaces = item.GetType().GetInterfaces();
            var props = item.GetType()
                .GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.FlattenHierarchy);
            foreach (var prop in props)
            {
                var insert = true;

                foreach (var i in interfaces)
                    if (i.HasProperty(prop.Name))
                        insert = false;

                if (insert && prop.GetValue(item) != null)
                    local.Add(new TranslationEntity {
                        LanguageId = item.LanguageId,
                        LocaleKey = prop.Name,
                        LocaleValue = prop.GetValue(item)?.ToString()
                    });
            }
        }

        return local;
    }

    public static bool HasProperty(this Type obj, string propertyName)
    {
        return obj.GetProperty(propertyName) != null;
    }
    
    public static async Task<string> GetFinalLinkUrl(this PictureSlider slider,IServiceProvider serviceProvider
        )
    {
        ICategoryService categoryService = serviceProvider.GetRequiredService<ICategoryService>();
            IProductService productService = serviceProvider.GetRequiredService<IProductService>();
        IBrandService brandService = serviceProvider.GetRequiredService<IBrandService>();
            ICollectionService collectionService = serviceProvider.GetRequiredService<ICollectionService>();
        IBlogService blogService = serviceProvider.GetRequiredService<IBlogService>();
            IWorkContext workContext = serviceProvider.GetRequiredService<IWorkContext>();
        ISlugService slugService = serviceProvider.GetRequiredService<ISlugService>();
            ILanguageService languageService = serviceProvider.GetRequiredService<ILanguageService>();
            AppConfig appConfig = serviceProvider.GetRequiredService<AppConfig>();
            var storeService = serviceProvider.GetRequiredService<IStoreService>();
            // Eğer slider linki boşsa, varsayılan URL'yi döndür    
        // Manuel URL için
        if (slider.LinkType == SliderLinkType.Manual)
            return slider.Link;
        
        // SEO URL'lerin dil desteği olup olmadığını kontrol etmek için
        var seoFriendlyUrlsForLanguagesEnabled = appConfig.SeoFriendlyUrlsForLanguagesEnabled;
        var language = workContext.WorkingLanguage;

        // URL prefix (dil desteği için)
        var languagePrefix = workContext.CurrentStore.Domains.First().Url.TrimEnd('/')+"/";
        if (seoFriendlyUrlsForLanguagesEnabled)
        {
            languagePrefix += $"{language.UniqueSeoCode}/";
        }
        
        // Generate URLs based on the link type and reference ID
        switch (slider.LinkType)
        {
            case SliderLinkType.Category:
                if (string.IsNullOrEmpty(slider.ReferenceId))
                    return "";
                
                var category = await categoryService.GetCategoryById(slider.ReferenceId);
                if (category == null)
                    return "";
                
                // Slug servisinden kategori slug'ını al
                var categorySlug = await slugService.GetActiveSlug(category.Id, "Category", language.Id);
                if (string.IsNullOrEmpty(categorySlug))
                    categorySlug = category.SeName;
                
                return $"{languagePrefix}{categorySlug}";
                
            case SliderLinkType.Product:
                if (string.IsNullOrEmpty(slider.ReferenceId))
                    return "";
                
                var product = await productService.GetProductById(slider.ReferenceId);
                if (product == null)
                    return "";
                
                // Slug servisinden ürün slug'ını al
                var productSlug = await slugService.GetActiveSlug(product.Id, "Product", language.Id);
                if (string.IsNullOrEmpty(productSlug))
                    productSlug = product.SeName;
                
                return $"{languagePrefix}{productSlug}";
                
            case SliderLinkType.Brand:
                if (string.IsNullOrEmpty(slider.ReferenceId))
                    return "";
                
                var brand = await brandService.GetBrandById(slider.ReferenceId);
                if (brand == null)
                    return "";
                
                // Slug servisinden marka slug'ını al
                var brandSlug = await slugService.GetActiveSlug(brand.Id, "Brand", language.Id);
                if (string.IsNullOrEmpty(brandSlug))
                    brandSlug = brand.SeName;
                
                return $"{languagePrefix}{brandSlug}";
                
            case SliderLinkType.Collection:
                if (string.IsNullOrEmpty(slider.ReferenceId))
                    return "";
                
                var collection = await collectionService.GetCollectionById(slider.ReferenceId);
                if (collection == null)
                    return "";
                
                // Slug servisinden koleksiyon slug'ını al
                var collectionSlug = await slugService.GetActiveSlug(collection.Id, "Collection", language.Id);
                if (string.IsNullOrEmpty(collectionSlug))
                    collectionSlug = collection.SeName;
                
                return $"{languagePrefix}{collectionSlug}";
                
            case SliderLinkType.Blog:
                if (string.IsNullOrEmpty(slider.ReferenceId))
                    return "";
                
                var blogPost = await blogService.GetBlogPostById(slider.ReferenceId);
                if (blogPost == null)
                    return "";
                
                // Slug servisinden blog yazısı slug'ını al
                var blogSlug = await slugService.GetActiveSlug(blogPost.Id, "BlogPost", language.Id);
                if (string.IsNullOrEmpty(blogSlug))
                    blogSlug = blogPost.SeName;
                
                return $"{languagePrefix}blog/{blogSlug}";
                
            case SliderLinkType.BlogList:
                return $"{languagePrefix}blog";
                
            case SliderLinkType.Search:
                if (string.IsNullOrEmpty(slider.ReferenceParameters))
                    return $"{languagePrefix}search";
                
                try
                {
                    var searchParams = JsonSerializer.Deserialize<Dictionary<string, string>>(slider.ReferenceParameters);
                    if (searchParams == null || !searchParams.Any())
                        return $"{languagePrefix}search";
                    
                    var queryString = string.Join("&", searchParams.Select(kv => $"{kv.Key}={Uri.EscapeDataString(kv.Value)}"));
                    return $"{languagePrefix}search?{queryString}";
                }
                catch
                {
                    return $"{languagePrefix}search";
                }
                
            default:
                return slider.Link;
        }
    }
}