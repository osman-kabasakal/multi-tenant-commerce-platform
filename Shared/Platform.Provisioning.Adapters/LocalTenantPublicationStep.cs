using System.Text.Json;
using Platform.Google;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class LocalTenantPublicationStep(LocalOnboardingOptions options, ITenantSecrets secrets) : IProvisioningStep
{
    public string Name => "publication";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {
        var storeUrl=options.StoreUrl(request.Slug);var adminUrl=options.AdminUrl(request.Slug);
        var route=Path.Combine(options.RouteDirectory,request.Slug+".json");
        if (File.Exists(route))
        {
            using var old=JsonDocument.Parse(await File.ReadAllTextAsync(route,ct));
            if (old.RootElement.GetProperty("tenantId").GetString()!=request.TenantId) throw new InvalidOperationException("Tenant route ownership conflict.");
        }
        object firebase = new {enabled=false,reason="Local profile uses the notification sink and does not create cloud resources."};
        var cloud = completed.TryGetValue("google-firebase", out var google);
        if (cloud)
        {
            var value = await secrets.GetAsync(request.TenantId, TenantFirebaseConfiguration.SecretName, ct);
            var config = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(value)
                ?? throw new InvalidOperationException("Missing tenant Firebase configuration.");
            if (config.TenantId != request.TenantId || config.ProjectId != google!.Resources["projectId"])
                throw new InvalidOperationException("Tenant Firebase publication ownership mismatch.");
            FirebaseConfigValidator.Validate(config);
            await PrivateFiles.WriteAsync(Path.Combine(options.MobileDirectory,request.Slug,"google-services.json"),config.AndroidConfigJson,ct);
            await PrivateFiles.WriteAsync(Path.Combine(options.MobileDirectory,request.Slug,"GoogleService-Info.plist"),config.IosConfigPlist,ct);
            firebase = new { enabled=true, projectId=config.ProjectId, projectNumber=config.ProjectNumber,
                androidAppId=config.AndroidAppId, iosAppId=config.IosAppId,
                androidConfigFile=request.Slug+"/google-services.json", iosConfigFile=request.Slug+"/GoogleService-Info.plist" };
        }
        await PrivateFiles.WriteAsync(Path.Combine(options.MobileDirectory,request.Slug+".json"),JsonSerializer.Serialize(new {
            tenantId=request.TenantId,slug=request.Slug,displayName=request.StoreName,baseUrl=storeUrl,
            localDemo=true,androidApplicationId=request.AndroidPackageName??"com.example.tenant"+request.TenantId,
            iosBundleId=request.IosBundleId??"com.example.tenant"+request.TenantId,
            firebase
        }),ct);
        await PrivateFiles.WriteAsync(Path.Combine(options.NotificationDirectory,request.Slug,"ready.json"),JsonSerializer.Serialize(new {
            tenantId=request.TenantId,recipient=request.OwnerEmail,title="Mağazanız hazır",storeUrl,adminUrl
        }),ct);
        // Publish the hostname only after database, installer and identity steps succeeded.
        await PrivateFiles.WriteAsync(route,JsonSerializer.Serialize(new {
            tenantId=request.TenantId,slug=request.Slug,storeId=completed["store"].Resources["storeId"],storeUrl,adminUrl
        }),ct);
        return new("Local",new Dictionary<string,string> {
            ["storeUrl"]=storeUrl,["adminUrl"]=adminUrl,["notificationProvider"]="LocalSink",["firebaseEnabled"]=cloud?"true":"false"
        });
    }
}
