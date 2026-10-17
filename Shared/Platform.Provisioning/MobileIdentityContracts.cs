using System.Text.RegularExpressions;

namespace Platform.Provisioning;

public sealed record MobileIdentityRequest(Guid Id,string TenantId,Guid BusinessAppId,Guid OwnerSubject,string DeploymentId,
    string AndroidPackageName,string IosBundleId,string StoreUrl,TenantDomainSelection? Domain,Guid? ExpectedActiveId,string OriginalRequestSha256,int PackagePolicyVersion)
{
    public void Validate(bool legacy=false)
    {
        IosReleasePlan.Tenant(TenantId);Domain?.Validate();
        if(Id==Guid.Empty || BusinessAppId==Guid.Empty || OwnerSubject==Guid.Empty || ExpectedActiveId==Guid.Empty ||
            !Regex.IsMatch(DeploymentId,"^[a-z][a-z0-9-]{2,39}\\z") || !IosReleasePlan.Digest(OriginalRequestSha256) ||
            AndroidPackageName.Length>200 || !Regex.IsMatch(AndroidPackageName,"^[A-Za-z][A-Za-z0-9_]*(\\.[A-Za-z][A-Za-z0-9_]*)+\\z") ||
            IosBundleId.Length>220 || !Regex.IsMatch(IosBundleId,"^[A-Za-z][A-Za-z0-9-]*(\\.[A-Za-z][A-Za-z0-9-]*)+\\z") ||
            !legacy && (Domain!=null && Domain.OwnerSubject!=OwnerSubject || ExpectedActiveId==null || PackagePolicyVersion!=1 ||
                AndroidPackageName=="com.example" || AndroidPackageName.StartsWith("com.example.",StringComparison.Ordinal)))
            throw new ArgumentException("Use an owned versioned mobile application identity.");
        if(!Uri.TryCreate(StoreUrl,UriKind.Absolute,out var url) || url.Scheme!="https" || !url.IsDefaultPort || url.AbsolutePath!="/" ||
            url.UserInfo.Length!=0 || url.Query.Length!=0 || url.Fragment.Length!=0 || Domain!=null && StoreUrl!="https://"+Domain.StoreHost)
            throw new ArgumentException("Use the verified tenant HTTPS store origin.");
    }
    public string FirebaseSecretName=>"firebase-mobile-identity-"+Id.ToString("N");
}
public sealed record PreparedMobileIdentity(string ProjectId,string ProjectNumber,string AndroidAppId,string IosAppId,
    string FirebaseSecretName,string AndroidSigningSecretName,string AndroidCertificateSha256,string AndroidSourceHash,int AndroidBuildNumber,IosReleasePlan IosPlan)
{
    public void Validate(MobileIdentityRequest request)
    {
        request.Validate();IosPlan.Validate();
        if(FirebaseSecretName!=request.FirebaseSecretName || AndroidSigningSecretName!="android-package-signing-v1-"+Convert.ToHexString(System.Security.Cryptography.SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(request.AndroidPackageName))).ToLowerInvariant() ||
            !IosReleasePlan.Digest(AndroidCertificateSha256) || !IosReleasePlan.Digest(AndroidSourceHash) || AndroidBuildNumber<1 ||
            IosPlan.MobileIdentityId!=request.Id || IosPlan.TenantId!=request.TenantId || IosPlan.DeploymentId!=request.DeploymentId ||
            IosPlan.IosBundleId!=request.IosBundleId || IosPlan.StoreUrl!=request.StoreUrl || IosPlan.ProjectId!=ProjectId || IosPlan.ProjectNumber!=ProjectNumber ||
            IosPlan.IosAppId!=IosAppId || !Regex.IsMatch(AndroidAppId,"^1:"+Regex.Escape(ProjectNumber)+":android:[A-Za-z0-9]+\\z"))
            throw new ArgumentException("Mobile build bindings must match their immutable tenant identity version.");
    }
    public void ValidateAndroid(MobileIdentityRequest request,ProvisioningStepResult receipt)
    {
        Validate(request);var r=receipt.Resources;
        var allowed=new HashSet<string>(StringComparer.Ordinal){"androidAppId","androidApplicationId","buildNumber","sourceHash","fileSize","sha256","signingCertificateSha256","release","storeUrl"};
        if(receipt.Provider!="AndroidAppDistribution" || r.Keys.Any(k=>!allowed.Contains(k)) || r.GetValueOrDefault("androidAppId")!=AndroidAppId ||
            r.GetValueOrDefault("androidApplicationId")!=request.AndroidPackageName || r.GetValueOrDefault("storeUrl")!=request.StoreUrl ||
            r.GetValueOrDefault("sourceHash")!=AndroidSourceHash || r.GetValueOrDefault("signingCertificateSha256")!=AndroidCertificateSha256 ||
            r.GetValueOrDefault("buildNumber")!=AndroidBuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture) || !IosReleasePlan.Digest(r.GetValueOrDefault("sha256")) ||
            !Regex.IsMatch(r.GetValueOrDefault("release")??"","^projects/"+Regex.Escape(ProjectNumber)+"/apps/"+Regex.Escape(AndroidAppId)+"/releases/[A-Za-z0-9_-]+\\z"))
            throw new ArgumentException("The Android result differs from the prepared package, endpoint or signing certificate.");
    }
}
public sealed record MobileIdentityVersion(MobileIdentityRequest Request,int Generation,bool Legacy,string State,int Attempts,
    PreparedMobileIdentity? Prepared,ProvisioningStepResult? AndroidReceipt,IosReleaseReceipt? IosReceipt,string? ErrorCode,DateTimeOffset CreatedAt,DateTimeOffset UpdatedAt)
{
    public int IosAttempts { get; init; }
}
public sealed record MobileIdentityLease(MobileIdentityVersion Version,Guid Token,string Platform);

/// <summary>Frozen public references selected when a build is queued. Keys and Firebase credentials stay encrypted.</summary>
public sealed record AndroidBuildScope(Guid IdentityId,bool Legacy,string AndroidPackageName,string IosBundleId,
    string FirebaseSecretName,string SigningSecretName,string CertificateSha256,string ProjectId,string ProjectNumber,
    string AndroidAppId,string StoreUrl,string? SourceHash=null)
{
    public TenantDomainSelection? Domain { get; init; }
    public void Validate(string tenant,string deployment)
    {
        Domain?.Validate();
        IosReleasePlan.Tenant(tenant);
        var keyName="android-package-signing-v1-"+Convert.ToHexString(System.Security.Cryptography.SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(AndroidPackageName))).ToLowerInvariant();
        if(IdentityId==Guid.Empty || Domain!=null && StoreUrl!="https://"+Domain.StoreHost || !IosReleasePlan.Digest(CertificateSha256) || SourceHash!=null && !IosReleasePlan.Digest(SourceHash) ||
            !Regex.IsMatch(AndroidPackageName,"^[A-Za-z][A-Za-z0-9_]*(\\.[A-Za-z][A-Za-z0-9_]*)+\\z") || AndroidPackageName.Length>200 ||
            !Regex.IsMatch(IosBundleId,"^[A-Za-z][A-Za-z0-9-]*(\\.[A-Za-z][A-Za-z0-9-]*)+\\z") || IosBundleId.Length>220 ||
            !Regex.IsMatch(ProjectId,"^[a-z][a-z0-9-]{4,28}[a-z0-9]\\z") || !Regex.IsMatch(ProjectNumber,"^[0-9]{1,30}\\z") ||
            !Regex.IsMatch(AndroidAppId,"^1:"+Regex.Escape(ProjectNumber)+":android:[A-Za-z0-9]+\\z") ||
            !Uri.TryCreate(StoreUrl,UriKind.Absolute,out var url) || url.Scheme!="https" || !url.IsDefaultPort || url.AbsolutePath!="/" ||
            url.UserInfo.Length!=0 || url.Query.Length!=0 || url.Fragment.Length!=0 ||
            (Legacy ? IdentityId!=MobileIdentityRegistry.InitialId(tenant,deployment) || FirebaseSecretName!="firebase-configuration" || SigningSecretName!="android-release-signing-v1" :
                FirebaseSecretName!="firebase-mobile-identity-"+IdentityId.ToString("N") || SigningSecretName!=keyName))
            throw new ArgumentException("The queued Android build must retain its owned package, endpoint and signing references.");
    }
    public void ValidateReceipt(ProvisioningStepResult receipt,int buildNumber)
    {
        var values=receipt.Resources;
        if(receipt.Provider!="AndroidAppDistribution" || values.GetValueOrDefault("androidApplicationId")!=AndroidPackageName ||
            values.GetValueOrDefault("androidAppId")!=AndroidAppId || values.GetValueOrDefault("signingCertificateSha256")!=CertificateSha256 ||
            values.GetValueOrDefault("storeUrl")!=StoreUrl || SourceHash!=null && values.GetValueOrDefault("sourceHash")!=SourceHash ||
            values.GetValueOrDefault("buildNumber")!=buildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture))
            throw new InvalidOperationException("The Android receipt differs from its queued identity.");
    }
}
