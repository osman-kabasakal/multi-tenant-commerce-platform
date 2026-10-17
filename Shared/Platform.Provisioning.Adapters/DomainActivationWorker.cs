using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Platform.Provisioning.Adapters;

public sealed class DomainActivationPipeline(DomainActivationQueue jobs,TenantDomainRegistry domains,MobileIdentityRegistry identities,
    IProvisioningQueue onboarding,PortableOnboardingOptions deployment,PortableDeploymentGuard guard,CloudflareTenantDomains cloudflare,
    PortableTenantPublicationStep publication,StoreInstallerStep installer)
{
    public async Task ExecuteAsync(DomainActivationLease lease,CancellationToken ct)
    {
        var plan=lease.Job.Plan;plan.Validate();
        var original=await onboarding.GetAsync(plan.TenantId,ct)??throw new ProvisioningConflictException();
        if(original.State!="Succeeded" || original.Request.DeploymentId!=deployment.DeploymentId || plan.DeploymentId!=deployment.DeploymentId ||
            DomainActivationPlan.Digest(original.Request)!=plan.OriginalRequestSha256)throw new ProvisioningConflictException();
        await guard.ValidateAsync(original.Request,original.Steps,ct);
        var binding=await domains.RequireVerifiedAsync(plan.Id,plan.OwnerSubject,plan.TenantId,plan.DeploymentId,ct);
        if(TenantDomainSelection.From(binding)!=plan.Domain)throw new ProvisioningConflictException();
        var primary=(await domains.ListAsync(plan.TenantId,plan.OwnerSubject,ct)).SingleOrDefault(x=>x.IsPrimary);
        if(primary?.Request.Id!=plan.PreviousPrimaryDomainId && primary?.Request.Id!=plan.Id)throw new TenantDomainException("DomainPrimaryChanged");
        var request=original.Request with {Domain=plan.Domain};
        var steps=new Dictionary<string,ProvisioningStepResult>(lease.Job.Steps);
        async Task Step(string name,Func<Task<ProvisioningStepResult>> action)
        {
            if(steps.ContainsKey(name))return;
            await jobs.RenewAsync(lease,ct);var receipt=await action();ct.ThrowIfCancellationRequested();
            await jobs.CheckpointAsync(lease,name,receipt,ct);steps.Add(name,receipt);
        }
        await Step("dns",async()=>{
            await cloudflare.EnsureRecordsAsync(binding,ct);
            return new("Cloudflare",new Dictionary<string,string>{{"domainRequestId",plan.Id.ToString("N")},{"storeHost",plan.Domain.StoreHost},{"adminHost",plan.Domain.AdminHost}});
        });
        await Step("https",async()=>{
            await publication.PublishCustomAliasesAsync(request,original.Steps["store"].Resources["storeId"],ct);
            await publication.VerifyCustomAsync(request,original.Steps["store"].Resources["storeId"],ct);
            return new("Portable",new Dictionary<string,string>{{"readiness","Verified"},{"storeUrl",deployment.StoreUrl(request)},{"adminUrl",deployment.AdminUrl(request)}});
        });
        await Step("store-address",()=>installer.RunAsync(request,original.Steps,"tenant-domain",ct));
        await Step("primary",async()=>{
            await domains.MarkActiveAsync(plan.Id,plan.OwnerSubject,plan.TenantId,plan.DeploymentId,ct,plan.PreviousPrimaryDomainId,enforcePrevious:true);
            return new("Portable",new Dictionary<string,string>{{"domainRequestId",plan.Id.ToString("N")}});
        });
        if(plan.CreateMobileIdentity)
            await Step("mobile-identity",async()=>{
                await identities.EnsureInitialAsync(original,plan.BusinessAppId,plan.OwnerSubject,ct);
                var active=(await identities.ListAsync(plan.TenantId,plan.OwnerSubject,ct)).Single(x=>x.State=="Active");
                if(active.Request.AndroidPackageName==plan.NewPackageName && active.Request.IosBundleId==plan.NewPackageName)
                    return new("MobileIdentity",new Dictionary<string,string>{{"identityId",active.Request.Id.ToString("N")},{"state","Active"}});
                var mobile=new MobileIdentityRequest(plan.Id,plan.TenantId,plan.BusinessAppId,plan.OwnerSubject,plan.DeploymentId,
                    plan.NewPackageName!,plan.NewPackageName!,deployment.StoreUrl(request),plan.Domain,active.Request.Id,plan.OriginalRequestSha256,1);
                var version=await identities.EnqueueAsync(mobile,ct);
                return new("MobileIdentity",new Dictionary<string,string>{{"identityId",version.Request.Id.ToString("N")}});
            });
        await jobs.CompleteAsync(lease,ct);
    }
}

public sealed class DomainActivationWorker(DomainActivationQueue jobs,PortableOnboardingOptions deployment,
    IServiceScopeFactory scopes,ILogger<DomainActivationWorker> logger):BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        while(!ct.IsCancellationRequested)
        {
            try
            {
                var lease=await jobs.ClaimAsync(deployment.DeploymentId,ct);
                if(lease==null)await Task.Delay(TimeSpan.FromSeconds(3),ct);else await RunAsync(lease,ct);
            }
            catch(OperationCanceledException)when(ct.IsCancellationRequested){break;}
            catch(Exception error){logger.LogWarning("Domain activation polling interrupted ({ErrorType})",error.GetType().Name);await Task.Delay(TimeSpan.FromSeconds(3),ct);}
        }
    }
    public async Task RunAsync(DomainActivationLease lease,CancellationToken ct)
    {
        using var owned=CancellationTokenSource.CreateLinkedTokenSource(ct);
        async Task KeepAsync()
        {
            try{while(!owned.IsCancellationRequested){await Task.Delay(TimeSpan.FromSeconds(30),owned.Token);await jobs.RenewAsync(lease,owned.Token);}}
            catch(OperationCanceledException)when(owned.IsCancellationRequested){}catch(Exception){owned.Cancel();}
        }
        var heartbeat=KeepAsync();
        try
        {
            await jobs.RenewAsync(lease,owned.Token);
            using var scope=scopes.CreateScope();
            await scope.ServiceProvider.GetRequiredService<DomainActivationPipeline>().ExecuteAsync(lease,owned.Token);
        }
        catch(OperationCanceledException)when(owned.IsCancellationRequested){}
        catch(ProvisioningLeaseLostException){}
        catch(ProvisioningDeferredException pending)
        {try{await jobs.DeferAsync(lease,pending,ct);}catch(ProvisioningLeaseLostException){}}
        catch(Exception error)
        {
            var code=error is TenantDomainException domain?domain.Code:"DomainActivation."+error.GetType().Name;
            logger.LogWarning("Domain activation {DomainId} failed ({ErrorCode})",lease.Job.Plan.Id,code);
            try{await jobs.FailAsync(lease,code,ct);}catch(ProvisioningLeaseLostException){}
        }
        finally{owned.Cancel();await heartbeat;}
    }
}
