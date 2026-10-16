using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;

namespace Platform.Provisioning.Adapters;

public sealed class AppleApiOptions
{
    public string DevelopmentTeam { get; init; } = "";
    public string KeyId { get; init; } = "";
    public string IssuerId { get; init; } = "";
    public string KeyFile { get; init; } = "";
    public bool AllowAppleWrites { get; init; }
    public string[] RequiredDeviceUdids { get; init; } = [];
    public static AppleApiOptions Read(string path)
    {
        PrivateFile(path, 65536);
        var options = JsonSerializer.Deserialize<AppleApiOptions>(File.ReadAllText(path), new JsonSerializerOptions {
            UnmappedMemberHandling = JsonUnmappedMemberHandling.Disallow
        }) ?? throw new ArgumentException("The Apple configuration must be an object.");
        options.Validate();
        return options;
    }
    private static void PrivateFile(string path, long limit)
    {
        if (!Path.IsPathFullyQualified(path)) throw new ArgumentException("Use an absolute private Apple configuration/key file.");
        MobileReleaseFiles.RegularFile(path, limit);
        if (!OperatingSystem.IsWindows() && (File.GetUnixFileMode(path) & (UnixFileMode.GroupRead | UnixFileMode.GroupWrite | UnixFileMode.GroupExecute | UnixFileMode.OtherRead | UnixFileMode.OtherWrite | UnixFileMode.OtherExecute)) != 0)
            throw new ArgumentException("Apple configuration and key files must be accessible only to their owner.");
    }
    public void Validate(bool writes = false)
    {
        if (DevelopmentTeam is null || KeyId is null || IssuerId is null || RequiredDeviceUdids is null || !Regex.IsMatch(DevelopmentTeam, "^[A-Z0-9]{10}\\z") || !Regex.IsMatch(KeyId, "^[A-Z0-9]{10}\\z") ||
            !Guid.TryParseExact(IssuerId, "D", out var issuer) || issuer == Guid.Empty)
            throw new ArgumentException("Configure the Apple signing team, API Key ID and Issuer UUID.");
        PrivateFile(KeyFile, 65536);
        if (writes && (!AllowAppleWrites || RequiredDeviceUdids.Length is < 1 or > 1000 ||
            RequiredDeviceUdids.Any(x => x is null || !Regex.IsMatch(x, "^(?:[A-Fa-f0-9]{40}|[A-Fa-f0-9]{8}-[A-Fa-f0-9]{16})\\z")) ||
            RequiredDeviceUdids.Distinct(StringComparer.OrdinalIgnoreCase).Count() != RequiredDeviceUdids.Length))
            throw new InvalidOperationException("Apple provisioning requires explicit writes and distinct registered test-device UDIDs.");
    }
}

public interface IAppleApiTokens { string Create(); }

public sealed class AppleApiTokens(AppleApiOptions options, TimeProvider? time = null) : IAppleApiTokens
{
    private static string Encode(byte[] value) => Convert.ToBase64String(value).TrimEnd('=').Replace('+', '-').Replace('/', '_');
    public string Create()
    {
        options.Validate();
        using var key = ECDsa.Create(); key.ImportFromPem(File.ReadAllText(options.KeyFile));
        if (key.ExportParameters(false).Curve.Oid.Value != "1.2.840.10045.3.1.7")
            throw new InvalidOperationException("App Store Connect requires a private P-256 key.");
        var now = (time ?? TimeProvider.System).GetUtcNow().ToUnixTimeSeconds();
        var header = Encode(JsonSerializer.SerializeToUtf8Bytes(new { alg = "ES256", kid = options.KeyId, typ = "JWT" }));
        // Optional per-request JWT scope is omitted; transport below enforces the permitted operations.
        var payload = Encode(JsonSerializer.SerializeToUtf8Bytes(new { iss = options.IssuerId, iat = now - 5, exp = now + 120, aud = "appstoreconnect-v1" }));
        var input = header + "." + payload;
        return input + "." + Encode(key.SignData(Encoding.ASCII.GetBytes(input), HashAlgorithmName.SHA256, DSASignatureFormat.IeeeP1363FixedFieldConcatenation));
    }
}

public sealed class AppleApiException(HttpStatusCode status, string code) : Exception($"Apple API failed with HTTP {(int)status} ({code}).")
{
    public HttpStatusCode Status { get; } = status;
    public string Code { get; } = code;
}
public sealed class AppleApiUnavailableException() : Exception("Apple API transport could not complete; reconcile owned resources before retrying.");

public sealed class AppleApiClient(HttpClient http, AppleApiOptions options, IAppleApiTokens tokens)
{
    public const string Origin = "https://api.appstoreconnect.apple.com/";
    private const int ResponseLimit = 4 * 1024 * 1024;
    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web);
    public static HttpClient CreateHttpClient() => new(new SocketsHttpHandler { AllowAutoRedirect = false }) { Timeout = TimeSpan.FromSeconds(45) };
    private static Uri Target(string path)
    {
        if (path.Length > 8192 || path.Any(char.IsControl) || path.StartsWith('/') || path.Contains('#')) throw new ArgumentException("Invalid Apple resource path.");
        var uri = new Uri(Origin + path);
        if (uri.Scheme != "https" || uri.Host != "api.appstoreconnect.apple.com" || !uri.IsDefaultPort || uri.UserInfo != "" ||
            !Regex.IsMatch(uri.AbsolutePath, "^/v1/(?:bundleIds|bundleIdCapabilities|certificates|devices|profiles)(?:/[A-Za-z0-9_-]+){0,3}\\z") ||
            path.Contains("..", StringComparison.Ordinal) || path.Contains("//", StringComparison.Ordinal))
            throw new ArgumentException("Apple resource paths must remain on the expected API host.");
        return uri;
    }
    public async Task<JsonObject> SendAsync(HttpMethod method, string path, object? body, CancellationToken ct)
    {
        var target = Target(path);
        if (method != HttpMethod.Get && (!options.AllowAppleWrites || method != HttpMethod.Post ||
            path is not ("v1/bundleIds" or "v1/bundleIdCapabilities" or "v1/profiles")))
            throw new InvalidOperationException("Only explicitly enabled tenant bundle, capability and profile creation is permitted.");
        using var request = new HttpRequestMessage(method, target);
        if (body != null) request.Content = JsonContent.Create(body, options: Json);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", tokens.Create());
        request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        try
        {
            using var response = await http.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, ct);
            await using var stream = await response.Content.ReadAsStreamAsync(ct);
            using var output = new MemoryStream(); var buffer = new byte[8192]; int count;
            while ((count = await stream.ReadAsync(buffer, ct)) != 0)
            {
                if (output.Length + count > ResponseLimit) throw new InvalidOperationException("Apple response exceeds the supported bounds.");
                output.Write(buffer, 0, count);
            }
            JsonObject? value = null;
            try { if (output.Length != 0) value = JsonNode.Parse(output.ToArray()) as JsonObject; } catch (JsonException) { }
            if (!response.IsSuccessStatusCode)
            {
                var code = value?["errors"] is JsonArray errors && errors.Count > 0 && errors[0] is JsonObject error &&
                    error["code"] is JsonValue codeValue && codeValue.TryGetValue<string>(out var parsedCode) ? parsedCode : "UNKNOWN";
                if (!Regex.IsMatch(code, "^[A-Z0-9_.-]{1,100}\\z")) code = "UNKNOWN";
                throw new AppleApiException(response.StatusCode, code);
            }
            return value ?? throw new InvalidOperationException("Apple returned an invalid response shape.");
        }
        catch (HttpRequestException) { throw new AppleApiUnavailableException(); }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested) { throw new AppleApiUnavailableException(); }
    }
    public async Task<IReadOnlyList<JsonObject>> ListAsync(string path, CancellationToken ct)
    {
        var collection = Target(path).AbsolutePath; var seenPages = new HashSet<string>(); var ids = new HashSet<string>();
        var result = new List<JsonObject>();
        for (var page = 0; page < 20; page++)
        {
            if (!seenPages.Add(path)) throw new InvalidOperationException("Apple pagination repeated a cursor.");
            var root = await SendAsync(HttpMethod.Get, path, null, ct);
            if (root["data"] is not JsonArray data || data.Count > 200) throw new InvalidOperationException("Invalid bounded Apple collection.");
            foreach (var item in data)
            {
                var value = item as JsonObject ?? throw new InvalidOperationException("Invalid Apple resource.");
                if (!ids.Add(Id(value))) throw new InvalidOperationException("Apple collection repeated a resource.");
                result.Add(value);
            }
            var next = root["links"]?["next"]?.GetValue<string>();
            if (string.IsNullOrEmpty(next)) return result;
            if (!Uri.TryCreate(next, UriKind.Absolute, out var uri) || uri.Scheme != "https" || uri.Host != "api.appstoreconnect.apple.com" ||
                !uri.IsDefaultPort || uri.UserInfo != "" || uri.Fragment != "" || uri.AbsolutePath != collection)
                throw new InvalidOperationException("Apple pagination changed its host or collection.");
            path = uri.PathAndQuery.TrimStart('/'); Target(path);
        }
        throw new InvalidOperationException("Apple collection exceeds the supported page limit.");
    }
    public static string Text(JsonObject value, string field) => value[field]?.GetValue<string>() ?? throw new InvalidOperationException("Apple response is missing a field.");
    public static string Id(JsonObject value)
    {
        var id = Text(value, "id");
        if (!Regex.IsMatch(id, "^[A-Za-z0-9_-]{1,128}\\z")) throw new InvalidOperationException("Invalid Apple resource ID.");
        return id;
    }
    public static string Query(string path, params (string Name, string Value)[] values) => path + "?" + string.Join('&', values.Select(x => Uri.EscapeDataString(x.Name) + "=" + Uri.EscapeDataString(x.Value)));
}
