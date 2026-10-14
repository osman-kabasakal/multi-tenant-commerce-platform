using Famizyo.TrendyolIntegration.Models;
using Famizyo.TrendyolIntegration.Services;
using Famizyo.TrendyolIntegration.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Web.Common.Controllers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Famizyo.TrendyolIntegration.Areas.Admin.Controllers;

public class TrendyolIntegrationController(
TrendyolIntegrationSettings trendyolIntegrationSettings,
ISettingService settingService
    ): BaseAdminPluginController
{

    [HttpGet]
    public async Task<IActionResult> Configure()
    {
        var model = new ConfigureViewModel
        {
            SaticiId = trendyolIntegrationSettings.SaticiId,
            ApiKey = trendyolIntegrationSettings.ApiKey,
            ApiSecret = trendyolIntegrationSettings.ApiSecret,
            StoreId = trendyolIntegrationSettings.StoreId,
            BestSellerSectionId = trendyolIntegrationSettings.BestSellerSectionId,
            NewSectionId = trendyolIntegrationSettings.NewSectionId
        };
        
        if(model.SaticiId != null && model.ApiKey != null && model.ApiSecret != null)
        {
            var restaurantClient = new TrendyolRestaurantClient(trendyolIntegrationSettings);
            var restaurantList = await restaurantClient.Process(null);
            var trendyolRestaurant = restaurantList?.restaurants.Select(x => new SelectListItem
            {
                Text = x.name,
                Value = x.id.ToString()
            }).ToList();
           
            model.TrendyolRestaurant = (trendyolRestaurant ?? []);
            model.TrendyolRestaurant.Insert(0,new SelectListItem() {
                Text = "Seçiniz",
                Value = ""
            });

            if (model.StoreId != null)
            {
                var trendyolMenuClient = new TrendyolMenuClient(trendyolIntegrationSettings, model.StoreId.Value);
                var trendyolMenu = await trendyolMenuClient.Process(null);
                var trendyolSections =trendyolMenu?.sections?.Select(x => new SelectListItem
                {
                    Text = x.name,
                    Value = x.id.ToString()
                }).ToList();
                model.TrendyolSections = trendyolSections?? [];
                
                model.TrendyolSections.Insert(0,new SelectListItem() {
                    Text = "Yok",
                    Value = "",
                });
            }
        }

        return View(model);
    }
    
    [HttpPost]
    public async Task<IActionResult> Configure(ConfigureViewModel model)
    {
        if (!ModelState.IsValid)
        {
            return await Task.FromResult<IActionResult>(View(model));
        }
        var setting = new TrendyolIntegrationSettings
        {
            SaticiId = model.SaticiId,
            ApiKey = model.ApiKey,
            ApiSecret = model.ApiSecret,
            StoreId = model.StoreId,
            BestSellerSectionId = model.BestSellerSectionId,
            NewSectionId = model.NewSectionId
        };

        await settingService.SaveSetting(setting);

        return RedirectToAction("Configure");
    }
}