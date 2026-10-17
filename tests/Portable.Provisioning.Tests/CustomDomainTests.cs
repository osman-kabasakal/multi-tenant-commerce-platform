using System.Net;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class CustomDomainTests
{
    [DataTestMethod]
    [DataRow("https://shop.example.net")][DataRow("shop.example.net/path")][DataRow("*.example.net")][DataRow("127.0.0.1")]
    [DataRow("localhost")][DataRow("internal.test")][DataRow("store.example.net:443")][DataRow("shop.example.net.")][DataRow(" shop.example.net")]
    public void DomainInputCannotBeAUrlIpWildcardOrLocalHost(string value) => Assert.ThrowsException<ArgumentException>(()=>TenantDomainNames.Normalize(value));
    [TestMethod]
    public void InternationalDomainNamesUseOneCanonicalAsciiRepresentation()
    {
        Assert.AreEqual("xn--dner-5qa.example.net",TenantDomainNames.Normalize("DÖNER.example.net"));
        Assert.IsFalse(TenantDomainNames.Within("notexample.net","example.net"));
        Assert.IsTrue(TenantDomainNames.Within("store.example.net","example.net"));
        Assert.AreNotEqual(TenantDomainNames.Challenge(Guid.NewGuid()),TenantDomainNames.Challenge(Guid.NewGuid()));
    }
    [TestMethod]
    public async Task AVerifiedUnassignedDomainCanMoveAnExternalARecordAfterSavingTheOriginal()
    {
        using var f=new DomainFixture();f.Server.Proof=true;
        var host=f.Binding.Request.StoreHost;var recordId=Guid.NewGuid().ToString("N");
        f.Server.Addresses[host]=new JsonObject{["id"]=recordId,["type"]="A",["name"]=host,["content"]="198.51.100.20",["ttl"]=3600,["proxied"]=true,["comment"]="Previous store"};
        // API access plus a TXT record still does not substitute for the exclusive, verified database claim.
        var error=await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>f.Provider.EnsureRecordsAsync(f.Binding,default));
        Assert.AreEqual("DomainNotVerified",error.Code);Assert.AreEqual(0,f.Server.Writes);
        var verified=f.Binding with {State="Verified",ZoneId=f.ZoneId,ZoneName="tenant.example.net"};
        await f.Provider.EnsureRecordsAsync(verified,default);
        Assert.AreEqual(recordId,f.Server.Addresses[host]["id"]!.GetValue<string>());
        Assert.AreEqual(f.Options.OriginIpv4,f.Server.Addresses[host]["content"]!.GetValue<string>());
        var backup=JsonNode.Parse(f.Secrets.Values[(f.Binding.Request.TenantId,"domain-dns-before-v1-"+f.Binding.Request.Id.ToString("N"))])!;
        Assert.AreEqual("198.51.100.20",backup["records"]![host]!["content"]!.GetValue<string>());
        Assert.IsTrue(backup["records"]![host]!["proxied"]!.GetValue<bool>());
        await f.Provider.EnsureRecordsAsync(verified,default);Assert.AreEqual(2,f.Server.Writes);
    }
    [TestMethod]
    public async Task AnUnownedRecordAlreadyPointingAtOurServerOrAnotherTenantMarkerCannotBeAdopted()
    {
        using var f=new DomainFixture();f.Server.Proof=true;var host=f.Binding.Request.StoreHost;
        f.Server.Addresses[host]=new JsonObject{["id"]=Guid.NewGuid().ToString("N"),["type"]="A",["name"]=host,["content"]=f.Options.OriginIpv4,["proxied"]=false};
        var error=await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>f.Provider.CheckAsync(f.Binding,false,default));Assert.AreEqual("DomainDnsConflict",error.Code);
        f.Server.Addresses[host]["content"]="198.51.100.20";f.Server.Addresses[host]["comment"]="platform=other;tenant="+Guid.NewGuid().ToString("N");
        await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>f.Provider.CheckAsync(f.Binding,false,default));Assert.AreEqual(0,f.Server.Writes);
    }
    [TestMethod]
    public async Task ApiAccessDoesNotProveOwnershipAndNeverWritesTheChallengeForTheUser()
    {
        using var f=new DomainFixture();
        var access=await f.Provider.CheckAsync(f.Binding,false,default);Assert.AreEqual(f.ZoneId,access.ZoneId);
        var error=await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>f.Provider.CheckAsync(f.Binding,true,default));
        Assert.AreEqual("DomainProofMissing",error.Code);Assert.AreEqual(0,f.Server.Writes);
        f.Server.Proof=true;Assert.AreEqual(access,await f.Provider.CheckAsync(f.Binding,true,default));Assert.AreEqual(0,f.Server.Writes);
    }
    [TestMethod]
    public async Task BothHostsAreCheckedBeforeTheFirstDnsWriteAndAnExistingSiteIsPreserved()
    {
        using var f=new DomainFixture(); f.Server.Proof=true;f.Server.ForeignAdmin=true;
        var error=await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>f.Provider.EnsureRecordsAsync(f.Verified,default));
        Assert.AreEqual("DomainDnsConflict",error.Code);Assert.AreEqual(0,f.Server.Writes);Assert.AreEqual(0,f.Server.Addresses.Count);
    }
    [TestMethod]
    public async Task AForeignWildcardAlsoStopsProvisioningWithoutWrites()
    {
        using var f=new DomainFixture(); f.Server.Proof=true;f.Server.ForeignWildcard=true;
        var error=await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>f.Provider.EnsureRecordsAsync(f.Verified,default));
        Assert.AreEqual("DomainDnsConflict",error.Code);Assert.AreEqual(0,f.Server.Writes);
    }
    [TestMethod]
    public async Task DnsCreationIsOwnedUnproxiedReadBackAndIdempotent()
    {
        using var f=new DomainFixture();f.Server.Proof=true;
        var first=await f.Provider.EnsureRecordsAsync(f.Verified,default);var second=await f.Provider.EnsureRecordsAsync(f.Verified,default);
        CollectionAssert.AreEquivalent(first.Values.ToArray(),second.Values.ToArray());Assert.AreEqual(2,f.Server.Writes);
        Assert.AreEqual(2,f.Server.Addresses.Count);Assert.IsTrue(f.Server.Addresses.Values.All(x=>x["proxied"]!.GetValue<bool>()==false));
        Assert.IsTrue(f.Server.Addresses.Values.All(x=>x["type"]!.GetValue<string>()=="A"));
    }
    [TestMethod]
    public async Task PartialProviderFailureCanResumeWithoutDuplicatingTheFirstRecord()
    {
        using var f=new DomainFixture();f.Server.Proof=true;f.Server.FailAdminOnce=true;
        await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>f.Provider.EnsureRecordsAsync(f.Verified,default));
        Assert.AreEqual(1,f.Server.Addresses.Count);
        await f.Provider.EnsureRecordsAsync(f.Verified,default);Assert.AreEqual(2,f.Server.Addresses.Count);Assert.AreEqual(3,f.Server.Writes);
    }
    [TestMethod]
    public async Task ForeignTenantCannotAdoptAnAlreadyCreatedRecord()
    {
        using var f=new DomainFixture();f.Server.Proof=true;await f.Provider.EnsureRecordsAsync(f.Verified,default);
        var other=f.Binding with{Request=f.Binding.Request with{TenantId=Guid.NewGuid().ToString("N")}};
        var error=await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>f.Provider.CheckAsync(other,false,default));
        Assert.AreEqual("DomainDnsConflict",error.Code);Assert.AreEqual(2,f.Server.Writes);
    }
    [TestMethod]
    public async Task PlatformZoneCannotBeClaimedByATenantEvenWithAChallenge()
    {
        using var f=new DomainFixture();f.Server.Proof=true;
        var options=f.withReservedHost(f.Binding.Request.StoreHost);
        var error=await Assert.ThrowsExceptionAsync<TenantDomainException>(()=>new CloudflareTenantDomains(options,f).CheckAsync(f.Binding,true,default));
        Assert.AreEqual("DomainReservedForPlatform",error.Code);Assert.AreEqual(0,f.Server.Writes);
    }
}
internal sealed class DomainFixture : IDisposable,IHttpClientFactory
{
    public readonly string ZoneId=new('a',32);public readonly string Root=Path.Combine(OperatingSystem.IsMacOS()?"/private/tmp":Path.GetTempPath(),"domain-proof-"+Guid.NewGuid().ToString("N"));
    public CustomDomainOptions Options {get;}
    public TenantDomainBinding Binding {get;}
    public TenantDomainBinding Verified=>Binding with{State="Verified",ZoneId=ZoneId,ZoneName="tenant.example.net"};
    public DomainServer Server {get;}
    public AndroidSecrets Secrets {get;}=new();
    public CloudflareTenantDomains Provider=>new(Options,this,Secrets);
    public DomainFixture()
    {
        Directory.CreateDirectory(Root);var file=Path.Combine(Root,"token");File.WriteAllText(file,"synthetic-cloudflare-access-for-tests");
        if(!OperatingSystem.IsWindows())File.SetUnixFileMode(file,UnixFileMode.UserRead|UnixFileMode.UserWrite);
        Options=new(){Enabled=true,AllowCloudWrites=true,DeploymentId="domain-contract",ApiTokenFile=file,OriginIpv4="203.0.113.10",ReservedHosts=["portal.platform.example.org"],AcmeEmail="operator@example.net"};
        var request=new TenantDomainRequest(Guid.NewGuid(),Guid.NewGuid().ToString("N"),Guid.NewGuid(),Options.DeploymentId,"shop.tenant.example.net","manage.shop.tenant.example.net");
        Binding=new(request,"AwaitingOwnership",TenantDomainNames.Challenge(request.Id),DateTimeOffset.UtcNow.AddHours(24),null,null,null,DateTimeOffset.UtcNow,DateTimeOffset.UtcNow);
        Server=new(this);
    }
    public CustomDomainOptions withReservedHost(string host)=>new(){Enabled=true,AllowCloudWrites=true,DeploymentId=Options.DeploymentId,ApiTokenFile=Options.ApiTokenFile,OriginIpv4=Options.OriginIpv4,ReservedHosts=[host],AcmeEmail=Options.AcmeEmail};
    public HttpClient CreateClient(string name)=>new(Server,false){Timeout=TimeSpan.FromSeconds(30)};
    public void Dispose(){Server.Dispose();Directory.Delete(Root,true);}
}
internal sealed class DomainServer(DomainFixture f) : HttpMessageHandler
{
    public bool Proof,ForeignAdmin,ForeignWildcard,FailAdminOnce;public int Writes;
    public Dictionary<string,JsonObject> Addresses=new();
    private static HttpResponseMessage Reply(object result,HttpStatusCode code=HttpStatusCode.OK)=>new(code){Content=JsonContent.Create(new{success=true,result,result_info=new{total_pages=1}})};
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,CancellationToken ct)
    {
        Assert.AreEqual("api.cloudflare.com",request.RequestUri!.Host);Assert.AreEqual("Bearer",request.Headers.Authorization?.Scheme);
        var query=System.Web.HttpUtility.ParseQueryString(request.RequestUri.Query);var name=query["name"];
        if(request.RequestUri.AbsolutePath=="/client/v4/zones")return Reply(name=="tenant.example.net"?new[]{new{id=f.ZoneId,name,status="active",paused=false}}:Array.Empty<object>());
        if(request.Method==HttpMethod.Patch)
        {
            Writes++;var id=request.RequestUri.Segments.Last();var record=Addresses.Values.Single(x=>x["id"]!.GetValue<string>()==id);
            foreach(var field in JsonNode.Parse(await request.Content!.ReadAsStringAsync(ct))!.AsObject())record[field.Key]=field.Value?.DeepClone();
            return Reply(record);
        }
        Assert.AreEqual("/client/v4/zones/"+f.ZoneId+"/dns_records",request.RequestUri.AbsolutePath);
        if(request.Method==HttpMethod.Post)
        {
            Writes++;var item=JsonNode.Parse(await request.Content!.ReadAsStringAsync(ct))!.AsObject();var host=item["name"]!.GetValue<string>();
            if(FailAdminOnce && host==f.Binding.Request.AdminHost){FailAdminOnce=false;return Reply(new{},HttpStatusCode.ServiceUnavailable);}
            Assert.IsFalse(Addresses.ContainsKey(host));item["id"]=Guid.NewGuid().ToString("N");Addresses[host]=item;return Reply(item);
        }
        if(Proof && name==TenantDomainNames.ChallengeName(f.Binding.Request.StoreHost))return Reply(new[]{new{type="TXT",name,content=f.Binding.Challenge}});
        if(ForeignAdmin && name==f.Binding.Request.AdminHost || ForeignWildcard && name=="*.tenant.example.net")return Reply(new[]{new{type="CNAME",name,content="existing.example.net"}});
        return Reply(Addresses.TryGetValue(name!,out var value)?new[]{value}:Array.Empty<JsonObject>());
    }
}
