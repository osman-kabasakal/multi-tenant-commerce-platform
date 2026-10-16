using System.Text.Json;
using Platform.Google;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class AndroidReleaseStep(AndroidReleasePipeline pipeline) : IProvisioningStep
{
    public string Name=>"mobile-android-release";
    public Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
        =>pipeline.ExecuteAsync(request,completed,ct);
}

public sealed class AndroidReleaseGuard(AndroidReleasePipeline pipeline) : IProvisioningGuard
{
    public Task ValidateAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
        =>pipeline.ValidateSavedPlanAsync(request,completed.ContainsKey("mobile-android-release"),ct);
}

public sealed class AndroidReleasePipeline(AndroidReleaseOptions options,PortableOnboardingOptions deployment,GoogleCloudOptions google,
    ITenantSecrets secrets,TenantAndroidSigningKeys signing,IAndroidReleaseBuilder builder,FirebaseAppDistribution distribution)
{
    public const string PlanSecret="android-initial-release-plan-v1";
    public const string ArtifactSecret="android-initial-release-artifact-v1";
    public const string DistributionSecret="android-initial-release-distribution-v1";

    private async Task<string?> FindAsync(string tenant,string name,CancellationToken ct)
    {try{return await secrets.GetAsync(tenant,name,ct);}catch(KeyNotFoundException){return null;}}
    private async Task<TenantFirebaseConfiguration> FirebaseAsync(TenantProvisioningRequest request,CancellationToken ct)
    {
        var firebase=MobileReleaseFiles.Parse<TenantFirebaseConfiguration>(await secrets.GetAsync(request.TenantId,TenantFirebaseConfiguration.SecretName,ct));
        FirebaseConfigValidator.Validate(firebase);
        if(firebase.TenantId!=request.TenantId || firebase.ProjectId!=google.ProjectId(request.TenantId) ||
            firebase.AndroidPackageName!=(request.AndroidPackageName??"com.example.tenant"+request.TenantId) ||
            firebase.IosBundleId!=(request.IosBundleId??"com.example.tenant"+request.TenantId) || firebase.DistributionGroupAlias!=google.DistributionGroupAlias)
            throw new InvalidOperationException("The mobile Firebase target belongs to another tenant or deployment.");
        return firebase;
    }
    private AndroidReleasePlan Expected(TenantProvisioningRequest request,TenantFirebaseConfiguration firebase,AndroidSigningKey key,string source)
    {
        if(!MobileReleaseFiles.Digest(source))throw new InvalidOperationException("Invalid mobile source fingerprint.");
        return new(1,request.TenantId,deployment.DeploymentId,firebase.AndroidPackageName,firebase.ProjectId,firebase.ProjectNumber,
            firebase.AndroidAppId,deployment.StoreUrl(request.Slug),options.BuildNumber,source,key.CertificateSha256,Path.GetFullPath(options.ArtifactDirectory));
    }
    public async Task ValidateSavedPlanAsync(TenantProvisioningRequest request,bool checkpoint,CancellationToken ct)
    {
        request.Validate();
        if(request.MobileReleaseProfile!="AndroidAppDistribution")throw new InvalidOperationException("The queued request did not select automatic signed Android distribution.");
        if(request.DeploymentId!=null && request.DeploymentId!=deployment.DeploymentId)throw new InvalidOperationException("Mobile job targets another deployment.");
        var existing=await FindAsync(request.TenantId,PlanSecret,ct);
        if(existing==null){if(checkpoint)throw new InvalidOperationException("The original mobile release binding is missing.");return;}
        var firebase=await FirebaseAsync(request,ct);var key=await signing.ReadAsync(request.TenantId,firebase.AndroidPackageName,ct);
        if(MobileReleaseFiles.Parse<AndroidReleasePlan>(existing)!=Expected(request,firebase,key,await builder.SourceHashAsync(ct)))
            throw new InvalidOperationException("The original mobile release source, version, signing identity or target changed.");
    }
    private static void Match(AndroidReleaseReceipt receipt,AndroidReleasePlan plan)
    {
        if(receipt.TenantId!=plan.TenantId || receipt.AndroidApplicationId!=plan.AndroidApplicationId || receipt.ProjectId!=plan.ProjectId ||
            receipt.ProjectNumber!=plan.ProjectNumber || receipt.AndroidAppId!=plan.AndroidAppId || receipt.StoreUrl!=plan.StoreUrl ||
            receipt.BuildNumber!=plan.BuildNumber || receipt.SourceHash!=plan.SourceHash || receipt.SigningCertificateSha256!=plan.SigningCertificateSha256 ||
            !MobileReleaseFiles.Digest(receipt.Sha256))throw new InvalidOperationException("The built Android artifact does not match its immutable tenant release plan.");
    }
    private string ArtifactPath(AndroidReleaseReceipt receipt)
    {
        if(!Guid.TryParseExact(receipt.TenantId,"N",out var tenant) || tenant==Guid.Empty || tenant.ToString("N")!=receipt.TenantId ||
            !MobileReleaseFiles.Digest(receipt.Sha256))throw new InvalidOperationException("Invalid immutable APK identity or digest.");
        var directory=Path.Combine(options.ArtifactDirectory,receipt.TenantId);MobileReleaseFiles.PrivateDirectory(directory);
        return Path.Combine(directory,receipt.Sha256+".apk");
    }
    private async Task VerifyAsync(string path,AndroidReleaseReceipt receipt,AndroidReleasePlan plan,CancellationToken ct)
    {
        Match(receipt,plan);
        if(await MobileReleaseFiles.HashAsync(path,ct)!=receipt.Sha256 || await builder.VerifyAsync(path,receipt,ct)!=receipt)
            throw new InvalidOperationException("The durable Android artifact signature, content or metadata changed.");
    }
    private async Task PromoteAsync(string source,string target,CancellationToken ct)
    {
        if(File.Exists(target))return;
        var temporary=target+"."+Guid.NewGuid().ToString("N")+".tmp";
        try
        {
            var settings=new FileStreamOptions{Mode=FileMode.CreateNew,Access=FileAccess.Write,Share=FileShare.None};
            if(!OperatingSystem.IsWindows())settings.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
            await using(var output=new FileStream(temporary,settings))
            await using(var input=File.OpenRead(source)){await input.CopyToAsync(output,ct);await output.FlushAsync(ct);}
            ct.ThrowIfCancellationRequested();
            try{File.Move(temporary,target,false);}catch(IOException)when(File.Exists(target)){}
        }
        finally{if(File.Exists(temporary))File.Delete(temporary);}
    }
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {
        request.Validate();await ValidateSavedPlanAsync(request,false,ct);
        if(!completed.TryGetValue("publication",out var publication) || publication.Resources.GetValueOrDefault("readiness")!="Verified" ||
            publication.Resources.GetValueOrDefault("storeUrl")!=deployment.StoreUrl(request.Slug) || !completed.TryGetValue("google-firebase",out var cloud))
            throw new InvalidOperationException("Mobile release requires verified public tenant readiness and Google provisioning.");
        var firebase=await FirebaseAsync(request,ct);
        if(cloud.Resources.GetValueOrDefault("projectId")!=firebase.ProjectId || cloud.Resources.GetValueOrDefault("androidAppId")!=firebase.AndroidAppId)
            throw new InvalidOperationException("The Google checkpoint does not match the saved tenant Firebase app.");
        var source=await builder.SourceHashAsync(ct);var key=await signing.GetOrCreateAsync(request.TenantId,firebase.AndroidPackageName,ct);
        var expected=Expected(request,firebase,key,source);
        var plan=MobileReleaseFiles.Parse<AndroidReleasePlan>(await secrets.GetOrCreateAsync(request.TenantId,PlanSecret,()=>JsonSerializer.Serialize(expected,MobileReleaseFiles.Json),ct));
        if(plan!=expected)throw new InvalidOperationException("The initial Android release target has changed.");
        var saved=await FindAsync(request.TenantId,ArtifactSecret,ct);
        AndroidReleaseReceipt receipt;
        if(saved==null)
        {
            var built=await builder.BuildAsync(request,firebase,key,plan,ct);
            try
            {
                await VerifyAsync(built.Path,built.Receipt,plan,ct);
                await PromoteAsync(built.Path,ArtifactPath(built.Receipt),ct);
                // Concurrent/reclaimed workers select a single immutable binary before any upload.
                saved=await secrets.GetOrCreateAsync(request.TenantId,ArtifactSecret,()=>JsonSerializer.Serialize(built.Receipt,MobileReleaseFiles.Json),ct);
            }
            finally
            {
                if(built.AttemptDirectory!=null)
                {
                    var parent=Path.Combine(Path.GetFullPath(options.WorkingDirectory),request.TenantId)+Path.DirectorySeparatorChar;
                    if(!Path.GetFullPath(built.AttemptDirectory).StartsWith(parent,StringComparison.Ordinal))throw new InvalidOperationException("Refusing to clean an unowned mobile build directory.");
                    Directory.Delete(built.AttemptDirectory,recursive:true);
                }
            }
        }
        receipt=MobileReleaseFiles.Parse<AndroidReleaseReceipt>(saved);Match(receipt,plan);
        var binary=ArtifactPath(receipt);await VerifyAsync(binary,receipt,plan,ct);ct.ThrowIfCancellationRequested();
        var distributed=await FindAsync(request.TenantId,DistributionSecret,ct);
        string release;
        if(distributed!=null)
        {
            release=distributed;await distribution.VerifyReleaseAsync(firebase,"android",release,plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture),ct);
        }
        else
        {
            release=await distribution.UploadAndDistributeAsync(firebase,"android",binary,ct);ct.ThrowIfCancellationRequested();
            var winner=await secrets.GetOrCreateAsync(request.TenantId,DistributionSecret,()=>release,ct);
            if(winner!=release)throw new InvalidOperationException("The initial Android release acquired a different distribution identity.");
        }
        return new("AndroidAppDistribution",new Dictionary<string,string>{["androidAppId"]=plan.AndroidAppId,["androidApplicationId"]=plan.AndroidApplicationId,
            ["buildNumber"]=plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture),["sourceHash"]=plan.SourceHash,
            ["sha256"]=receipt.Sha256,["signingCertificateSha256"]=plan.SigningCertificateSha256,["release"]=release});
    }
}
