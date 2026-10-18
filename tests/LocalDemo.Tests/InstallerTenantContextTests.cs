using Grand.Business.Tenants.Services.TenantServiceProvider;
using Grand.Installer.Cli.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace LocalDemo.Tests;

[TestClass]
public sealed class InstallerTenantContextTests
{
    [TestMethod]
    public async Task StoreNamespaceSurvivesAsyncEventsAndIsClearedOnFailure()
    {
        var identity = new TenantIdentityAccessor(); identity.TenantId = null;
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(async () => {
            using var context = new InstallerTenantContext(identity, "installed-store");
            await Task.Yield();
            Assert.AreEqual("installed-store", identity.TenantId);
            throw new InvalidOperationException("controlled-service-failure");
        });
        Assert.IsNull(identity.TenantId);
    }

    [TestMethod]
    public void RejectsMissingOrForeignStoreWithoutReplacingCallerContext()
    {
        var identity = new TenantIdentityAccessor(); identity.TenantId = "caller-store";
        try
        {
            Assert.ThrowsException<InvalidOperationException>(() => new InstallerTenantContext(identity, ""));
            Assert.ThrowsException<InvalidOperationException>(() => new InstallerTenantContext(identity, "other-store"));
            Assert.AreEqual("caller-store", identity.TenantId);
            using (new InstallerTenantContext(identity, "caller-store")) Assert.AreEqual("caller-store", identity.TenantId);
            Assert.AreEqual("caller-store", identity.TenantId);
        }
        finally { identity.TenantId = null; }
    }

    [TestMethod]
    public async Task ParallelInstallersKeepSeparateCacheNamespaces()
    {
        var identity = new TenantIdentityAccessor(); identity.TenantId = null;
        var ready = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
        var arrived = 0;
        async Task Install(string store)
        {
            using var context = new InstallerTenantContext(identity, store);
            if (Interlocked.Increment(ref arrived) == 2) ready.TrySetResult();
            await ready.Task.WaitAsync(TimeSpan.FromSeconds(5));
            Assert.AreEqual(store, identity.TenantId);
        }
        await Task.WhenAll(Install("first-store"), Install("second-store"));
        Assert.IsNull(identity.TenantId);
    }
}
