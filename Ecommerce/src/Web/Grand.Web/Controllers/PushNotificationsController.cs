using System.ComponentModel.DataAnnotations;
using Grand.Business.Core.Interfaces.Marketing.PushNotifications;
using Grand.Domain.PushNotifications;
using Grand.Infrastructure;
using Grand.SharedKernel.Attributes;
using Grand.Web.Common.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace Grand.Web.Controllers;

public class PushNotificationsController : BasePublicController
{
    private readonly IPushNotificationsService _pushNotificationsService;
    private readonly IWorkContext _workContext;

    public PushNotificationsController(IWorkContext workContext, IPushNotificationsService pushNotificationsService)
    {
        _workContext = workContext;
        _pushNotificationsService = pushNotificationsService;
    }

    // Authenticated mobile clients use JSON; the existing browser endpoint accepts form fields.
    [IgnoreApi]
    [HttpPost]
    [ActionName(nameof(ProcessRegistration))]
    [Consumes("application/json")]
    public virtual Task<IActionResult> ProcessRegistrationJson([FromBody] PushRegistrationRequest model)
    {
        if (!ModelState.IsValid || model == null || model.Success == null || model.Success.Value && string.IsNullOrWhiteSpace(model.Value))
            return Task.FromResult<IActionResult>(BadRequest("Invalid notification registration."));
        return ProcessRegistration(model.Success.Value, model.Value);
    }

    [IgnoreApi]
    [HttpPost]
    [Consumes("application/x-www-form-urlencoded", "multipart/form-data")]
    public virtual async Task<IActionResult> ProcessRegistration(bool success, string value)
    {
        if (success)
        {
            var toUpdate = await _pushNotificationsService.GetPushReceiverByCustomerId(_workContext.CurrentCustomer.Id);

            if (toUpdate == null)
            {
                await _pushNotificationsService.InsertPushReceiver(new PushRegistration {
                    CustomerId = _workContext.CurrentCustomer.Id,
                    Token = value,
                    RegisteredOn = DateTime.UtcNow,
                    Allowed = true
                });
            }
            else
            {
                toUpdate.Token = value;
                toUpdate.RegisteredOn = DateTime.UtcNow;
                toUpdate.Allowed = true;
                await _pushNotificationsService.UpdatePushReceiver(toUpdate);
            }
        }
        else
        {
            if (value != "Permission denied") return new JsonResult("");
            var toUpdate = await _pushNotificationsService.GetPushReceiverByCustomerId(_workContext.CurrentCustomer.Id);

            if (toUpdate == null)
            {
                await _pushNotificationsService.InsertPushReceiver(new PushRegistration {
                    CustomerId = _workContext.CurrentCustomer.Id,
                    Token = "[DENIED]",
                    RegisteredOn = DateTime.UtcNow,
                    Allowed = false
                });
            }
            else
            {
                toUpdate.Token = "[DENIED]";
                toUpdate.RegisteredOn = DateTime.UtcNow;
                toUpdate.Allowed = false;
                await _pushNotificationsService.UpdatePushReceiver(toUpdate);
            }
        }

        return new JsonResult("");
    }
}
public sealed class PushRegistrationRequest
{
    [Required]
    public bool? Success { get; set; }
    [StringLength(4096)]
    public string Value { get; set; } = "";
}
