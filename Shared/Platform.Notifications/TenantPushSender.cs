using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Platform.Google;
using Platform.Security;

namespace Platform.Notifications;

public sealed record TenantPushMessage(string? Title, string? Body, string? ImageUrl = null,
    string? ClickUrl = null, IReadOnlyDictionary<string, string>? Data = null)
{
    public FirebasePushContent Content(bool allowLocalImages = false)
    {
        var data = Data == null ? new Dictionary<string,string>() : new Dictionary<string,string>(Data);
        if (!string.IsNullOrEmpty(ClickUrl))
        {
            if (!Uri.TryCreate(ClickUrl, UriKind.Absolute, out var link) || link.Scheme is not ("http" or "https") || !string.IsNullOrEmpty(link.UserInfo))
                throw new ArgumentException("Invalid notification action URL.");
            data["action_link"] = ClickUrl;
        }
        var content = new FirebasePushContent(Title, Body, ImageUrl, data);
        content.Validate(allowLocalImages);
        return content;
    }
}

public sealed record TenantPushReceipt(int Attempted, int Accepted, string Provider);

// Trusted server API: callers must obtain the tenant identity from an authenticated tenant scope.
public interface ITenantPushSender
{
    Task<TenantPushReceipt> SendAsync(string tenantIdOrAlias, IReadOnlyList<string> registrationTokens,
        TenantPushMessage message, CancellationToken ct = default);
}

internal static class PushInput
{
    public static string[] Tokens(IReadOnlyList<string> tokens)
    {
        if (tokens.Count is < 1 or > 500 || tokens.Any(t => string.IsNullOrWhiteSpace(t) || t.Length > 4096 || t == "[DENIED]"))
            throw new ArgumentException("Supply 1-500 valid notification registration tokens.");
        return tokens.Distinct(StringComparer.Ordinal).ToArray();
    }
    public static void Canonical(string tenant)
    {
        if (!Guid.TryParseExact(tenant, "N", out var id) || id == Guid.Empty || id.ToString("N") != tenant)
            throw new InvalidOperationException("Notification storage requires a canonical tenant identity.");
    }
}

public sealed class FcmTenantPushSender(ITenantSecrets secrets, FirebaseCloudMessaging firebase) : ITenantPushSender
{
    public async Task<TenantPushReceipt> SendAsync(string tenantIdOrAlias, IReadOnlyList<string> registrationTokens,
        TenantPushMessage message, CancellationToken ct = default)
    {
        var tokens = PushInput.Tokens(registrationTokens);
        var content = message.Content();
        var tenant = await secrets.ResolveAsync(tenantIdOrAlias, ct);
        PushInput.Canonical(tenant);
        var value = await secrets.GetAsync(tenant, TenantFirebaseConfiguration.SecretName, ct);
        var config = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(value)
            ?? throw new InvalidOperationException("Tenant Firebase configuration is missing.");
        if (config.TenantId != tenant) throw new InvalidOperationException("Firebase configuration belongs to a different tenant.");
        FirebaseConfigValidator.Validate(config);
        var accepted = 0;
        foreach (var token in tokens)
        {
            try
            {
                await firebase.SendAsync(config, token, content, ct: ct);
                accepted++;
            }
            catch (GoogleApiException error) when (error.StatusCode is HttpStatusCode.BadRequest or HttpStatusCode.NotFound)
            {
                // A rejected registration token must not suppress valid recipients or expose provider bodies.
            }
        }
        return new(tokens.Length, accepted, "Fcm");
    }
}

public sealed class LocalSinkTenantPushSender(ITenantSecrets secrets, NotificationOptions options) : ITenantPushSender
{
    public async Task<TenantPushReceipt> SendAsync(string tenantIdOrAlias, IReadOnlyList<string> registrationTokens,
        TenantPushMessage message, CancellationToken ct = default)
    {
        var tokens = PushInput.Tokens(registrationTokens);
        message.Content(allowLocalImages: true);
        var tenant = await secrets.ResolveAsync(tenantIdOrAlias, ct);
        PushInput.Canonical(tenant);
        var directory = Path.Combine(options.LocalDirectory, tenant, "push");
        Directory.CreateDirectory(directory);
        var name = Guid.NewGuid().ToString("N");
        var temporary = Path.Combine(directory, name + ".tmp");
        var path = Path.Combine(directory, name + ".json");
        try
        {
            var fileOptions = new FileStreamOptions { Mode = FileMode.CreateNew, Access = FileAccess.Write, Share = FileShare.None };
            if (!OperatingSystem.IsWindows()) fileOptions.UnixCreateMode = UnixFileMode.UserRead | UnixFileMode.UserWrite;
            await using (var stream = new FileStream(temporary, fileOptions))
                await JsonSerializer.SerializeAsync(stream, new {
                    tenantId = tenant, createdAt = DateTimeOffset.UtcNow, message,
                    registrationTokenSha256 = tokens.Select(t => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(t))).ToLowerInvariant()).ToArray()
                }, cancellationToken: ct);
            File.Move(temporary, path);
        }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
        return new(tokens.Length, tokens.Length, "LocalSink");
    }
}

public sealed class DisabledTenantPushSender : ITenantPushSender
{
    public Task<TenantPushReceipt> SendAsync(string tenantIdOrAlias, IReadOnlyList<string> registrationTokens,
        TenantPushMessage message, CancellationToken ct = default)
        => throw new InvalidOperationException("Tenant notifications are disabled; choose a provider explicitly.");
}
