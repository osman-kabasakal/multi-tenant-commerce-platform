using Famizyo.Notification.Services;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Infrastructure;
using Grand.Web.Common.Controllers;
using Grand.Web.Common.Filters;
using Microsoft.AspNetCore.Mvc;

namespace Famizyo.Notification.Areas.Admin.Controllers;

public class NotificationController : BaseAdminPluginController
{
    private readonly IOrderNotificationService _orderNotificationService;
    private readonly IWorkContext _workContext;
    private readonly IPermissionService _permissionService;

    public NotificationController(
        IOrderNotificationService orderNotificationService,
        IWorkContext workContext,
        IPermissionService permissionService)
    {
        _orderNotificationService = orderNotificationService;
        _workContext = workContext;
        _permissionService = permissionService;
    }

    /// <summary>
    /// Marks a notification as viewed
    /// </summary>
    [HttpPost]
    [IgnoreAntiforgeryToken]
    public async Task<IActionResult> MarkAsViewed(string notificationId)
    {
        // Check permissions
        if (!await _permissionService.Authorize(PermissionSystemName.Orders))
            return Forbid();

        if (string.IsNullOrEmpty(notificationId))
            return BadRequest("Notification ID is required");

        try
        {
            await _orderNotificationService.MarkAsViewedAsync(notificationId, _workContext.CurrentCustomer.Id);
            return Ok(new { success = true });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { success = false, message = ex.Message });
        }
    }

    /// <summary>
    /// Marks a notification as interacted with
    /// </summary>
    [HttpPost]
    [IgnoreAntiforgeryToken]
    public async Task<IActionResult> MarkAsInteracted(string notificationId)
    {
        // Check permissions
        if (!await _permissionService.Authorize(PermissionSystemName.Orders))
            return Forbid();

        if (string.IsNullOrEmpty(notificationId))
            return BadRequest("Notification ID is required");

        try
        {
            await _orderNotificationService.MarkAsInteractedAsync(notificationId, _workContext.CurrentCustomer.Id);
            return Ok(new { success = true });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { success = false, message = ex.Message });
        }
    }
}