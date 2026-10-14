using Famizyo.Notification.Hubs;
using Grand.Infrastructure.Endpoints;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace Famizyo.Notification;

public class NotificationEndpointProvider: IEndpointProvider
{
    public int Priority => 100000;
    public void RegisterEndpoint(IEndpointRouteBuilder endpointRouteBuilder)
    {
        // Map SignalR hub
        endpointRouteBuilder.MapHub<NotificationHub>("/notificationhub");

        // Map controller endpoints for notification tracking
        endpointRouteBuilder.MapControllerRoute(
            name: "Plugin.Famizyo.Notification.MarkAsViewed",
            pattern: "Admin/Notification/MarkAsViewed",
            defaults: new { controller = "Notification", action = "MarkAsViewed", area = "Admin" }
        );

        endpointRouteBuilder.MapControllerRoute(
            name: "Plugin.Famizyo.Notification.MarkAsInteracted",
            pattern: "Admin/Notification/MarkAsInteracted",
            defaults: new { controller = "Notification", action = "MarkAsInteracted", area = "Admin" }
        );
    }
}