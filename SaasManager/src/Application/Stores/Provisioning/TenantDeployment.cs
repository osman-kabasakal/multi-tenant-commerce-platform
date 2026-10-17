using Microsoft.Extensions.Configuration;
using Platform.Provisioning;
using SaasManager.Application.AppBuilds;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Application.Stores.Provisioning;

[Authorize]
public sealed record GetTenantDeployment:IRequest<TenantDeploymentView>;
[Authorize]
public sealed record ActivateTenantDomain(Guid DomainRequestId,bool CreateMobileIdentity):IRequest<DomainActivationJob>;
[Authorize]
public sealed record CreateMobileIdentity(Guid RequestId):IRequest<MobileIdentityView>;
[Authorize]
public sealed record RetryTenantDeployment(Guid Id,string Kind):IRequest<bool>;
public sealed record TenantDomainStatus(TenantDomainView Domain,DomainActivationJob? Activation);
public sealed record MobileIdentityView(Guid Id,string PackageName,string IosBundleId,string State,bool IsActive,bool AndroidReady,bool IosReady,
    string? AndroidCertificateSha256,string? IosCertificateSha256,string StoreUrl,string? ErrorCode,DateTimeOffset UpdatedAt)
{
    public static MobileIdentityView From(MobileIdentityVersion v)=>new(v.Request.Id,v.Request.AndroidPackageName,v.Request.IosBundleId,v.State,v.State=="Active",
        v.AndroidReceipt!=null,v.IosReceipt!=null,v.Prepared?.AndroidCertificateSha256??v.AndroidReceipt?.Resources.GetValueOrDefault("signingCertificateSha256"),
        v.Prepared?.IosPlan.SigningCertificateSha256,v.Request.StoreUrl,v.ErrorCode,v.UpdatedAt);
}
public sealed record TenantDeploymentView(Guid BusinessId,Guid OwnerId,string BusinessName,bool DomainEnabled,bool IdentityEnabled,bool CanChange,string? BlockReason,
    string StoreUrl,string AdminUrl,string ProposedPackageName,IReadOnlyList<TenantDomainStatus> Domains,IReadOnlyList<MobileIdentityView> Identities);

public sealed class TenantDeploymentHandler(IApplicationDbContext db,IWorkContext work,IConfiguration config,IProvisioningQueue onboarding,
    TenantDomainRegistry domains,DomainActivationQueue activations,MobileIdentityRegistry identities)
    :IRequestHandler<GetTenantDeployment,TenantDeploymentView>,IRequestHandler<ActivateTenantDomain,DomainActivationJob>,
     IRequestHandler<CreateMobileIdentity,MobileIdentityView>,IRequestHandler<RetryTenantDeployment,bool>
{
    private string Deployment=>config["Provisioning:DeploymentId"]??"";
    private bool DomainsEnabled=>config.GetValue<bool>("Provisioning:CustomDomains:Enabled");
    private bool IdentityEnabled=>config["Provisioning:Mobile:Provider"]=="AndroidIosAppDistribution";
    private async Task<(Business Business,BusinessApp App,ProvisioningJob Original,Guid Owner,BuildEligibility Eligibility)> ContextAsync(bool change,CancellationToken ct)
    {
        TrialEnrollmentPolicy.Owner(work);
        if(config["Provisioning:Profile"]!="Portable" || config.GetValue<bool>("LocalDemo:Enabled"))throw new TenantDomainException("DeploymentUnavailable");
        var id=BusinessOwnerContext.BusinessId(work)??throw new UnauthorizedAccessException();
        var business=await db.Businesses.SingleOrDefaultAsync(x=>x.Id==id && !x.IsDeleted && x.CreatedByGuestId==work.GuestRegistration!.Id,ct)
            ??throw new UnauthorizedAccessException();
        var eligibility=await BuildEligibility.CheckAsync(db,work,ct);
        var app=eligibility.App??throw new TenantDomainException("TenantNotReady");
        var original=await onboarding.GetAsync(business.Id.ToString("N"),ct);
        if(original?.State!="Succeeded" || original.Request.DeploymentId!=Deployment || !original.Steps.ContainsKey("publication"))throw new TenantDomainException("TenantNotReady");
        if(change && !eligibility.Allowed)throw new TenantDomainException("SubscriptionRequired");
        return(business,app,original,work.KeycloakId!.Value,eligibility);
    }
    public async Task<TenantDeploymentView> Handle(GetTenantDeployment request,CancellationToken ct)
    {
        var c=await ContextAsync(false,ct);var tenant=c.Original.Request.TenantId;
        var bindings=await domains.ListAsync(tenant,c.Owner,ct);var primary=bindings.SingleOrDefault(x=>x.IsPrimary);
        var versions=await identities.ListAsync(tenant,c.Owner,ct);
        var views=versions.Select(MobileIdentityView.From).ToList();
        if(views.Count==0 && c.Original.Steps.TryGetValue("mobile-android-release",out var initial))
            views.Add(new(MobileIdentityRegistry.InitialId(tenant,Deployment),c.Original.Request.AndroidPackageName??c.App.PackageName,
                c.Original.Request.IosBundleId??c.App.PackageName,"Active",true,true,c.Original.Steps.ContainsKey("mobile-ios-release"),
                initial.Resources.GetValueOrDefault("signingCertificateSha256"),c.Original.Steps.GetValueOrDefault("mobile-ios-release")?.Resources.GetValueOrDefault("signingCertificateSha256"),
                c.Original.Steps["publication"].Resources["storeUrl"],null,c.Original.UpdatedAt));
        var domainViews=new List<TenantDomainStatus>();
        foreach(var binding in bindings)domainViews.Add(new(TenantDomainView.From(binding),await activations.GetAsync(binding.Request.Id,c.Owner,ct)));
        return new(c.Business.Id,c.Owner,c.Business.Name,DomainsEnabled,IdentityEnabled,c.Eligibility.Allowed,c.Eligibility.BlockReason,
            primary==null?c.Original.Steps["publication"].Resources["storeUrl"]:"https://"+primary.Request.StoreHost,
            primary==null?c.Original.Steps["publication"].Resources["adminUrl"]:"https://"+primary.Request.AdminHost+"/Admin",
            TenantMobileApplicationId.ForBusiness(config,c.Business.Name,c.Business.Id,verifiedStoreHost:primary?.Request.StoreHost),domainViews,views);
    }
    private async Task<string> PackageAsync(Business business,string? domain,CancellationToken ct)
    {
        var candidate=TenantMobileApplicationId.ForBusiness(config,business.Name,business.Id,verifiedStoreHost:domain);
        if(await db.BusinessApps.AnyAsync(x=>x.PackageName==candidate && x.BusinessId!=business.Id,ct) || await identities.PackageTakenAsync(candidate,business.Id.ToString("N"),ct))
            candidate=TenantMobileApplicationId.ForBusiness(config,business.Name,business.Id,true,domain);
        return candidate;
    }
    public async Task<DomainActivationJob> Handle(ActivateTenantDomain request,CancellationToken ct)
    {
        if(!DomainsEnabled)throw new TenantDomainException("DomainFeatureDisabled");
        if(request.CreateMobileIdentity && !IdentityEnabled)throw new TenantDomainException("MobileIdentityDisabled");
        var c=await ContextAsync(true,ct);var tenant=c.Original.Request.TenantId;
        var binding=await domains.RequireVerifiedAsync(request.DomainRequestId,c.Owner,tenant,Deployment,ct);
        var prior=await activations.GetAsync(binding.Request.Id,c.Owner,ct);
        if(prior!=null)
        {if(prior.Plan.CreateMobileIdentity!=request.CreateMobileIdentity)throw new ProvisioningConflictException();return prior;}
        var primary=(await domains.ListAsync(tenant,c.Owner,ct)).SingleOrDefault(x=>x.IsPrimary);
        if(primary?.Request.Id==binding.Request.Id)throw new TenantDomainException("DomainAlreadyActive");
        var package=request.CreateMobileIdentity?await PackageAsync(c.Business,binding.Request.StoreHost,ct):null;
        return await activations.EnqueueAsync(new(binding.Request.Id,tenant,c.Owner,Deployment,TenantDomainSelection.From(binding),
            primary?.Request.Id,DomainActivationPlan.Digest(c.Original.Request),c.App.Id,request.CreateMobileIdentity,package),ct);
    }
    public async Task<MobileIdentityView> Handle(CreateMobileIdentity request,CancellationToken ct)
    {
        if(!IdentityEnabled)throw new TenantDomainException("MobileIdentityDisabled");
        var c=await ContextAsync(true,ct);var tenant=c.Original.Request.TenantId;
        var prior=await identities.GetAsync(request.RequestId,c.Owner,ct);
        if(prior!=null){if(prior.Request.TenantId!=tenant)throw new UnauthorizedAccessException();return MobileIdentityView.From(prior);}
        if(await activations.HasPendingAsync(tenant,ct))throw new ProvisioningConflictException();
        await identities.EnsureInitialAsync(c.Original,c.App.Id,c.Owner,ct);
        var active=(await identities.ListAsync(tenant,c.Owner,ct)).Single(x=>x.State=="Active");
        var primary=(await domains.ListAsync(tenant,c.Owner,ct)).SingleOrDefault(x=>x.IsPrimary);
        var package=await PackageAsync(c.Business,primary?.Request.StoreHost,ct);
        if(active.Request.AndroidPackageName==package && active.Request.IosBundleId==package)throw new TenantDomainException("MobileIdentityUnchanged");
        var storeUrl=primary==null?c.Original.Steps["publication"].Resources["storeUrl"]:"https://"+primary.Request.StoreHost;
        return MobileIdentityView.From(await identities.EnqueueAsync(new(request.RequestId,tenant,c.App.Id,c.Owner,Deployment,package,package,storeUrl,
            primary==null?null:TenantDomainSelection.From(primary),active.Request.Id,DomainActivationPlan.Digest(c.Original.Request),1),ct));
    }
    public async Task<bool> Handle(RetryTenantDeployment request,CancellationToken ct)
    {
        var c=await ContextAsync(true,ct);var tenant=c.Original.Request.TenantId;
        if(request.Kind=="domain")
        {
            var job=await activations.GetAsync(request.Id,c.Owner,ct);
            return job?.Plan.TenantId==tenant && await activations.RetryAsync(request.Id,c.Owner,ct);
        }
        if(request.Kind=="identity")
        {
            var version=await identities.GetAsync(request.Id,c.Owner,ct);
            return version?.Request.TenantId==tenant && await identities.RetryAsync(request.Id,c.Owner,ct);
        }
        throw new ArgumentException("Unknown retry target.");
    }
}
