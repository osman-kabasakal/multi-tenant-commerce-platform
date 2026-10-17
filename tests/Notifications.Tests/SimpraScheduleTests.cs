using Famizyo.Simpra.Infrastructure;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Famizyo.Simpra.Tasks;
using Famizyo.Simpra.Settings;
using Famizyo.Simpra.Services;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Data;
using Grand.Domain.Orders;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
namespace Platform.Notifications.Tests;
[TestClass]
public sealed class SimpraScheduleTests
{
    [DataTestMethod]
    [DataRow(false, 0)]
    [DataRow(true, 2)]
    public void DedicatedTaskFlagRegistersSimpraTasksWithoutStartingItsHostedProcessor(bool enabled, int count)
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?> {
            ["Provisioning:ManagedRuntime"] = "true", ["MultitenantTask:Enabled"] = enabled.ToString()
        }).Build();
        var services = new ServiceCollection();
        new SimpraStartup().ConfigureServices(services, config);
        Assert.AreEqual(count, services.Count(x => x.ServiceType == typeof(IScheduleTask)));
        Assert.IsFalse(services.Any(x => x.ServiceType == typeof(IHostedService)));
    }

    [TestMethod]
    public async Task AnUnconfiguredTenantCanExecuteBothTasksWithoutConstructingItsOptionalIntegration()
    {
        var settings = new Mock<ISettingService>(); settings.Setup(x => x.LoadSetting<SimpraSettings>(It.IsAny<string>())).Returns(new SimpraSettings());
        var provider = new Mock<IServiceProvider>(MockBehavior.Strict);
        await new SimpraOrderSyncTask(Mock.Of<IRepository<Order>>(), settings.Object, provider.Object, NullLogger<SimpraOrderSyncTask>.Instance).Execute();
        await new SimpraProductSyncTask(settings.Object, provider.Object, NullLogger<SimpraProductSyncTask>.Instance).Execute();
        provider.VerifyNoOtherCalls();
    }
    [TestMethod]
    public async Task AConfiguredIntegrationFailureReachesTheSchedulerRetryPolicy()
    {
        var settings = new Mock<ISettingService>(); settings.Setup(x => x.LoadSetting<SimpraSettings>(It.IsAny<string>())).Returns(new SimpraSettings { AccessToken = "synthetic-fixture", EnableOrderStatusSync = true, EnableProductSync = true });
        var provider = new Mock<IServiceProvider>(); provider.Setup(x => x.GetService(It.IsAny<Type>())).Throws(new InvalidOperationException("synthetic provider failure"));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new SimpraOrderSyncTask(Mock.Of<IRepository<Order>>(), settings.Object, provider.Object, NullLogger<SimpraOrderSyncTask>.Instance).Execute());
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => new SimpraProductSyncTask(settings.Object, provider.Object, NullLogger<SimpraProductSyncTask>.Instance).Execute());
    }
}
