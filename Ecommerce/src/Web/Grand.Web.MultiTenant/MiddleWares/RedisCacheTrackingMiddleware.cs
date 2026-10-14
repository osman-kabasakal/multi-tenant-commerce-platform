using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Caching.Redis;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;

namespace Grand.Web.MultiTenant.MiddleWares
{
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
            ICacheBase cacheBase,
            RedisCacheCoordinator cacheCoordinator,
            ILogger<RedisCacheTrackingMiddleware> logger,
            IWorkContext workContext)
        {
            // CurrentCustomerId'yi HttpContext'e ekle
            if (workContext.CurrentCustomer != null)
            {
                context.Items["CurrentCustomerId"] = workContext.CurrentCustomer.Id;
            }
            
            // URL tabanlı ön izlemeler - optimize edilmiş
            if (context.Items.TryGetValue("CorrelationId", out var corId))
            {
                var path = context.Request.Path.Value.TrimStart('/').ToLower();
                
                // Hash set kullanarak daha hızlı bir lookup
                var cachablePathPrefixes = new HashSet<string> { "account/", "shoppingcart/", "wishlist/", "order/" };
                
                bool shouldCache = cachablePathPrefixes.Any(prefix => path.Contains(prefix));
                
                if (shouldCache && workContext.CurrentCustomer != null)
                {
                    var key = string.Format(CacheKey.URLEntity_BY_SLUG_KEY, $"{workContext.CurrentCustomer.Id}.{path}");
                    cacheBase.Get(key, () => true);
                }
            }
            
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
}