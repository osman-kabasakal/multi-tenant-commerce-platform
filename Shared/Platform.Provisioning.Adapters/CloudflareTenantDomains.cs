using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Nodes;
using Platform.Security;
using System.Text.RegularExpressions;

namespace Platform.Provisioning.Adapters;

public sealed class CustomDomainOptions
{
    public bool Enabled { get; init; }
    public bool AllowCloudWrites { get; init; }
    public string DeploymentId { get; init; } = "";
    public string ApiTokenFile { get; init; } = "";
    public string OriginIpv4 { get; init; } = "";
    public string[] ReservedHosts { get; init; } = [];
    public string AcmeEmail { get; init; } = "";
    public string? IngressConnectAddress { get; init; }
    public void Validate()
    {
        if (!Enabled || !AllowCloudWrites || !Regex.IsMatch(DeploymentId,"^[a-z][a-z0-9-]{2,39}\\z") ||
            !IPAddress.TryParse(OriginIpv4, out var ip) || ip.AddressFamily != System.Net.Sockets.AddressFamily.InterNetwork ||
            IPAddress.IsLoopback(ip) || ip.GetAddressBytes()[0] is 0 or 10 or >=224 ||
            ip.GetAddressBytes()[0] == 169 && ip.GetAddressBytes()[1] == 254 ||
            ip.GetAddressBytes()[0] == 192 && ip.GetAddressBytes()[1] == 168 ||
            ip.GetAddressBytes()[0] == 172 && ip.GetAddressBytes()[1] is >=16 and <=31 ||
            ReservedHosts.Length == 0 || ReservedHosts.Any(h => TenantDomainNames.Normalize(h) != h) ||
            !System.Net.Mail.MailAddress.TryCreate(AcmeEmail, out var email) || email.Address != AcmeEmail)
            throw new InvalidOperationException("Configure explicit custom domain writes, the public origin IPv4, platform hosts and ACME contact.");
        if (IngressConnectAddress != null && !IPAddress.TryParse(IngressConnectAddress,out _)) throw new InvalidOperationException("Use an explicit trusted ingress IP for custom domain probes.");
        if (!Path.IsPathFullyQualified(ApiTokenFile)) throw new InvalidOperationException("Use an absolute private Cloudflare token file.");
        var file = new FileInfo(ApiTokenFile);
        if (!file.Exists || file.LinkTarget != null || file.Length is < 1 or > 8192) throw new InvalidOperationException("Use a bounded regular Cloudflare token file.");
        for (var directory = file.Directory; directory != null; directory = directory.Parent)
            if (directory.LinkTarget != null) throw new InvalidOperationException("Cloudflare credential paths cannot contain symbolic links.");
        if (!Path.IsPathFullyQualified(ApiTokenFile) || !OperatingSystem.IsWindows() &&
            (File.GetUnixFileMode(ApiTokenFile) & (UnixFileMode.GroupRead | UnixFileMode.GroupWrite | UnixFileMode.OtherRead | UnixFileMode.OtherWrite)) != 0)
            throw new InvalidOperationException("Use an owner-only Cloudflare token file outside source control.");
    }
}

/// <summary>The central token proves API access. Only the separately entered tenant TXT challenge proves tenant ownership.</summary>
public sealed class CloudflareTenantDomains(CustomDomainOptions options, IHttpClientFactory clients,ITenantSecrets? secrets=null) : ITenantDomainOwnership
{
    private const string Api = "https://api.cloudflare.com/client/v4/";
    private static string Text(JsonObject value,string name) => value[name]?.GetValue<string>() ?? throw new TenantDomainException("DomainProviderResponseInvalid");
    private HttpClient Client()
    {
        options.Validate();
        var client=clients.CreateClient("onboarding-dns");
        var token=File.ReadAllText(options.ApiTokenFile).Trim();
        if (token.Length is < 20 or > 8192 || token.Any(char.IsWhiteSpace)) { client.Dispose(); throw new InvalidOperationException("Invalid private Cloudflare token file."); }
        client.DefaultRequestHeaders.Authorization=new AuthenticationHeaderValue("Bearer",token); return client;
    }
    private static async Task<JsonObject> ReadAsync(HttpResponseMessage response,CancellationToken ct)
    {
        using(response)
        {
            if (!response.IsSuccessStatusCode) throw new TenantDomainException(response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden ? "DomainNotAccessible" : "DomainProviderUnavailable");
            if (response.Content.Headers.ContentLength > 1024*1024) throw new TenantDomainException("DomainProviderResponseInvalid");
            var bytes=await response.Content.ReadAsByteArrayAsync(ct);
            if (bytes.Length>1024*1024) throw new TenantDomainException("DomainProviderResponseInvalid");
            var data=JsonNode.Parse(bytes) as JsonObject ?? throw new TenantDomainException("DomainProviderResponseInvalid");
            if (data["success"]?.GetValue<bool>() != true) throw new TenantDomainException("DomainProviderRejected");
            if (data["result_info"]?["total_pages"]?.GetValue<int>() > 1) throw new TenantDomainException("DomainProviderResponseInvalid");
            return data;
        }
    }
    private static async Task<JsonObject[]> RecordsAsync(HttpClient client,string zone,string host,CancellationToken ct)
    {
        var data=await ReadAsync(await client.GetAsync(Api+"zones/"+zone+"/dns_records?name="+Uri.EscapeDataString(host)+"&per_page=100",ct),ct);
        var records=data["result"] as JsonArray ?? throw new TenantDomainException("DomainProviderResponseInvalid");
        if (records.Count>100 || records.Any(x => x is not JsonObject)) throw new TenantDomainException("DomainProviderResponseInvalid");
        return records.OfType<JsonObject>().ToArray();
    }
    private async Task<TenantDomainAccess> ZoneAsync(HttpClient client,TenantDomainBinding binding,CancellationToken ct)
    {
        var labels=binding.Request.StoreHost.Split('.');
        for (var index=0;index<labels.Length-1;index++)
        {
            var name=string.Join('.',labels[index..]);
            var data=await ReadAsync(await client.GetAsync(Api+"zones?name="+Uri.EscapeDataString(name)+"&status=active&per_page=50",ct),ct);
            var zones=data["result"] as JsonArray ?? throw new TenantDomainException("DomainProviderResponseInvalid");
            if (zones.Count==0) continue;
            if (zones.Count!=1 || zones[0] is not JsonObject zone || Text(zone,"name")!=name || Text(zone,"status")!="active" ||
                !Regex.IsMatch(Text(zone,"id"),"^[a-f0-9]{32}\\z") || zone["paused"]?.GetValue<bool>()==true)
                throw new TenantDomainException("DomainNotAccessible");
            if (options.ReservedHosts.Any(h => TenantDomainNames.Within(h,name))) throw new TenantDomainException("DomainReservedForPlatform");
            if (binding.ZoneId != null && (binding.ZoneId != Text(zone,"id") || binding.ZoneName != name)) throw new TenantDomainException("DomainZoneChanged");
            return new(Text(zone,"id"),name);
        }
        throw new TenantDomainException("DomainNotAccessible");
    }
    private string Marker(TenantDomainBinding binding) => "platform="+options.DeploymentId+";tenant="+binding.Request.TenantId;
    private bool Owned(JsonObject record,string host,TenantDomainBinding binding) => record["type"]?.GetValue<string>()=="A" &&
        record["name"]?.GetValue<string>()==host && record["content"]?.GetValue<string>()==options.OriginIpv4 &&
        record["comment"]?.GetValue<string>()==Marker(binding) && record["proxied"]?.GetValue<bool>()==false;
    private bool Replaceable(JsonObject record,string host) => record["type"]?.GetValue<string>()=="A" &&
        record["name"]?.GetValue<string>()==host && record["content"]?.GetValue<string>()!=options.OriginIpv4 &&
        IPAddress.TryParse(record["content"]?.GetValue<string>(),out var ip) && ip.AddressFamily==System.Net.Sockets.AddressFamily.InterNetwork &&
        !(record["comment"]?.GetValue<string>()??"").Contains("platform=",StringComparison.OrdinalIgnoreCase) &&
        !(record["comment"]?.GetValue<string>()??"").Contains("tenant=",StringComparison.OrdinalIgnoreCase);
    private static JsonObject Snapshot(JsonObject record)
    {
        var id=Text(record,"id");if(!Regex.IsMatch(id,"^[a-f0-9]{32}\\z"))throw new TenantDomainException("DomainProviderResponseInvalid");
        var result=new JsonObject();
        foreach(var field in new[]{"id","type","name","content","ttl","proxied","comment","tags","settings"})
            result[field]=record[field]?.DeepClone();
        return result;
    }
    private static bool Address(JsonObject record) => record["type"]?.GetValue<string>() is "A" or "AAAA" or "CNAME";
    private async Task CheckRecordsAsync(HttpClient client,TenantDomainAccess access,TenantDomainBinding binding,CancellationToken ct)
    {
        foreach(var host in new[]{binding.Request.StoreHost,binding.Request.AdminHost})
        {
            var records=(await RecordsAsync(client,access.ZoneId,host,ct)).Where(Address).ToArray();
            if (records.Length>1 || records.Length==1 && !Owned(records[0],host,binding) && !Replaceable(records[0],host)) throw new TenantDomainException("DomainDnsConflict");
            // A foreign wildcard also represents an existing site. Do not take it over with a more-specific record.
            var parts=host.Split('.');
            for(var index=1;index<parts.Length;index++)
            {
                var parent=string.Join('.',parts[index..]); if(!TenantDomainNames.Within(parent,access.ZoneName)) break;
                if((await RecordsAsync(client,access.ZoneId,"*."+parent,ct)).Any(Address)) throw new TenantDomainException("DomainDnsConflict");
            }
        }
    }
    public async Task<TenantDomainAccess> CheckAsync(TenantDomainBinding binding,bool requireProof,CancellationToken ct)
    {
        binding.Request.Validate();
        if (binding.Request.DeploymentId!=options.DeploymentId) throw new TenantDomainException("DomainDeploymentChanged");
        using var client=Client(); var access=await ZoneAsync(client,binding,ct);
        await CheckRecordsAsync(client,access,binding,ct);
        if (requireProof)
        {
            var records=await RecordsAsync(client,access.ZoneId,TenantDomainNames.ChallengeName(binding.Request.StoreHost),ct);
            if(!records.Any(x => x["type"]?.GetValue<string>()=="TXT" && x["name"]?.GetValue<string>()==TenantDomainNames.ChallengeName(binding.Request.StoreHost) &&
                x["content"]?.GetValue<string>()?.Trim('"')==binding.Challenge)) throw new TenantDomainException("DomainProofMissing");
        }
        return access;
    }
    public async Task<IReadOnlyDictionary<string,string>> EnsureRecordsAsync(TenantDomainBinding binding,CancellationToken ct)
    {
        if(binding.State is not ("Verified" or "Provisioning" or "Active") || binding.ZoneId==null || binding.ZoneName==null)
            throw new TenantDomainException("DomainNotVerified");
        var access=await CheckAsync(binding,true,ct); // Recheck both hosts before the first provider write.
        if(secrets==null)throw new InvalidOperationException("Configure the encrypted DNS migration journal before changing records.");
        using var client=Client();var result=new Dictionary<string,string>();
        await CheckRecordsAsync(client,access,binding,ct);
        var before=new JsonObject();
        foreach(var host in new[]{binding.Request.StoreHost,binding.Request.AdminHost})
        {
            var current=(await RecordsAsync(client,access.ZoneId,host,ct)).Where(Address).ToArray();
            if(current.Length>1 || current.Length==1 && !Owned(current[0],host,binding) && !Replaceable(current[0],host))throw new TenantDomainException("DomainDnsConflict");
            if(current.Length==1 && !Owned(current[0],host,binding) && (binding.State is not ("Verified" or "Provisioning" or "Active") || binding.ZoneId!=access.ZoneId || binding.ZoneName!=access.ZoneName))
                throw new TenantDomainException("DomainNotVerified");
            before[host]=current.Length==0?null:Snapshot(current[0]);
        }
        var candidate=new JsonObject{["version"]=1,["tenantId"]=binding.Request.TenantId,["requestId"]=binding.Request.Id.ToString("N"),
            ["zoneId"]=access.ZoneId,["deploymentId"]=options.DeploymentId,["records"]=before};
        var json=candidate.ToJsonString();if(json.Length>65536)throw new TenantDomainException("DomainProviderResponseInvalid");
        var saved=JsonNode.Parse(await secrets.GetOrCreateAsync(binding.Request.TenantId,"domain-dns-before-v1-"+binding.Request.Id.ToString("N"),()=>json,ct)) as JsonObject;
        if(saved==null || saved["version"]?.GetValue<int>()!=1 || saved["tenantId"]?.GetValue<string>()!=binding.Request.TenantId ||
            saved["requestId"]?.GetValue<string>()!=binding.Request.Id.ToString("N") || saved["zoneId"]?.GetValue<string>()!=access.ZoneId ||
            saved["deploymentId"]?.GetValue<string>()!=options.DeploymentId || saved["records"] is not JsonObject originals)
            throw new TenantDomainException("DomainDnsJournalChanged");
        // Recheck both frozen source records before the first write. Retry can reuse only this tenant's finished records.
        foreach(var host in new[]{binding.Request.StoreHost,binding.Request.AdminHost})
        {
            var current=(await RecordsAsync(client,access.ZoneId,host,ct)).Where(Address).ToArray();
            if(current.Length==1 && Owned(current[0],host,binding))continue;
            if(current.Length>1 || !JsonNode.DeepEquals(current.Length==0?null:Snapshot(current[0]),originals[host]))throw new TenantDomainException("DomainDnsChanged");
        }
        foreach(var (host,key) in new[]{(binding.Request.StoreHost,"storeRecordId"),(binding.Request.AdminHost,"adminRecordId")})
        {
            var records=(await RecordsAsync(client,access.ZoneId,host,ct)).Where(Address).ToArray();
            if(records.Length!=1 || !Owned(records[0],host,binding))
            {
                if(records.Length>1 || !JsonNode.DeepEquals(records.Length==0?null:Snapshot(records[0]),originals[host]))throw new TenantDomainException("DomainDnsChanged");
                try
                {
                    if(records.Length==0)
                        await ReadAsync(await client.PostAsJsonAsync(Api+"zones/"+access.ZoneId+"/dns_records",new {type="A",name=host,content=options.OriginIpv4,ttl=120,proxied=false,comment=Marker(binding)},ct),ct);
                    else
                    {
                        if(!Replaceable(records[0],host))throw new TenantDomainException("DomainDnsConflict");
                        var previousId=Text(records[0],"id");
                        await ReadAsync(await client.PatchAsJsonAsync(Api+"zones/"+access.ZoneId+"/dns_records/"+previousId,
                            new {content=options.OriginIpv4,ttl=120,proxied=false,comment=Marker(binding)},ct),ct);
                    }
                }
                catch(TenantDomainException error) when(error.Code is "DomainProviderRejected" or "DomainProviderUnavailable") { }
                records=(await RecordsAsync(client,access.ZoneId,host,ct)).Where(Address).ToArray();
            }
            if(records.Length!=1 || !Owned(records[0],host,binding)) throw new TenantDomainException("DomainDnsConflict");
            var id=Text(records[0],"id");if(!Regex.IsMatch(id,"^[a-f0-9]{32}\\z")) throw new TenantDomainException("DomainProviderResponseInvalid");
            result[key]=id;
        }
        return result;
    }
}
