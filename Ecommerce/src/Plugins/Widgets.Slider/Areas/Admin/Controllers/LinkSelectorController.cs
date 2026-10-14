using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Domain.Common;
using Grand.Infrastructure;
using Grand.Web.Common.Controllers;
using Grand.Web.Common.DataSource;
using Grand.Web.Common.Security.Authorization;
using Microsoft.AspNetCore.Mvc;
using Widgets.Slider.Models;
using Widgets.Slider.Services;

namespace Widgets.Slider.Areas.Admin.Controllers;

[PermissionAuthorize(PermissionSystemName.Widgets)]
public class LinkSelectorController : BaseAdminPluginController
{
    private readonly ILinkSelectorService _linkSelectorService;
    private readonly ITranslationService _translationService;
    private readonly IStoreService _storeService;
    private readonly IStoreHelper _storeHelper;
    private readonly ICategoryService _categoryService;

    public LinkSelectorController(
        ILinkSelectorService linkSelectorService,
        ITranslationService translationService,
        IStoreService storeService,
        IStoreHelper storeHelper,
        ICategoryService categoryService)
    {
        _linkSelectorService = linkSelectorService;
        _translationService = translationService;
        _storeService = storeService;
        _storeHelper = storeHelper;
        _categoryService = categoryService;
    }

    [HttpPost]
    public async Task<IActionResult> GetCategories(DataSourceRequest command, string q = "")
    {
        var storeId = (await _storeService.GetAllStores()).FirstOrDefault()?.Id;
        
        var categories = await _linkSelectorService.GetCategories(storeId, command.Page - 1, command.PageSize,q);
        
        var gridModel = new DataSourceResult
        {
            Data = categories.Categories.Select(x => new
            {
                Id = x.Id,
                Name = x.Name,
                Breadcrumb = _categoryService.GetFormattedBreadCrumb(x)
            }),
            Total = categories.TotalCount
        };

        return Json(gridModel);
    }

    [HttpPost]
    public async Task<IActionResult> GetProducts(DataSourceRequest command, string q = "")
    {
        var storeId = (await _storeService.GetAllStores()).FirstOrDefault()?.Id;
        
        var products = await _linkSelectorService.GetProducts(storeId, command.Page - 1, command.PageSize,q);
        
        
        var gridModel = new DataSourceResult
        {
            Data = products.Products.Select(x => new
            {
                Id = x.Id,
                Name = x.Name
            }),
            Total = products.TotalCount
        };

        return Json(gridModel);
    }

    [HttpPost]
    public async Task<IActionResult> GetBrands(DataSourceRequest command, string q = "")
    {
        var storeId = (await _storeService.GetAllStores()).FirstOrDefault()?.Id;
        
        var brands = await _linkSelectorService.GetBrands(storeId, command.Page - 1, command.PageSize,q);
        
        
        var gridModel = new DataSourceResult
        {
            Data = brands.Brands.Select(x => new
            {
                Id = x.Id,
                Name = x.Name
            }),
            Total = brands.TotalCount
        };

        return Json(gridModel);
    }

    [HttpPost]
    public async Task<IActionResult> GetCollections(DataSourceRequest command, string q = "")
    {
        var storeId = (await _storeService.GetAllStores()).FirstOrDefault()?.Id;
        
        var collections = await _linkSelectorService.GetCollections(storeId, command.Page - 1, command.PageSize,q);
        
        var gridModel = new DataSourceResult
        {
            Data = collections.Collections.Select(x => new
            {
                Id = x.Id,
                Name = x.Name
            }),
            Total = collections.Collections.Count
        };

        return Json(gridModel);
    }

    [HttpPost]
    public async Task<IActionResult> GetBlogPosts(DataSourceRequest command, string q = "")
    {
        var storeId = (await _storeService.GetAllStores()).FirstOrDefault()?.Id;
        
        var blogPosts = await _linkSelectorService.GetBlogPosts(storeId, command.Page - 1, command.PageSize,q);
        
        
        
        var gridModel = new DataSourceResult
        {
            Data = blogPosts.BlogPosts.Select(x => new
            {
                Id = x.Id,
                Name = x.Title
            }),
            Total = blogPosts.BlogPosts.Count
        };

        return Json(gridModel);
    }
}