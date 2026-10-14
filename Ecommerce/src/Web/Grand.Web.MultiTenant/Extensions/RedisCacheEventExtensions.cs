using Grand.Infrastructure.Events;
using Grand.Web.MultiTenant.CacheHub;
using MediatR;
using Microsoft.Extensions.DependencyInjection;

namespace Grand.Web.MultiTenant.Extensions
{
    /// <summary>
    /// Redis cache event servisleri için extension metotları
    /// </summary>
    public static class RedisCacheEventExtensions
    {
        /// <summary>
        /// Redis tabanlı cache event handler'ları ekler
        /// </summary>
        public static IServiceCollection AddRedisCacheEventHandlers(this IServiceCollection services)
        {
            // Yeni Redis tabanlı event handler'ı ekle
            // services.AddScoped<INotificationHandler<EntityCacheEvent>, RedisEventNotificationHandler>();
            
            // Eski handler'ı kaldır
            // var descriptorToRemove = ServiceDescriptor.Scoped<INotificationHandler<EntityCacheEvent>, EventNotificationHandler>();
            // services.Remove(descriptorToRemove);
            
            return services;
        }
    }
}