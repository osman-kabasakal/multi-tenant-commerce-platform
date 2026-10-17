using System.Net.Http.Json;
using System.Text.Json;
using Platform.Google;
using Platform.Hosting;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class PortableTenantPublicationStep(PortableOnboardingOptions options,ITenantSecrets secrets,IHttpClientFactory clients,TenantDomainRegistry? domains=null,CustomDomainOptions? custom=null) : IProvisioningStep
{
    public string Name=>"publication";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {
        request.Validate();
        var storeUrl=options.StoreUrl(request);var adminUrl=options.AdminUrl(request);
        var storeId=completed["store"].Resources["storeId"];
        if (completed["identity"].Resources["clientId"]!=request.Slug || completed["domains"].Resources["storeHost"]!=new Uri(storeUrl).Host ||
            completed["domains"].Resources["adminHost"]!=new Uri(adminUrl).Host)
            throw new InvalidOperationException("Tenant publication checkpoints do not match their configured targets.");
        foreach (var phase in ManagedTenantStep.Tasks)
            if (!completed.TryGetValue(phase,out var checkpoint) ||
                !checkpoint.Resources.TryGetValue("storeId",out var installedStore) || installedStore!=storeId ||
                !checkpoint.Resources.TryGetValue("profileVersion",out var version) || version!="1")
                throw new InvalidOperationException("Complete all owned tenant installation phases before publication.");
        var route=Path.Combine(options.RouteDirectory,request.Slug+".json");
        // Only owned metadata is published. The ingress must authenticate the real tenant token.
        await WriteOwnedAsync(route,request.TenantId,JsonSerializer.Serialize(new {
            version=1,profile="Portable",tenantId=request.TenantId,slug=request.Slug,storeId,storeUrl=options.StoreUrl(request.Slug),adminUrl=options.AdminUrl(request.Slug)
        }),ct);
        if(request.Domain!=null)await PublishCustomAliasesAsync(request,storeId,ct);
        if(request.Domain is {} dnsDomain)
        {
            if(custom==null)throw new InvalidOperationException("Configure the trusted custom ingress before publication.");
            await TenantIngressProbe.WaitForCustomDnsAsync(dnsDomain,custom.OriginIpv4,ct);
        }
        using var ingress=clients.CreateClient(request.Domain==null?"onboarding-ingress":"onboarding-custom-ingress");
        await TenantIngressProbe.VerifyAsync(ingress,storeUrl,adminUrl,request.TenantId,storeId,ct);
        if(request.Domain is {} readyDomain)
            await domains!.MarkActiveAsync(readyDomain.Id,readyDomain.OwnerSubject,request.TenantId,options.DeploymentId,ct);
        object firebase=new {enabled=false,reason="Google/Firebase provisioning is explicitly disabled."};
        var cloud=completed.TryGetValue("google-firebase",out var google);
        if (cloud)
        {
            var value=await secrets.GetAsync(request.TenantId,TenantFirebaseConfiguration.SecretName,ct);
            var config=JsonSerializer.Deserialize<TenantFirebaseConfiguration>(value)??throw new InvalidOperationException("Missing tenant Firebase configuration.");
            if (config.TenantId!=request.TenantId || config.ProjectId!=google!.Resources["projectId"])
                throw new InvalidOperationException("Tenant Firebase ownership mismatch.");
            await FirebaseClientFiles.ExportAsync(config,Path.Combine(options.MobileDirectory,request.Slug),ct);
            firebase=new {enabled=true,projectId=config.ProjectId,projectNumber=config.ProjectNumber,androidAppId=config.AndroidAppId,iosAppId=config.IosAppId,
                androidConfigFile=request.Slug+"/google-services.json",iosConfigFile=request.Slug+"/GoogleService-Info.plist"};
        }
        await PrivateFiles.WriteAsync(Path.Combine(options.MobileDirectory,request.Slug+".json"),JsonSerializer.Serialize(new {
            tenantId=request.TenantId,slug=request.Slug,displayName=request.StoreName,baseUrl=storeUrl,localDemo=false,
            androidApplicationId=request.AndroidPackageName??"com.example.tenant"+request.TenantId,iosBundleId=request.IosBundleId??"com.example.tenant"+request.TenantId,firebase
        }),ct);
        await PrivateFiles.WriteAsync(Path.Combine(options.NotificationDirectory,request.Slug,"ready.json"),JsonSerializer.Serialize(new {
            version=1,tenantId=request.TenantId,recipient=request.OwnerEmail,title="Mağazanız hazır",storeUrl,adminUrl,eventType="tenant-ready"
        }),ct);
        return new("Portable",new Dictionary<string,string> { ["storeUrl"]=storeUrl,["adminUrl"]=adminUrl,
            ["notificationProvider"]="Outbox",["firebaseEnabled"]=cloud?"true":"false",["readiness"]="Verified" });
    }
    public async Task PublishCustomAliasesAsync(TenantProvisioningRequest request,string storeId,CancellationToken ct)
    {
        var storeUrl=options.StoreUrl(request);var adminUrl=options.AdminUrl(request);
        if(request.Domain is {} selected)
        {
            if(domains==null)throw new InvalidOperationException("The domain ownership registry is missing.");
            var binding=await domains.RequireVerifiedAsync(selected.Id,selected.OwnerSubject,request.TenantId,options.DeploymentId,ct);
            if(TenantDomainSelection.From(binding)!=selected)throw new InvalidOperationException("Custom route ownership differs from the saved request.");
            foreach(var (host,role) in new[]{(selected.StoreHost,"store"),(selected.AdminHost,"admin")})
            {
                var alias=new TenantCustomHostRoute(1,"Portable",request.TenantId,request.Slug,storeId,selected.Id,host,role,storeUrl,adminUrl,true);
                alias.Validate(host);
                await WriteOwnedAsync(TenantCustomHostRoutes.PathFor(options.RouteDirectory,host),request.TenantId,
                    JsonSerializer.Serialize(alias,new JsonSerializerOptions(JsonSerializerDefaults.Web)),ct);
            }
        }
    }
    public async Task VerifyCustomAsync(TenantProvisioningRequest request,string storeId,CancellationToken ct)
    {
        if(request.Domain==null || custom==null)throw new InvalidOperationException("A verified custom ingress is required.");
        await TenantIngressProbe.WaitForCustomDnsAsync(request.Domain,custom.OriginIpv4,ct);
        using var ingress=clients.CreateClient("onboarding-custom-ingress");
        await TenantIngressProbe.VerifyAsync(ingress,options.StoreUrl(request),options.AdminUrl(request),request.TenantId,storeId,ct);
    }
    private static async Task WriteOwnedAsync(string path,string tenant,string json,CancellationToken ct)
    {
        var settings=new FileStreamOptions {Mode=FileMode.OpenOrCreate,Access=FileAccess.ReadWrite,Share=FileShare.None};
        if (!OperatingSystem.IsWindows()) settings.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
        using var owned=new FileStream(path+".lock",settings);
        if (File.Exists(path))
        {
            using var previous=JsonDocument.Parse(await File.ReadAllTextAsync(path,ct));
            if (previous.RootElement.GetProperty("tenantId").GetString()!=tenant ||
                !previous.RootElement.TryGetProperty("profile",out var profile) || profile.GetString()!="Portable")
                throw new InvalidOperationException("Tenant route ownership conflict.");
        }
        await PrivateFiles.WriteAsync(path,json,ct);
    }
}
