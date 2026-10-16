using System.Security.Cryptography;
using System.Text;
using Grand.Web.ExternalSettings.DataProtection;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace LocalDemo.Tests;

[TestClass]
public sealed class TenantCookieProtectionTests
{
    [TestMethod]
    public void CachedProtectorSurvivesDifferentTenantRequestOrderOnAnotherNode()
    {
        using var keys = new KeyRing();
        var context = new HttpContextAccessor { HttpContext = null };
        var original = Protector(keys.Provider(), context);
        var payload = Encoding.UTF8.GetBytes("synthetic owner session");
        var cookies = new Dictionary<string, byte[]>();
        foreach (var tenant in new[] { "alpha", "beta", "gamma" })
        {
            Select(context, tenant);
            cookies[tenant] = original.Protect(payload);
        }

        var afterRestart = Protector(keys.Provider(), context);
        foreach (var tenant in new[] { "gamma", "alpha", "beta" })
        {
            Select(context, tenant);
            CollectionAssert.AreEqual(payload, afterRestart.Unprotect(cookies[tenant]));
            foreach (var foreign in cookies.Where(cookie => cookie.Key != tenant))
                Assert.ThrowsException<CryptographicException>(() => afterRestart.Unprotect(foreign.Value));
        }
    }

    [TestMethod]
    public void CorrectExistingTenantPayloadAndPurposeChainRemainCompatible()
    {
        using var keys = new KeyRing();
        var context = new HttpContextAccessor { HttpContext = null };
        // Authentication options can cache this protector before any tenant request exists.
        var current = Protector(keys.Provider(), context);
        Select(context, "alpha");
        var legacy = keys.Provider().CreateProtector("Tenant_alpha_cookie").CreateProtector("scheme").CreateProtector("v2");
        var payload = Encoding.UTF8.GetBytes("synthetic existing tenant session");
        CollectionAssert.AreEqual(payload, current.Unprotect(legacy.Protect(payload)));
        CollectionAssert.AreEqual(payload, legacy.Unprotect(current.Protect(payload)));
        Select(context, "beta");
        Assert.ThrowsException<CryptographicException>(() => current.Unprotect(legacy.Protect(payload)));
        Assert.ThrowsException<CryptographicException>(() => legacy.Unprotect(current.Protect(payload)));
    }

    private static IDataProtector Protector(IDataProtectionProvider provider, HttpContextAccessor context) =>
        new TenantAwareDataProtectionProvider(provider, context).CreateProtector("cookie").CreateProtector("scheme").CreateProtector("v2");

    private static void Select(HttpContextAccessor context, string tenant)
    {
        context.HttpContext = new DefaultHttpContext();
        context.HttpContext.Items["StoreId"] = tenant;
    }

    private sealed class KeyRing : IDisposable
    {
        private readonly DirectoryInfo directory = Directory.CreateTempSubdirectory("commerce-tenant-cookie-");
        public KeyRing()
        {
            if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(directory.FullName, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
        }
        public IDataProtectionProvider Provider() => DataProtectionProvider.Create(directory, options => options.SetApplicationName("TenantCookieProtectionTests"));
        public void Dispose() => directory.Delete(true);
    }
}
