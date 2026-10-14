using Grand.Business.Core.Interfaces.Customers;
using Grand.Data;
using Grand.Domain.Customers;
using Grand.Domain.Stores;
using Grand.Infrastructure;
using Grand.Infrastructure.MultiTenant;
using Hangfire;
using Microsoft.Extensions.DependencyInjection;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using System.Linq.Expressions;

namespace Grand.Business.Tenants.Services.Hangfire;

public static class MultitenantTaskExtensions
{
    public static async Task RunForTenant<T>(IJobCancellationToken jobCancellationToken,
        MultitenantTaskContext<T> taskContext, Expression<Func<IJobCancellationToken, IServiceScope, T, Task>> callback)
    {
        var mongourl = new MongoUrl(taskContext.TenantDbSettings.ConnectionString);
        var databaseName = mongourl.DatabaseName;
        var database = new MongoClient(taskContext.TenantDbSettings.ConnectionString).GetDatabase(databaseName);
        var storeRepository = database.GetCollection<Store>(nameof(Store));
        var store = await storeRepository.AsQueryable()
            .FirstOrDefaultAsync();
        using (var scope = taskContext.ScopedServiceProvider!.CreateScopeWithReplacement(database,store?.Id))
        {
            var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
            tenantIdentityAccessor.TenantId = store?.Id;
            var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
            dbContext.SetConnection(taskContext.TenantDbSettings.ConnectionString);
            if (!await dbContext.DatabaseExist())
            {
                return;
            }

            await callback.Compile().Invoke(jobCancellationToken, scope, taskContext.JobArgs);
        }
    }

    public static async Task RunInTenantScope(this IMultitenantTaskContext context, Func<IServiceScope, Task> callback)
    {
        var mongourl = new MongoUrl(context.TenantDbSettings.ConnectionString);
        var databaseName = mongourl.DatabaseName;
        var database = new MongoClient(context.TenantDbSettings.ConnectionString).GetDatabase(databaseName);
        var storeRepository = database.GetCollection<Store>(nameof(Store));
        var store = await storeRepository.AsQueryable()
            .FirstOrDefaultAsync();
        using (var scope = context.ScopedServiceProvider!.CreateScopeWithReplacement(database,store?.Id))
        {
            var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
            tenantIdentityAccessor.TenantId = store?.Id;
            var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
            dbContext.SetConnection(context.TenantDbSettings.ConnectionString);
            if (!await dbContext.DatabaseExist())
            {
                return;
            }

            if (context.CustomerId != null)
            {
                var workContextSetter = scope.ServiceProvider.GetRequiredService<IWorkContextSetter>();
                var customerService = scope.ServiceProvider.GetRequiredService<ICustomerService>();
                var customer = await customerService.GetCustomerById(context.CustomerId);
                if (customer != null)
                {
                    await workContextSetter.SetCurrentCustomer(customer);
                }
                else
                {
                    var bgTaskCustomer =
                        await customerService.GetCustomerBySystemName(SystemCustomerNames.BackgroundTask);
                    if (bgTaskCustomer != null)
                    {
                        await workContextSetter.SetCurrentCustomer(bgTaskCustomer);
                    }
                }
            }

            await callback.Invoke(scope);
        }
    }
}