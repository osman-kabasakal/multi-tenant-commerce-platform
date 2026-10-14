using Grand.Business.Authentication.Services;
using Grand.Business.Core.Interfaces.Authentication;
using Grand.Infrastructure;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Grand.Business.Authentication.Startup;

public class TenantAuthenticationStartup : IStartupApplication
{
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        // Replace the default RefreshTokenService with the tenant-specific one
        var refreshTokenService = services.FirstOrDefault(
            sd => sd.ServiceType == typeof(IRefreshTokenService) &&
                  sd.ImplementationType == typeof(RefreshTokenService));
        
        if (refreshTokenService != null)
        {
            services.Remove(refreshTokenService);
        }
        
        services.AddScoped<IRefreshTokenService, TenantRefreshTokenService>();
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
    }

    public int Priority => 101; // Higher priority than StartupApplication
    public bool BeforeConfigure => false;
}