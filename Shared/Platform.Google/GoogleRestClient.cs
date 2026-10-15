using System.Collections.Concurrent;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using Google.Apis.Auth.OAuth2;

namespace Platform.Google;

public enum GoogleApi { ResourceManager, ServiceUsage, Firebase, Billing, Distribution, Messaging }

public sealed class GoogleApiException(GoogleApi api, HttpStatusCode status)
    : Exception($"Google {api} request failed with HTTP {(int)status}.")
{
    public HttpStatusCode StatusCode { get; } = status;
}

public interface IGoogleAccessTokenSource
{
    Task<string> GetAsync(string scope, CancellationToken ct);
}

public sealed class ApplicationDefaultTokenSource : IGoogleAccessTokenSource
{
    private readonly Lazy<Task<GoogleCredential>> credential = new(() => GoogleCredential.GetApplicationDefaultAsync());
    private readonly ConcurrentDictionary<string, GoogleCredential> scoped = new();
    public async Task<string> GetAsync(string scope, CancellationToken ct)
    {
        var root = await credential.Value.WaitAsync(ct);
        var selected = scoped.GetOrAdd(scope, value => root.CreateScoped(value));
        return await ((ITokenAccess)selected).GetAccessTokenForRequestAsync(cancellationToken: ct);
    }
}

public sealed class GoogleRestClient(HttpClient http, IGoogleAccessTokenSource tokens)
{
    public const string CloudScope = "https://www.googleapis.com/auth/cloud-platform";
    public const string MessagingScope = "https://www.googleapis.com/auth/firebase.messaging";
    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web);
    private static string Host(GoogleApi api) => api switch
    {
        GoogleApi.ResourceManager => "cloudresourcemanager.googleapis.com",
        GoogleApi.ServiceUsage => "serviceusage.googleapis.com",
        GoogleApi.Firebase => "firebase.googleapis.com",
        GoogleApi.Billing => "cloudbilling.googleapis.com",
        GoogleApi.Distribution => "firebaseappdistribution.googleapis.com",
        GoogleApi.Messaging => "fcm.googleapis.com",
        _ => throw new ArgumentOutOfRangeException(nameof(api))
    };

    public Task<JsonObject?> SendAsync(GoogleApi api, HttpMethod method, string path, object? body, CancellationToken ct, bool notFoundIsNull = false)
        => SendContentAsync(api, method, path, body == null ? null : JsonContent.Create(body, options: Json), ct, notFoundIsNull);

    public async Task<JsonObject?> SendContentAsync(GoogleApi api, HttpMethod method, string path, HttpContent? content,
        CancellationToken ct, bool notFoundIsNull = false, IReadOnlyDictionary<string, string>? headers = null)
    {
        if (!Regex.IsMatch(path, "^(v[0-9][a-z0-9]*/|upload/v1/)[A-Za-z0-9_./:%?=&~-]+$") ||
            path.Contains("..", StringComparison.Ordinal) || path.Contains("//", StringComparison.Ordinal))
            throw new ArgumentException("Google API paths must be relative resource paths.");
        using var request = new HttpRequestMessage(method, new Uri("https://" + Host(api) + "/" + path)) { Content = content };
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", await tokens.GetAsync(
            api == GoogleApi.Messaging ? MessagingScope : CloudScope, ct));
        if (headers != null) foreach (var pair in headers) request.Headers.Add(pair.Key, pair.Value);
        using var response = await http.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, ct);
        if (notFoundIsNull && response.StatusCode == HttpStatusCode.NotFound) return null;
        // Provider error bodies may contain private resource data. Do not retain them in exceptions/logs.
        if (!response.IsSuccessStatusCode) throw new GoogleApiException(api, response.StatusCode);
        if (response.Content.Headers.ContentLength == 0) return new JsonObject();
        var bytes = await response.Content.ReadAsByteArrayAsync(ct);
        if (bytes.Length == 0) return new JsonObject();
        return JsonNode.Parse(bytes) as JsonObject ?? throw new InvalidOperationException("Invalid Google response shape.");
    }

    public async Task<JsonObject> WaitAsync(GoogleApi api, string version, JsonObject operation, GoogleCloudOptions options, CancellationToken ct)
    {
        using var deadline = CancellationTokenSource.CreateLinkedTokenSource(ct);
        deadline.CancelAfter(TimeSpan.FromSeconds(options.OperationTimeoutSeconds));
        try
        {
            while (true)
            {
                if (operation["done"]?.GetValue<bool>() == true)
                {
                    if (operation["error"] != null) throw new InvalidOperationException("Google operation reported failure.");
                    return operation["response"] as JsonObject ?? new JsonObject();
                }
                var name = Text(operation, "name");
                if (!Regex.IsMatch(name, "^(operations|projects/[A-Za-z0-9:_-]+/apps/[A-Za-z0-9:_-]+/releases/[A-Za-z0-9_-]+/operations)/[A-Za-z0-9._~-]+$"))
                    throw new InvalidOperationException("Invalid Google operation resource.");
                await Task.Delay(TimeSpan.FromSeconds(options.PollIntervalSeconds), deadline.Token);
                operation = await SendAsync(api, HttpMethod.Get, version + "/" + name, null, deadline.Token)
                    ?? throw new InvalidOperationException("Google operation is unavailable.");
            }
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        { throw new TimeoutException("Google operation did not complete before its deadline."); }
    }

    public static string Text(JsonObject value, string key) => value[key]?.GetValue<string>()
        ?? throw new InvalidOperationException("Google response is missing a required field.");
    public static string Segment(string value) => Uri.EscapeDataString(value);
}
