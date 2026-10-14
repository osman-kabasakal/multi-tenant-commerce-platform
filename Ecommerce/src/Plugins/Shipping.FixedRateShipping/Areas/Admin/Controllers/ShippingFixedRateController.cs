using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Web.Common.Controllers;
using Grand.Web.Common.DataSource;
using Grand.Web.Common.Filters;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Shipping.FixedRateShipping.Models;
using Shipping.FixedRateShipping.Services;
using System;

namespace Shipping.FixedRateShipping.Areas.Admin.Controllers;

[Area("Admin")]
[AuthorizeAdmin]
public class ShippingFixedRateController : BaseShippingController
{
    private readonly IPermissionService _permissionService;
    private readonly ISettingService _settingService;
    private readonly IShippingMethodService _shippingMethodService;
    private readonly IDeliveryAreaService _deliveryAreaService;
    private readonly ShippingFixedRateSettings _shippingFixedRateSettings;

    public ShippingFixedRateController(
        IShippingMethodService shippingMethodService,
        ISettingService settingService,
        IPermissionService permissionService,
        IDeliveryAreaService deliveryAreaService,
        ShippingFixedRateSettings shippingFixedRateSettings)
    {
        _shippingMethodService = shippingMethodService;
        _settingService = settingService;
        _permissionService = permissionService;
        _deliveryAreaService = deliveryAreaService;
        _shippingFixedRateSettings = shippingFixedRateSettings;
    }

    public IActionResult Configure()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Configure(DataSourceRequest command)
    {
        if (!await _permissionService.Authorize(StandardPermission.ManageShippingSettings))
            return Content("Access denied");

        var rateModels = new List<FixedShippingRateModel>();
        foreach (var shippingMethod in await _shippingMethodService.GetAllShippingMethods())
            rateModels.Add(new FixedShippingRateModel {
                ShippingMethodId = shippingMethod.Id,
                ShippingMethodName = shippingMethod.Name,
                Rate = GetShippingRate(shippingMethod.Id)
            });

        var gridModel = new DataSourceResult {
            Data = rateModels,
            Total = rateModels.Count
        };
        return Json(gridModel);
    }

    [HttpPost]
    [AutoValidateAntiforgeryToken]
    public async Task<IActionResult> ShippingRateUpdate(FixedShippingRateModel model)
    {
        if (!await _permissionService.Authorize(StandardPermission.ManageShippingSettings))
            return Content("Access denied");

        var shippingMethodId = model.ShippingMethodId;
        var rate = new FixedShippingRate {
            Rate = model.Rate
        };

        await _settingService.SetSetting(
            $"ShippingRateComputationMethod.FixedRate.Rate.ShippingMethodId{shippingMethodId}", rate);

        return new JsonResult("");
    }
    
    #region Delivery Areas

    public IActionResult DeliveryAreas()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> DeliveryAreasList(DataSourceRequest command)
    {
        if (!await _permissionService.Authorize(StandardPermission.ManageShippingSettings))
            return Content("Access denied");

        var deliveryAreaModels = new List<DeliveryAreaModel>();
        foreach (var shippingMethod in await _shippingMethodService.GetAllShippingMethods())
        {
            var deliveryAreas = await _deliveryAreaService.GetDeliveryAreas(shippingMethod.Id);
            foreach (var deliveryArea in deliveryAreas)
            {
                deliveryAreaModels.Add(new DeliveryAreaModel {
                    Id = deliveryArea.Id,
                    Name = deliveryArea.Name,
                    GeoJsonData = deliveryArea.GeoJsonData,
                    ShippingRate = deliveryArea.ShippingRate,
                    MinimumOrderAmount = deliveryArea.MinimumOrderAmount,
                    UseFreeShipping = deliveryArea.UseFreeShipping,
                    FreeShippingOrderAmount = deliveryArea.FreeShippingOrderAmount,
                    ShippingMethodId = shippingMethod.Id,
                    ShippingMethodName = shippingMethod.Name
                });
            }
        }

        var gridModel = new DataSourceResult {
            Data = deliveryAreaModels,
            Total = deliveryAreaModels.Count
        };
        return Json(gridModel);
    }

    public async Task<IActionResult> CreateDeliveryArea()
    {
        if (!await _permissionService.Authorize(StandardPermission.ManageShippingSettings))
            return AccessDeniedView();

        var model = new DeliveryAreaModel();
        
        // Populate shipping methods dropdown
        var shippingMethods = await _shippingMethodService.GetAllShippingMethods();
        if (shippingMethods.Any())
        {
            model.ShippingMethodId = shippingMethods.First().Id;
            model.ShippingMethodName = shippingMethods.First().Name;
            
            // Create SelectList for the view
            ViewBag.ShippingMethods = new Microsoft.AspNetCore.Mvc.Rendering.SelectList(
                shippingMethods, "Id", "Name", model.ShippingMethodId);
        }
        else
        {
            ViewBag.ShippingMethods = new Microsoft.AspNetCore.Mvc.Rendering.SelectList(
                new List<SelectListItem>());
        }
        
        return View(model);
    }

    [HttpPost]
    [AutoValidateAntiforgeryToken]
    public async Task<IActionResult> CreateDeliveryArea(DeliveryAreaModel model)
    {
        if (!await _permissionService.Authorize(StandardPermission.ManageShippingSettings))
            return AccessDeniedView();

        if (ModelState.IsValid)
        {
            var deliveryArea = new DeliveryArea
            {
                Id = Guid.NewGuid().ToString(),
                Name = model.Name,
                GeoJsonData = model.GeoJsonData,
                ShippingRate = model.ShippingRate,
                MinimumOrderAmount = model.MinimumOrderAmount,
                UseFreeShipping = model.UseFreeShipping,
                FreeShippingOrderAmount = model.FreeShippingOrderAmount
            };

            await _deliveryAreaService.SaveDeliveryArea(model.ShippingMethodId, deliveryArea);

            ViewBag.RefreshPage = true;
            return View(model);
        }

        return View(model);
    }

    public async Task<IActionResult> EditDeliveryArea(string id, string shippingMethodId)
    {
        if (!await _permissionService.Authorize(StandardPermission.ManageShippingSettings))
            return AccessDeniedView();

        var deliveryAreas = await _deliveryAreaService.GetDeliveryAreas(shippingMethodId);
        var deliveryArea = deliveryAreas.FirstOrDefault(x => x.Id == id);
        if (deliveryArea == null)
            return RedirectToAction("DeliveryAreas");

        var model = new DeliveryAreaModel
        {
            Id = deliveryArea.Id,
            Name = deliveryArea.Name,
            GeoJsonData = deliveryArea.GeoJsonData,
            ShippingRate = deliveryArea.ShippingRate,
            MinimumOrderAmount = deliveryArea.MinimumOrderAmount,
            UseFreeShipping = deliveryArea.UseFreeShipping,
            FreeShippingOrderAmount = deliveryArea.FreeShippingOrderAmount,
            ShippingMethodId = shippingMethodId,
            ShippingMethodName = (await _shippingMethodService.GetShippingMethodById(shippingMethodId))?.Name
        };

        return View(model);
    }

    [HttpPost]
    [AutoValidateAntiforgeryToken]
    public async Task<IActionResult> EditDeliveryArea(DeliveryAreaModel model)
    {
        if (!await _permissionService.Authorize(StandardPermission.ManageShippingSettings))
            return AccessDeniedView();

        if (ModelState.IsValid)
        {
            var deliveryArea = new DeliveryArea
            {
                Id = model.Id,
                Name = model.Name,
                GeoJsonData = model.GeoJsonData,
                ShippingRate = model.ShippingRate,
                MinimumOrderAmount = model.MinimumOrderAmount,
                UseFreeShipping = model.UseFreeShipping,
                FreeShippingOrderAmount = model.FreeShippingOrderAmount
            };

            await _deliveryAreaService.SaveDeliveryArea(model.ShippingMethodId, deliveryArea);

            ViewBag.RefreshPage = true;
            return View(model);
        }

        return View(model);
    }

    [HttpPost]
    [AutoValidateAntiforgeryToken]
    public async Task<IActionResult> DeleteDeliveryArea(string id)
    {
        if (!await _permissionService.Authorize(StandardPermission.ManageShippingSettings))
            return AccessDeniedView();

        await _deliveryAreaService.DeleteDeliveryArea( id);

        return RedirectToAction("DeliveryAreas");
    }

    #endregion

    [NonAction]
    private double GetShippingRate(string shippingMethodId)
    {
        var rate = _settingService.GetSettingByKey<FixedShippingRate>(
            $"ShippingRateComputationMethod.FixedRate.Rate.ShippingMethodId{shippingMethodId}")?.Rate;
        return rate ?? 0;
    }
}