using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Interfaces.Marketing.PushNotifications;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Domain.PushNotifications;
using Grand.Infrastructure;
using Platform.Notifications;
using Grand.Web.Admin.Models.PushNotifications;
using Grand.Web.Common.DataSource;
using Grand.Web.Common.Security.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Grand.Web.Admin.Controllers;

[PermissionAuthorize(PermissionSystemName.PushNotifications)]
public class PushNotificationsController(
    PushNotificationsSettings pushNotificationsSettings,
    NotificationOptions notificationOptions,
    ITranslationService translationService,
    ISettingService settingService,
    IPushNotificationsService pushNotificationsService,
    ICustomerService customerService,
    IPictureService pictureService,
    IStoreService storeService,
    IWorkContext workContext,
    IDateTimeService dateTimeService)
    : BaseAdminController
{
    public async Task<IActionResult> Send()
    {
        var store = await storeService.GetStoreById(workContext.CurrentStore.Id);
        var model = new PushModel {
            MessageText = translationService.GetResource("Admin.PushNotifications.MessageTextPlaceholder"),
            Title = translationService.GetResource("Admin.PushNotifications.MessageTitlePlaceholder"),
            PictureId = pushNotificationsSettings.PictureId,
            ClickUrl = Grand.Web.Admin.Infrastructure.StorePushLinks.Default(store.Url, store.Domains.Select(x => x.Url), pushNotificationsSettings.ClickUrl, notificationOptions.Provider == "LocalSink")
        };

        return View(model);
    }

    [PermissionAuthorizeAction(PermissionActionName.Create)]
    [HttpPost]
    public async Task<IActionResult> Send(PushModel model)
    {
        if (notificationOptions.Provider != "Disabled" && !string.IsNullOrWhiteSpace(model.MessageText))
        {
            var targetStore = await storeService.GetStoreById(workContext.CurrentStore.Id);
            if (string.IsNullOrWhiteSpace(model.ClickUrl)) model.ClickUrl = targetStore.Url;
            if (!Uri.TryCreate(model.ClickUrl, UriKind.Absolute, out var link) || (link.Scheme != "https" && !(notificationOptions.Provider == "LocalSink" && link.Scheme == "http")) || !string.IsNullOrEmpty(link.UserInfo) ||
                !Uri.TryCreate(targetStore.Url, UriKind.Absolute, out var activeOrigin) || !activeOrigin.Authority.Equals(link.Authority, StringComparison.OrdinalIgnoreCase))
            {
                Error("Bildirim bağlantısı işletmenizin aktif mağaza alan adında olmalıdır.");
                return RedirectToAction("Send");
            }
            pushNotificationsSettings.PictureId = model.PictureId;
            pushNotificationsSettings.ClickUrl = model.ClickUrl;
            await settingService.SaveSetting(pushNotificationsSettings);
            
            var store = await storeService.GetStoreById(workContext.CurrentStore.Id);
            var storeDomain = store.Domains.FirstOrDefault(x => x.Primary);
            string pictureUrl = null;
            if (!string.IsNullOrEmpty(model.PictureId))
            {
                var picture = await pictureService.GetPictureUrl(model.PictureId);
                if (Uri.TryCreate(picture, UriKind.Absolute, out var absolute)) pictureUrl = absolute.AbsoluteUri;
                else if (Uri.TryCreate(storeDomain?.Url, UriKind.Absolute, out var origin)) pictureUrl = new Uri(origin, picture).AbsoluteUri;
            }
            var result =
                await pushNotificationsService.SendPushNotification(model.Title, model.MessageText, pictureUrl,
                    model.ClickUrl);
            if (result.Item1)
                Success(translationService.GetResource(result.Item2));
            else
                Error(translationService.GetResource(result.Item2));
        }
        else
        {
            Error(translationService.GetResource(notificationOptions.Provider == "Disabled"
                ? "Admin.PushNotifications.Error.Disabled" : "Admin.PushNotifications.Error.MessageRequired"));
        }

        return RedirectToAction("Send");
    }

    [PermissionAuthorizeAction(PermissionActionName.List)]
    public async Task<IActionResult> Messages()
    {
        var model = new MessagesModel {
            Allowed = await pushNotificationsService.GetAllowedReceivers(),
            Denied = await pushNotificationsService.GetDeniedReceivers()
        };

        return View(model);
    }

    [PermissionAuthorizeAction(PermissionActionName.List)]
    public async Task<IActionResult> Receivers()
    {
        var model = new ReceiversModel {
            Allowed = await pushNotificationsService.GetAllowedReceivers(),
            Denied = await pushNotificationsService.GetDeniedReceivers()
        };

        return View(model);
    }

    [PermissionAuthorizeAction(PermissionActionName.List)]
    [HttpPost]
    public async Task<IActionResult> PushMessagesList(DataSourceRequest command)
    {
        var messages = await pushNotificationsService.GetPushMessages(command.Page - 1, command.PageSize);
        var gridModel = new DataSourceResult {
            Data = messages.Select(x => new PushMessageGridModel {
                Id = x.Id,
                Text = x.Text,
                Title = x.Title,
                SentOn = dateTimeService.ConvertToUserTime(x.SentOn, DateTimeKind.Utc),
                NumberOfReceivers = x.NumberOfReceivers
            }),
            Total = messages.TotalCount
        };

        return Json(gridModel);
    }

    [PermissionAuthorizeAction(PermissionActionName.List)]
    [HttpPost]
    public async Task<IActionResult> PushReceiversList(DataSourceRequest command)
    {
        var receivers = await pushNotificationsService.GetPushReceivers(command.Page - 1, command.PageSize);
        var gridModel = new DataSourceResult();
        var list = new List<PushRegistrationGridModel>();
        foreach (var receiver in receivers)
        {
            var gridReceiver = new PushRegistrationGridModel();

            var customer = await customerService.GetCustomerById(receiver.CustomerId);
            if (customer == null)
            {
                await pushNotificationsService.DeletePushReceiver(receiver);
                continue;
            }

            gridReceiver.CustomerEmail = !string.IsNullOrEmpty(customer.Email)
                ? customer.Email
                : translationService.GetResource("Admin.Customers.Guest");

            gridReceiver.CustomerId = receiver.CustomerId;
            gridReceiver.Id = receiver.Id;
            gridReceiver.RegisteredOn = dateTimeService.ConvertToUserTime(receiver.RegisteredOn, DateTimeKind.Utc);
            gridReceiver.Token = receiver.Token;
            gridReceiver.Allowed = receiver.Allowed;

            list.Add(gridReceiver);
        }

        gridModel.Data = list;
        gridModel.Total = receivers.TotalCount;

        return Json(gridModel);
    }

    [PermissionAuthorizeAction(PermissionActionName.Delete)]
    [HttpPost]
    public async Task<IActionResult> DeleteReceiver(string id)
    {
        var receiver = await pushNotificationsService.GetPushReceiver(id);
        await pushNotificationsService.DeletePushReceiver(receiver);
        return new JsonResult("");
    }
}