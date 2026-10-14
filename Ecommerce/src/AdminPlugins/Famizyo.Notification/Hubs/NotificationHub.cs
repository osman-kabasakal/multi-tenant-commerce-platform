using Famizyo.Notification.Services;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Infrastructure;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Famizyo.Notification.Hubs;

public class NotificationHub: Hub
{
    // private readonly IPermissionService _permissionService;
    // private readonly IWorkContextSetter _workContextSetter;
    // private readonly IOrderNotificationService _orderNotificationService;

    public NotificationHub(
        
        )
    {
        // _permissionService = permissionService;
        // _workContextSetter = workContextSetter;
        // _orderNotificationService = orderNotificationService;
    }
    
    public override async Task OnConnectedAsync()
    {
        var httpContext = Context.GetHttpContext();
        if (httpContext == null || Context.User==null)
        {
            // Reject connection if no HttpContext or User is available
            Context.Abort();
            return;
        }

        // Verify authentication is complete by checking for tenant information
        if (!httpContext.Items.TryGetValue("StoreId", out var storeId) || storeId == null)
        {
            // Authentication is incomplete - either user isn't authenticated properly
            // or tenant information hasn't been set in the middleware pipeline
            Context.Abort();
            return;
        }

        try
        {
            // Get required services
            IPermissionService _permissionService = httpContext.RequestServices.GetRequiredService<IPermissionService>();
            IWorkContextSetter _workContextSetter = httpContext.RequestServices.GetRequiredService<IWorkContextSetter>();
            IOrderNotificationService _orderNotificationService = httpContext.RequestServices.GetRequiredService<IOrderNotificationService>();

            // Set current customer and verify permissions
            var customer = await _workContextSetter.SetCurrentCustomer();
            if (customer == null || !await _permissionService.Authorize(PermissionSystemName.Orders, customer))
            {
                // User doesn't have proper permissions - reject connection
                Context.Abort();
                return;
            }

            // Add user to the appropriate notification group
            var groupName = string.Format(NotificationDefaults.NotificationGroupFormat, storeId,
                NotificationDefaults.NotificationNewOrderGroupName);
            await Groups.AddToGroupAsync(Context.ConnectionId, groupName);

            // When user connects, send them all unread/non-interacted notifications
            var notificationsToResend = await _orderNotificationService.GetNotificationsToResendAsync(storeId.ToString());
            foreach (var notification in notificationsToResend)
            {
                await Clients.Caller.SendAsync(NotificationDefaults.NotificationClientNewOrderMethodName,
                    notification.OrderId, notification.Id);

                // Update the send count
                await _orderNotificationService.IncrementSendCountAsync(notification.Id);
            }

            await base.OnConnectedAsync();
        }
        catch (Exception ex)
        {
            // Log any errors and abort the connection
            var logger = httpContext.RequestServices.GetService<ILogger<NotificationHub>>();
            logger?.LogError(ex, "Error establishing SignalR connection");
            Context.Abort();
        }
    }
    
    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        var httpContext = Context.GetHttpContext();
        if (httpContext == null || Context.User==null)
        {
            return;
        }

        try
        {
            // Only attempt to remove from groups if StoreId is available
            if (httpContext.Items.TryGetValue("StoreId", out var storeId) && storeId != null)
            {
                IPermissionService _permissionService = httpContext.RequestServices.GetRequiredService<IPermissionService>();
                IWorkContextSetter _workContextSetter = httpContext.RequestServices.GetRequiredService<IWorkContextSetter>();

                var customer = await _workContextSetter.SetCurrentCustomer();
                if (customer != null)
                {
                    var groupName = string.Format(NotificationDefaults.NotificationGroupFormat, storeId,
                        NotificationDefaults.NotificationNewOrderGroupName);
                    await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupName);
                }
            }
        }
        catch (Exception ex)
        {
            // Log any errors but don't re-throw since we're disconnecting anyway
            var logger = httpContext.RequestServices.GetService<ILogger<NotificationHub>>();
            logger?.LogError(ex, "Error during SignalR disconnection");
        }

        await base.OnDisconnectedAsync(exception);
    }
    
    // Block all client-to-server method calls
    [HubMethodName("*")]
    public ValueTask<object> InvokeMethodAsync(HubInvocationContext invocationContext, Func<HubInvocationContext, ValueTask<object>> next)
    {
        // Block all client-to-server method calls
        throw new HubException("Direct hub method invocation is not allowed.");
    }
}