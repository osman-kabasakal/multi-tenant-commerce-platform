using Grand.Infrastructure;
using Grand.Web.Common.View;
using Grand.Web.OnlyAdmin.ViewFactories;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Razor;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using NPOI.SS.Formula.Functions;

namespace Grand.Web.OnlyAdmin.Startups;

public class ViewFactoriesStartup: IStartupApplication
{
    public int Priority => 10;
    public bool BeforeConfigure => false;
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        services.AddScoped<IAreaViewFactory, PdfViewFactory>();
        services.Configure<RazorViewEngineOptions>(options =>
        {
            options.ViewLocationFormats.Add("/Views/{1}/{0}.cshtml");
            options.ViewLocationExpanders.Add(new PdfViewFactory());
        });
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        
    }
}