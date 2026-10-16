using System.Net;
using System.Security.Cryptography;
using System.Text.Json.Nodes;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class IdentityTests
{
    [TestMethod]
    public async Task ServiceAccountCreatesOnceAndReplayPreservesTheRemoteSecretAndEncryptedClaims()
    {
        using var f=new Fixture();var request=Fixture.Request();var secrets=new MemorySecrets();
        await secrets.SetAsync(request.TenantId,TenantSecretNames.DatabaseConnection,"mongodb://owned-db");
        var encryption=new PortableEncryptionService(Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)));
        var server=new IdentityServer();var step=new KeycloakTenantStep(f.Options(),secrets,encryption,server.Factory());
        await step.ExecuteAsync(request,Fixture.Completed(request),default);var body=server.Client!.ToJsonString();var secret=await secrets.GetAsync(request.TenantId,TenantSecretNames.KeycloakClient);
        await step.ExecuteAsync(request,Fixture.Completed(request),default);
        Assert.AreEqual(1,server.Creates);Assert.AreEqual(body,server.Client.ToJsonString());Assert.AreEqual(secret,server.RemoteSecret);Assert.AreEqual(0,server.Updates);
        Assert.AreEqual(0,Directory.GetFiles(f.Root,"ClientSecret-*",SearchOption.AllDirectories).Length);
        server.RemoteSecret="externally-rotated-value";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>step.ExecuteAsync(request,Fixture.Completed(request),default));Assert.AreEqual(0,server.Updates);
        Assert.AreEqual(secret,await secrets.GetAsync(request.TenantId,TenantSecretNames.KeycloakClient));
    }
    [TestMethod]
    public async Task ForeignClientCannotBeAdoptedAndMissingSavedSecretsAreNeverRegenerated()
    {
        using var f=new Fixture();var request=Fixture.Request();var secrets=new MemorySecrets();await secrets.SetAsync(request.TenantId,TenantSecretNames.DatabaseConnection,"mongodb://owned-db");
        var server=new IdentityServer();var step=new KeycloakTenantStep(f.Options(),secrets,new PortableEncryptionService(Convert.ToBase64String(RandomNumberGenerator.GetBytes(32))),server.Factory());
        await step.ExecuteAsync(request,Fixture.Completed(request),default);var before=secrets.Creates;
        secrets.Values.Remove((request.TenantId,TenantSecretNames.KeycloakClient));
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(()=>step.ExecuteAsync(request,Fixture.Completed(request),default));Assert.AreEqual(before,secrets.Creates);
        server.Client!["attributes"]!["platform-tenant-id"]="foreign";
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>step.ExecuteAsync(request,Fixture.Completed(request),default));Assert.AreEqual(1,server.Creates);Assert.AreEqual(0,server.Updates);
    }
}
internal sealed class IdentityServer
{
    public JsonObject? Client;public string RemoteSecret="";public int Creates,Updates;
    public Factory Factory()=>new(async(_,request)=>{
        if(request.RequestUri!.AbsolutePath.EndsWith("/token"))
        {
            var body=await request.Content!.ReadAsStringAsync();StringAssert.Contains(body,"grant_type=client_credentials");StringAssert.Contains(body,"client_id=provisioner");Assert.IsFalse(body.Contains("password="));
            return Portable.Provisioning.Tests.Factory.Json(new{access_token="contract-admin-token"});
        }
        if(request.Method==HttpMethod.Post){Creates++;Client=JsonNode.Parse(await request.Content!.ReadAsStringAsync())!.AsObject();Client["id"]="owned-client";RemoteSecret=Client["secret"]!.GetValue<string>();return Portable.Provisioning.Tests.Factory.Json(new{},HttpStatusCode.Created);}
        if(request.Method==HttpMethod.Put){Updates++;throw new Exception("Unexpected client rewrite");}
        if(request.RequestUri.AbsolutePath.EndsWith("/client-secret"))return Portable.Provisioning.Tests.Factory.Json(new{value=RemoteSecret});
        if(request.RequestUri.Query.Contains("clientId="))return Portable.Provisioning.Tests.Factory.Json(Client==null?new JsonArray():new JsonArray(Client.DeepClone()));
        return Portable.Provisioning.Tests.Factory.Json(Client!);
    });
}
