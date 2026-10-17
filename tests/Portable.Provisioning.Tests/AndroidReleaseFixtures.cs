using System.Collections.Concurrent;
using System.Net;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Configuration;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace Portable.Provisioning.Tests;

internal sealed class AndroidSecrets : ITenantSecrets
{
    public ConcurrentDictionary<(string,string),string> Values {get;}=new();
    public Task ProvisionAsync(string tenant,string alias,CancellationToken ct=default)=>Task.CompletedTask;
    public Task BindAliasAsync(string tenant,string alias,CancellationToken ct=default)=>Task.CompletedTask;
    public Task<string> ResolveAsync(string tenant,CancellationToken ct=default)=>Task.FromResult(tenant);
    public Task<string> GetAsync(string tenant,string name,CancellationToken ct=default)=>Values.TryGetValue((tenant,name),out var value)?Task.FromResult(value):Task.FromException<string>(new KeyNotFoundException());
    public Task SetAsync(string tenant,string name,string value,CancellationToken ct=default){Values[(tenant,name)]=value;return Task.CompletedTask;}
    public Task<string> GetOrCreateAsync(string tenant,string name,Func<string> generate,CancellationToken ct=default)=>Task.FromResult(Values.GetOrAdd((tenant,name),_=>generate()));
}
internal sealed class AndroidKeys : IAndroidSigningKeyFactory
{
    public int Creates;
    public async Task<AndroidSigningKey> CreateAsync(string tenant,string package,CancellationToken ct)
    {
        Interlocked.Increment(ref Creates);await Task.Yield();
        using var rsa=RSA.Create(2048);var request=new CertificateRequest("CN=Synthetic Tenant Signing",rsa,HashAlgorithmName.SHA256,RSASignaturePadding.Pkcs1);
        using var certificate=request.CreateSelfSigned(DateTimeOffset.UtcNow.AddDays(-1),DateTimeOffset.UtcNow.AddDays(10000));
        var password=Convert.ToHexString(RandomNumberGenerator.GetBytes(32));
        return new(1,tenant,package,"tenant",password,Convert.ToBase64String(certificate.Export(X509ContentType.Pfx,password)),Convert.ToHexString(SHA256.HashData(certificate.RawData)).ToLowerInvariant(),Convert.ToBase64String(certificate.RawData));
    }
    public Task VerifyAsync(AndroidSigningKey key,CancellationToken ct){key.Validate(key.TenantId,key.PackageName);return Task.CompletedTask;}
}
internal sealed class AndroidBuilder(string root) : IAndroidReleaseBuilder
{
    public string SourceHash=new('a',64);public int Builds,Verifications;public Func<AndroidReleaseReceipt,AndroidReleaseReceipt>? Alter {get;set;}
    public bool RejectSignature {get;set;}
    public Task<string> SourceHashAsync(CancellationToken ct)=>Task.FromResult(SourceHash);
    public async Task<AndroidBuiltArtifact> BuildAsync(TenantProvisioningRequest request,TenantFirebaseConfiguration firebase,AndroidSigningKey key,AndroidReleasePlan plan,CancellationToken ct)
    {
        var number=Interlocked.Increment(ref Builds);var path=Path.Combine(root,"candidate-"+Guid.NewGuid().ToString("N")+".apk");
        var bytes=Encoding.UTF8.GetBytes("Synthetic interface-only APK "+request.TenantId+" "+number);await File.WriteAllBytesAsync(path,bytes,ct);
        var receipt=new AndroidReleaseReceipt(request.TenantId,firebase.AndroidPackageName,firebase.ProjectId,firebase.ProjectNumber,firebase.AndroidAppId,
            plan.StoreUrl,plan.BuildNumber,SourceHash,key.CertificateSha256,Convert.ToHexString(SHA256.HashData(bytes)).ToLowerInvariant());
        return new(path,Alter?.Invoke(receipt)??receipt);
    }
    public Task<AndroidReleaseReceipt> VerifyAsync(string path,AndroidReleaseReceipt expected,CancellationToken ct)
    {
        Interlocked.Increment(ref Verifications);
        if(RejectSignature)throw new InvalidOperationException("Synthetic verifier rejected the artifact.");
        return Task.FromResult(expected);
    }
}
internal sealed class AndroidToken : IGoogleAccessTokenSource
{public Task<string> GetAsync(string scope,CancellationToken ct)=>Task.FromResult("synthetic-contract-access");}
internal sealed class AndroidGoogle : HttpMessageHandler
{
    public Dictionary<string,TenantFirebaseConfiguration> Tenants=new();public int Uploads,Deliveries,ReleaseReads,Requests;
    public bool FailUploadOnce,FailDistributeOnce;public bool ForeignProject {get;set;}public string BuildVersion="1";
    public List<string> BinaryHashes=[];public List<string> Groups=[];
    public Dictionary<string,JsonArray> Certificates=new();public int CertificateWrites;public bool FailCertificateOnce;
    private static HttpResponseMessage Reply(object value,HttpStatusCode status=HttpStatusCode.OK)=>new(status){Content=new StringContent(JsonSerializer.Serialize(value),Encoding.UTF8,"application/json")};
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,CancellationToken ct)
    {
        Requests++;var path=request.RequestUri!.AbsolutePath;
        if(request.RequestUri.Host=="cloudresourcemanager.googleapis.com")
        {
            var tenant=Tenants[path.Split('/').Last()];
            return Reply(new{projectId=tenant.ProjectId,name="projects/"+tenant.ProjectNumber,parent="folders/123456",state="ACTIVE",
                labels=new Dictionary<string,string>{{"platform-tenant",ForeignProject?new string('f',32):tenant.TenantId},{"platform-deployment","android-contract"}}});
        }
        if(request.RequestUri.Host=="firebase.googleapis.com")
        {
            var parts=Uri.UnescapeDataString(path).Split('/');var config=Tenants[parts[3]];
            if(parts[^1]=="sha")
            {
                if(!Certificates.TryGetValue(config.AndroidAppId,out var items))Certificates[config.AndroidAppId]=items=new();
                if(request.Method==HttpMethod.Post){CertificateWrites++;if(FailCertificateOnce){FailCertificateOnce=false;return Reply(new{},HttpStatusCode.ServiceUnavailable);}var cert=JsonNode.Parse(await request.Content!.ReadAsStringAsync(ct))!.AsObject();cert["name"]=$"projects/{config.ProjectId}/androidApps/{config.AndroidAppId}/sha/"+cert["shaHash"]!.GetValue<string>();items.Add(cert);return Reply(cert);}
                return Reply(new{certificates=items});
            }
            return Reply(new{name=$"projects/{config.ProjectId}/androidApps/{config.AndroidAppId}",appId=config.AndroidAppId,packageName=config.AndroidPackageName,state="ACTIVE"});
        }
        if(path.StartsWith("/upload/v1/",StringComparison.Ordinal))
        {
            Uploads++;BinaryHashes.Add(Convert.ToHexString(SHA256.HashData(await request.Content!.ReadAsByteArrayAsync(ct))).ToLowerInvariant());
            if(FailUploadOnce){FailUploadOnce=false;return Reply(new{error="private-provider-detail"},HttpStatusCode.ServiceUnavailable);}
            var resource=path["/upload/v1/".Length..].Replace("/releases:upload","/releases/initial",StringComparison.Ordinal);
            return Reply(new{done=true,response=new{release=new{name=resource,buildVersion=BuildVersion}}});
        }
        if(request.Method==HttpMethod.Post && path.EndsWith(":distribute",StringComparison.Ordinal))
        {
            if(FailDistributeOnce){FailDistributeOnce=false;return Reply(new{error="private-provider-detail"},HttpStatusCode.ServiceUnavailable);}
            Deliveries++;using var json=JsonDocument.Parse(await request.Content!.ReadAsStringAsync(ct));Groups.Add(json.RootElement.GetProperty("groupAliases")[0].GetString()!);return Reply(new{});
        }
        if(request.Method==HttpMethod.Get && path.Contains("/releases/",StringComparison.Ordinal))
        {ReleaseReads++;return Reply(new{name=path["/v1/".Length..],buildVersion=BuildVersion});}
        throw new InvalidOperationException("Unexpected synthetic Google request: "+path);
    }
}
internal sealed class AndroidFixture : IDisposable
{
    public string Root=Path.Combine(OperatingSystem.IsMacOS()?"/private/tmp":Path.GetTempPath(),"android-release-"+Guid.NewGuid().ToString("N"));
    public readonly AndroidSecrets Secrets=new();public readonly AndroidKeys Keys=new();public AndroidBuilder Builder;
    public readonly AndroidGoogle Server=new();public readonly GoogleCloudOptions Google=new(){AllowCloudWrites=true,DeploymentId="android-contract",ProjectIdPrefix="android",Parent="folders/123456",SenderServiceAccount="sender-account@sender-project.iam.gserviceaccount.com"};
    public readonly PortableOnboardingOptions Deployment=new(){DeploymentId="android-contract",StoreBaseUrl="https://shops.example.test",AdminBaseUrl="https://manage.example.test"};
    public AndroidReleaseOptions Options;public TenantProvisioningRequest Request;public TenantFirebaseConfiguration Firebase;public Dictionary<string,ProvisioningStepResult> Completed;
    public AndroidFixture()
    {
        Directory.CreateDirectory(Root);Builder=new(Root);var source=Path.Combine(Root,"source");
        foreach(var path in new[]{"scripts/mobile_android.py","Platforms/store_user_app/pubspec.lock","Platforms/store_user_app/lib/core/config/tenant_firebase_identity.dart"})
        {var full=Path.Combine(source,path);Directory.CreateDirectory(Path.GetDirectoryName(full)!);File.WriteAllText(full,"Synthetic source fixture");}
        var sdk=Path.Combine(Root,"sdk");var buildTools=Path.Combine(sdk,"build-tools",AndroidReleaseOptions.BuildToolsVersion);Directory.CreateDirectory(buildTools);
        foreach(var tool in new[]{"aapt2","apksigner"})File.WriteAllText(Path.Combine(buildTools,tool+(OperatingSystem.IsWindows()?(tool=="apksigner"?".bat":".exe"):"")),"Synthetic tool fixture");
        Options=new(){AllowSigningKeyCreation=true,SharedArtifactsConfirmed=true,SourceDirectory=source,WorkingDirectory=Path.Combine(Root,"work"),ArtifactDirectory=Path.Combine(Root,"artifacts"),
            PythonPath=Environment.ProcessPath!,FlutterPath=Environment.ProcessPath!,KeytoolPath=Environment.ProcessPath!,AndroidSdkDirectory=sdk};
        Directory.CreateDirectory(Options.WorkingDirectory);Directory.CreateDirectory(Options.ArtifactDirectory);
        var id=Guid.NewGuid().ToString("N");Request=new(id,"android-"+id[..10],"Android Store","owner@example.com","Owner","Probe","Address","5551234567","store@example.com",DeploymentId:Deployment.DeploymentId,MobileReleaseProfile:"AndroidAppDistribution");
        Firebase=AddTenant(Request);Completed=Checkpoints(Request,Firebase);
    }
    public TenantFirebaseConfiguration AddTenant(TenantProvisioningRequest request)
    {
        var number=(100000+Server.Tenants.Count).ToString(System.Globalization.CultureInfo.InvariantCulture);var package="com.example.tenant"+request.TenantId;
        var project=Google.ProjectId(request.TenantId);var android="1:"+number+":android:"+request.TenantId[..12];var ios="1:"+number+":ios:"+request.TenantId[..12];
        var json=JsonSerializer.Serialize(new{project_info=new{project_id=project,project_number=number},client=new[]{new{client_info=new{mobilesdk_app_id=android,android_client_info=new{package_name=package}}}}});
        var plist=$"<plist><dict><key>PROJECT_ID</key><string>{project}</string><key>GCM_SENDER_ID</key><string>{number}</string><key>GOOGLE_APP_ID</key><string>{ios}</string><key>BUNDLE_ID</key><string>{package}</string></dict></plist>";
        var value=new TenantFirebaseConfiguration(request.TenantId,project,number,Google.SenderServiceAccount,android,ios,package,package,json,plist,Google.DistributionGroupAlias);
        Server.Tenants.Add(project,value);Secrets.Values[(request.TenantId,TenantFirebaseConfiguration.SecretName)]=JsonSerializer.Serialize(value);return value;
    }
    public Dictionary<string,ProvisioningStepResult> Checkpoints(TenantProvisioningRequest request,TenantFirebaseConfiguration firebase)=>new(){
        ["publication"]=new("Portable",new Dictionary<string,string>{{"readiness","Verified"},{"storeUrl",Deployment.StoreUrl(request.Slug)}}),
        ["google-firebase"]=new("Google",new Dictionary<string,string>{{"projectId",firebase.ProjectId},{"androidAppId",firebase.AndroidAppId}})};
    public IConfiguration Configuration(params (string,string)[] updates)
    {
        var values=new Dictionary<string,string?>{{"LocalDemo:Enabled","false"},{"PlatformSecurity:Provider","AesGcm"},{"Provisioning:Profile","Portable"},{"Provisioning:Google:Provider","Google"},{"Provisioning:Google:AllowCloudWrites","true"}};
        foreach(var (key,value)in updates)values[key]=value;
        return new ConfigurationBuilder().AddInMemoryCollection(values).Build();
    }
    public AndroidReleasePipeline Pipeline(AndroidReleaseOptions? options=null,IAndroidReleaseBuilder? builder=null,ITenantSecrets? secrets=null)
    {
        var store=secrets??Secrets;var signing=new TenantAndroidSigningKeys(store,Keys);
        return new(options??Options,Deployment,Google,store,signing,builder??Builder,new FirebaseAppDistribution(new GoogleRestClient(new HttpClient(Server,disposeHandler:false),new AndroidToken()),Google),new FirebaseAppIdentity(new GoogleRestClient(new HttpClient(Server,disposeHandler:false),new AndroidToken()),Google));
    }
    public void Dispose(){Server.Dispose();Directory.Delete(Root,true);}
}
