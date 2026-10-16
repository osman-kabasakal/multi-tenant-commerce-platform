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

        var paymentProvider = applicationBuilder.Configuration["Payments:Provider"];
        if (paymentProvider is not (null or "Disabled" or "Iyzico"))
            throw new InvalidOperationException("Choose Disabled or Iyzico payment configuration.");
        applicationBuilder.Services.Configure<IyzicoConfiguration>(a =>
        {
            var enabled = paymentProvider == "Iyzico";
            var legacyDevelopment = paymentProvider == null && applicationBuilder.Environment.IsDevelopment();
            a.ApiKey = (enabled ? applicationBuilder.Configuration["Payments:Iyzico:ApiKey"] :
                legacyDevelopment ? applicationBuilder.Configuration["Dev:Iyzico:ApiKey"] : null) ?? string.Empty;
            a.SecretKey = (enabled ? applicationBuilder.Configuration["Payments:Iyzico:SecretKey"] :
                legacyDevelopment ? applicationBuilder.Configuration["Dev:Iyzico:SecretKey"] : null) ?? string.Empty;
            a.ProviderId = enabled ? applicationBuilder.Configuration["Payments:Iyzico:ProviderId"] ?? string.Empty : string.Empty;
            a.IsSandbox = !enabled || applicationBuilder.Configuration.GetValue("Payments:Iyzico:IsSandbox", true);
        });
    }
}
