using Grand.Infrastructure;
using Grand.Web.Common.Menu;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using Widgets.LegalTexts.Services;

namespace Widgets.LegalTexts;

public class LegalTextsStartup : IStartupApplication
{
    public int Priority => 0;

    public bool BeforeConfigure => false;

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
    }

    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        services.AddScoped<ILegalTextMessageTemplateService,LegalTextMessageTemplateService>();
        services.AddScoped<IAdminMenuProvider, AdminMenuProvider>();
    }
}
