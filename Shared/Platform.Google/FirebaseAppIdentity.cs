using System.Net;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using static Platform.Google.GoogleRestClient;

namespace Platform.Google;

/// <summary>Reconciles public app metadata without creating projects, rotating keys or inviting testers.</summary>
public sealed class FirebaseAppIdentity(GoogleRestClient api, GoogleCloudOptions options)
{
    private async Task<JsonObject> AppAsync(TenantFirebaseConfiguration config, bool ios, CancellationToken ct)
    {
        options.Validate();
        FirebaseConfigValidator.Validate(config);
        if (config.ProjectId != options.ProjectId(config.TenantId) || config.SenderServiceAccount != options.SenderServiceAccount)
            throw new InvalidOperationException("The Firebase application targets another deployment.");
        var project = (await api.SendAsync(GoogleApi.ResourceManager, HttpMethod.Get, "v3/projects/" + config.ProjectId, null, ct))!;
        if (Text(project, "projectId") != config.ProjectId || Text(project, "name") != "projects/" + config.ProjectNumber || Text(project, "parent") != options.Parent ||
            Text(project, "state") != "ACTIVE" || project["labels"]?["platform-tenant"]?.GetValue<string>() != config.TenantId ||
            project["labels"]?["platform-deployment"]?.GetValue<string>() != options.DeploymentId)
            throw new InvalidOperationException("The Firebase project has conflicting tenant ownership.");
        var kind = ios ? "iosApps" : "androidApps";
        var appId = ios ? config.IosAppId : config.AndroidAppId;
        var app = (await api.SendAsync(GoogleApi.Firebase, HttpMethod.Get,
            $"v1beta1/projects/{config.ProjectId}/{kind}/{Segment(appId)}", null, ct))!;
        ValidateApp(app, config, ios);
        return app;
    }

    private static void ValidateApp(JsonObject app, TenantFirebaseConfiguration config, bool ios)
    {
        var kind = ios ? "iosApps" : "androidApps";
        var id = ios ? config.IosAppId : config.AndroidAppId;
        if (Text(app, "appId") != id || app["state"]?.GetValue<string>() is not (null or "ACTIVE") ||
            (Text(app, "name") != $"projects/{config.ProjectId}/{kind}/{id}" && Text(app, "name") != $"projects/{config.ProjectNumber}/{kind}/{id}") ||
            Text(app, ios ? "bundleId" : "packageName") != (ios ? config.IosBundleId : config.AndroidPackageName))
            throw new InvalidOperationException("The Firebase application identity changed.");
    }

    public async Task VerifyAsync(TenantFirebaseConfiguration config, CancellationToken ct = default)
    {
        await AppAsync(config, false, ct);
        await AppAsync(config, true, ct);
    }

    public async Task EnsureIosTeamAsync(TenantFirebaseConfiguration config, CancellationToken ct = default)
    {
        var team = options.IosDevelopmentTeam;
        if (team == null || !Regex.IsMatch(team, "^[A-Z0-9]{10}\\z") || config.IosDevelopmentTeam != team)
            throw new InvalidOperationException("Select the same explicit Apple team for Firebase and tenant signing.");
        var app = await AppAsync(config, true, ct);
        var current = app["teamId"]?.GetValue<string>();
        if (current == team) return;
        if (!string.IsNullOrEmpty(current)) throw new InvalidOperationException("The Firebase iOS app is already bound to another Apple team.");
        var etag = Text(app, "etag");
        if (string.IsNullOrEmpty(etag)) throw new InvalidOperationException("Firebase iOS metadata is missing its concurrency token.");
        await api.SendAsync(GoogleApi.Firebase, HttpMethod.Patch,
            $"v1beta1/projects/{config.ProjectId}/iosApps/{Segment(config.IosAppId)}?updateMask=teamId",
            new { name = Text(app, "name"), teamId = team, etag }, ct);
        var actual = await AppAsync(config, true, ct);
        if (actual["teamId"]?.GetValue<string>() != team) throw new InvalidOperationException("Firebase did not retain the configured Apple team.");
    }

    public async Task EnsureAndroidSigningAsync(TenantFirebaseConfiguration config, string certificateBase64,
        string expectedCertificateSha256, CancellationToken ct = default)
    {
        if (certificateBase64.Length is 0 or > 65536) throw new ArgumentException("Use a bounded public signing certificate.");
        using var certificate = new X509Certificate2(Convert.FromBase64String(certificateBase64));
        var sha256 = Convert.ToHexString(SHA256.HashData(certificate.RawData)).ToLowerInvariant();
        if (expectedCertificateSha256 != sha256) throw new InvalidOperationException("The public certificate does not match the verified APK signing identity.");
        // SHA-1 is the fingerprint required by Firebase, never a trust/signature algorithm here.
        var sha1 = Convert.ToHexString(SHA1.HashData(certificate.RawData)).ToLowerInvariant();
        await AppAsync(config, false, ct);
        var certificates = await CertificatesAsync(config, ct);
        foreach (var (type, hash) in new[] { ("SHA_1", sha1), ("SHA_256", sha256) })
        {
            if (Contains(certificates, type, hash)) continue;
            try
            {
                await api.SendAsync(GoogleApi.Firebase, HttpMethod.Post,
                    $"v1beta1/projects/{config.ProjectId}/androidApps/{Segment(config.AndroidAppId)}/sha",
                    new { certType = type, shaHash = hash }, ct);
            }
            catch (GoogleApiException error) when (error.StatusCode == HttpStatusCode.Conflict) { }
            certificates = await CertificatesAsync(config, ct);
            if (!Contains(certificates, type, hash)) throw new InvalidOperationException("Firebase did not retain the APK certificate fingerprint.");
        }
    }

    private async Task<JsonArray> CertificatesAsync(TenantFirebaseConfiguration config, CancellationToken ct)
    {
        var result = (await api.SendAsync(GoogleApi.Firebase, HttpMethod.Get,
            $"v1beta1/projects/{config.ProjectId}/androidApps/{Segment(config.AndroidAppId)}/sha", null, ct))!;
        var certificates = result["certificates"] is null ? new JsonArray() : result["certificates"] as JsonArray
            ?? throw new InvalidOperationException("Invalid Firebase certificate list.");
        if (certificates.Count > 1000) throw new InvalidOperationException("The Firebase certificate list exceeds its bound.");
        foreach (var entry in certificates)
        {
            if (entry is not JsonObject certificate) throw new InvalidOperationException("Invalid Firebase certificate entry.");
            var name = Text(certificate, "name");
            if (!name.StartsWith($"projects/{config.ProjectId}/androidApps/{config.AndroidAppId}/sha/", StringComparison.Ordinal) &&
                !name.StartsWith($"projects/{config.ProjectNumber}/androidApps/{config.AndroidAppId}/sha/", StringComparison.Ordinal))
                throw new InvalidOperationException("Firebase returned a certificate belonging to another application.");
        }
        return certificates;
    }

    private static bool Contains(JsonArray certificates, string type, string hash) => certificates.OfType<JsonObject>()
        .Any(c => c["certType"]?.GetValue<string>() == type && c["shaHash"]?.GetValue<string>()
            .Replace(":", "", StringComparison.Ordinal).Equals(hash, StringComparison.OrdinalIgnoreCase) == true);
}
