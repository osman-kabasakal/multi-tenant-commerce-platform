using Microsoft.Extensions.DependencyInjection;
using System;

namespace Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;

public interface ITenantScopedServiceProvider<T> where T : class
{
    IServiceScope CreateScopeWithReplacement(T replacement, string storeId);
}
