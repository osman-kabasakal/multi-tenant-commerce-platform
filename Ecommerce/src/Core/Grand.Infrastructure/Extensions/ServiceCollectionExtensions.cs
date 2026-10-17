using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Configuration;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;
using System;

namespace Grand.Infrastructure.Extensions
{
    /// <summary>
    /// Service collection extension metotları
    /// </summary>
    public static class ServiceCollectionExtensions
    {
        /// <summary>
        /// Redis tabanlı cache hizmetlerini ekler
        /// </summary>
        public static IServiceCollection AddRedisCache(this IServiceCollection services, IConfiguration configuration)
        {
            var redisConfig = configuration.GetSection("Redis").Get<RedisConfig>() ?? 
                              new RedisConfig { RedisPubSubConnectionString = "localhost:6379,abortConnect=false" };
        
            var redisOptions = ConfigurationOptions.Parse(redisConfig.RedisPubSubConnectionString);
            redisOptions.ConnectTimeout = 15000; // 15 saniye
            redisOptions.SyncTimeout = 15000;
            redisOptions.AbortOnConnectFail = false;
            redisOptions.ConnectRetry = 3;
            redisOptions.ReconnectRetryPolicy = new ExponentialRetry(1000);
        
            var redis = ConnectionMultiplexer.Connect(redisOptions);
        
            // Bağlantı olaylarını dinle
            redis.ConnectionFailed += (sender, e) => {
                // logger.LogError("Redis connection failed: {EndPoint}, {Exception}", e.EndPoint, e.Exception);
            };
        
            redis.ConnectionRestored += (sender, e) => {
                // logger.LogInformation("Redis connection restored: {EndPoint}", e.EndPoint);
            };
            // Redis bağlantısı
            services.AddSingleton<IConnectionMultiplexer>(redis);
            
            // Redis cache koordinatörü
            services.AddSingleton<RedisCacheCoordinator>();
            services.AddSingleton<TenantCacheJournal>();
        services.AddSingleton<ClientCacheSocket>();
            
            // Redis ile izlenen memory cache
            // services.AddScoped<ICacheBase, RedisTrackedMemoryCacheBase>();
            
            return services;
        }
    }
    
    /// <summary>
    /// Redis konfigürasyonu
    /// </summary>
    // public class RedisConfig
    // {
    //     /// <summary>
    //     /// Redis bağlantı bilgisi
    //     /// </summary>
    //     public string ConnectionString { get; set; } = "localhost:6379,abortConnect=false";
    //     
    //     /// <summary>
    //     /// Redis instance adı (client name olarak kullanılır)
    //     /// </summary>
    //     public string InstanceName { get; set; } = "GrandNode";
    //     
    //     /// <summary>
    //     /// Redis pub/sub kanalı
    //     /// </summary>
    //     public string RedisPubSubChannel { get; set; } = "grand:cache:events";
    // }
}