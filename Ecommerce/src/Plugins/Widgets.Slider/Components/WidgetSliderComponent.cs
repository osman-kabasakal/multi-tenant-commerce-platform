using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Catalog.Brands;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Catalog.Collections;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Seo;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Infrastructure;
using Grand.Web.Common.Components;
using Microsoft.AspNetCore.Mvc;
using Widgets.Slider.Domain;
using Widgets.Slider.Models;
using Widgets.Slider.Services;

namespace Widgets.Slider.Components;

[ViewComponent(Name = "WidgetSlider")]
public class WidgetSliderComponent : BaseViewComponent
{
    private readonly IPictureService _pictureService;
    private readonly ISliderService _sliderService;
    private readonly IWorkContext _workContext;
    private readonly ICategoryService _categoryService;
    private readonly IProductService _productService;
    private readonly IBrandService _brandService;
    private readonly ICollectionService _collectionService;
    private readonly IBlogService _blogService;
    private readonly ISlugService _slugService;
    private readonly ILanguageService _languageService;
    private readonly IServiceProvider _serviceProvider;

    public WidgetSliderComponent(
        IPictureService pictureService,
        ISliderService sliderService,
        IWorkContext workContext,
        ICategoryService categoryService,
        IProductService productService,
        IBrandService brandService,
        ICollectionService collectionService,
        IBlogService blogService,
        ISlugService slugService,
        ILanguageService languageService,
        IServiceProvider serviceProvider
        )
    {
        _pictureService = pictureService;
        _sliderService = sliderService;
        _workContext = workContext;
        _categoryService = categoryService;
        _productService = productService;
        _brandService = brandService;
        _collectionService = collectionService;
        _blogService = blogService;
        _slugService = slugService;
        _languageService = languageService;
        _serviceProvider = serviceProvider;
    }

    private async Task<string> GetPictureUrl(string pictureId)
    {
        var url = await _pictureService.GetPictureUrl(pictureId, showDefaultPicture: false) ?? "";

        return url;
    }

    private async Task PrepareModel(IList<PictureSlider> sliders, PublicInfoModel model)
    {
        var i = 1;
        foreach (var item in sliders.OrderBy(x => x.DisplayOrder))
        {
            if ((item.StartDateUtc.HasValue && item.StartDateUtc > DateTime.UtcNow) ||
                (item.EndDateUtc.HasValue && item.EndDateUtc < DateTime.UtcNow))
                continue;

            model.Slide.Add(new PublicInfoModel.Slider {
                Link = await item.GetFinalLinkUrl(serviceProvider: _serviceProvider),
                PictureUrl = await GetPictureUrl(item.PictureId),
                Name = item.GetTranslation(x => x.Name, _workContext.WorkingLanguage.Id),
                Description = item.GetTranslation(x => x.Description, _workContext.WorkingLanguage.Id),
                FullWidth = item.FullWidth,
                CssClass = i == 1 ? "active" : ""
            });
            i++;
        }
    }

    public async Task<IViewComponentResult> InvokeAsync(string widgetZone, object additionalData = null)
    {
        var model = new PublicInfoModel();
        if (widgetZone == SliderWidgetDefaults.WidgetZoneHomePage)
        {
            var slides = await _sliderService.GetPictureSliders(SliderType.HomePage);
            await PrepareModel(slides, model);
        }

        if (widgetZone == SliderWidgetDefaults.WidgetZoneCategoryPage)
        {
            var slides = await _sliderService.GetPictureSliders(SliderType.Category, additionalData?.ToString());
            await PrepareModel(slides, model);
        }

        if (widgetZone == SliderWidgetDefaults.WidgetZoneCollectionPage)
        {
            var slides = await _sliderService.GetPictureSliders(SliderType.Collection, additionalData?.ToString());
            await PrepareModel(slides, model);
        }

        if (widgetZone == SliderWidgetDefaults.WidgetZoneBrandPage)
        {
            var slides = await _sliderService.GetPictureSliders(SliderType.Brand, additionalData?.ToString());
            await PrepareModel(slides, model);
        }

        if (!model.Slide.Any())
            return Content("");

        return View(model);
    }
}