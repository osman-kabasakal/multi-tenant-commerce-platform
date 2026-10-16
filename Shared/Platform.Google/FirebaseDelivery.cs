using System.Net.Http.Headers;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using static Platform.Google.GoogleRestClient;

namespace Platform.Google;

public sealed class FirebaseCloudMessaging(GoogleRestClient api)
{
    public Task<string> SendAsync(TenantFirebaseConfiguration tenant, string registrationToken, string title,
        string body, IReadOnlyDictionary<string, string>? data = null, bool validateOnly = false, CancellationToken ct = default)
        => SendAsync(tenant, registrationToken, new FirebasePushContent(title, body, Data: data), validateOnly, ct);

    public async Task<string> SendAsync(TenantFirebaseConfiguration tenant, string registrationToken,
        FirebasePushContent content, bool validateOnly = false, CancellationToken ct = default)
    {
        content.Validate();
        if (!Regex.IsMatch(tenant.ProjectId, "^[a-z][a-z0-9-]{4,28}[a-z0-9]$") ||
            string.IsNullOrWhiteSpace(registrationToken) || registrationToken.Length > 4096)
            throw new ArgumentException("Invalid Firebase message.");
        var message = new JsonObject { ["token"] = registrationToken };
        if (content.Data?.Count > 0) message["data"] = JsonSerializer.SerializeToNode(content.Data);
        var visible = !string.IsNullOrEmpty(content.Title) || !string.IsNullOrEmpty(content.Body);
        var aps = new JsonObject();
        if (visible)
        {
            var notification = new JsonObject();
            if (content.Title != null) notification["title"] = content.Title;
            if (content.Body != null) notification["body"] = content.Body;
            if (!string.IsNullOrEmpty(content.ImageUrl)) notification["image"] = content.ImageUrl;
            message["notification"] = notification;
            message["android"] = new JsonObject {
                ["notification"] = new JsonObject { ["channel_id"] = "high_importance_channel", ["default_sound"] = true }
            };
            var alert = notification.DeepClone().AsObject(); alert.Remove("image");
            aps["alert"] = alert; aps["sound"] = "default";
            if (!string.IsNullOrEmpty(content.ImageUrl)) aps["mutable-content"] = 1;
        }
        else aps["content-available"] = 1;
        var apns = new JsonObject {
            ["headers"] = new JsonObject { ["apns-priority"] = visible ? "10" : "5", ["apns-push-type"] = visible ? "alert" : "background" },
            ["payload"] = new JsonObject { ["aps"] = aps }
        };
        if (!string.IsNullOrEmpty(content.ImageUrl)) apns["fcm_options"] = new JsonObject { ["image"] = content.ImageUrl };
        message["apns"] = apns;
        if (content.Data?.TryGetValue("action_link", out var url) == true &&
            Uri.TryCreate(url, UriKind.Absolute, out var link) && link.Scheme == "https")
            message["webpush"] = new JsonObject { ["fcm_options"] = new JsonObject { ["link"] = url } };
        var result = (await api.SendAsync(GoogleApi.Messaging, HttpMethod.Post, $"v1/projects/{tenant.ProjectId}/messages:send",
            new { validateOnly, message }, ct))!;
        var name = Text(result, "name");
        if (!name.StartsWith($"projects/{tenant.ProjectId}/messages/", StringComparison.Ordinal))
            throw new InvalidOperationException("FCM returned a different target project.");
        return name;
    }
}

public sealed class FirebaseAppDistribution(GoogleRestClient api, GoogleCloudOptions options)
{
    public async Task<string> UploadAndDistributeAsync(TenantFirebaseConfiguration tenant, string platform,
        string binaryPath, CancellationToken ct = default)
    {
        var extension = platform switch { "android"=>".apk", "ios"=>".ipa", _=>throw new ArgumentException("Choose android or ios.") };
        if (!Path.GetExtension(binaryPath).Equals(extension,StringComparison.OrdinalIgnoreCase))
            throw new ArgumentException("Supply an APK for Android or a signed IPA for iOS.");
        var appResource=TargetApp(tenant,platform);
        await VerifyProjectAsync(tenant,ct);
        await using var stream = File.OpenRead(binaryPath);
        using var content = new StreamContent(stream);
        content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
        var operation = await api.SendContentAsync(GoogleApi.Distribution, HttpMethod.Post,
            $"upload/v1/{appResource}/releases:upload", content, ct, headers: new Dictionary<string, string>
            {
                ["X-Goog-Upload-Protocol"] = "raw", ["X-Goog-Upload-File-Name"] = "release" + extension
            });
        var response = await api.WaitAsync(GoogleApi.Distribution, "v1", operation!, options, ct);
        var release = response["release"] as JsonObject ?? throw new InvalidOperationException("App Distribution returned no release.");
        var name = Text(release, "name");
        if (!Regex.IsMatch(name, "^" + Regex.Escape(appResource) + "/releases/[a-zA-Z0-9_-]+$"))
            throw new InvalidOperationException("App Distribution release belongs to another app.");
        await api.SendAsync(GoogleApi.Distribution, HttpMethod.Post, "v1/" + name + ":distribute",
            new { groupAliases = new[] { tenant.DistributionGroupAlias } }, ct);
        return name;
    }
    private string TargetApp(TenantFirebaseConfiguration tenant,string platform)
    {
        options.Validate();FirebaseConfigValidator.Validate(tenant);
        if(tenant.ProjectId!=options.ProjectId(tenant.TenantId) || tenant.DistributionGroupAlias!=options.DistributionGroupAlias)
            throw new InvalidOperationException("App Distribution target belongs to another deployment.");
        var app=platform switch {"android"=>tenant.AndroidAppId,"ios"=>tenant.IosAppId,_=>throw new ArgumentException("Choose android or ios.")};
        if(!Regex.IsMatch(tenant.ProjectNumber,"^[1-9][0-9]*$") || !Regex.IsMatch(app,"^1:"+tenant.ProjectNumber+":"+platform+":[A-Za-z0-9]+$"))
            throw new InvalidOperationException("Invalid App Distribution application identity.");
        return $"projects/{tenant.ProjectNumber}/apps/{app}";
    }
    private async Task VerifyProjectAsync(TenantFirebaseConfiguration tenant,CancellationToken ct)
    {
        var project=(await api.SendAsync(GoogleApi.ResourceManager,HttpMethod.Get,"v3/projects/"+tenant.ProjectId,null,ct))!;
        if(project["labels"]?["platform-tenant"]?.GetValue<string>()!=tenant.TenantId ||
            project["labels"]?["platform-deployment"]?.GetValue<string>()!=options.DeploymentId ||
            project["parent"]?.GetValue<string>()!=options.Parent || project["state"]?.GetValue<string>()!="ACTIVE" ||
            project["name"]?.GetValue<string>()!="projects/"+tenant.ProjectNumber)
            throw new InvalidOperationException("App Distribution project ownership changed.");
    }
    public async Task VerifyReleaseAsync(TenantFirebaseConfiguration tenant,string platform,string name,string expectedBuildVersion,CancellationToken ct=default)
    {
        var app=TargetApp(tenant,platform);
        if(!Regex.IsMatch(name,"^"+Regex.Escape(app)+"/releases/[a-zA-Z0-9_-]+$") || !Regex.IsMatch(expectedBuildVersion,"^[0-9]{1,10}$"))
            throw new InvalidOperationException("Cached App Distribution release belongs to another target.");
        await VerifyProjectAsync(tenant,ct);
        var release=(await api.SendAsync(GoogleApi.Distribution,HttpMethod.Get,"v1/"+name,null,ct))!;
        if(release["name"]?.GetValue<string>()!=name || release["buildVersion"]?.GetValue<string>()!=expectedBuildVersion)
            throw new InvalidOperationException("Cached App Distribution release version or ownership changed.");
    }

}
