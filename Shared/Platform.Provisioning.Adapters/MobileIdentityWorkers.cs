using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Platform.Google;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

/// <summary>Prepares app/key references once, then builds Android. Mac completion controls the active pointer.</summary>
public sealed class MobileIdentityPreparation(GoogleTenantProvisioner google,GoogleCloudOptions cloud,ITenantSecrets secrets,
    TenantAndroidSigningKeys signing,IAndroidReleaseBuilder android,IosReleaseBindingOptions ios)
{
    public async Task<PreparedMobileIdentity> PrepareAsync(MobileIdentityRequest request,ProvisioningJob original,CancellationToken ct)
    {
        request.Validate();
        if(original.State!="Succeeded" || original.Request.TenantId!=request.TenantId || original.Request.DeploymentId!=request.DeploymentId ||
            DomainActivationPlan.Digest(original.Request)!=request.OriginalRequestSha256 || cloud.DeploymentId!=request.DeploymentId)
            throw new ProvisioningConflictException();
        var previous=MobileReleaseFiles.Parse<TenantFirebaseConfiguration>(await secrets.GetAsync(request.TenantId,TenantFirebaseConfiguration.SecretName,ct));
        var firebase=await google.EnsureApplicationVersionAsync(previous,new(request.TenantId,original.Request.StoreName,original.Request.OwnerEmail,
            request.AndroidPackageName,request.IosBundleId),ct);
        var saved=MobileReleaseFiles.Parse<TenantFirebaseConfiguration>(await secrets.GetOrCreateAsync(request.TenantId,request.FirebaseSecretName,
            ()=>JsonSerializer.Serialize(firebase,MobileReleaseFiles.Json),ct));
        if(saved!=firebase)throw new ProvisioningConflictException();
        var key=await signing.GetOrCreatePackageAsync(request.TenantId,request.AndroidPackageName,ct);
        if(firebase.IosDevelopmentTeam!=ios.DevelopmentTeam)throw new InvalidOperationException("Use the same Apple team for Firebase and signing.");
        var plan=new IosReleasePlan(request.TenantId,request.DeploymentId,request.IosBundleId,ios.DevelopmentTeam,
            ios.SigningCertificateSha256,ios.ExpectedSourceHash,1,firebase.ProjectId,firebase.ProjectNumber,firebase.IosAppId,
            IosReleaseOptions.SdkHash(firebase),request.StoreUrl){MobileIdentityId=request.Id,IosPushTransport=firebase.IosPushTransport=="Apns"?"Apns":null};
        var result=new PreparedMobileIdentity(firebase.ProjectId,firebase.ProjectNumber,firebase.AndroidAppId,firebase.IosAppId,
            request.FirebaseSecretName,TenantAndroidSigningKeys.PackageSecretName(request.AndroidPackageName),key.CertificateSha256,
            await android.SourceHashAsync(ct),1,plan);
        result.Validate(request);return result;
    }
}

public sealed class MobileIdentityLinuxWorker(MobileIdentityRegistry identities,IProvisioningQueue onboarding,
    PortableOnboardingOptions deployment,IServiceScopeFactory scopes,ILogger<MobileIdentityLinuxWorker> logger):BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        while(!ct.IsCancellationRequested)
        {
            try
            {
                var lease=await identities.ClaimLinuxAsync(deployment.DeploymentId,ct);
                if(lease==null)await Task.Delay(TimeSpan.FromSeconds(3),ct);else await RunAsync(lease,ct);
            }
            catch(OperationCanceledException)when(ct.IsCancellationRequested){break;}
            catch(Exception error){logger.LogWarning("Mobile identity polling interrupted ({ErrorType})",error.GetType().Name);await Task.Delay(TimeSpan.FromSeconds(3),ct);}
        }
    }
    public async Task RunAsync(MobileIdentityLease lease,CancellationToken ct)
    {
        using var owned=CancellationTokenSource.CreateLinkedTokenSource(ct);
        var heartbeat=KeepLeaseAsync(lease,owned);
        try
        {
            await identities.RenewAsync(lease,owned.Token);
            if(lease.Version.State=="Ready")
            {await identities.TryPromoteAsync(lease.Version.Request.Id,lease.Version.Request.TenantId,owned.Token);return;}
            var request=lease.Version.Request;
            var original=await onboarding.GetAsync(request.TenantId,owned.Token)??throw new ProvisioningConflictException();
            using var scope=scopes.CreateScope();
            await scope.ServiceProvider.GetRequiredService<PortableDeploymentGuard>().ValidateAsync(original.Request,original.Steps,owned.Token);
            if(lease.Version.Prepared==null)
            {
                var prepared=await scope.ServiceProvider.GetRequiredService<MobileIdentityPreparation>().PrepareAsync(request,original,owned.Token);
                await identities.PrepareAsync(lease,prepared,owned.Token);
            }
            var current=await identities.GetForWorkerAsync(request.TenantId,request.Id,owned.Token)??throw new ProvisioningLeaseLostException();
            var binding=MobileIdentityBuildScopes.Android(current,original,request.StoreUrl,freezeSource:true);
            var receipt=await scope.ServiceProvider.GetRequiredService<AndroidReleasePipeline>().ExecuteAsync(original.Request,original.Steps,owned.Token,
                request.Id,current.Prepared!.AndroidBuildNumber,binding);
            await identities.CompleteAndroidAsync(lease,receipt,owned.Token);
            logger.LogInformation("Tenant {TenantId}: Android identity {IdentityId} is ready",request.TenantId,request.Id);
        }
        catch(OperationCanceledException)when(owned.IsCancellationRequested){}
        catch(ProvisioningLeaseLostException){}
        catch(Exception error)
        {
            logger.LogWarning("Mobile identity {IdentityId} failed ({ErrorType})",lease.Version.Request.Id,error.GetType().Name);
            try{await identities.FailAsync(lease,"MobileAndroid."+error.GetType().Name,ct);}catch(ProvisioningLeaseLostException){}
        }
        finally{owned.Cancel();await heartbeat;}
    }
    private async Task KeepLeaseAsync(MobileIdentityLease lease,CancellationTokenSource owned)
    {
        try{while(!owned.IsCancellationRequested){await Task.Delay(TimeSpan.FromSeconds(30),owned.Token);await identities.RenewAsync(lease,owned.Token);}}
        catch(OperationCanceledException)when(owned.IsCancellationRequested){}catch(Exception){owned.Cancel();}
    }
}
