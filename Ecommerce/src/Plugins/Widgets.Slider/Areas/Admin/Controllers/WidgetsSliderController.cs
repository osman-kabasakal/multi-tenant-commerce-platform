using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Catalog.Brands;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Catalog.Collections;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Seo;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Infrastructure;
using Grand.Web.Common.Controllers;
using Grand.Web.Common.DataSource;
using Grand.Web.Common.Filters;
using Grand.Web.Common.Security.Authorization;
using Microsoft.AspNetCore.Mvc;
using Widgets.Slider.Domain;
using Widgets.Slider.Models;
using Widgets.Slider.Services;

namespace Widgets.Slider.Areas.Admin.Controllers;

[PermissionAuthorize(PermissionSystemName.Widgets)]
public class WidgetsSliderController : BaseAdminPluginController
{
    private readonly IDateTimeService _dateTimeService;
    private readonly IWorkContext _workContext;
    private readonly ICategoryService _categoryService;
    private readonly IProductService _productService;
    private readonly IBrandService _brandService;
    private readonly ICollectionService _collectionService;
    private readonly IBlogService _blogService;
    private readonly ISlugService _slugService;
    private readonly IServiceProvider _serviceProvider;
    private readonly ILanguageService _languageService;
    private readonly IPictureService _pictureService;
    private readonly ISettingService _settingService;
    private readonly ISliderService _sliderService;
    private readonly SliderWidgetSettings _sliderWidgetSettings;
    private readonly ITranslationService _translationService;

    public WidgetsSliderController(
        IPictureService pictureService,
        ITranslationService translationService,
        ISliderService sliderService,
        ILanguageService languageService,
        ISettingService settingService,
        SliderWidgetSettings sliderWidgetSettings,
        IDateTimeService dateTimeService,
        IWorkContext workContext,
        ICategoryService categoryService,
        IProductService productService,
        IBrandService brandService,
        ICollectionService collectionService,
        IBlogService blogService,
        ISlugService slugService,
        IServiceProvider serviceProvider
        )
    {
        _pictureService = pictureService;
        _translationService = translationService;
        _sliderService = sliderService;
        _languageService = languageService;
        _settingService = settingService;
        _sliderWidgetSettings = sliderWidgetSettings;
        _dateTimeService = dateTimeService;
        _workContext = workContext;
        _categoryService = categoryService;
        _productService = productService;
        _brandService = brandService;
        _collectionService = collectionService;
        _blogService = blogService;
        _slugService = slugService;
        _serviceProvider = serviceProvider;
    }

    public IActionResult Configure()
    {
        var model = new ConfigurationModel {
            DisplayOrder = _sliderWidgetSettings.DisplayOrder,
            CustomerGroups = _sliderWidgetSettings.LimitedToGroups?.ToArray(),
            Stores = _sliderWidgetSettings.LimitedToStores?.ToArray()
        };
        return View(model);
    }

    [HttpPost]
    public IActionResult Configure(ConfigurationModel model)
    {
        _sliderWidgetSettings.DisplayOrder = model.DisplayOrder;
        _sliderWidgetSettings.LimitedToGroups =
            model.CustomerGroups == null ? new List<string>() : model.CustomerGroups.ToList();
        _sliderWidgetSettings.LimitedToStores = model.Stores == null ? new List<string>() : model.Stores.ToList();
        _settingService.SaveSetting(_sliderWidgetSettings);
        return Json("Ok");
    }

    [HttpPost]
    public async Task<IActionResult> List(DataSourceRequest command)
    {
        var sliders = await _sliderService.GetPictureSliders();

        var items = new List<SlideListModel>();
        foreach (var x in sliders)
        {
            var model = x.ToListModel();
            model.Link = await x.GetFinalLinkUrl(_serviceProvider);
            var picture = await _pictureService.GetPictureById(x.PictureId);
            if (picture != null) model.PictureUrl = await _pictureService.GetPictureUrl(picture, 150);
            items.Add(model);
        }

        var gridModel = new DataSourceResult {
            Data = items,
            Total = sliders.Count
        };
        return Json(gridModel);
    }

    public async Task<IActionResult> Create()
    {
        var model = new SlideModel();
        //locales
        await AddLocales(_languageService, model.Locales);

        return View(model);
    }

    [HttpPost]
    [ArgumentNameFilter(KeyName = "save-continue", Argument = "continueEditing")]
    public async Task<IActionResult> Create(SlideModel model, bool continueEditing)
    {
        if (ModelState.IsValid)
        {
            // Process the link data based on LinkType
            ProcessLinkData(model);
            
            var pictureSlider = model.ToEntity(_dateTimeService);
            pictureSlider.Locales = model.Locales.ToLocalizedProperty();

            await _sliderService.InsertPictureSlider(pictureSlider);

            Success(_translationService.GetResource("Widgets.Slider.Added"));
            return continueEditing
                ? RedirectToAction("Edit", new { id = pictureSlider.Id })
                : RedirectToAction("Configure");
        }

        return View(model);
    }
    
    private void ProcessLinkData(SlideModel model)
    {
        // Handle link data based on the selected link type
        switch (model.LinkType)
        {
            case SliderLinkType.Manual:
                // Keep the manually entered link as is
                model.ReferenceId = null;
                model.ReferenceParameters = null;
                break;
                
            case SliderLinkType.Category:
                model.ReferenceId = model.CategoryId;
                model.Link = null;
                model.ReferenceParameters = null;
                break;
                
            case SliderLinkType.Product:
                model.ReferenceId = model.ProductId;
                model.Link = null;
                model.ReferenceParameters = null;
                break;
                
            case SliderLinkType.Brand:
                model.ReferenceId = model.BrandId;
                model.Link = null;
                model.ReferenceParameters = null;
                break;
                
            case SliderLinkType.Collection:
                model.ReferenceId = model.CollectionId;
                model.Link = null;
                model.ReferenceParameters = null;
                break;
                
            case SliderLinkType.Blog:
                model.ReferenceId = model.BlogPostId;
                model.Link = null;
                model.ReferenceParameters = null;
                break;
                
            case SliderLinkType.BlogList:
                model.ReferenceId = null;
                model.Link = null;
                model.ReferenceParameters = null;
                break;
                
            case SliderLinkType.Search:
                model.ReferenceId = null;
                model.Link = null;
                // ReferenceParameters should contain search params in JSON format already
                break;
        }
    }

    public async Task<IActionResult> Edit(string id)
    {
        var slide = await _sliderService.GetById(id);
        if (slide == null)
            return RedirectToAction("Configure");

        var model = slide.ToModel(_dateTimeService);

        // Handle reference fields based on link type
        switch (model.LinkType)
        {
            case SliderLinkType.Category:
                model.CategoryId = slide.ReferenceId;
                break;
                
            case SliderLinkType.Product:
                model.ProductId = slide.ReferenceId;
                break;
                
            case SliderLinkType.Brand:
                model.BrandId = slide.ReferenceId;
                break;
                
            case SliderLinkType.Collection:
                model.CollectionId = slide.ReferenceId;
                break;
                
            case SliderLinkType.Blog:
                model.BlogPostId = slide.ReferenceId;
                break;
                
            case SliderLinkType.Search:
                if (!string.IsNullOrEmpty(slide.ReferenceParameters))
                {
                    try
                    {
                        var searchParams = System.Text.Json.JsonSerializer.Deserialize<Dictionary<string, string>>(slide.ReferenceParameters);
                        if (searchParams != null && searchParams.ContainsKey("q"))
                        {
                            model.SearchTerm = searchParams["q"];
                        }
                    }
                    catch
                    {
                        // Handle JSON parsing error
                    }
                }
                break;
        }

        //locales
        await AddLocales(_languageService, model.Locales, (locale, languageId) =>
        {
            locale.Name = slide.GetTranslation(x => x.Name, languageId, false);
            locale.Description = slide.GetTranslation(x => x.Description, languageId, false);
        });

        return View(model);
    }

    [HttpPost]
    [ArgumentNameFilter(KeyName = "save-continue", Argument = "continueEditing")]
    public async Task<IActionResult> Edit(SlideModel model, bool continueEditing)
    {
        var pictureSlider = await _sliderService.GetById(model.Id);
        if (pictureSlider == null)
            return RedirectToAction("Configure");

        if (ModelState.IsValid)
        {
            // Process the link data based on LinkType
            ProcessLinkData(model);
            
            pictureSlider = model.ToEntity(pictureSlider, _dateTimeService);
            pictureSlider.Locales = model.Locales.ToLocalizedProperty();
            await _sliderService.UpdatePictureSlider(pictureSlider);
            Success(_translationService.GetResource("Widgets.Slider.Edited"));
            return continueEditing
                ? RedirectToAction("Edit", new { id = pictureSlider.Id })
                : RedirectToAction("Configure");
        }

        return View(model);
    }

    public async Task<IActionResult> Delete(string id)
    {
        var pictureSlider = await _sliderService.GetById(id);
        if (pictureSlider == null)
            return Json(new DataSourceResult { Errors = "This pictureSlider not exists" });

        await _sliderService.DeleteSlider(pictureSlider);

        return new JsonResult("");
    }
}