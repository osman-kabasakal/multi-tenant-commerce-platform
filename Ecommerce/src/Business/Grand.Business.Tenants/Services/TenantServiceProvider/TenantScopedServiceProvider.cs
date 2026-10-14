using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.MultiTenant;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.Memory;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Hosting;
using StackExchange.Redis;
using System;

namespace Grand.Business.Tenants.Services.TenantServiceProvider;

public class TenantScopedServiceProvider<T> : ITenantScopedServiceProvider<T> where T : class
{
    private readonly IServiceProvider _serviceProvider;
    private readonly IServiceCollection _serviceCollection;
    // private readonly IConfiguration _configuration;
    // private readonly IConnectionMultiplexer _connectionMultiplexer;
    // private readonly IDatabase _database;
    // private readonly ISubscriber _subscriber;

    public TenantScopedServiceProvider(
        IServiceProvider serviceProvider,
        IServiceCollection serviceCollection
        
        )
    {
        _serviceProvider = serviceProvider;
        _serviceCollection = serviceCollection;
        
    }

    public IServiceScope CreateScopeWithReplacement(T replacement, string storeId)
    {
        // Yeni bir service collection oluştur
        var scopedServices = new ServiceCollection();
        // Mevcut servisleri kopyala
        foreach (var service in _serviceCollection)
        {
            if (service.ServiceType.IsAssignableTo(typeof(IHostedService)) 
                || (service.ServiceType.Namespace?.StartsWith("Hangfire", StringComparison.InvariantCultureIgnoreCase) ?? false) ||
                service.ServiceType.IsAssignableTo(typeof(IConnectionMultiplexer))
                || service.ServiceType.IsAssignableTo(typeof(IDatabase))
                || service.ServiceType.IsAssignableTo(typeof(ISubscriber))
                || service.ServiceType.IsAssignableTo(typeof(ITenantScopedServiceProvider<T>))
                || service.ServiceType.IsAssignableTo(typeof(RedisCacheCoordinator))
                )
            {
                continue;
            }
            scopedServices.Add(service);
        }

        // Değiştirilecek servisi bul ve güncelle
        var serviceType = typeof(T);
        var existingDescriptor = scopedServices.FirstOrDefault(d => serviceType.IsAssignableTo(d.ServiceType));
        if (existingDescriptor != null)
        {
            scopedServices.Remove(existingDescriptor);
            scopedServices.AddScoped(existingDescriptor.ServiceType, _ => replacement);
        }
        
        var configBuilder = new ConfigurationBuilder();
    
        // ConfigurationRoot'a erişebiliyorsak kaynakları doğrudan kopyalayabiliriz
        configBuilder.AddConfiguration(_serviceProvider.GetRequiredService<IConfiguration>());
        
        var overrideDict = new Dictionary<string, string>
        {
            {"TenantServiceScopeConfig:IsBackgroundScope", "true"},
            {"TenantServiceScopeConfig:StoreId", storeId}
            // Diğer değiştirilecek değerler...
        };
    
        // Override değerlerini en sona ekleyelim (böylece önceliği yüksek olur)
        configBuilder.AddInMemoryCollection(overrideDict);
        
        var newConfiguration = configBuilder.Build();
    
        // Hedef collection'a ekleyelim
        scopedServices.AddSingleton<IConfiguration>(newConfiguration);
        scopedServices.Configure<TenantServiceScopeConfig>(newConfiguration.GetSection("TenantServiceScopeConfig"));

        scopedServices.AddSingleton(sp=>_serviceProvider.GetRequiredService<IConnectionMultiplexer>());
        scopedServices.AddSingleton(sp=>_serviceProvider.GetRequiredService<IDatabase>());
        scopedServices.AddSingleton(sp=>_serviceProvider.GetRequiredService<ISubscriber>());
        scopedServices.AddSingleton(sp=>_serviceProvider.GetRequiredService<RedisCacheCoordinator>());
        
        // Yeni service provider oluştur
        var scopedProvider = scopedServices.BuildServiceProvider();

        // Scope'u oluştur
        return scopedProvider.CreateScope();
    }
}


