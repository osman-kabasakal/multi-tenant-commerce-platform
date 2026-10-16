using System.Net.Http.Json;
using System.Text.Json;
using Platform.Google;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class PortableTenantPublicationStep(PortableOnboardingOptions options,ITenantSecrets secrets,IHttpClientFactory clients) : IProvisioningStep
{
    public string Name=>"publication";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {
        request.Validate();
        var storeUrl=options.StoreUrl(request.Slug);var adminUrl=options.AdminUrl(request.Slug);
        var storeId=completed["store"].Resources["storeId"];
        if (completed["identity"].Resources["clientId"]!=request.Slug || completed["domains"].Resources["storeHost"]!=new Uri(storeUrl).Host ||
            completed["domains"].Resources["adminHost"]!=new Uri(adminUrl).Host)
            throw new InvalidOperationException("Tenant publication checkpoints do not match their configured targets.");
        var route=Path.Combine(options.RouteDirectory,request.Slug+".json");
        // Only owned metadata is published. The ingress must authenticate the real tenant token.
        await WriteOwnedAsync(route,request.TenantId,JsonSerializer.Serialize(new {
            version=1,profile="Portable",tenantId=request.TenantId,slug=request.Slug,storeId,storeUrl,adminUrl
        }),ct);
        using var ingress=clients.CreateClient("onboarding-ingress");
        using var probe=new HttpRequestMessage(HttpMethod.Get,storeUrl+"/_platform/ready");
        // Probe as a public caller: the ingress must obtain/inject the tenant token itself.
        // A privileged worker token must not hide a missing public gateway.
        using var response=await ingress.SendAsync(probe,ct);
        if (!response.IsSuccessStatusCode) throw new InvalidOperationException("The tenant ingress is not ready; provision DNS, TLS and runtime routing before completion.");
        using var ready=JsonDocument.Parse(await response.Content.ReadAsStringAsync(ct));
        if (ready.RootElement.GetProperty("tenantId").GetString()!=request.TenantId || ready.RootElement.GetProperty("storeId").GetString()!=storeId)
            throw new InvalidOperationException("Tenant ingress readiness returned a different tenant.");
        using var adminResponse=await ingress.GetAsync(adminUrl,ct);
        if (!adminResponse.Headers.TryGetValues("X-Platform-Tenant",out var tenants) || tenants.SingleOrDefault()!=request.TenantId ||
            adminResponse.StatusCode!=System.Net.HttpStatusCode.Redirect || adminResponse.Headers.Location==null)
            throw new InvalidOperationException("The owned admin host is not ready for authentication.");
        var login=new Uri(new Uri(adminUrl),adminResponse.Headers.Location);
        if (login.Scheme!="https" || login.Authority!=new Uri(adminUrl).Authority || !login.AbsolutePath.EndsWith("/login",StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("The admin host redirected outside its own HTTPS login.");
        using var loginResponse=await ingress.GetAsync(login,ct);
        if (!loginResponse.IsSuccessStatusCode || !loginResponse.Headers.TryGetValues("X-Platform-Tenant",out var loginTenants) || loginTenants.SingleOrDefault()!=request.TenantId ||
            loginResponse.Content.Headers.ContentType?.MediaType!="text/html")
            throw new InvalidOperationException("The owned admin login page is not ready.");
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
