using Grand.Web.Common.Components;
using Microsoft.AspNetCore.Mvc;

namespace Famizyo.Notification.Components;

[ViewComponent(Name = NotificationDefaults.NotificationWidgetName)]
public class FamizyoNotificationWidget: BaseAdminViewComponent
{
    public async Task<IViewComponentResult> InvokeAsync(string widgetZone, object additionalData = null)
    {
        // return View($"~/Plugins/{NotificationDefaults.ProviderSystemName}/Areas/Admin/Views/Shared/Components/FamizyoNotificationWidget/Default.cshtml");
        return View("Default");
    }
}