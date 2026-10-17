using Famizyo.Notification.BackgroundServices;
using Famizyo.Notification.Models;
using Famizyo.Notification.Services;
using Famizyo.Notification.Tasks;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Infrastructure;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace Famizyo.Notification;

public class NotificationStartup: IStartupApplication
{
    public int Priority => 10000;
    public bool BeforeConfigure => false;
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        // Register notification service
        services.AddScoped<IOrderNotificationService, OrderNotificationService>();

        if (!configuration.GetValue<bool>("Provisioning:ManagedRuntime") && configuration["MultitenantTask:Enabled"] != null
            && !bool.Parse(configuration["MultitenantTask:Enabled"]!.ToString()))
        {
            // Register background service
            services.AddSingleton<IHostedService, NewOrderBackgroundService>();
        }
        
        // Register widget provider
        services.AddScoped<IWidgetProvider, NotificationWidgetProvider>();
        
        // Register scheduled tasks
        services.AddScoped<IScheduleTask, ResendUnseenNotificationsTask>();
        
        // Add SignalR
        services.AddSignalR();
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        // No hub mapping needed here as we use endpoint provider
    }
}