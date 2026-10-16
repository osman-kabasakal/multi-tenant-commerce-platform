using System.Net;
using System.Text.Json.Nodes;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Provisioning.Adapters;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class DomainTests
{
    private static TenantDomainOptions Options()=>new(){Provider="Cloudflare",AllowCloudWrites=true,ZoneId=new string('a',32),ZoneName="example.test",ApiToken="contract-dns-token",TargetHost="ingress.example.test"};
    [TestMethod]
    public async Task CloudflareCreatesTwoOwnedRecordsAndReplayNeverWritesThemAgain()
    {
        using var f=new Fixture();var request=Fixture.Request();var server=new DnsServer();var step=new TenantDomainStep(f.Options(),Options(),server.Factory());
        var first=await step.ExecuteAsync(request,Fixture.Completed(request),default);var second=await step.ExecuteAsync(request,Fixture.Completed(request),default);
        Assert.AreEqual(2,server.Creates);Assert.AreEqual(first.Resources["storeRecordId"],second.Resources["storeRecordId"]);
        Assert.IsFalse(System.Text.Json.JsonSerializer.Serialize(first).Contains("contract-dns-token"));
    }
    [TestMethod]
    public async Task ForeignDnsAndChangedTargetsAreRefusedBeforeWrites()
    {
        foreach(var wrong in new[]{"owner","target"})
        {
            using var f=new Fixture();var request=Fixture.Request();var server=new DnsServer();var options=f.Options();var dns=Options();
            server.Records[request.Slug+".shops.example.test"]=JsonNode.Parse(System.Text.Json.JsonSerializer.Serialize(new {id="foreign-record",type="CNAME",name=request.Slug+".shops.example.test",content=wrong=="target"?"foreign.example.test":dns.TargetHost,
                comment=wrong=="owner"?"foreign":"platform="+options.DeploymentId+";tenant="+request.TenantId,proxied=false}))!.AsObject();
            await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new TenantDomainStep(options,dns,server.Factory()).ExecuteAsync(request,Fixture.Completed(request),default));Assert.AreEqual(0,server.Creates);
        }
    }
    [TestMethod]
    public async Task ZoneMismatchAndPermissionErrorsDoNotPublishRecordsOrProviderBodies()
    {
        using var f=new Fixture();var request=Fixture.Request();var server=new DnsServer{Zone="foreign.test"};
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new TenantDomainStep(f.Options(),Options(),server.Factory()).ExecuteAsync(request,Fixture.Completed(request),default));Assert.AreEqual(0,server.Creates);
        var factory=new Factory((_,_)=>Task.FromResult(Factory.Json(new {secret="provider-private-body"},HttpStatusCode.Forbidden)));
        var error=await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new TenantDomainStep(f.Options(),Options(),factory).ExecuteAsync(request,Fixture.Completed(request),default));Assert.IsFalse(error.Message.Contains("provider-private-body"));
    }
    [TestMethod]
    public void DomainWritesAndWildcardAssumptionsAreExplicit()
    {
        using var f=new Fixture();var options=f.Options();
        Assert.ThrowsException<InvalidOperationException>(()=>new TenantDomainOptions{Provider="Wildcard"}.Validate(options));
        Assert.ThrowsException<InvalidOperationException>(()=>new TenantDomainOptions{Provider="Cloudflare"}.Validate(options));
        Options().Validate(options);
    }
}
internal sealed class DnsServer
{
    public string Zone="example.test";public int Creates;public Dictionary<string,JsonObject> Records=[];
    public Factory Factory()=>new(async(_,http)=>{
        Assert.AreEqual("api.cloudflare.com",http.RequestUri!.Host);Assert.AreEqual("contract-dns-token",http.Headers.Authorization!.Parameter);
        if(!http.RequestUri.AbsolutePath.EndsWith("/dns_records"))return Portable.Provisioning.Tests.Factory.Json(new{success=true,result=new{name=Zone}});
        if(http.Method==HttpMethod.Post)
        {
            Creates++;var value=JsonNode.Parse(await http.Content!.ReadAsStringAsync())!.AsObject();value["id"]="record-"+Creates;Records[value["name"]!.GetValue<string>()]=value;
            return Portable.Provisioning.Tests.Factory.Json(new{success=true,result=value});
        }
        var query=http.RequestUri.Query.TrimStart('?').Split('&').Single(x=>x.StartsWith("name="))[5..];var name=Uri.UnescapeDataString(query);
        return Portable.Provisioning.Tests.Factory.Json(new{success=true,result=Records.TryGetValue(name,out var found)?new JsonArray(found.DeepClone()):new JsonArray()});
    });
}
