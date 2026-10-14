using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Data;
using Hangfire.Server;
using MongoDB.Driver;
using System;

namespace Authentication.Keycloak.MultitenantTasks;

public class MultitenantTaskContext{
    public DataSettings TenantDbSettings { get; set; }
    public ITenantScopedServiceProvider<IMongoDatabase> ScopedServiceProvider { get; set; }
}

public class MultitenantBackgroundTaskFilter : IServerFilter
{
    private readonly ITenantScopedServiceProvider<IMongoDatabase> scopedServiceProvider;

    public MultitenantBackgroundTaskFilter(ITenantScopedServiceProvider<IMongoDatabase> scopedServiceProvider)
    {
        this.scopedServiceProvider = scopedServiceProvider;
    }

    private void InjectPerformContext(PerformContext context)
    {
        foreach (var x in context.BackgroundJob.Job.Args)
        {
            if(x !=null && x is MultitenantTaskContext jobArgs)
            {
                jobArgs.ScopedServiceProvider = scopedServiceProvider;
            }
        }
    }

    public void OnPerformed(PerformedContext context)
    {
        
    }

    public void OnPerforming(PerformingContext context)
    {
        InjectPerformContext(context);
    }
}
