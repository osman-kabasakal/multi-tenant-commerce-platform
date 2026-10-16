using System.Net;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Gateway;
using Platform.Security;

namespace Gateway.Tests;

[TestClass]
public sealed class TokenTests
{
    [TestMethod]
    public async Task ConcurrentRequestsShareOneFetchAndKeepCustomerCancellationIndependent()
    {
        using var f=new Fixture();var started=new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);var release=new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);var calls=0;
        var factory=new Factory(async(request,ct)=>{Interlocked.Increment(ref calls);Assert.AreEqual("https://identity.example.test/realms/commerce/protocol/openid-connect/token",request.RequestUri!.AbsoluteUri);
            var form=await request.Content!.ReadAsStringAsync(ct);StringAssert.Contains(form,"client_id=alpha-shop");StringAssert.Contains(form,"client_secret=private-alpha-client");started.SetResult();await release.Task.WaitAsync(ct);return Factory.Json(new{access_token="alpha.payload.signature",expires_in=120,token_type="Bearer"});});
        using var tokens=new TenantTokens(f.Options(),f.Secrets,factory);using var cancelled=new CancellationTokenSource();
        var first=tokens.GetAsync(f.TenantRoute(),cancelled.Token);await started.Task;var others=Enumerable.Range(0,24).Select(_=>tokens.GetAsync(f.TenantRoute(),default)).ToArray();cancelled.Cancel();
        await Assert.ThrowsExceptionAsync<TaskCanceledException>(async()=>await first);release.SetResult();
        var results=await Task.WhenAll(others);Assert.IsTrue(results.All(value=>value=="alpha.payload.signature"));Assert.AreEqual("alpha.payload.signature",await tokens.GetAsync(f.TenantRoute(),default));Assert.AreEqual(1,calls);Assert.AreEqual(0,f.Secrets.Writes);
    }
    [TestMethod]
    public async Task TokensStayBoundToEachCanonicalTenantAndSlug()
    {
        using var f=new Fixture();var second=Guid.NewGuid().ToString("N");f.Secrets.Values[(second,TenantSecretNames.KeycloakClient)]="private-beta-client";var calls=0;
        using var tokens=new TenantTokens(f.Options(),f.Secrets,new Factory(async(request,ct)=>{Interlocked.Increment(ref calls);var form=await request.Content!.ReadAsStringAsync(ct);
            var alpha=form.Contains("client_id=alpha-shop",StringComparison.Ordinal);StringAssert.Contains(form,alpha?"private-alpha-client":"private-beta-client");return Factory.Json(new{access_token=alpha?"alpha.payload.signature":"beta.payload.signature",expires_in=120,token_type="Bearer"});}));
        Assert.AreEqual("alpha.payload.signature",await tokens.GetAsync(f.TenantRoute(),default));Assert.AreEqual("beta.payload.signature",await tokens.GetAsync(new(second,"beta-shop","store-beta",false),default));Assert.AreEqual(2,calls);
    }
    [TestMethod]
    public async Task ProviderFailureIsNotCachedAndDoesNotExposeItsBody()
    {
        using var f=new Fixture();var calls=0;using var tokens=new TenantTokens(f.Options(),f.Secrets,new Factory((_,_)=>Task.FromResult(++calls==1?Factory.Json(new{error="private-provider-detail"},HttpStatusCode.Unauthorized):Factory.Json(new{access_token="alpha.payload.signature",expires_in=120,token_type="Bearer"}))));
        var error=await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>tokens.GetAsync(f.TenantRoute(),default));Assert.IsFalse(error.ToString().Contains("private-provider-detail",StringComparison.Ordinal));Assert.AreEqual("alpha.payload.signature",await tokens.GetAsync(f.TenantRoute(),default));Assert.AreEqual(2,calls);
    }
    [DataTestMethod]
    [DataRow("not-a-jwt",120,"Bearer")][DataRow("alpha.payload.signature",0,"Bearer")][DataRow("alpha.payload.signature",120,"Basic")]
    public async Task InvalidProviderTokensNeverReachCommerce(string token,int lifetime,string type)
    {using var f=new Fixture();using var tokens=new TenantTokens(f.Options(),f.Secrets,new Factory((_,_)=>Task.FromResult(Factory.Json(new{access_token=token,expires_in=lifetime,token_type=type}))));await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>tokens.GetAsync(f.TenantRoute(),default));}
}
