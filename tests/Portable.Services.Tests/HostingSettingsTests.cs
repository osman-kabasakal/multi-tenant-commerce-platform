using Microsoft.AspNetCore.DataProtection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Web.Infrastructure;

namespace Portable.Services.Tests;

[TestClass]
public sealed class HostingSettingsTests
{
    private static IConfiguration Config(params (string,string)[] values) => new ConfigurationBuilder()
        .AddInMemoryCollection(values.Select(x => new KeyValuePair<string,string?>(x.Item1,x.Item2))).Build();

    [TestMethod]
    public void PublicOriginDoesNotDependOnTheListenAddress()
    {
        CollectionAssert.AreEqual(new[]{"https://portal.example.test"}, SaasHostingSettings.AllowedOrigins(Config(("ApplicationUrl","https://portal.example.test")),false));
        CollectionAssert.AreEqual(new[]{"https://browser.example.test"}, SaasHostingSettings.AllowedOrigins(Config(("ApplicationUrl","https://portal.example.test"),("Web:AllowedOrigins:0","https://browser.example.test")),false));
    }

    [DataTestMethod]
    [DataRow("http://portal.example.test")]
    [DataRow("https://portal.example.test/")]
    [DataRow("https://*.example.test")]
    [DataRow("https://user:password@portal.example.test")]
    [DataRow("https://portal.example.test/path")]
    [DataRow("https://portal.example.test?private=value")]
    [DataRow("https://0.0.0.0:5001")]
    public void ProductionRejectsInvalidCredentialedOrigins(string origin) =>
        Assert.ThrowsException<InvalidOperationException>(() => SaasHostingSettings.AllowedOrigins(Config(("ApplicationUrl",origin)),false));

    [TestMethod]
    public void CookieKeysRemainPrivateAndReusableAcrossReplicas()
    {
        var root=Path.Combine(OperatingSystem.IsMacOS()?"/private/tmp":Path.GetTempPath(),"saas-cookie-tests-"+Guid.NewGuid().ToString("N"));
        var keys=Path.Combine(root,"private-keys");
        var config=Config(("Web:DataProtectionKeyDirectory",keys),("Web:DataProtectionApplicationName","test-saas"));
        try
        {
            using var first=Provider(config,root);var protectedValue=first.GetRequiredService<IDataProtectionProvider>().CreateProtector("session-test").Protect("session");
            using var second=Provider(config,Path.Combine(root,"different-content-root"));
            Assert.AreEqual("session",second.GetRequiredService<IDataProtectionProvider>().CreateProtector("session-test").Unprotect(protectedValue));
            if(!OperatingSystem.IsWindows()) Assert.AreEqual(UnixFileMode.UserRead|UnixFileMode.UserWrite|UnixFileMode.UserExecute,File.GetUnixFileMode(keys));
            Assert.ThrowsException<InvalidOperationException>(() => SaasHostingSettings.AddPersistentCookies(new ServiceCollection(),
                Config(("Web:DataProtectionKeyDirectory",Path.Combine(root,"wwwroot/keys")),("Web:DataProtectionApplicationName","test")),root));
        }
        finally { if(Directory.Exists(root))Directory.Delete(root,true); }
    }
    private static ServiceProvider Provider(IConfiguration config,string contentRoot)
    {
        var services=new ServiceCollection().AddLogging();SaasHostingSettings.AddPersistentCookies(services,config,contentRoot);return services.BuildServiceProvider();
    }
}
