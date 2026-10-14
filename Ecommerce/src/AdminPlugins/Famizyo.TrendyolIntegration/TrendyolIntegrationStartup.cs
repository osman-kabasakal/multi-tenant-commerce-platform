using Famizyo.TrendyolIntegration.Settings;
using Famizyo.TrendyolIntegration.Tasks;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Infrastructure;
using Grand.Web.Common.Infrastructure;
using Grand.Web.Common.Menu;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Famizyo.TrendyolIntegration;

public class TrendyolIntegrationStartup: IStartupApplication
{
    public int Priority => 10000;
    public bool BeforeConfigure => false;
    
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        services.AddScoped<IScheduleTask, TrendyolRestaurantMenuSyncTask>();
        services.AddScoped<IAdminMenuProvider, AdminMenu>();
    }
    
    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        
    }
}