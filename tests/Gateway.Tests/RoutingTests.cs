using Microsoft.AspNetCore.Http;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Gateway;

namespace Gateway.Tests;

[TestClass]
public sealed class RoutingTests
{
    [TestMethod]
    public async Task OwnedStoreAndAdminResolveWithoutCreatingSecrets()
    {
        using var f=new Fixture();f.Options().Validate(f.Config());await f.Route();var routes=new TenantRoutes(f.Options(),f.Secrets);
        var store=await routes.ResolveAsync(new HostString("alpha-shop.shops.example.test"),default);
        var admin=await routes.ResolveAsync(new HostString("alpha-shop.manage.example.test:443"),default);
        Assert.AreEqual(f.Tenant,store!.TenantId);Assert.IsFalse(store.Admin);Assert.IsTrue(admin!.Admin);Assert.AreEqual("store-alpha",admin.StoreId);Assert.AreEqual(0,f.Secrets.Writes);
    }
    [DataTestMethod]
    [DataRow("alpha-shop.shops.example.test.attacker.test")]
    [DataRow("alpha-shop.shops.example.test:8443")]
    [DataRow("unknown-shop.shops.example.test")]
    [DataRow("alpha-shop.other.test")]
    [DataRow("extra.alpha-shop.shops.example.test")]
    [DataRow("shops.example.test")]
    public async Task UnknownHostCannotSelectAConnectionOrToken(string host)
    {using var f=new Fixture();await f.Route();Assert.IsNull(await new TenantRoutes(f.Options(),f.Secrets).ResolveAsync(new HostString(host),default));Assert.AreEqual(0,f.Secrets.Writes);}
    [DataTestMethod]
    [DataRow("foreign-alias")][DataRow("uppercase-id")][DataRow("development-profile")][DataRow("foreign-origin")][DataRow("admin-userinfo")][DataRow("admin-path")][DataRow("symlink")][DataRow("oversize")]
    public async Task RouteDriftAndForeignBindingsFailClosed(string scenario)
    {
        using var f=new Fixture();await f.Route(tenant:scenario=="uppercase-id"?f.Tenant.ToUpperInvariant():null,profile:scenario=="development-profile"?"Local":"Portable",
            storeUrl:scenario=="foreign-origin"?"https://attacker.test/":null,adminUrl:scenario switch {"admin-userinfo"=>"https://user@alpha-shop.manage.example.test/Admin","admin-path"=>"https://alpha-shop.manage.example.test/other",_=>null});
        if(scenario=="foreign-alias")f.Secrets.Aliases["store-alpha"]=Guid.NewGuid().ToString("N");
        if(scenario=="oversize")await File.WriteAllTextAsync(Path.Combine(f.Root,"alpha-shop.json"),new string(' ',65537));
        if(scenario=="symlink"){File.Move(Path.Combine(f.Root,"alpha-shop.json"),Path.Combine(f.Root,"target.json"));File.CreateSymbolicLink(Path.Combine(f.Root,"alpha-shop.json"),Path.Combine(f.Root,"target.json"));}
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>new TenantRoutes(f.Options(),f.Secrets).ResolveAsync(new HostString("alpha-shop.shops.example.test"),default));Assert.AreEqual(0,f.Secrets.Writes);
    }
    [DataTestMethod]
    [DataRow("LocalDemo:Enabled","true")][DataRow("PlatformSecurity:ReadOnly","false")][DataRow("PlatformSecurity:InitializeSchema","true")][DataRow("PlatformSecurity:Provider","Local")]
    public void GatewayRefusesWritableOrDemoSecretConfiguration(string name,string value)
    {using var f=new Fixture();f.Values[name]=value;Assert.ThrowsException<InvalidOperationException>(()=>f.Options().Validate(f.Config()));}
    [TestMethod]
    public void PlainUpstreamsRequireExplicitPrivateHopConfiguration()
    {using var f=new Fixture();Assert.ThrowsException<InvalidOperationException>(()=>f.Options("http://127.0.0.1:8080").Validate(f.Config()));f.Options("http://127.0.0.1:8080",true).Validate(f.Config());}
}
