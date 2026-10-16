using System.Text.Json;
using Platform.Google;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class GoogleTenantStep(GoogleTenantProvisioner google, ITenantSecrets secrets, GoogleCloudOptions options) : IProvisioningStep
{
    public string Name => "google-firebase";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,
        IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
    {
        request.Validate();
        string? previous = null;
        try { previous = await secrets.GetAsync(request.TenantId, TenantFirebaseConfiguration.SecretName, ct); }
        catch (KeyNotFoundException) { }
        if (previous != null)
        {
            var existing = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(previous)
                ?? throw new InvalidOperationException("Invalid saved tenant Firebase configuration.");
            if (existing.TenantId != request.TenantId || existing.ProjectId != options.ProjectId(request.TenantId) ||
                existing.AndroidPackageName != (request.AndroidPackageName ?? "com.example.tenant" + request.TenantId) ||
                existing.IosBundleId != (request.IosBundleId ?? "com.example.tenant" + request.TenantId) ||
                existing.IosPushTransport != options.IosPushTransport || existing.IosDevelopmentTeam != options.IosDevelopmentTeam)
                throw new InvalidOperationException("Tenant Firebase target changed; an explicit migration is required.");
        }
        var config = await google.EnsureAsync(new(request.TenantId, request.StoreName, request.OwnerEmail,
            request.AndroidPackageName ?? "com.example.tenant" + request.TenantId,
            request.IosBundleId ?? "com.example.tenant" + request.TenantId), ct);
        var current = await secrets.GetOrCreateAsync(request.TenantId, TenantFirebaseConfiguration.SecretName,
            () => JsonSerializer.Serialize(config), ct);
        var saved = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(current)
            ?? throw new InvalidOperationException("Invalid saved tenant Firebase configuration.");
        if (saved.TenantId != config.TenantId || saved.ProjectId != config.ProjectId || saved.AndroidAppId != config.AndroidAppId || saved.IosAppId != config.IosAppId ||
            saved.IosPushTransport != config.IosPushTransport || saved.IosDevelopmentTeam != config.IosDevelopmentTeam)
            throw new InvalidOperationException("Tenant Firebase resource identity changed; an explicit migration is required.");
        await secrets.SetAsync(request.TenantId, TenantFirebaseConfiguration.SecretName, JsonSerializer.Serialize(config), ct);
        return new("Google", new Dictionary<string,string> {
            ["projectId"] = config.ProjectId, ["projectNumber"] = config.ProjectNumber,
            ["androidAppId"] = config.AndroidAppId, ["iosAppId"] = config.IosAppId,
            ["distributionGroup"] = config.DistributionGroupAlias, ["notificationProvider"] = config.IosPushTransport == "Apns" ? "FcmApns" : "Fcm"
        });
    }
}
