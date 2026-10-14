using Famizyo.Integration.Adisyo.Services;
using Famizyo.Integration.Adisyo.Tasks;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Infrastructure;
using Grand.Web.Common.Menu;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Famizyo.Integration.Adisyo;

public class AdisyoIntegrationStartup : IStartupApplication
{
    public int Priority => 100;
    public bool BeforeConfigure => false;

    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        // Register HttpClient for Adisyo API calls
        services.AddHttpClient<IAdisyoApiService, AdisyoApiService>(client =>
        {
            client.Timeout = TimeSpan.FromSeconds(30);
            client.DefaultRequestHeaders.Add("User-Agent", "GrandNode-Adisyo-Integration/1.0");
        });

        // Register Adisyo services
        services.AddScoped<IAdisyoApiService, AdisyoApiService>();
        services.AddScoped<IAdisyoOrderService, AdisyoOrderService>();
        services.AddScoped<IAdisyoOrderMappingService, AdisyoOrderMappingService>();
        services.AddScoped<IAdisyoProductSyncService, AdisyoProductSyncService>();
        
        //AdminMenu
        services.AddScoped<IAdminMenuProvider, AdminMenu>();
        
        //Register Tasks
        services.AddScoped<IScheduleTask, AdisyoOrderSyncTask>();
        services.AddScoped<IScheduleTask, AdisyoProductSyncTask>();
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        // No specific configuration needed for middleware
    }
}