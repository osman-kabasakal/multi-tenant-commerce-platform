using System.Text.Json;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;

namespace Portable.Provisioning.Tests;

[TestClass]
public sealed class MobileIdentityBuildTests
{
    private static async Task<AndroidBuildScope> NewIdentityAsync(AndroidFixture f)
    {
        const string package="com.publisher.newbusiness";
        var id=Guid.NewGuid();var previous=f.Firebase;
        var next=previous with {AndroidPackageName=package,IosBundleId=package,AndroidAppId=previous.AndroidAppId+"a",IosAppId=previous.IosAppId+"a",
            AndroidConfigJson=previous.AndroidConfigJson.Replace(previous.AndroidPackageName,package,StringComparison.Ordinal).Replace(previous.AndroidAppId,previous.AndroidAppId+"a",StringComparison.Ordinal),
            IosConfigPlist=previous.IosConfigPlist.Replace(previous.IosBundleId,package,StringComparison.Ordinal).Replace(previous.IosAppId,previous.IosAppId+"a",StringComparison.Ordinal)};
        // Only this fixture's synthetic remote app is switched. The encrypted legacy configuration remains untouched.
        f.Server.Tenants[previous.ProjectId]=next;
        var name="firebase-mobile-identity-"+id.ToString("N");f.Secrets.Values[(f.Request.TenantId,name)]=JsonSerializer.Serialize(next);
        var key=await new TenantAndroidSigningKeys(f.Secrets,f.Keys).GetOrCreatePackageAsync(f.Request.TenantId,package,default);
        return new(id,false,package,package,name,TenantAndroidSigningKeys.PackageSecretName(package),key.CertificateSha256,next.ProjectId,next.ProjectNumber,next.AndroidAppId,
            "https://shop.example.org",f.Builder.SourceHash);
    }
    [TestMethod]
    public async Task NewIdentityUsesItsOwnFirebaseAppKeyAndEndpointWithoutChangingTheOriginalRelease()
    {
        using var f=new AndroidFixture();
        var original=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default);
        f.Completed["mobile-android-release"]=original;
        var legacy=f.Secrets.Values.Where(x=>!x.Key.Item2.Contains("identity",StringComparison.Ordinal)).ToDictionary(x=>x.Key,x=>x.Value);
        var scope=await NewIdentityAsync(f);
        var receipt=await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,scope.IdentityId,1,scope);
        Assert.AreEqual(scope.AndroidPackageName,receipt.Resources["androidApplicationId"]);
        Assert.AreEqual(scope.StoreUrl,receipt.Resources["storeUrl"]);
        Assert.AreEqual(scope.CertificateSha256,receipt.Resources["signingCertificateSha256"]);
        Assert.AreNotEqual(original.Resources["signingCertificateSha256"],scope.CertificateSha256);
        foreach(var saved in legacy)Assert.AreEqual(saved.Value,f.Secrets.Values[saved.Key]);
        Assert.AreEqual(2,f.Keys.Creates);
        await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,scope.IdentityId,1,scope);
        Assert.AreEqual(2,f.Builder.Builds);Assert.AreEqual(2,f.Keys.Creates);
        // An explicit manual release, even with the same GUID, cannot consume the identity's initial artifact receipt.
        f.Server.BuildVersion="2";
        await f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,scope.IdentityId,2,scope with {SourceHash=null});
        Assert.AreEqual(3,f.Builder.Builds);Assert.AreEqual(2,f.Keys.Creates);
    }
    [TestMethod]
    public async Task ChangedPreparedSourceOrCertificateNeverBuildsWithAnAlternativeKey()
    {
        using var f=new AndroidFixture();var scope=await NewIdentityAsync(f);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,scope.IdentityId,1,scope with{SourceHash=new string('b',64)}));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,scope.IdentityId,1,scope with{CertificateSha256=new string('c',64)}));
        Assert.AreEqual(0,f.Builder.Builds);Assert.AreEqual(1,f.Keys.Creates);Assert.AreEqual(0,f.Server.Uploads);
    }
    [TestMethod]
    public async Task MissingPackageSigningMaterialCannotBeReplacedDuringAScopedBuild()
    {
        using var f=new AndroidFixture();var scope=await NewIdentityAsync(f);
        f.Secrets.Values.TryRemove((f.Request.TenantId,scope.SigningSecretName),out _);
        await Assert.ThrowsExceptionAsync<KeyNotFoundException>(()=>f.Pipeline().ExecuteAsync(f.Request,f.Completed,default,scope.IdentityId,1,scope));
        Assert.AreEqual(1,f.Keys.Creates);Assert.AreEqual(0,f.Builder.Builds);
    }
}
