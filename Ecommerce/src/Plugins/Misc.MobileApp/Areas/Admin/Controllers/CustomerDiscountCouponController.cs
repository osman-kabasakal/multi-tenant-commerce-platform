using Grand.Business.Core.Interfaces.Catalog.Discounts;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Web.Common.Controllers;
using Microsoft.AspNetCore.Mvc;
using Misc.MobileApp.Domain.Enums;

namespace Misc.MobileApp.Areas.Admin.Controllers;

public class CustomerDiscountCouponController: BaseAdminPluginController
{
    private readonly SendCouponCodeNotificationSettings _sendCouponCodeNotificationSettings;
    private readonly ISettingService _settingService;
    private readonly IDiscountService _discountService;

    public CustomerDiscountCouponController(
        SendCouponCodeNotificationSettings sendCouponCodeNotificationSettings,
        ISettingService settingService,
        IDiscountService discountService
        )
    {
        _sendCouponCodeNotificationSettings = sendCouponCodeNotificationSettings;
        _settingService = settingService;
        _discountService = discountService;
    }

    public async Task<IActionResult> Configure()
    {
        return View(_sendCouponCodeNotificationSettings);
    }
    
    [HttpPost]
    public async Task<IActionResult> Configure(SendCouponCodeNotificationSettings sendCouponCodeNotificationSettings)
    {
        if (ModelState.IsValid)
        {
            var discount = await _discountService.GetDiscountById(sendCouponCodeNotificationSettings.DiscountId);
            if (discount == null)
            {
                Error("İndirim kuponu bulunamadı.");
                return View(sendCouponCodeNotificationSettings);
            }

            if (!discount.RequiresCouponCode)
            {
                Error("İndirim kuponu gerekmiyor.");
                return View(sendCouponCodeNotificationSettings);
            }
            
            await _settingService.SaveSetting(sendCouponCodeNotificationSettings);
            Success("İndirim kupon oluşturma ayaralrınız kaydedildi.");
            return RedirectToAction("Configure");
        }
        
        Error("Alanları kontrol ederek tekrar deneyiniz!",false);
        return View(sendCouponCodeNotificationSettings);
    }
}