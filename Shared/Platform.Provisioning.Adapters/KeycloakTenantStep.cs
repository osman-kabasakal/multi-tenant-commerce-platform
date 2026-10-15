using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text.Json;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class KeycloakTenantStep(LocalOnboardingOptions options, ITenantSecrets secrets,
    ITenantEncryptionService encryption,IHttpClientFactory clients) : IProvisioningStep
{
    public string Name => "identity";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {
        using var client=clients.CreateClient("onboarding-keycloak");
        using var auth=await client.PostAsync(options.KeycloakAuthority+"/realms/master/protocol/openid-connect/token",new FormUrlEncodedContent(new Dictionary<string,string> {
            ["grant_type"]="password",["client_id"]="admin-cli",["username"]=options.KeycloakAdminUsername,["password"]=options.KeycloakAdminPassword
        }),ct);
        if (!auth.IsSuccessStatusCode) throw new InvalidOperationException("Keycloak provisioning authentication failed.");
        using var token=JsonDocument.Parse(await auth.Content.ReadAsStringAsync(ct));
        client.DefaultRequestHeaders.Authorization=new AuthenticationHeaderValue("Bearer",token.RootElement.GetProperty("access_token").GetString());
        var api=options.KeycloakAuthority+"/admin/realms/"+Uri.EscapeDataString(options.KeycloakRealm);
        using var response=await client.GetAsync(api+"/clients?clientId="+Uri.EscapeDataString(request.Slug),ct);
        response.EnsureSuccessStatusCode();
        using var existing=JsonDocument.Parse(await response.Content.ReadAsStringAsync(ct));
        var entries=existing.RootElement.EnumerateArray().ToArray();
        string? id=null;
        if (entries.Length>0)
        {
            var entry=entries.Single();
            if (!entry.TryGetProperty("attributes",out var attributes) || !attributes.TryGetProperty("platform-tenant-id",out var owner) || owner.GetString()!=request.TenantId)
                throw new InvalidOperationException("Refusing to adopt an unowned Keycloak client.");
            id=entry.GetProperty("id").GetString();
        }
        var secret=await secrets.GetOrCreateAsync(request.TenantId,TenantSecretNames.KeycloakClient,()=>Convert.ToHexString(RandomNumberGenerator.GetBytes(32)).ToLowerInvariant(),ct);
        var mappers=new List<object>();
        foreach (var pair in new Dictionary<string,string> {
            ["sub_domainname"]=request.Slug,
            ["store_id"]=await encryption.EncryptAsync(completed["store"].Resources["storeId"],request.Slug),
            ["db_connection"]=await encryption.EncryptAsync(await secrets.GetAsync(request.TenantId,TenantSecretNames.DatabaseConnection,ct),request.Slug)
        })
            mappers.Add(new {name=pair.Key,protocol="openid-connect",protocolMapper="oidc-hardcoded-claim-mapper",config=new Dictionary<string,string> {
                ["claim.name"]=pair.Key,["claim.value"]=pair.Value,["jsonType.label"]="String",["access.token.claim"]="true"
            }});
        mappers.Add(new {name="tenant-audience",protocol="openid-connect",protocolMapper="oidc-audience-mapper",config=new Dictionary<string,string> {
            ["included.client.audience"]=request.Slug,["access.token.claim"]="true"
        }});
        var body=new { clientId=request.Slug,enabled=true,publicClient=false,secret,standardFlowEnabled=false,
            serviceAccountsEnabled=true,attributes=new Dictionary<string,string> { ["platform-tenant-id"]=request.TenantId },protocolMappers=mappers };
        using var save=id==null ? await client.PostAsJsonAsync(api+"/clients",body,ct) : await client.PutAsJsonAsync(api+"/clients/"+id,body,ct);
        if (!save.IsSuccessStatusCode) throw new InvalidOperationException("Keycloak client provisioning failed.");
        await PrivateFiles.WriteAsync(Path.Combine(options.SecretDirectory,"ClientSecret-"+request.Slug),secret,ct);
        return new("Keycloak",new Dictionary<string,string> { ["clientId"]=request.Slug });
    }
}
