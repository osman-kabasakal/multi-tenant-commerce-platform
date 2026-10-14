using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Hangfire.Server;
using MongoDB.Driver;

namespace Grand.Business.Tenants.Services.Hangfire;

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
            if(x !=null && x is IMultitenantTaskContext jobArgs)
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