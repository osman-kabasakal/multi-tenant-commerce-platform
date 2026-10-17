using Famizyo.Simpra.BackgroundServices;
using Famizyo.Simpra.Services;
using Famizyo.Simpra.Tasks;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Infrastructure;
using Grand.Web.Common.Menu;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Famizyo.Simpra.Infrastructure;

public class SimpraStartup : IStartupApplication
{
    public int Priority => 100;
    public bool BeforeConfigure => false;

    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        // Register HttpClient for Simpra API calls
        services.AddHttpClient<ISimpraApiService, SimpraApiService>(client =>
        {
            client.Timeout = TimeSpan.FromSeconds(30);
            client.DefaultRequestHeaders.Add("User-Agent", "Famizyo-Simpra-Integration/1.0");
        });

        // Register Simpra services
        services.AddScoped<ISimpraApiService, SimpraApiService>();
        services.AddScoped<ISimpraOrderService, SimpraOrderService>();
        services.AddScoped<IGrandToSimpraSyncService, GrandToSimpraSyncService>();
        services.AddScoped<ISimpraToGrandSyncService, SimpraToGrandSyncService>();
        services.AddScoped<ISimpraProductSyncService, SimpraProductSyncService>();
        
        // Register mapping services
        services.AddScoped<ISimpraMenuItemMappingService, SimpraMenuItemMappingService>();
        services.AddScoped<ISimpraCondimentMappingService, SimpraCondimentMappingService>();

        if (!configuration.GetValue<bool>("Provisioning:ManagedRuntime") && configuration["MultitenantTask:Enabled"] != null
            && !bool.Parse(configuration["MultitenantTask:Enabled"]!.ToString()))
        {
            // Register background services
            services.AddHostedService<SimpraOrderStatusProcessor>();
        }

        if (configuration["MultitenantTask:Enabled"] == null
            || bool.Parse(configuration["MultitenantTask:Enabled"]!.ToString()))
        {
            // Register scheduled tasks
            services.AddScoped<IScheduleTask, SimpraOrderSyncTask>();
            services.AddScoped<IScheduleTask, SimpraProductSyncTask>();
        }
        
        // Register admin menu
        services.AddScoped<IAdminMenuProvider, AdminMenu>();
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        // No specific middleware configuration needed
    }
}