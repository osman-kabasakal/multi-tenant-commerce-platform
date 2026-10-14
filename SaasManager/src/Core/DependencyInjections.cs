using Core.Models.Configs;
using Core.Utilities;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using StackExchange.Redis;

namespace Core;

public static class DependencyInjections
{
    public static void ConfigureServices(this IHostApplicationBuilder applicationBuilder)
    {
        var redisConnectionString = applicationBuilder.Configuration["redispublisher"]!;
        var redis= ConnectionMultiplexer.Connect(redisConnectionString!);
        applicationBuilder.Services.AddSingleton(_ => redis.GetSubscriber());
    }
    
    public static void ConfigureSettings(this IHostApplicationBuilder applicationBuilder)
    {
        applicationBuilder.Services.StartupConfig<CacheConfig>(applicationBuilder.Configuration.GetSection("Cache"));
        applicationBuilder.Services.StartupConfig<GuestAuthConfiguration>(applicationBuilder.Configuration.GetSection("GuestAuth"));

        applicationBuilder.Services.Configure<IyzicoConfiguration>((a) =>
        {
            a.ApiKey = applicationBuilder.Configuration["Dev:Iyzico:ApiKey"]??string.Empty;
            a.SecretKey = applicationBuilder.Configuration["Dev:Iyzico:SecretKey"]??string.Empty;
            a.IsSandbox = true;
        });
    }
}
