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
