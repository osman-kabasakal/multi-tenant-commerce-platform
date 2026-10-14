using Grand.Business.Core.Interfaces.Authentication;
using Grand.Infrastructure;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.MultiTenant;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Grand.Api.Infrastructure;

public class TenantApiStartup : IStartupApplication
{
    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
    }

    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        var config = new TenantBackendAPIConfig();
        configuration.GetSection("BackendAPI").Bind(config);

        services.AddSingleton(config);

        var frontendConfig = new TenantFrontendAPIConfig();
        configuration.GetSection("FrontendAPI").Bind(frontendConfig);

        services.AddSingleton(frontendConfig);

        // Register tenant-specific services
        services.AddSingleton<ITenantSecretService, TenantSecretService>();
        
        // Replace existing registrar with tenant-specific one
        var authRegistrar = services.FirstOrDefault(
            sd => sd.ServiceType == typeof(IAuthenticationBuilder) &&
                  sd.ImplementationType == typeof(ApiAuthenticationRegistrar));
        
        if (authRegistrar != null)
        {
            services.Remove(authRegistrar);
        }
        
        services.AddScoped<IAuthenticationBuilder, TenantApiAuthenticationRegistrar>();
    }

    public int Priority => 100;

    public bool BeforeConfigure => false;
}