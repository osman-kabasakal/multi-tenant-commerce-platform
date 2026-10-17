using System.Text;
using System.Text.Json;
using Platform.Google;

namespace Platform.Provisioning.Adapters;

public sealed record AndroidReleasePlan(int Version,string TenantId,string DeploymentId,string AndroidApplicationId,
    string ProjectId,string ProjectNumber,string AndroidAppId,string StoreUrl,int BuildNumber,string SourceHash,
    string SigningCertificateSha256,string ArtifactDirectory)
{
    [System.Text.Json.Serialization.JsonIgnore(Condition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull)]
    public MobileBranding? Branding {get;init;}
}
public sealed record AndroidReleaseReceipt(string TenantId,string AndroidApplicationId,string ProjectId,string ProjectNumber,
    string AndroidAppId,string StoreUrl,int BuildNumber,string SourceHash,string SigningCertificateSha256,string Sha256)
{
    [System.Text.Json.Serialization.JsonIgnore(Condition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull)]
    public MobileBranding? Branding {get;init;}
}
public sealed record AndroidBuiltArtifact(string Path,AndroidReleaseReceipt Receipt,string? AttemptDirectory=null);

public interface IAndroidReleaseBuilder
{
    Task<string> SourceHashAsync(CancellationToken ct);
    Task<AndroidBuiltArtifact> BuildAsync(TenantProvisioningRequest request,TenantFirebaseConfiguration firebase,
        AndroidSigningKey signing,AndroidReleasePlan plan,CancellationToken ct);
    Task<AndroidReleaseReceipt> VerifyAsync(string path,AndroidReleaseReceipt expected,CancellationToken ct);
}

public sealed class AndroidReleaseBuilder(AndroidReleaseOptions options,MobileBrandingStore? branding=null) : IAndroidReleaseBuilder
{
    public async Task<string> SourceHashAsync(CancellationToken ct)
    {
        var value=await MobileProcess.RunAsync(options.PythonPath,[options.Script,"--source-hash"],options.SourceDirectory,null,TimeSpan.FromMinutes(2),ct);
        if(!MobileReleaseFiles.Digest(value))throw new InvalidOperationException("Invalid mobile source fingerprint.");
        return value;
    }
    public async Task<AndroidBuiltArtifact> BuildAsync(TenantProvisioningRequest request,TenantFirebaseConfiguration firebase,
        AndroidSigningKey signing,AndroidReleasePlan plan,CancellationToken ct)
    {
        var version=await MobileProcess.RunAsync(options.FlutterPath,["--version","--machine"],options.SourceDirectory,null,TimeSpan.FromMinutes(2),ct);
        using(var value=JsonDocument.Parse(version))
            if(value.RootElement.GetProperty("frameworkVersion").GetString()!="3.44.6" ||
                value.RootElement.GetProperty("frameworkRevision").GetString()!="ee80f08bbf97172ec030b8751ceab557177a34a6")
                throw new InvalidOperationException("Install the pinned Flutter revision before automatic release builds.");
        var owner=Path.Combine(options.WorkingDirectory,request.TenantId);MobileReleaseFiles.PrivateDirectory(owner);
        var attempt=Path.Combine(owner,Guid.NewGuid().ToString("N"));MobileReleaseFiles.PrivateDirectory(attempt);
        var inputs=Path.Combine(attempt,"inputs");MobileReleaseFiles.PrivateDirectory(inputs);
        var keyPath=Path.Combine(inputs,"signing.p12");var properties=Path.Combine(inputs,"signing.properties");
        var workspace=Path.Combine(attempt,"workspace");var builtSuccessfully=false;
        try
        {
            await FirebaseClientFiles.ExportAsync(firebase,inputs,ct);
            await MobileBrandingFiles.ExportAsync(branding,request.TenantId,plan.Branding,inputs,ct);
            var manifest=Path.Combine(inputs,"tenant.json");
            await MobileReleaseFiles.WriteAsync(manifest,JsonSerializer.SerializeToUtf8Bytes(new {
                tenantId=request.TenantId,slug=request.Slug,displayName=request.StoreName,baseUrl=plan.StoreUrl,localDemo=false,verifiedDomain=request.Domain,branding=plan.Branding,
                androidApplicationId=firebase.AndroidPackageName,iosBundleId=firebase.IosBundleId,
                firebase=new{enabled=true,projectId=firebase.ProjectId,projectNumber=firebase.ProjectNumber,androidAppId=firebase.AndroidAppId,iosAppId=firebase.IosAppId}
            },MobileReleaseFiles.Json),ct);
            await MobileReleaseFiles.WriteAsync(keyPath,Convert.FromBase64String(signing.KeyStoreBase64),ct);
            var escaped=keyPath.Replace("\\","\\\\",StringComparison.Ordinal);
            await MobileReleaseFiles.WriteAsync(properties,Encoding.UTF8.GetBytes("storeFile="+escaped+"\nstorePassword="+signing.Password+
                "\nkeyAlias="+signing.KeyAlias+"\nkeyPassword="+signing.Password+"\n"),ct);
            await MobileProcess.RunAsync(options.PythonPath,[options.Script,manifest,"--firebase-directory",inputs,"--workspace",workspace,
                "--build-number",plan.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture),"--build","--signing-properties",properties,
                "--flutter",options.FlutterPath,"--android-sdk",options.AndroidSdkDirectory],options.SourceDirectory,null,TimeSpan.FromSeconds(options.BuildTimeoutSeconds),ct);
            var resultPath=Path.Combine(workspace,"build-result.json");MobileReleaseFiles.RegularFile(resultPath,65536);
            var json=await File.ReadAllTextAsync(resultPath,ct);var receipt=MobileReleaseFiles.Parse<AndroidReleaseReceipt>(json);
            using var document=JsonDocument.Parse(json);var relative=document.RootElement.GetProperty("artifact").GetString()??throw new InvalidOperationException("Missing APK result.");
            if(Path.IsPathFullyQualified(relative))throw new InvalidOperationException("The APK result must stay in its isolated workspace.");
            var binary=Path.GetFullPath(Path.Combine(workspace,relative));
            if(!binary.StartsWith(workspace+Path.DirectorySeparatorChar,StringComparison.Ordinal) || Path.GetExtension(binary)!=".apk")
                throw new InvalidOperationException("The APK result escaped its isolated workspace.");
            MobileReleaseFiles.RegularFile(binary,1024L*1024*1024);
            builtSuccessfully=true;return new(binary,receipt,attempt);
        }
        finally
        {
            // Durable signing material stays only in the shared encrypted secret store.
            if(File.Exists(properties))File.Delete(properties);
            if(File.Exists(keyPath))File.Delete(keyPath);
            if(!builtSuccessfully && Directory.Exists(workspace))
            {
                var diagnostics=Path.Combine(workspace,"build.log");
                if(File.Exists(diagnostics))File.Move(diagnostics,Path.Combine(attempt,"build.log"),true);
                Directory.Delete(workspace,recursive:true);
            }
        }
    }
    public async Task<AndroidReleaseReceipt> VerifyAsync(string path,AndroidReleaseReceipt expected,CancellationToken ct)
    {
        MobileReleaseFiles.RegularFile(path,1024L*1024*1024);
        var directory=Path.Combine(options.WorkingDirectory,"verify-"+Guid.NewGuid().ToString("N"));MobileReleaseFiles.PrivateDirectory(directory);
        try
        {
            var metadata=Path.Combine(directory,"expected.json");await MobileReleaseFiles.WriteAsync(metadata,JsonSerializer.SerializeToUtf8Bytes(expected,MobileReleaseFiles.Json),ct);
            var json=await MobileProcess.RunAsync(options.PythonPath,[options.Script,"--verify-apk",path,"--expected-build",metadata,"--android-sdk",options.AndroidSdkDirectory,
                "--build-number",expected.BuildNumber.ToString(System.Globalization.CultureInfo.InvariantCulture)],options.SourceDirectory,null,TimeSpan.FromMinutes(2),ct);
            return MobileReleaseFiles.Parse<AndroidReleaseReceipt>(json);
        }
        finally {Directory.Delete(directory,recursive:true);}
    }
}
