using System.Globalization;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Platform.Google;
using Platform.Security;

namespace Platform.Notifications;

public sealed class ApnsOptions
{
    public string Environment { get; init; } = "Production";
    public string DevelopmentTeam { get; init; } = "";
    public string KeyId { get; init; } = "";
    public string KeyFile { get; init; } = "";
    public int LifetimeSeconds { get; init; } = 3600;

    public void Validate()
    {
        if (Environment != "Production" || !Regex.IsMatch(DevelopmentTeam, "^[A-Z0-9]{10}\\z") ||
            !Regex.IsMatch(KeyId, "^[A-Z0-9]{10}\\z") || !Path.IsPathFullyQualified(KeyFile) ||
            LifetimeSeconds is < 0 or > 86400)
            throw new InvalidOperationException("Configure an explicit production APNs team key and bounded delivery lifetime.");
    }

    internal ECDsa ReadKey()
    {
        Validate();
        try
        {
            var file = new FileInfo(KeyFile);
            if (!file.Exists || file.LinkTarget != null || file.Length is < 1 or > 8192 ||
                (file.Attributes & FileAttributes.ReparsePoint) != 0)
                throw new InvalidOperationException();
            for (var parent = file.Directory; parent != null; parent = parent.Parent)
                if (parent.LinkTarget != null || (parent.Attributes & FileAttributes.ReparsePoint) != 0)
                    throw new InvalidOperationException();
            if (!OperatingSystem.IsWindows() && (File.GetUnixFileMode(file.FullName) &
                (UnixFileMode.GroupRead | UnixFileMode.GroupWrite | UnixFileMode.GroupExecute |
                 UnixFileMode.OtherRead | UnixFileMode.OtherWrite | UnixFileMode.OtherExecute)) != 0)
                throw new InvalidOperationException();
            var key = ECDsa.Create();
            try
            {
                key.ImportFromPem(File.ReadAllText(file.FullName));
                var value = key.ExportParameters(true);
                if (key.KeySize != 256 || value.Curve.Oid.Value != ECCurve.NamedCurves.nistP256.Oid.Value || value.D?.Length != 32)
                    throw new InvalidOperationException();
                return key;
            }
            catch { key.Dispose(); throw; }
        }
        catch { throw new InvalidOperationException("Use an owner-only regular APNs P-256 private key file without symbolic links."); }
    }
}

public sealed class ApnsProviderTokens : IDisposable
{
    private readonly ApnsOptions options;
    private readonly ECDsa key;
    private readonly TimeProvider clock;
    private readonly object gate = new();
    private string? token;
    private DateTimeOffset issued;
    public ApnsProviderTokens(ApnsOptions options, TimeProvider clock)
    {
        this.options = options; this.clock = clock; key = options.ReadKey();
    }
    private static string Url(byte[] value) => Convert.ToBase64String(value).TrimEnd('=').Replace('+','-').Replace('/','_');
    public string Get()
    {
        lock (gate)
        {
            var now = clock.GetUtcNow();
            if (token != null && now < issued) throw new InvalidOperationException("APNs requires a stable synchronized UTC clock.");
            // Apple requires token refresh between 20 and 60 minutes, including across tenant topics.
            if (token != null && now - issued < TimeSpan.FromMinutes(40)) return token;
            var header = Url(JsonSerializer.SerializeToUtf8Bytes(new { alg = "ES256", kid = options.KeyId }));
            var payload = Url(JsonSerializer.SerializeToUtf8Bytes(new { iss = options.DevelopmentTeam, iat = now.ToUnixTimeSeconds() }));
            var input = header + "." + payload;
            var signature = key.SignData(Encoding.ASCII.GetBytes(input), HashAlgorithmName.SHA256,
                DSASignatureFormat.IeeeP1363FixedFieldConcatenation);
            token = input + "." + Url(signature); issued = now; return token;
        }
    }
    public void Dispose() => key.Dispose();
}

public static class ApnsRegistrationToken
{
    public const string Prefix = "apns-v1:production:";
    public static bool Reserved(string value) => value.StartsWith("apns-v", StringComparison.Ordinal);
    public static string Decode(string value)
    {
        if (!value.StartsWith(Prefix,StringComparison.Ordinal)) throw new ArgumentException("Unsupported APNs registration format or environment.");
        var token = value[Prefix.Length..];
        // APNs device tokens have variable length; never assume the historical 32-byte size.
        if (token.Length is < 2 or > 512 || token.Length % 2 != 0 || token.Any(c => !char.IsAsciiHexDigit(c)))
            throw new ArgumentException("Invalid APNs device token.");
        return token.ToLowerInvariant();
    }
}

public sealed class ApnsApiException(HttpStatusCode? status, string code) : Exception("APNs operation failed (" + code + ").")
{
    public HttpStatusCode? StatusCode { get; } = status;
    public string Code { get; } = code;
}

public interface IApnsHttpClients { HttpClient Create(); }
public sealed class ApnsHttpClients : IApnsHttpClients
{
    // Each batch gets a new connection pool for exactly one topic. Apple requires new connections
    // for App IDs added after a connection was authenticated; never reuse an old tenant's pool.
    public HttpClient Create() => new(new SocketsHttpHandler { AllowAutoRedirect = false,
        ConnectTimeout = TimeSpan.FromSeconds(15) }) { Timeout = TimeSpan.FromSeconds(45) };
}

public sealed class ApnsTenantPushSender(ITenantSecrets secrets, ApnsOptions options,
    ApnsProviderTokens tokens, IApnsHttpClients clients, TimeProvider clock) : ITenantPushSender
{
    public async Task<TenantFirebaseConfiguration> TargetAsync(string tenantIdOrAlias, CancellationToken ct = default)
    {
        var tenant = await secrets.ResolveAsync(tenantIdOrAlias, ct); PushInput.Canonical(tenant);
        var config = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(await secrets.GetAsync(tenant, TenantFirebaseConfiguration.SecretName,ct))
            ?? throw new InvalidOperationException("Tenant notification configuration is missing.");
        FirebaseConfigValidator.Validate(config);
        if (config.TenantId != tenant || config.IosPushTransport != "Apns" || config.IosDevelopmentTeam != options.DevelopmentTeam ||
            config.IosBundleId.Length > 220 || !Regex.IsMatch(config.IosBundleId,"^[A-Za-z][A-Za-z0-9-]*(\\.[A-Za-z][A-Za-z0-9-]*)+\\z"))
            throw new InvalidOperationException("The APNs target does not match the tenant's configured Apple team and application.");
        return config;
    }

    public static byte[] Payload(TenantPushMessage message)
    {
        var content = message.Content();
        var silent = string.IsNullOrEmpty(content.Title) && string.IsNullOrEmpty(content.Body);
        var aps = silent ? new Dictionary<string,object> { ["content-available"] = 1 } :
            new Dictionary<string,object> { ["alert"] = new { title = content.Title, body = content.Body }, ["sound"] = "default" };
        var payload = new Dictionary<string,object?> { ["aps"] = aps, ["platform_apns"] = "v1", ["data"] = content.Data };
        if (!silent && !string.IsNullOrEmpty(content.ImageUrl)) { aps["mutable-content"] = 1; payload["image"] = content.ImageUrl; }
        var bytes = JsonSerializer.SerializeToUtf8Bytes(payload);
        if (bytes.Length > 4096) throw new ArgumentException("The APNs alert exceeds the 4096-byte payload limit.");
        return bytes;
    }

    public async Task<TenantPushReceipt> SendAsync(string tenantIdOrAlias, IReadOnlyList<string> registrationTokens,
        TenantPushMessage message, CancellationToken ct = default)
    {
        options.Validate();
        var deviceTokens = PushInput.Tokens(registrationTokens).Select(ApnsRegistrationToken.Decode).Distinct(StringComparer.Ordinal).ToArray();
        var bytes = Payload(message);
        var silent = string.IsNullOrEmpty(message.Title) && string.IsNullOrEmpty(message.Body);
        var target = await TargetAsync(tenantIdOrAlias,ct);
        using var http = clients.Create();
        var accepted = 0;
        foreach (var device in deviceTokens)
        {
            using var request = new HttpRequestMessage(HttpMethod.Post,"https://api.push.apple.com/3/device/" + device)
            {
                Version = HttpVersion.Version20, VersionPolicy = HttpVersionPolicy.RequestVersionExact,
                Content = new ByteArrayContent(bytes)
            };
            request.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
            request.Headers.Authorization = new AuthenticationHeaderValue("bearer",tokens.Get());
            request.Headers.Add("apns-topic",target.IosBundleId);
            request.Headers.Add("apns-push-type",silent ? "background" : "alert"); request.Headers.Add("apns-priority",silent ? "5" : "10");
            request.Headers.Add("apns-id",Guid.NewGuid().ToString());
            request.Headers.Add("apns-expiration",options.LifetimeSeconds == 0 ? "0" :
                clock.GetUtcNow().AddSeconds(options.LifetimeSeconds).ToUnixTimeSeconds().ToString(CultureInfo.InvariantCulture));
            try
            {
                using var response = await http.SendAsync(request,HttpCompletionOption.ResponseHeadersRead,ct);
                if (response.Version.Major != 2) throw new ApnsApiException(response.StatusCode,"Protocol");
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    if (!response.Headers.TryGetValues("apns-id",out var ids) || ids.Take(2).Count() != 1 || !Guid.TryParse(ids.FirstOrDefault(),out var id) || id == Guid.Empty)
                        throw new ApnsApiException(response.StatusCode,"Receipt");
                    accepted++; continue;
                }
                var reason = await ReasonAsync(response,ct);
                if (response.StatusCode == HttpStatusCode.BadRequest && (reason is "BadDeviceToken" or "DeviceTokenNotForTopic") ||
                    response.StatusCode == HttpStatusCode.Gone && reason == "Unregistered") continue;
                throw new ApnsApiException(response.StatusCode,reason);
            }
            catch (HttpRequestException) { throw new ApnsApiException(null,"Transport"); }
            catch (OperationCanceledException) when (!ct.IsCancellationRequested) { throw new ApnsApiException(null,"Timeout"); }
        }
        return new(deviceTokens.Length,accepted,"Apns");
    }

    private static async Task<string> ReasonAsync(HttpResponseMessage response, CancellationToken ct)
    {
        if (response.Content.Headers.ContentLength > 4096) throw new ApnsApiException(response.StatusCode,"Protocol");
        await using var stream = await response.Content.ReadAsStreamAsync(ct);
        var buffer = new byte[4097]; var length = 0;
        while (length < buffer.Length)
        {
            var read = await stream.ReadAsync(buffer.AsMemory(length),ct); if (read == 0) break; length += read;
        }
        if (length == 0 || length > 4096) throw new ApnsApiException(response.StatusCode,"Protocol");
        try
        {
            using var document = JsonDocument.Parse(buffer.AsMemory(0,length));
            if (document.RootElement.ValueKind != JsonValueKind.Object || !document.RootElement.TryGetProperty("reason",out var value) || value.ValueKind != JsonValueKind.String)
                throw new ApnsApiException(response.StatusCode,"Protocol");
            var reason = value.GetString();
            return reason is "BadDeviceToken" or "DeviceTokenNotForTopic" or "Unregistered" or "ExpiredProviderToken" or
                "InvalidProviderToken" or "TopicDisallowed" or "BadTopic" or "TooManyRequests" or "InternalServerError" or
                "ServiceUnavailable" or "MissingProviderToken" or "PayloadTooLarge" ? reason : "Rejected";
        }
        catch (JsonException) { throw new ApnsApiException(response.StatusCode,"Protocol"); }
    }
}

public sealed class FcmApnsTenantPushSender(FcmTenantPushSender fcm, ApnsTenantPushSender apns) : ITenantPushSender
{
    public async Task<TenantPushReceipt> SendAsync(string tenantIdOrAlias, IReadOnlyList<string> registrationTokens,
        TenantPushMessage message, CancellationToken ct = default)
    {
        var unique = PushInput.Tokens(registrationTokens).Select(x => ApnsRegistrationToken.Reserved(x) ?
            ApnsRegistrationToken.Prefix + ApnsRegistrationToken.Decode(x) : x).Distinct(StringComparer.Ordinal).ToArray();
        var apple = unique.Where(ApnsRegistrationToken.Reserved).ToArray();
        var google = unique.Where(x => !ApnsRegistrationToken.Reserved(x)).ToArray();
        // Validate all Apple input and tenant policy before either provider can perform a write.
        foreach (var token in apple) ApnsRegistrationToken.Decode(token);
        if (apple.Length > 0) { ApnsTenantPushSender.Payload(message); await apns.TargetAsync(tenantIdOrAlias,ct); }
        var accepted = 0;
        if (google.Length > 0) accepted += (await fcm.SendAsync(tenantIdOrAlias,google,message,ct)).Accepted;
        if (apple.Length > 0) accepted += (await apns.SendAsync(tenantIdOrAlias,apple,message,ct)).Accepted;
        return new(unique.Length,accepted,"FcmApns");
    }
}
