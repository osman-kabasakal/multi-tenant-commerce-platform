using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text.Json;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class KeycloakTenantStep(OnboardingInfrastructureOptions options, ITenantSecrets secrets,
    ITenantEncryptionService encryption,IHttpClientFactory clients) : IProvisioningStep
{
    public string Name => "identity";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {
        using var client=clients.CreateClient("onboarding-keycloak");
        var credentials=options is LocalOnboardingOptions local
            ? new Dictionary<string,string> { ["grant_type"]="password",["client_id"]="admin-cli",["username"]=local.KeycloakAdminUsername,["password"]=local.KeycloakAdminPassword }
            : options is PortableOnboardingOptions portable
                ? new Dictionary<string,string> { ["grant_type"]="client_credentials",["client_id"]=portable.KeycloakAdminClientId,["client_secret"]=portable.KeycloakAdminClientSecret }
                : throw new InvalidOperationException("Unknown onboarding infrastructure profile.");
        var authRealm=options is PortableOnboardingOptions configured?configured.KeycloakAdminRealm:"master";
        using var auth=await client.PostAsync(options.KeycloakAuthority+"/realms/"+Uri.EscapeDataString(authRealm)+"/protocol/openid-connect/token",new FormUrlEncodedContent(credentials),ct);
        if (!auth.IsSuccessStatusCode) throw new InvalidOperationException("Keycloak provisioning authentication failed.");
        using var token=JsonDocument.Parse(await auth.Content.ReadAsStringAsync(ct));
        client.DefaultRequestHeaders.Authorization=new AuthenticationHeaderValue("Bearer",token.RootElement.GetProperty("access_token").GetString());
        var api=options.KeycloakAuthority+"/admin/realms/"+Uri.EscapeDataString(options.KeycloakRealm);
        using var response=await client.GetAsync(api+"/clients?clientId="+Uri.EscapeDataString(request.Slug)+"&briefRepresentation=false",ct);
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
        var secret=!options.IsLocal && id!=null ? await secrets.GetAsync(request.TenantId,TenantSecretNames.KeycloakClient,ct)
            : await secrets.GetOrCreateAsync(request.TenantId,TenantSecretNames.KeycloakClient,()=>Convert.ToHexString(RandomNumberGenerator.GetBytes(32)).ToLowerInvariant(),ct);
        if (!options.IsLocal && id!=null)
        {
            using var details=await client.GetAsync(api+"/clients/"+Uri.EscapeDataString(id),ct);
            if (!details.IsSuccessStatusCode) throw new InvalidOperationException("Keycloak client inspection failed.");
            using var saved=JsonDocument.Parse(await details.Content.ReadAsStringAsync(ct));
            var entry=saved.RootElement;
            if (entry.GetProperty("clientId").GetString()!=request.Slug || entry.GetProperty("publicClient").GetBoolean() ||
                !entry.GetProperty("enabled").GetBoolean() || !entry.GetProperty("serviceAccountsEnabled").GetBoolean() || entry.GetProperty("standardFlowEnabled").GetBoolean())
                throw new InvalidOperationException("The owned client policy changed; repair explicitly.");
            using var storedSecret=await client.GetAsync(api+"/clients/"+Uri.EscapeDataString(id)+"/client-secret",ct);
            if (!storedSecret.IsSuccessStatusCode) throw new InvalidOperationException("Keycloak client secret inspection failed.");
            using var secretJson=JsonDocument.Parse(await storedSecret.Content.ReadAsStringAsync(ct));
            if (secretJson.RootElement.GetProperty("value").GetString()!=secret)
                throw new InvalidOperationException("The owned client secret changed; refusing automatic rotation.");
            var savedMappers=entry.GetProperty("protocolMappers").EnumerateArray().ToArray();
            foreach (var pair in new Dictionary<string,string> { ["sub_domainname"]=request.Slug,["store_id"]=completed["store"].Resources["storeId"],
                ["db_connection"]=await secrets.GetAsync(request.TenantId,TenantSecretNames.DatabaseConnection,ct) })
            {
                var mapper=savedMappers.Single(m=>m.GetProperty("name").GetString()==pair.Key);
                var value=mapper.GetProperty("config");
                if (mapper.GetProperty("protocolMapper").GetString()!="oidc-hardcoded-claim-mapper" || value.GetProperty("claim.name").GetString()!=pair.Key || value.GetProperty("access.token.claim").GetString()!="true")
                    throw new InvalidOperationException("The owned client mapper policy changed.");
                var claim=value.GetProperty("claim.value").GetString()!;
                if (pair.Key!="sub_domainname") claim=await encryption.DecryptAsync(claim,request.Slug);
                if (claim!=pair.Value) throw new InvalidOperationException("The owned client target changed; refusing to overwrite it.");
            }
            var audience=savedMappers.Single(m=>m.GetProperty("name").GetString()=="tenant-audience").GetProperty("config");
            if (audience.GetProperty("included.client.audience").GetString()!=request.Slug || audience.GetProperty("access.token.claim").GetString()!="true")
                throw new InvalidOperationException("The owned client audience changed.");
            return new("Keycloak",new Dictionary<string,string> { ["clientId"]=request.Slug });
        }
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
        if (options.IsLocal) await PrivateFiles.WriteAsync(Path.Combine(options.SecretDirectory,"ClientSecret-"+request.Slug),secret,ct);
        return new("Keycloak",new Dictionary<string,string> { ["clientId"]=request.Slug });
    }
}
