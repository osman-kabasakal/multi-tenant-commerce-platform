using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Caching.Redis;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace Grand.Web.OnlyAdmin.Middlewares;

/// <summary>
/// Redis tabanlı cache izleme middleware'i
/// </summary>
public class RedisCacheTrackingMiddleware
{
    private readonly RequestDelegate _next;

    public RedisCacheTrackingMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(
        HttpContext context,
        RedisCacheCoordinator cacheCoordinator,
        ILogger<RedisCacheTrackingMiddleware> logger)
    {
        // İstek tamamlandığında biriken cache invalidation eventlerini işle
        context.Response.OnCompleted(async () =>
        {
            try
            {
                await cacheCoordinator.ProcessRequestEventsAsync();
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error processing cache events on request completion");
            }
        });

        await _next(context);
    }
}