using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Business.Tenants.Services.TenantServiceProvider;
using Grand.Domain.Stores;
using Grand.Installer.Cli.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Provisioning;

namespace LocalDemo.Tests;

[TestClass]
public sealed class ManagedTenantDomainContextTests
{
    private static Store Store() => new() { Id = Guid.NewGuid().ToString("N")[..24], Url = "https://legacy.example.net", Domains = [] };
    private static TenantDomainSelection Domain() => new(Guid.NewGuid(), Guid.NewGuid(), "customer.example.net", "manage.customer.example.net", new string('a',32), "example.net");

    [TestMethod]
    public async Task MigrationSuppliesTheOwnedStoreContextAcrossAsynchronousServiceEvents()
    {
        var identity = new TenantIdentityAccessor(); identity.TenantId = null;
        var store = Store(); var service = new Mock<IStoreService>();
        service.Setup(s => s.UpdateStore(store)).Returns(async () => {
            await Task.Yield();
            Assert.AreEqual(store.Id, identity.TenantId, "Cache and domain events require the same store namespace as HTTP requests.");
        });
        await ManagedTenantDomain.UpdateAsync(store, service.Object, Domain(), identity);
        service.Verify(s => s.UpdateStore(store), Times.Once);
        Assert.AreEqual("https://customer.example.net", store.Url);
        Assert.IsTrue(store.SslEnabled);
        Assert.IsTrue(store.Domains.Any(d => d.HostName == "legacy.example.net"));
        Assert.IsNull(identity.TenantId, "The isolated installer must clear its own ambient context.");
    }

    [TestMethod]
    public async Task FailedServiceUpdateAlsoClearsTheInstallerContext()
    {
        var identity = new TenantIdentityAccessor(); identity.TenantId = null;
        var store = Store(); var service = new Mock<IStoreService>();
        service.Setup(s => s.UpdateStore(store)).Returns(async () => {
            await Task.Yield(); Assert.AreEqual(store.Id, identity.TenantId);
            throw new InvalidOperationException("controlled-update-failure");
        });
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => ManagedTenantDomain.UpdateAsync(store,service.Object,Domain(),identity));
        Assert.IsNull(identity.TenantId);
    }

    [TestMethod]
    public async Task ForeignAmbientTenantIsRejectedBeforeTheStoreChanges()
    {
        var identity = new TenantIdentityAccessor(); identity.TenantId = "foreign-store";
        try
        {
            var store = Store(); var service = new Mock<IStoreService>();
            await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => ManagedTenantDomain.UpdateAsync(store,service.Object,Domain(),identity));
            Assert.AreEqual("foreign-store",identity.TenantId);
            Assert.AreEqual("https://legacy.example.net",store.Url);
            service.Verify(s => s.UpdateStore(It.IsAny<Store>()),Times.Never);
        }
        finally { identity.TenantId = null; }
    }

    [TestMethod]
    public async Task MatchingExistingContextRemainsAvailableToItsCaller()
    {
        var identity = new TenantIdentityAccessor(); var store = Store(); identity.TenantId = store.Id;
        try
        {
            var service = new Mock<IStoreService>();
            service.Setup(s => s.UpdateStore(store)).Returns(async () => { await Task.Yield(); Assert.AreEqual(store.Id,identity.TenantId); });
            await ManagedTenantDomain.UpdateAsync(store,service.Object,Domain(),identity);
            Assert.AreEqual(store.Id,identity.TenantId, "Do not replace the shared AsyncLocal holder when the caller already selected this store.");
        }
        finally { identity.TenantId = null; }
    }

    [TestMethod]
    public async Task ConcurrentMigrationsCannotBorrowEachOthersStoreContext()
    {
        var identity = new TenantIdentityAccessor(); identity.TenantId = null;
        var first = Store(); var second = Store(); var service = new Mock<IStoreService>();
        var barrier = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously); var arrived = 0;
        service.Setup(s => s.UpdateStore(It.IsAny<Store>())).Returns(async (Store store) => {
            Assert.AreEqual(store.Id,identity.TenantId);
            if(Interlocked.Increment(ref arrived)==2)barrier.TrySetResult();
            await barrier.Task.WaitAsync(TimeSpan.FromSeconds(5));
            Assert.AreEqual(store.Id,identity.TenantId);
        });
        await Task.WhenAll(ManagedTenantDomain.UpdateAsync(first,service.Object,Domain(),identity),ManagedTenantDomain.UpdateAsync(second,service.Object,Domain(),identity));
        Assert.IsNull(identity.TenantId); Assert.AreEqual(2,arrived);
    }
}
