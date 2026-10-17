using System.Globalization;
using System.Net;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Platform.Security;
using System.Text.RegularExpressions;

namespace Platform.Provisioning.Adapters;

public interface IAppleSigningIdentityVerifier
{
    Task VerifyAsync(string certificateSha1, string team, CancellationToken ct);
}
public sealed class MacAppleSigningIdentityVerifier : IAppleSigningIdentityVerifier
{
    public async Task VerifyAsync(string certificateSha1, string team, CancellationToken ct)
    {
        if (!OperatingSystem.IsMacOS()) throw new InvalidOperationException("Apple tenant provisioning requires the prepared signing Mac.");
        var output = await MobileProcess.RunAsync("/usr/bin/security", ["find-identity", "-v", "-p", "codesigning"], "/", null, TimeSpan.FromSeconds(30), ct);
        var entries = Regex.Matches(output, "^\\s*\\d+\\)\\s+([A-Fa-f0-9]{40})\\s+\"(?:Apple|iPhone) Distribution:[^\\r\\n]*\\(([A-Z0-9]{10})\\)\"\\s*$", RegexOptions.Multiline);
        if (!entries.Any(x => x.Groups[1].Value.Equals(certificateSha1, StringComparison.OrdinalIgnoreCase) && x.Groups[2].Value == team))
            throw new InvalidOperationException("The selected Apple distribution certificate/private key is not usable on this Mac.");
    }
}
public sealed class AppleCreationAmbiguousException() : Exception("An earlier Apple creation is unresolved. Reconcile the existing resource or repair its saved intent before another create.");

public sealed record AppleSigningProfile(string ResourceId, string Uuid, byte[] Cms);
public sealed record AppleSigningMaterial(string CertificateSha1, string CertificateSha256, AppleSigningProfile Application, AppleSigningProfile Extension);

/// <summary>Reconcile only this deployment's named tenant resources. Never rename, delete or revoke account resources.</summary>
public sealed class AppleTenantProvisioner(AppleApiOptions options, AppleApiClient api, IAppleSigningIdentityVerifier signing, ITenantSecrets secrets)
{
    private static string Hash(string value) => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(value))).ToLowerInvariant();
    private static JsonObject Attributes(JsonObject value, string kind)
    {
        if (AppleApiClient.Text(value, "type") != kind) throw new InvalidOperationException("Apple returned another resource type.");
        AppleApiClient.Id(value);
        return value["attributes"] as JsonObject ?? throw new InvalidOperationException("Apple resource has no attributes.");
    }
    private static bool Future(JsonObject attributes) => DateTimeOffset.TryParse(AppleApiClient.Text(attributes, "expirationDate"), CultureInfo.InvariantCulture,
        DateTimeStyles.None, out var expiry) && expiry > DateTimeOffset.UtcNow;
    private async Task<(string Id, string Sha1)> CertificateAsync(IosReleasePlan plan, CancellationToken ct)
    {
        var values = await api.ListAsync(AppleApiClient.Query("v1/certificates", ("limit", "200"), ("fields[certificates]", "certificateType,expirationDate,certificateContent")), ct);
        var matches = new List<(string Id, string Sha1)>();
        foreach (var value in values)
        {
            var attributes = Attributes(value, "certificates");
            if (AppleApiClient.Text(attributes, "certificateType") is not ("DISTRIBUTION" or "IOS_DISTRIBUTION") || !Future(attributes)) continue;
            var raw = Convert.FromBase64String(AppleApiClient.Text(attributes, "certificateContent"));
            if (raw.Length > 65536 || HashBytes(raw) != plan.SigningCertificateSha256) continue;
            using var certificate = new X509Certificate2(raw);
            var subject = certificate.SubjectName.Decode(X500DistinguishedNameFlags.UseNewLines | X500DistinguishedNameFlags.DoNotUseQuotes);
            if (certificate.NotBefore.ToUniversalTime() > DateTime.UtcNow || certificate.NotAfter.ToUniversalTime() <= DateTime.UtcNow || !Regex.IsMatch(subject, "(?:^|\\n)OU=" + plan.DevelopmentTeam + "(?:\\r?\\n|\\z)"))
                throw new InvalidOperationException("The selected Apple certificate belongs to another team or has expired.");
            matches.Add((AppleApiClient.Id(value), Convert.ToHexString(SHA1.HashData(raw)).ToLowerInvariant()));
        }
        if (matches.Count != 1) throw new InvalidOperationException("Exactly one active selected Apple distribution certificate is required.");
        await signing.VerifyAsync(matches[0].Sha1, plan.DevelopmentTeam, ct);
        return matches[0];
    }
    private static string HashBytes(byte[] value) => Convert.ToHexString(SHA256.HashData(value)).ToLowerInvariant();
    private async Task<string[]> DevicesAsync(CancellationToken ct)
    {
        var wanted = options.RequiredDeviceUdids.Select(x => x.ToUpperInvariant()).ToHashSet(StringComparer.Ordinal);
        var found = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (var value in await api.ListAsync(AppleApiClient.Query("v1/devices", ("limit", "200"), ("filter[platform]", "IOS"), ("fields[devices]", "udid,platform,status")), ct))
        {
            var attributes = Attributes(value, "devices");
            var udid = AppleApiClient.Text(attributes, "udid").ToUpperInvariant();
            if (!wanted.Contains(udid)) continue;
            if (AppleApiClient.Text(attributes, "platform") != "IOS" || AppleApiClient.Text(attributes, "status") != "ENABLED" || !found.TryAdd(udid, AppleApiClient.Id(value)))
                throw new InvalidOperationException("A selected tester device is unavailable or ambiguous.");
        }
        if (found.Count != wanted.Count) throw new InvalidOperationException("Register every selected iOS test device before tenant provisioning.");
        return found.Values.Order(StringComparer.Ordinal).ToArray();
    }
    private async Task<JsonObject?> FindAsync(string collection, string field, string expected, CancellationToken ct)
    {
        var fields = collection == "bundleIds" ? "identifier,name,platform" : "name,profileType,profileState,uuid,profileContent,expirationDate";
        var values = await api.ListAsync(AppleApiClient.Query("v1/" + collection, ("filter[" + field + "]", expected), ("limit", "200"), ("fields[" + collection + "]", fields)), ct);
        // Apple's identifier filter also returns prefix siblings such as the notification extension.
        var exact = values.Where(x => AppleApiClient.Text(Attributes(x, collection), field) == expected).ToArray();
        if (exact.Length > 1) throw new InvalidOperationException("Apple returned an ambiguous tenant resource.");
        return exact.SingleOrDefault();
    }
    private sealed record CreateIntent(string TenantId, string DeploymentId, string Collection, string BodySha256, string AttemptId);
    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web);
    private async Task<JsonObject> CreateAsync(IosReleasePlan plan, string collection, object body, Func<Task<JsonObject?>> reconcile, CancellationToken ct)
    {
        var digest = Hash(JsonSerializer.Serialize(body, Json));
        var proposed = new CreateIntent(plan.TenantId, plan.DeploymentId, collection, digest, Guid.NewGuid().ToString("N"));
        var saved = JsonSerializer.Deserialize<CreateIntent>(await secrets.GetOrCreateAsync(plan.TenantId, "apple-create-" + collection.ToLowerInvariant() + "-" + digest[..32],
            () => JsonSerializer.Serialize(proposed, Json), ct), Json) ?? throw new InvalidOperationException("Apple creation intent is invalid.");
        if ((saved with { AttemptId = proposed.AttemptId }) != proposed) throw new InvalidOperationException("The Apple creation intent belongs to another target.");
        if (saved.AttemptId != proposed.AttemptId)
            return await reconcile() ?? throw new AppleCreationAmbiguousException();
        try
        {
            var response = await api.SendAsync(HttpMethod.Post, "v1/" + collection, body, ct);
            return response["data"] as JsonObject ?? throw new InvalidOperationException("Apple creation returned no resource.");
        }
        catch (AppleApiException error) when (error.Status == HttpStatusCode.Conflict || (int)error.Status >= 500)
        { return await reconcile() ?? throw new AppleCreationAmbiguousException(); }
        catch (AppleApiUnavailableException)
        { return await reconcile() ?? throw new AppleCreationAmbiguousException(); }
    }
    private async Task<string> BundleAsync(IosReleasePlan plan, string bundle, string kind, CancellationToken ct)
    {
        var name = "mtc-" + Hash(plan.DeploymentId + "\n" + plan.TenantId + "\n" + plan.DevelopmentTeam + "\n" + bundle)[..32] + "-" + kind;
        Task<JsonObject?> Find() => FindAsync("bundleIds", "identifier", bundle, ct);
        var value = await Find() ?? await CreateAsync(plan, "bundleIds", new { data = new { type = "bundleIds", attributes = new { identifier = bundle, name, platform = "IOS" } } }, Find, ct);
        var attributes = Attributes(value, "bundleIds");
        if (AppleApiClient.Text(attributes, "identifier") != bundle || AppleApiClient.Text(attributes, "name") != name ||
            AppleApiClient.Text(attributes, "platform") is not ("IOS" or "UNIVERSAL"))
            throw new InvalidOperationException("The existing Apple bundle belongs to another owner; it was not adopted or renamed.");
        return AppleApiClient.Id(value);
    }
    private async Task CapabilityAsync(IosReleasePlan plan, string bundle, string capability, CancellationToken ct)
    {
        async Task<JsonObject?> Find()
        {
            var all = await api.ListAsync($"v1/bundleIds/{bundle}/bundleIdCapabilities", ct);
            var matches = all.Where(x => AppleApiClient.Text(Attributes(x, "bundleIdCapabilities"), "capabilityType") == capability).ToArray();
            if (matches.Length > 1) throw new InvalidOperationException("Apple returned ambiguous app capabilities.");
            return matches.SingleOrDefault();
        }
        if (await Find() != null) return;
        await CreateAsync(plan, "bundleIdCapabilities", new { data = new { type = "bundleIdCapabilities", attributes = new { capabilityType = capability },
            relationships = new { bundleId = new { data = new { type = "bundleIds", id = bundle } } } } }, Find, ct);
        if (await Find() == null) throw new InvalidOperationException("The tenant app capability was not verified after creation.");
    }
    private async Task<AppleSigningProfile> ProfileAsync(IosReleasePlan plan, string bundle, string kind, string certificate, string[] devices, CancellationToken ct)
    {
        var name = "mtc-" + Hash(plan.DeploymentId + "\n" + plan.TenantId + "\n" + bundle + "\n" + plan.SigningCertificateSha256 + "\n" + string.Join('\n', devices) + (kind == "app" ? "\nassociated-domains-v1" : ""))[..32] + "-" + kind;
        Task<JsonObject?> Find() => FindAsync("profiles", "name", name, ct);
        var value = await Find() ?? await CreateAsync(plan, "profiles", new { data = new { type = "profiles", attributes = new { name, profileType = "IOS_APP_ADHOC" },
            relationships = new { bundleId = new { data = new { type = "bundleIds", id = bundle } },
                certificates = new { data = new[] { new { type = "certificates", id = certificate } } },
                devices = new { data = devices.Select(id => new { type = "devices", id }).ToArray() } } } }, Find, ct);
        var attributes = Attributes(value, "profiles"); var id = AppleApiClient.Id(value);
        if (AppleApiClient.Text(attributes, "name") != name || AppleApiClient.Text(attributes, "profileType") != "IOS_APP_ADHOC" ||
            AppleApiClient.Text(attributes, "profileState") != "ACTIVE" || !Future(attributes) ||
            !Guid.TryParseExact(AppleApiClient.Text(attributes, "uuid"), "D", out var uuid) || uuid == Guid.Empty)
            throw new InvalidOperationException("The owned Apple profile is inactive, expired or incompatible; no profile was deleted.");
        var linked = await api.SendAsync(HttpMethod.Get, $"v1/profiles/{id}/relationships/bundleId", null, ct);
        if (linked["data"] is not JsonObject resource || AppleApiClient.Text(resource, "type") != "bundleIds" || AppleApiClient.Id(resource) != bundle)
            throw new InvalidOperationException("The Apple profile belongs to another bundle.");
        async Task<string[]> Links(string kind)
        {
            var values = await api.ListAsync($"v1/profiles/{id}/relationships/{kind}", ct);
            if (values.Any(x => AppleApiClient.Text(x, "type") != kind)) throw new InvalidOperationException("The Apple profile returned another relationship type.");
            return values.Select(AppleApiClient.Id).Order(StringComparer.Ordinal).ToArray();
        }
        if (!(await Links("certificates")).SequenceEqual([certificate]) || !(await Links("devices")).SequenceEqual(devices))
            throw new InvalidOperationException("The Apple profile authorizes a different certificate or tester-device set.");
        var cms = Convert.FromBase64String(AppleApiClient.Text(attributes, "profileContent"));
        if (cms.Length is < 1 or > 2 * 1024 * 1024) throw new InvalidOperationException("The Apple profile content exceeds the supported bounds.");
        return new(id, uuid.ToString("D").ToUpperInvariant(), cms);
    }
    public async Task<AppleSigningMaterial> PrepareAsync(IosReleasePlan plan, CancellationToken ct = default)
    {
        plan.Validate(); options.Validate(writes: true);
        if (options.DevelopmentTeam != plan.DevelopmentTeam) throw new InvalidOperationException("The Apple API policy belongs to another signing team.");
        var certificate = await CertificateAsync(plan, ct); var devices = await DevicesAsync(ct);
        var app = await BundleAsync(plan, plan.IosBundleId, "app", ct);
        var extension = await BundleAsync(plan, plan.IosBundleId + ".NotificationServiceExtension", "nse", ct);
        await CapabilityAsync(plan, app, "PUSH_NOTIFICATIONS", ct);
        await CapabilityAsync(plan, app, "ASSOCIATED_DOMAINS", ct);
        return new(certificate.Sha1, plan.SigningCertificateSha256,
            await ProfileAsync(plan, app, "app", certificate.Id, devices, ct),
            await ProfileAsync(plan, extension, "nse", certificate.Id, devices, ct));
    }
}
