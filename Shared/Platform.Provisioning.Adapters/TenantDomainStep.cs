using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace Platform.Provisioning.Adapters;

public sealed class TenantDomainOptions
{
    public string Provider { get; init; } = "";
    public bool WildcardConfigured { get; init; }
    public bool AllowCloudWrites { get; init; }
    public string ZoneId { get; init; } = "";
    public string ZoneName { get; init; } = "";
    public string ApiToken { get; init; } = "";
    public string TargetHost { get; init; } = "";
    public bool Proxied { get; init; }

    public void Validate(PortableOnboardingOptions options)
    {
        if (Provider=="Wildcard")
        {
            if (!WildcardConfigured) throw new InvalidOperationException("A wildcard provider requires explicitly configured DNS and ingress.");
            return;
        }
        if (Provider!="Cloudflare" || !AllowCloudWrites || !Regex.IsMatch(ZoneId,"^[a-fA-F0-9]{32}$") || string.IsNullOrWhiteSpace(ApiToken) || !HostName(ZoneName) || !HostName(TargetHost))
            throw new InvalidOperationException("Select Wildcard or explicitly configured Cloudflare domain provisioning.");
        foreach (var domain in new[] {new Uri(options.StoreBaseUrl).Host,new Uri(options.AdminBaseUrl).Host})
            if (domain!=ZoneName && !domain.EndsWith("."+ZoneName,StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("The configured domain parents are outside the Cloudflare zone.");
    }
    private static bool HostName(string value)=>value.Length is > 0 and <=253 && value.Split('.').Length>=2 && value.Split('.').All(label=>Regex.IsMatch(label,"^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$",RegexOptions.IgnoreCase));
    public string TargetFingerprint()=>Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(new {Provider,WildcardConfigured,ZoneId,ZoneName,TargetHost,Proxied}))));
}

public sealed class TenantDomainStep(PortableOnboardingOptions options,TenantDomainOptions dns,IHttpClientFactory clients) : IProvisioningStep
{
    public string Name=>"domains";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {
        request.Validate();
        var hosts=new[] {new Uri(options.StoreUrl(request.Slug)).Host,new Uri(options.AdminUrl(request.Slug)).Host};
        var resources=new Dictionary<string,string> { ["storeHost"]=hosts[0],["adminHost"]=hosts[1] };
        if (dns.Provider=="Wildcard") return new("Wildcard",resources);
        if (dns.Provider!="Cloudflare" || !dns.AllowCloudWrites) throw new InvalidOperationException("Cloud DNS writes have not been enabled.");
        using var client=clients.CreateClient("onboarding-dns");
        client.DefaultRequestHeaders.Authorization=new AuthenticationHeaderValue("Bearer",dns.ApiToken);
        const string api="https://api.cloudflare.com/client/v4/zones/";
        using (var zone=await ReadAsync(await client.GetAsync(api+dns.ZoneId,ct),ct))
            if (!zone.RootElement.GetProperty("result").GetProperty("name").GetString()!.Equals(dns.ZoneName,StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("The configured Cloudflare zone identity does not match.");
        var marker="platform="+options.DeploymentId+";tenant="+request.TenantId;
        for (var index=0;index<hosts.Length;index++)
        {
            var host=hosts[index];
            if (host.Equals(dns.TargetHost,StringComparison.OrdinalIgnoreCase)) throw new InvalidOperationException("A tenant CNAME cannot point to itself.");
            var endpoint=api+dns.ZoneId+"/dns_records";
            using var records=await ReadAsync(await client.GetAsync(endpoint+"?name="+Uri.EscapeDataString(host)+"&per_page=100",ct),ct);
            var matches=records.RootElement.GetProperty("result").EnumerateArray().ToArray();
            string id;
            if (matches.Length==0)
            {
                using var created=await ReadAsync(await client.PostAsJsonAsync(endpoint,new {type="CNAME",name=host,content=dns.TargetHost,ttl=1,proxied=dns.Proxied,comment=marker},ct),ct);
                id=OwnedRecord(created.RootElement.GetProperty("result"),host,marker);
            }
            else
            {
                if (matches.Length!=1) throw new InvalidOperationException("Conflicting records already own the tenant hostname.");
                id=OwnedRecord(matches[0],host,marker);
            }
            resources[index==0?"storeRecordId":"adminRecordId"]=id;
        }
        return new("Cloudflare",resources);
    }
    private string OwnedRecord(JsonElement entry,string host,string marker)
    {
        if (entry.GetProperty("type").GetString()!="CNAME" || !string.Equals(entry.GetProperty("name").GetString(),host,StringComparison.OrdinalIgnoreCase) ||
            !entry.TryGetProperty("comment",out var comment) || comment.GetString()!=marker ||
            !string.Equals(entry.GetProperty("content").GetString(),dns.TargetHost,StringComparison.OrdinalIgnoreCase) || entry.GetProperty("proxied").GetBoolean()!=dns.Proxied)
            throw new InvalidOperationException("Refusing to adopt or change a foreign or conflicting tenant DNS record.");
        return entry.GetProperty("id").GetString()??throw new InvalidOperationException("Missing domain resource identifier.");
    }
    private static async Task<JsonDocument> ReadAsync(HttpResponseMessage response,CancellationToken ct)
    {
        using(response)
        {
            if (!response.IsSuccessStatusCode) throw new InvalidOperationException("Cloudflare domain provisioning request failed.");
            var document=JsonDocument.Parse(await response.Content.ReadAsStringAsync(ct));
            if (!document.RootElement.TryGetProperty("success",out var success) || !success.GetBoolean()) {document.Dispose();throw new InvalidOperationException("Cloudflare domain provisioning was rejected.");}
            return document;
        }
    }
}
