using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace Platform.Hosting;

// Public route metadata. Only the trusted provisioning worker writes this directory; runtimes mount it read-only.
public sealed record TenantCustomHostRoute(int Version,string Profile,string TenantId,string Slug,string StoreId,
    Guid DomainRequestId,string Host,string Role,string StoreUrl,string AdminUrl,bool CertificateAllowed)
{
    public void Validate(string requestedHost)
    {
        if(Version!=1 || Profile!="Portable" || !Guid.TryParseExact(TenantId,"N",out var tenant) || tenant==Guid.Empty || tenant.ToString("N")!=TenantId ||
            DomainRequestId==Guid.Empty || !Regex.IsMatch(Slug,"^[a-z][a-z0-9-]{1,38}[a-z0-9]$",RegexOptions.CultureInvariant) ||
            string.IsNullOrWhiteSpace(StoreId) || StoreId.Length>200 || !CertificateAllowed || Host!=requestedHost ||
            Role is not ("store" or "admin")) throw new InvalidOperationException("Invalid custom tenant route binding.");
        var store=Origin(StoreUrl,"/");var admin=Origin(AdminUrl,"/Admin");
        if(store.Host==admin.Host || Host!=(Role=="admin"?admin.Host:store.Host))throw new InvalidOperationException("The custom route belongs to another hostname.");
    }
    private static Uri Origin(string value,string path)
    {
        if(value.Length>2000 || !Uri.TryCreate(value,UriKind.Absolute,out var uri) || uri.Scheme!="https" || !uri.IsDefaultPort ||
            uri.AbsolutePath!=path || uri.UserInfo.Length!=0 || uri.Query.Length!=0 || uri.Fragment.Length!=0 ||
            !TenantCustomHostRoutes.ValidHost(uri.Host))throw new InvalidOperationException("Invalid custom route origin.");
        return uri;
    }
}
public static class TenantCustomHostRoutes
{
    private static readonly JsonSerializerOptions Json=new(JsonSerializerDefaults.Web);
    public static bool ValidHost(string host)=>host.Length is >0 and <=253 && host==host.ToLowerInvariant() && host.Split('.').Length>=2 &&
        !System.Net.IPAddress.TryParse(host,out _) && host.Split('.').All(label=>Regex.IsMatch(label,"^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\\z",RegexOptions.CultureInvariant));
    public static string PathFor(string directory,string host)
    {
        if(!ValidHost(host))throw new ArgumentException("Use a canonical DNS hostname.");
        return Path.Combine(directory,"custom-host-"+Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(host))).ToLowerInvariant()+".json");
    }
    public static async Task<TenantCustomHostRoute?> FindAsync(string directory,string host,CancellationToken ct=default)
    {
        if(!ValidHost(host))return null;
        var path=PathFor(directory,host);if(!File.Exists(path))return null;
        var file=new FileInfo(path);if(file.LinkTarget!=null || file.Length is <1 or >16384)throw new InvalidOperationException("A custom tenant route must be a bounded regular metadata file.");
        var route=JsonSerializer.Deserialize<TenantCustomHostRoute>(await File.ReadAllTextAsync(path,ct),Json) ?? throw new InvalidOperationException("Missing custom tenant route metadata.");
        route.Validate(host);return route;
    }
}
