using Grand.Infrastructure;
using Grand.Infrastructure.Endpoints;
using Grand.Web.Common.Menu;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Misc.MobileApp.Domain.Enums;
using Misc.MobileApp.Services;

namespace Misc.MobileApp;

public class MobileAppStartup: IStartupApplication
{
    public int Priority => 0;
    public bool BeforeConfigure => false;
    
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        services.AddScoped<IAdminMenuProvider, AdminMenuProvider>();
        services.AddScoped<ISmsProviderFactory, SmsProviderFactory>();
        services.AddKeyedScoped<ISmsProvider, TwilioSmsProvider>(SmsProviders.Twilio);
        services.AddKeyedScoped<ISmsProvider, NetGsmSmsProvider>(SmsProviders.NetGsm);
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        
    }
}