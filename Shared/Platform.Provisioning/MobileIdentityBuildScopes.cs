namespace Platform.Provisioning;

public static class MobileIdentityBuildScopes
{
    public static AndroidBuildScope Android(MobileIdentityVersion version, ProvisioningJob original, string storeUrl, bool freezeSource = false,TenantDomainSelection? domain=null)
    {
        var request=version.Request;
        if(original.State!="Succeeded" || original.Request.TenantId!=request.TenantId || original.Request.DeploymentId!=request.DeploymentId ||
            DomainActivationPlan.Digest(original.Request)!=request.OriginalRequestSha256)
            throw new ProvisioningConflictException();
        AndroidBuildScope scope;
        if(version.Legacy)
        {
            var cloud=original.Steps["google-firebase"].Resources;
            scope=new(request.Id,true,request.AndroidPackageName,request.IosBundleId,"firebase-configuration",
                "android-release-signing-v1",original.Steps["mobile-android-release"].Resources["signingCertificateSha256"],
                cloud["projectId"],cloud["projectNumber"],cloud["androidAppId"],storeUrl);
        }
        else
        {
            var prepared=version.Prepared??throw new InvalidOperationException("The mobile identity is not prepared.");
            prepared.Validate(request);
            scope=new(request.Id,false,request.AndroidPackageName,request.IosBundleId,prepared.FirebaseSecretName,
                prepared.AndroidSigningSecretName,prepared.AndroidCertificateSha256,prepared.ProjectId,prepared.ProjectNumber,
                prepared.AndroidAppId,storeUrl,freezeSource?prepared.AndroidSourceHash:null);
        }
        var selected=domain??(storeUrl==request.StoreUrl?request.Domain:null);
        if(selected!=null && selected.OwnerSubject!=request.OwnerSubject)throw new ProvisioningConflictException();
        scope=scope with {Domain=selected};scope.Validate(request.TenantId,request.DeploymentId);return scope;
    }
}
