using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Data;
using MongoDB.Driver;

namespace Grand.Business.Tenants.Services.Hangfire;

public class MultitenantTaskContext<T>: IMultitenantTaskContext
{
    public string CustomerId { get; set; }
    public T JobArgs { get; set; }
    public DataSettings TenantDbSettings { get; set; }
    public ITenantScopedServiceProvider<IMongoDatabase> ScopedServiceProvider { get; set; }
}

public interface IMultitenantTaskContext
{
    public string CustomerId { get; set; }
    DataSettings TenantDbSettings { get; set; }
    ITenantScopedServiceProvider<IMongoDatabase> ScopedServiceProvider { get; set; }
}