using Grand.Business.Core.Interfaces.Cms;
using Grand.Infrastructure;
using Grand.Infrastructure.Endpoints;
using Grand.Web.Common.Menu;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Widgets.Slider.Infrastructure;
using Widgets.Slider.Services;

namespace Widgets.Slider;

public class StartupApplication : IStartupApplication
{
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        services.AddScoped<IWidgetProvider, SliderWidgetProvider>();
        services.AddScoped<ISliderService, SliderService>();
        services.AddScoped<ILinkSelectorService, LinkSelectorService>();
        services.AddScoped<IAdminMenuProvider, AdminMenuProvider>();
        services.AddScoped<IEndpointProvider, EndpointProvider>();
    }

    public int Priority => 10;

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
    }

    public bool BeforeConfigure => false;
}