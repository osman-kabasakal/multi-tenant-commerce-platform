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
    ITenantSecrets secrets,TenantAndroidSigningKeys signing,IAndroidReleaseBuilder builder,FirebaseAppDistribution distribution,FirebaseAppIdentity appIdentity)
{
    private static readonly SemaphoreSlim BuildLane=new(1,1);
    public const string PlanSecret="android-initial-release-plan-v1";
    public const string ArtifactSecret="android-initial-release-artifact-v1";
    public const string DistributionSecret="android-initial-release-distribution-v1";

    private static string Secret(string initial,Guid? release,AndroidBuildScope? scope=null)=>scope?.SourceHash!=null ? initial.Replace("initial","identity-"+scope.IdentityId.ToString("N"),StringComparison.Ordinal) : release is {} id ? initial.Replace("initial",id.ToString("N"),StringComparison.Ordinal) : initial;

    private async Task<string?> FindAsync(string tenant,string name,CancellationToken ct)
    {try{return await secrets.GetAsync(tenant,name,ct);}catch(KeyNotFoundException){return null;}}
    private async Task<TenantFirebaseConfiguration> FirebaseAsync(TenantProvisioningRequest request,CancellationToken ct,AndroidBuildScope? scope=null)
    {
        var firebase=MobileReleaseFiles.Parse<TenantFirebaseConfiguration>(await secrets.GetAsync(request.TenantId,scope?.FirebaseSecretName??TenantFirebaseConfiguration.SecretName,ct));
        FirebaseConfigValidator.Validate(firebase);
        if(firebase.TenantId!=request.TenantId || firebase.ProjectId!=google.ProjectId(request.TenantId) ||
            firebase.AndroidPackageName!=(scope?.AndroidPackageName??request.AndroidPackageName??"com.example.tenant"+request.TenantId) ||
            firebase.IosBundleId!=(scope?.IosBundleId??request.IosBundleId??"com.example.tenant"+request.TenantId) || firebase.DistributionGroupAlias!=google.DistributionGroupAlias)
            throw new InvalidOperationException("The mobile Firebase target belongs to another tenant or deployment.");
        if(scope!=null && (firebase.ProjectId!=scope.ProjectId || firebase.ProjectNumber!=scope.ProjectNumber || firebase.AndroidAppId!=scope.AndroidAppId))
            throw new InvalidOperationException("The saved Firebase identity differs from the queued build scope.");
        return firebase;
    }
    private AndroidReleasePlan Expected(TenantProvisioningRequest request,TenantFirebaseConfiguration firebase,AndroidSigningKey key,string source,int? buildNumber=null,AndroidBuildScope? scope=null)
    {
        if(!MobileReleaseFiles.Digest(source))throw new InvalidOperationException("Invalid mobile source fingerprint.");
        return new(1,request.TenantId,deployment.DeploymentId,firebase.AndroidPackageName,firebase.ProjectId,firebase.ProjectNumber,
            firebase.AndroidAppId,scope?.StoreUrl??deployment.StoreUrl(request),buildNumber??options.BuildNumber,source,key.CertificateSha256,Path.GetFullPath(options.ArtifactDirectory)){Branding=scope?.Branding??request.Branding};
    }
    public async Task ValidateSavedPlanAsync(TenantProvisioningRequest request,bool checkpoint,CancellationToken ct,Guid? releaseId=null,int? buildNumber=null,AndroidBuildScope? scope=null)
    {
        request.Validate();scope?.Validate(request.TenantId,deployment.DeploymentId);
        if(request.MobileReleaseProfile is not ("AndroidAppDistribution" or "AndroidIosAppDistribution"))throw new InvalidOperationException("The queued request did not select automatic signed Android distribution.");
        if(request.DeploymentId!=null && request.DeploymentId!=deployment.DeploymentId)throw new InvalidOperationException("Mobile job targets another deployment.");
        var existing=await FindAsync(request.TenantId,Secret(PlanSecret,releaseId,scope),ct);
        if(existing==null){if(checkpoint)throw new InvalidOperationException("The original mobile release binding is missing.");return;}
        var firebase=await FirebaseAsync(request,ct,scope);var key=scope?.Legacy==false ? await signing.ReadPackageAsync(request.TenantId,firebase.AndroidPackageName,ct) : await signing.ReadAsync(request.TenantId,firebase.AndroidPackageName,ct);
        if(MobileReleaseFiles.Parse<AndroidReleasePlan>(existing)!=Expected(request,firebase,key,await builder.SourceHashAsync(ct),buildNumber,scope))
            throw new InvalidOperationException("The original mobile release source, version, signing identity or target changed.");
    }
    private static void Match(AndroidReleaseReceipt receipt,AndroidReleasePlan plan)
    {
        if(receipt.TenantId!=plan.TenantId || receipt.AndroidApplicationId!=plan.AndroidApplicationId || receipt.ProjectId!=plan.ProjectId ||
            receipt.ProjectNumber!=plan.ProjectNumber || receipt.AndroidAppId!=plan.AndroidAppId || receipt.StoreUrl!=plan.StoreUrl ||
            receipt.Branding!=plan.Branding || receipt.BuildNumber!=plan.BuildNumber || receipt.SourceHash!=plan.SourceHash || receipt.SigningCertificateSha256!=plan.SigningCertificateSha256 ||
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
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct,Guid? releaseId=null,int? buildNumber=null,AndroidBuildScope? scope=null)
    {
        request.Validate();scope?.Validate(request.TenantId,deployment.DeploymentId);
        await BuildLane.WaitAsync(ct);
        try
        {
        if(releaseId==Guid.Empty || (releaseId.HasValue != buildNumber.HasValue) || buildNumber is <=0)throw new ArgumentException("A manual Android release requires its own identity and version.");
        await ValidateSavedPlanAsync(request,false,ct,releaseId,buildNumber,scope);
        if(!completed.TryGetValue("publication",out var publication) || publication.Resources.GetValueOrDefault("readiness")!="Verified" ||
            (scope==null && publication.Resources.GetValueOrDefault("storeUrl")!=deployment.StoreUrl(request)) || !completed.TryGetValue("google-firebase",out var cloud))
            throw new InvalidOperationException("Mobile release requires verified public tenant readiness and Google provisioning.");
        var firebase=await FirebaseAsync(request,ct,scope);
        if(cloud.Resources.GetValueOrDefault("projectId")!=firebase.ProjectId || (scope==null && cloud.Resources.GetValueOrDefault("androidAppId")!=firebase.AndroidAppId))
            throw new InvalidOperationException("The Google checkpoint does not match the saved tenant Firebase app.");
        var source=await builder.SourceHashAsync(ct);
        if(scope?.SourceHash!=null && scope.SourceHash!=source)throw new InvalidOperationException("The prepared Android source changed.");
        var key=scope?.Legacy==false ? await signing.ReadPackageAsync(request.TenantId,firebase.AndroidPackageName,ct) : releaseId.HasValue ? await signing.ReadAsync(request.TenantId,firebase.AndroidPackageName,ct) : await signing.GetOrCreateAsync(request.TenantId,firebase.AndroidPackageName,ct);
        if(scope==null && releaseId.HasValue && (!completed.TryGetValue("mobile-android-release",out var initial) || initial.Resources.GetValueOrDefault("signingCertificateSha256")!=key.CertificateSha256))
            throw new InvalidOperationException("Manual releases must retain the original tenant signing identity.");
        if(scope!=null && key.CertificateSha256!=scope.CertificateSha256)throw new InvalidOperationException("The queued package signing certificate changed.");
        var expected=Expected(request,firebase,key,source,buildNumber,scope);
        var plan=MobileReleaseFiles.Parse<AndroidReleasePlan>(await secrets.GetOrCreateAsync(request.TenantId,Secret(PlanSecret,releaseId,scope),()=>JsonSerializer.Serialize(expected,MobileReleaseFiles.Json),ct));
        if(plan!=expected)throw new InvalidOperationException("The initial Android release target has changed.");
        var saved=await FindAsync(request.TenantId,Secret(ArtifactSecret,releaseId,scope),ct);
        AndroidReleaseReceipt receipt;
        if(saved==null)
        {
            var buildRequest=scope==null?request:request with {AndroidPackageName=scope.AndroidPackageName,IosBundleId=scope.IosBundleId,Domain=scope.Domain};
            var built=await builder.BuildAsync(buildRequest,firebase,key,plan,ct);
            try
            {
                await VerifyAsync(built.Path,built.Receipt,plan,ct);
                await PromoteAsync(built.Path,ArtifactPath(built.Receipt),ct);
                // Concurrent/reclaimed workers select a single immutable binary before any upload.
                saved=await secrets.GetOrCreateAsync(request.TenantId,Secret(ArtifactSecret,releaseId,scope),()=>JsonSerializer.Serialize(built.Receipt,MobileReleaseFiles.Json),ct);
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
        await appIdentity.EnsureAndroidSigningAsync(firebase,key.CertificateBase64,key.CertificateSha256,ct);
        var distributed=await FindAsync(request.TenantId,Secret(DistributionSecret,releaseId,scope),ct);
        string release;
        if(distributed!=null)
        {
            release=distributed;await distribution.VerifyReleaseAsync(firebase,"android",release,plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture),ct);
        }
        else
        {
            release=await distribution.UploadAndDistributeAsync(firebase,"android",binary,ct);ct.ThrowIfCancellationRequested();
            var winner=await secrets.GetOrCreateAsync(request.TenantId,Secret(DistributionSecret,releaseId,scope),()=>release,ct);
            if(winner!=release)throw new InvalidOperationException("The initial Android release acquired a different distribution identity.");
        }
        var result=new ProvisioningStepResult("AndroidAppDistribution",new Dictionary<string,string>{["androidAppId"]=plan.AndroidAppId,["androidApplicationId"]=plan.AndroidApplicationId,
            ["buildNumber"]=plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture),["sourceHash"]=plan.SourceHash,
            ["fileSize"]=new FileInfo(binary).Length.ToString(System.Globalization.CultureInfo.InvariantCulture),["sha256"]=receipt.Sha256,["signingCertificateSha256"]=plan.SigningCertificateSha256,["release"]=release});
        if(scope!=null)result=result with {Resources=new Dictionary<string,string>(result.Resources){["storeUrl"]=plan.StoreUrl}};
        if(plan.Branding!=null)result=result with {Resources=new Dictionary<string,string>(result.Resources){["brandingSha256"]=plan.Branding.Sha256}};
        scope?.ValidateReceipt(result,plan.BuildNumber);return result;
        }
        finally{BuildLane.Release();}
    }
}
