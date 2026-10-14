using Grand.Business.Marketing.Services.PushNotifications;
using Microsoft.Extensions.DependencyInjection;

namespace Grand.Business.Marketing.Extensions
{
    /// <summary>
    /// FCM hizmetleri için extension metotları
    /// </summary>
    /// disabled
    public static class FCMServiceExtensions
    {
        /// <summary>
        /// Redis tabanlı FCM bildirim hizmetlerini ekler
        /// </summary>
        public static IServiceCollection AddRedisFCMServices(this IServiceCollection services)
        {
            // Redis FCM background service
            services.AddHostedService<RedisFCMNotificationService>();
            
            return services;
        }
    }
}