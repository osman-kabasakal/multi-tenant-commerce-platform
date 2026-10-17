using Microsoft.Extensions.Configuration;

namespace Platform.Gateway;

public sealed class GatewayOptions
{
    public string Provider { get; init; } = "";
    public string RouteDirectory { get; init; } = "";
    public bool CustomDomainsEnabled { get; init; }
    public string CertificatePermissionPeer { get; init; } = "";
    public string StoreBaseUrl { get; init; } = "";
    public string AdminBaseUrl { get; init; } = "";
    public string CommerceUpstream { get; init; } = "";
    public string AdminUpstream { get; init; } = "";
    public bool AllowHttpUpstreams { get; init; }
    public string IdentityAuthority { get; init; } = "";
    public string IdentityRealm { get; init; } = "";
    public string? IdentityRootCertificateFile { get; init; }
    public string? UpstreamRootCertificateFile { get; init; }
    public int TokenCacheSeconds { get; init; } = 60;
    public int TokenCacheEntries { get; init; } = 1000;

    public void Validate(IConfiguration config)
    {
        if (Provider != "Directory" || config.GetValue<bool>("LocalDemo:Enabled") ||
            config["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure") ||
            !config.GetValue<bool>("PlatformSecurity:ReadOnly") || config.GetValue<bool>("PlatformSecurity:InitializeSchema"))
            throw new InvalidOperationException("Gateway requires explicit Directory routing and read-only deployment secret storage.");
        if (!Path.IsPathFullyQualified(RouteDirectory) || !Directory.Exists(RouteDirectory) || Path.GetFullPath(RouteDirectory) == Path.GetPathRoot(RouteDirectory))
            throw new InvalidOperationException("Mount an absolute private tenant route directory.");
        for (var path = new DirectoryInfo(RouteDirectory); path != null; path = path.Parent)
            if (path.LinkTarget != null) throw new InvalidOperationException("Tenant route directories cannot contain symbolic links.");
        if (CustomDomainsEnabled && !System.Net.IPAddress.TryParse(CertificatePermissionPeer,out _))
            throw new InvalidOperationException("Bind custom domain certificate permission to the private edge peer.");
        var store = Origin(StoreBaseUrl, false); var admin = Origin(AdminBaseUrl, false);
        if (store.Host == admin.Host || Uri.CheckHostName(store.Host) != UriHostNameType.Dns || Uri.CheckHostName(admin.Host) != UriHostNameType.Dns)
            throw new InvalidOperationException("Configure distinct store/admin parent domain origins.");
        Origin(CommerceUpstream, AllowHttpUpstreams); Origin(AdminUpstream, AllowHttpUpstreams); Origin(IdentityAuthority, false);
        if (!System.Text.RegularExpressions.Regex.IsMatch(IdentityRealm, "^[a-zA-Z0-9_-]{1,100}$") || TokenCacheSeconds is < 1 or > 240 || TokenCacheEntries is < 1 or > 100000)
            throw new InvalidOperationException("Configure a valid identity realm and bounded token cache.");
    }

    internal static Uri Origin(string value, bool allowHttp)
    {
        if (!Uri.TryCreate(value, UriKind.Absolute, out var uri) || (uri.Scheme != "https" && !(allowHttp && uri.Scheme == "http")) ||
            uri.AbsolutePath != "/" || !string.IsNullOrEmpty(uri.UserInfo) || !string.IsNullOrEmpty(uri.Query) || !string.IsNullOrEmpty(uri.Fragment) || uri.Host.Contains('*'))
            throw new InvalidOperationException("Configure explicit gateway origins without credentials, paths, queries or wildcards.");
        return uri;
    }
}
