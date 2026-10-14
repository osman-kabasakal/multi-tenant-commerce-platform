using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Events;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;

namespace Grand.Web.MultiTenant.CacheHub
{
    /// <summary>
    /// Redis tabanlı cache invalidation event handler
    /// </summary>
    public class RedisEventNotificationHandler : INotificationHandler<EntityCacheEvent>
    {
        private readonly RedisCacheCoordinator _cacheCoordinator;
        private readonly ILogger<RedisEventNotificationHandler> _logger;
        
        public RedisEventNotificationHandler(
            RedisCacheCoordinator cacheCoordinator,
            ILogger<RedisEventNotificationHandler> logger)
        {
            _cacheCoordinator = cacheCoordinator;
            _logger = logger;
        }
        
        public Task Handle(EntityCacheEvent notification, CancellationToken cancellationToken)
        {
            try
            {
                // Cache invalidation event'ini Redis koordinatörüne ekle
                // Bu, istek bazlı veya global olarak gruplandırılıp Redis'e yayınlanacak
                // _cacheCoordinator.AddCacheInvalidation(notification.Entity, notification.Event);
                //
                // _logger.LogDebug(
                //     "Added cache invalidation for {Entity} with event {Event}",
                //     notification.Entity, notification.Event);
                    
                return Task.CompletedTask;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error handling cache event {Event} for entity {Entity}",
                    notification.Event, notification.Entity);
                return Task.CompletedTask;
            }
        }
    }
}