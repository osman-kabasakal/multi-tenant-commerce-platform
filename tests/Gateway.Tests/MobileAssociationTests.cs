using System.Text.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Gateway;

namespace Gateway.Tests;

[TestClass]
public sealed class MobileAssociationTests
{
    private sealed class Source(params MobileAssociation[] entries) : IMobileAssociationSource
    {
        public string? Tenant;
        public Task<IReadOnlyList<MobileAssociation>> ReadAsync(string tenant, CancellationToken ct)
        { Tenant = tenant; return Task.FromResult<IReadOnlyList<MobileAssociation>>(entries); }
    }
    private static DefaultHttpContext Context(string path, string method = "GET")
    {
        var c = new DefaultHttpContext(); c.Request.Scheme = "https"; c.Request.Host = new("alpha-shop.shops.example.test");
        c.Request.Path = path; c.Request.Method = method; c.Response.Body = new MemoryStream(); return c;
    }
    private static MobileAssociation Entry(string? host = null) => new("https://" + (host ?? "alpha-shop.shops.example.test"),
        "com.publisher.alpha", "com.publisher.alpha", new string('a', 64), "ABCDE12345");
    [TestMethod]
    public async Task AndroidPublishesOnlyTheResolvedTenantOriginAndActualSigningFingerprint()
    {
        using var f = new Fixture(); var source = new Source(Entry(), Entry("another-shop.shops.example.test"));
        var c = Context(MobileAssociations.AndroidPath); await MobileAssociations.WriteAsync(c, f.TenantRoute(), source);
        c.Response.Body.Position = 0; using var json = await JsonDocument.ParseAsync(c.Response.Body);
        Assert.AreEqual(1, json.RootElement.GetArrayLength()); Assert.AreEqual(f.Tenant, source.Tenant);
        var target = json.RootElement[0].GetProperty("target"); Assert.AreEqual("com.publisher.alpha", target.GetProperty("package_name").GetString());
        Assert.AreEqual(string.Join(":", Enumerable.Repeat("AA", 32)), target.GetProperty("sha256_cert_fingerprints")[0].GetString());
        Assert.AreEqual("application/json; charset=utf-8", c.Response.ContentType);
    }
    [TestMethod]
    public async Task ApplePublishesTheSelectedTeamAndBundleWithAdminPathsExcluded()
    {
        using var f = new Fixture(); var c = Context(MobileAssociations.ApplePath);
        await MobileAssociations.WriteAsync(c, f.TenantRoute(), new Source(Entry())); c.Response.Body.Position = 0;
        using var json = await JsonDocument.ParseAsync(c.Response.Body); var detail = json.RootElement.GetProperty("applinks").GetProperty("details")[0];
        Assert.AreEqual("ABCDE12345.com.publisher.alpha", detail.GetProperty("appID").GetString());
        CollectionAssert.Contains(detail.GetProperty("paths").EnumerateArray().Select(x => x.GetString()).ToArray(), "NOT /Admin/*");
    }
    [TestMethod]
    public async Task NoApprovedIdentityOrInvalidSigningDataNeverAuthorizesAnApplication()
    {
        using var f = new Fixture();
        foreach (var item in new[] { Entry("foreign.example.test"), Entry() with { AndroidCertificateSha256 = "bad", IosTeam = "bad" } })
        foreach (var path in new[] { MobileAssociations.AndroidPath, MobileAssociations.ApplePath })
        { var c = Context(path); await MobileAssociations.WriteAsync(c, f.TenantRoute(), new Source(item)); Assert.AreEqual(404, c.Response.StatusCode); Assert.AreEqual(0L, c.Response.Body.Length); }
    }
    [TestMethod]
    public async Task AdminAndMutationRequestsCannotReadOrChangeAssociationBindings()
    {
        using var f = new Fixture(); var source = new Source(Entry()); var c = Context(MobileAssociations.AndroidPath);
        await MobileAssociations.WriteAsync(c, f.TenantRoute() with { Admin = true }, source); Assert.AreEqual(404, c.Response.StatusCode); Assert.IsNull(source.Tenant);
        c = Context(MobileAssociations.AndroidPath, "POST"); await MobileAssociations.WriteAsync(c, f.TenantRoute(), source);
        Assert.AreEqual(405, c.Response.StatusCode); Assert.IsNull(source.Tenant);
        c = Context(MobileAssociations.AndroidPath, "HEAD"); await MobileAssociations.WriteAsync(c, f.TenantRoute(), source);
        Assert.AreEqual(200, c.Response.StatusCode); Assert.AreEqual(0L, c.Response.Body.Length);
    }
}
