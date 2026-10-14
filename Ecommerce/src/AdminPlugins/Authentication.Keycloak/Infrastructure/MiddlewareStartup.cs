using Authentication.Keycloak.Middlewares;
using Grand.Infrastructure;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Authentication.Keycloak.Infrastructure;

public class MiddlewareStartup: IStartupApplication
{
    public int Priority => 501;
    public bool BeforeConfigure => false;
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        application.UseMiddleware<BackchannelLogoutCheckMiddleware>();
    }
}