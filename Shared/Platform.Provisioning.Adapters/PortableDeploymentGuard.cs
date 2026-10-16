using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class PortableDeploymentGuard(PortableOnboardingOptions options,TenantDomainOptions domains,ITenantSecrets secrets) : IProvisioningGuard
{
    public const string SecretName="provisioning-deployment-v1";
    public async Task ValidateAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {
        request.Validate();
        if(request.DeploymentId!=null && request.DeploymentId!=options.DeploymentId)
            throw new InvalidOperationException("This job targets a different deployment.");
        if((request.MobileReleaseProfile??"Disabled")!=options.MobileReleaseProvider)
            throw new InvalidOperationException("This worker's mobile policy differs from the queued tenant request.");
        // Registration must already own this tenant and have persisted its initial password.
        await secrets.GetAsync(request.TenantId,TenantSecretNames.InitialPassword,ct);
        var expected=options.TargetFingerprint()+":"+domains.TargetFingerprint();
        var actual=completed.Count==0
            ? await secrets.GetOrCreateAsync(request.TenantId,SecretName,()=>expected,ct)
            : await secrets.GetAsync(request.TenantId,SecretName,ct);
        if (actual!=expected) throw new InvalidOperationException("Tenant deployment target changed; perform an explicit migration.");
    }
}
