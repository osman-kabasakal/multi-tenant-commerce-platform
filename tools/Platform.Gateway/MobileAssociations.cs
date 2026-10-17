using System.Text.RegularExpressions;
using Npgsql;

namespace Platform.Gateway;

public sealed record MobileAssociation(string StoreUrl, string AndroidPackage, string IosBundle,
    string? AndroidCertificateSha256, string? IosTeam);

public interface IMobileAssociationSource
{
    Task<IReadOnlyList<MobileAssociation>> ReadAsync(string tenant, CancellationToken ct);
}

/// <summary>Read public signing bindings from completed identities; never export SDK or private key material.</summary>
public sealed class PostgresMobileAssociationSource : IMobileAssociationSource, IAsyncDisposable
{
    private readonly NpgsqlDataSource database;
    public PostgresMobileAssociationSource(string connectionString) => database = NpgsqlDataSource.Create(connectionString);
    public async Task<IReadOnlyList<MobileAssociation>> ReadAsync(string tenant, CancellationToken ct)
    {
        if (!Guid.TryParseExact(tenant, "N", out var id) || id == Guid.Empty || id.ToString("N") != tenant)
            throw new InvalidOperationException("Select an owned tenant.");
        await using var command = database.CreateCommand("""
            SELECT request->>'StoreUrl',android_package,ios_bundle,
                CASE WHEN android_receipt IS NOT NULL THEN COALESCE(prepared->>'AndroidCertificateSha256',android_receipt->'Resources'->>'signingCertificateSha256') END,
                CASE WHEN ios_receipt IS NOT NULL THEN prepared->'IosPlan'->>'DevelopmentTeam' END
            FROM platform_provisioning.mobile_identity_versions
            WHERE tenant_id=$1 AND state IN ('Active','Retired') ORDER BY generation DESC LIMIT 100
            """);
        command.Parameters.AddWithValue(tenant);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var result = new List<MobileAssociation>();
        while (await reader.ReadAsync(ct))
            result.Add(new(reader.GetString(0), reader.GetString(1), reader.GetString(2),
                reader.IsDBNull(3) ? null : reader.GetString(3), reader.IsDBNull(4) ? null : reader.GetString(4)));
        return result;
    }
    public ValueTask DisposeAsync() => database.DisposeAsync();
}

public static class MobileAssociations
{
    public const string AndroidPath = "/.well-known/assetlinks.json";
    public const string ApplePath = "/.well-known/apple-app-site-association";
    public static bool Handles(PathString path) => path == AndroidPath || path == ApplePath;

    public static async Task WriteAsync(HttpContext context, TenantRoute route, IMobileAssociationSource source)
    {
        if (route.Admin) { context.Response.StatusCode = 404; return; }
        if (!HttpMethods.IsGet(context.Request.Method) && !HttpMethods.IsHead(context.Request.Method))
        { context.Response.StatusCode = 405; context.Response.Headers.Allow = "GET, HEAD"; return; }
        var entries = (await source.ReadAsync(route.TenantId, context.RequestAborted)).Where(x =>
            Uri.TryCreate(x.StoreUrl, UriKind.Absolute, out var origin) && origin.Scheme == "https" && origin.UserInfo.Length == 0 &&
            origin.Authority.Equals(context.Request.Host.Value, StringComparison.OrdinalIgnoreCase)).ToArray();
        var android = context.Request.Path == AndroidPath;
        var approved = entries.Where(x => android
            ? Regex.IsMatch(x.AndroidPackage, @"^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+\z") && Regex.IsMatch(x.AndroidCertificateSha256 ?? "", @"^[a-f0-9]{64}\z")
            : Regex.IsMatch(x.IosBundle, @"^[a-zA-Z][a-zA-Z0-9-]*(\.[a-zA-Z][a-zA-Z0-9-]*)+\z") && Regex.IsMatch(x.IosTeam ?? "", @"^[A-Z0-9]{10}\z")).ToArray();
        if (approved.Length == 0) { context.Response.StatusCode = 404; return; }
        context.Response.ContentType = "application/json";
        context.Response.Headers.CacheControl = "public, max-age=300";
        if (HttpMethods.IsHead(context.Request.Method)) return;
        if (android)
            await context.Response.WriteAsJsonAsync(approved.Select(x => new {
                relation = new[] { "delegate_permission/common.handle_all_urls" },
                target = new { @namespace = "android_app", package_name = x.AndroidPackage,
                    sha256_cert_fingerprints = new[] { string.Join(":", Enumerable.Range(0, 32).Select(i => x.AndroidCertificateSha256!.Substring(i * 2, 2).ToUpperInvariant())) } }
            }).DistinctBy(x => x.target.package_name), context.RequestAborted);
        else
            await context.Response.WriteAsJsonAsync(new { applinks = new { apps = Array.Empty<string>(),
                details = approved.Select(x => new { appID = x.IosTeam + "." + x.IosBundle,
                    paths = new[] { "NOT /Admin", "NOT /Admin/*", "NOT /admin", "NOT /admin/*", "NOT /.well-known/*", "/*" } }).DistinctBy(x => x.appID) } }, context.RequestAborted);
    }
}
