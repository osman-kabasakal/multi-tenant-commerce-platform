using Authentication.Keycloak.Middlewares;
using Grand.Infrastructure;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Authentication.Keycloak.Infrastructure;

public class StoreMiddlewareStartup : IStartupApplication
{
    public int Priority => -500;
    public bool BeforeConfigure => false;
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {

    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        application.UseMiddleware<KeycloakGroupMiddleware>();

        application.Use((context, next) =>
        {
            if (context.Response.StatusCode == 200 &&
            context.Request.Path.Value != null &&
             (
             context.Request.Path.Value == "/" ||
             context.Request.Path.Value!.StartsWith("/admin/login", StringComparison.InvariantCultureIgnoreCase)
             )
             )
            {
                context.Response.Redirect(context.Request.PathBase + "/Admin");
                return Task.CompletedTask;
            }
            return next();
        });
    }
}