using Grand.Web.MultiTenant.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Grand.Web.MultiTenant.MiddleWares;

public class PublicPathMiddleware
{
    private readonly RequestDelegate _next;
    public PublicPathMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context,
        ILogger<PublicPathMiddleware> logger,
        PublicRouteService publicRouteService
    )
    {
        var path = context.Request.Path.Value?.TrimStart('/').TrimEnd('/').Trim().ToLowerInvariant();
        if(path != null && publicRouteService.IsPublicPath(path))
        {
            var content = await publicRouteService.GetPublicContent(path);
            if (!string.IsNullOrEmpty(content))
            {
                context.Response.ContentType = "text/html";
                await context.Response.WriteAsync(content);
                return;
            }
        }
        
        await _next(context);
    }
}