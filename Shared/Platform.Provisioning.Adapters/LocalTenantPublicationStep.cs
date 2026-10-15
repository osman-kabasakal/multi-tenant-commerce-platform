using System.Text.Json;

namespace Platform.Provisioning.Adapters;

public sealed class LocalTenantPublicationStep(LocalOnboardingOptions options) : IProvisioningStep
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
        await PrivateFiles.WriteAsync(Path.Combine(options.MobileDirectory,request.Slug+".json"),JsonSerializer.Serialize(new {
            tenantId=request.TenantId,slug=request.Slug,displayName=request.StoreName,baseUrl=storeUrl,
            localDemo=true,androidApplicationId=request.AndroidPackageName??"com.example.tenant"+request.TenantId,
            iosBundleId=request.IosBundleId??"com.example.tenant"+request.TenantId,
            firebase=new {enabled=false,reason="Local profile uses the notification sink and does not create cloud resources."}
        }),ct);
        await PrivateFiles.WriteAsync(Path.Combine(options.NotificationDirectory,request.Slug,"ready.json"),JsonSerializer.Serialize(new {
            tenantId=request.TenantId,recipient=request.OwnerEmail,title="Mağazanız hazır",storeUrl,adminUrl
        }),ct);
        // Publish the hostname only after database, installer and identity steps succeeded.
        await PrivateFiles.WriteAsync(route,JsonSerializer.Serialize(new {
            tenantId=request.TenantId,slug=request.Slug,storeId=completed["store"].Resources["storeId"],storeUrl,adminUrl
        }),ct);
        return new("Local",new Dictionary<string,string> {
            ["storeUrl"]=storeUrl,["adminUrl"]=adminUrl,["notificationProvider"]="LocalSink",["firebaseEnabled"]="false"
        });
    }
}
