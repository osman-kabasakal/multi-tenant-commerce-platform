using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Business.Tenants.Services.TenantServiceProvider;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using StackExchange.Redis;
using System;

namespace Grand.Business.Tenants.Extensions;

public static class TenantScopeServiceProviderExtensions
{
    public static IServiceCollection AddScopedServiceProvider<T>(
        this IServiceCollection services) where T : class
    {
        services.AddSingleton<ITenantScopedServiceProvider<T>>(sp =>
            new TenantScopedServiceProvider<T>(sp, services));
        return services;
    }
}
