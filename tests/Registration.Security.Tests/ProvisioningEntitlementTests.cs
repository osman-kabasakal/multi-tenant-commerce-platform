using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Provisioning;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Mongo;
using SaasManager.Application.Common.Models;
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Application.Stores.Provisioning;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Domain.Enums;
using SaasManager.Infrastructure.Data;
using StackExchange.Redis;

namespace Registration.Security.Tests;

[TestClass]
public sealed class ProvisioningEntitlementTests
{
    [DataTestMethod]
    [DataRow("no-subscription")][DataRow("awaiting-payment")][DataRow("active-without-payment")]
    [DataRow("cancelled")][DataRow("expired")][DataRow("expired-trial")][DataRow("future-trial")]
    [DataRow("disabled-trial")][DataRow("other-trial-plan")][DataRow("other-owner-payment")]
    [DataRow("incomplete-payment")][DataRow("missing-payment-reference")]
    public async Task InvalidEntitlementCannotCreateSecretsOrEnqueueResources(string scenario)
    {
        await using var fixture = await Fixture.Create(scenario);
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(() => fixture.Register());
        fixture.Secrets.VerifyNoOtherCalls(); fixture.Queue.VerifyNoOtherCalls();
    }
    [DataTestMethod]
    [DataRow("portable-trial")][DataRow("local-trial")][DataRow("paid")]
    public async Task ApprovedTrialOrCompletedOwnedPaymentCanEnqueue(string scenario)
    {
        await using var fixture = await Fixture.Create(scenario);
        Assert.IsTrue((await fixture.Register()).IsSuccess);
        fixture.Secrets.Verify(s => s.ProvisionAsync(fixture.Business.Id.ToString("N"), "test-shop", It.IsAny<CancellationToken>()), Times.Once);
        fixture.Queue.Verify(q => q.EnqueueAsync(It.IsAny<TenantProvisioningRequest>(), It.IsAny<CancellationToken>()), Times.Once);
    }
    [TestMethod]
    public async Task CancelledSubscriptionCanReadStatusButCannotRetrySetup()
    {
        await using var fixture = await Fixture.Create("cancelled");
        fixture.Queue.Setup(q => q.GetAsync(fixture.Business.Id.ToString("N"), It.IsAny<CancellationToken>())).ReturnsAsync((ProvisioningJob?)null);
        var handler = new ProvisioningStatusHandler(fixture.Db, fixture.Work.Object, fixture.Queue.Object, fixture.Config);
        Assert.IsNull(await handler.Handle(new GetProvisioningStatus(fixture.Business.Id), default));
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(() => handler.Handle(new RetryProvisioning(fixture.Business.Id), default));
        fixture.Queue.Verify(q => q.GetAsync(fixture.Business.Id.ToString("N"), It.IsAny<CancellationToken>()), Times.Once);
        fixture.Queue.VerifyNoOtherCalls(); fixture.Secrets.VerifyNoOtherCalls();
    }
    private sealed class Fixture : IAsyncDisposable
    {
        public required ApplicationDbContext Db;
        public required GuestRegistration Guest;
        public required Business Business;
        public required IConfiguration Config;
        public Mock<IWorkContext> Work = new();
        public Mock<ITenantSecrets> Secrets = new();
        public Mock<IProvisioningQueue> Queue = new(MockBehavior.Strict);
        public async Task<Core.Models.Responses.ServiceResponse<TenantStatusMessage>> Register()
        {
            Queue.Setup(q => q.EnqueueAsync(It.IsAny<TenantProvisioningRequest>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync((TenantProvisioningRequest request, CancellationToken _) =>
                    new ProvisioningJob(request, "Pending", 0, new Dictionary<string, ProvisioningStepResult>(), null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow));
            var handler = new RegisterStoreCommandHandler(Db, new Mock<IMongoAtlasManager>(MockBehavior.Strict).Object,
                new Mock<ISubscriber>(MockBehavior.Strict).Object, Config, Secrets.Object, Work.Object, Queue.Object);
            return await handler.Handle(new RegisterStoreCommand { BusinessId = Business.Id, StoreName = Business.Name,
                StoreSubDomain = "test-shop", OwnerEmail = Guest.Email!, Password = "synthetic-private-password",
                FirstName = "Test", Lastname = "Owner" }, default);
        }
        public static async Task<Fixture> Create(string scenario)
        {
            var db = new TestContext(new DbContextOptionsBuilder<ApplicationDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
            var guest = new GuestRegistration("owner@example.test", "fixture-token") { Id = Guid.NewGuid() };
            var business = new Business("Test Shop", "Owner", guest.Email!, "000", "123", "Test", "Street", "City", "District", "00000", "Test Ltd", guest.Id);
            guest.ConvertToBusiness(business); db.GuestRegistrations.Add(guest); db.Businesses.Add(business);
            var trial = scenario.Contains("trial") || scenario is "cancelled" or "expired";
            var plan = new SubscriptionPlan("Fixture", "fixture-plan", 10, 10, 2, 100, false, false, JsonDocument.Parse("{}"),
                trial ? 14 : 0, "Fixture plan", 0, true, 0, 1, 0);
            db.SubscriptionPlans.Add(plan); var now = DateTime.UtcNow;
            var subscription = new BusinessSubscription(business.Id, plan.Id, scenario == "future-trial" ? now.AddDays(1) : now.AddDays(-1),
                scenario == "expired" ? now.AddDays(-1) : now.AddDays(14), trial ? 0 : 10, PaymentPeriod.Monthly, trial,
                trial ? (scenario == "expired-trial" ? now.AddDays(-1) : now.AddDays(14)) : null);
            if (scenario == "awaiting-payment") subscription.UpdateStatus(SubscriptionStatus.AwaitingPayment);
            if (scenario == "cancelled") subscription.Cancel();
            if (scenario != "no-subscription") db.BusinessSubscriptions.Add(subscription);
            if (scenario is "paid" or "other-owner-payment" or "incomplete-payment" or "missing-payment-reference")
            {
                var payer = scenario == "other-owner-payment" ? new GuestRegistration("other@example.test", "other-fixture") { Id = Guid.NewGuid() } : guest;
                if (payer != guest) db.GuestRegistrations.Add(payer);
                var payment = new PaymentSetupState(payer);
                if (scenario != "missing-payment-reference") payment.SetPreAuthDetails(1, "fixture-provider-reference");
                if (scenario != "incomplete-payment") payment.Complete(); db.PaymentSetupStates.Add(payment);
            }
            var settings = new Dictionary<string, string?> { ["Provisioning:Enabled"] = "true", ["Provisioning:Profile"] = "Portable" };
            if (trial && scenario != "disabled-trial")
            {
                settings["TenantOnboarding:Trial:Enabled"] = "true";
                settings["TenantOnboarding:Trial:PlanId"] = (scenario == "other-trial-plan" ? Guid.NewGuid() : plan.Id).ToString();
            }
            if (scenario == "local-trial")
            {
                settings["Provisioning:Profile"] = "Local"; settings["LocalDemo:Enabled"] = "true"; settings["LocalDemo:SelfService"] = "true";
            }
            var fixture = new Fixture { Db = db, Guest = guest, Business = business, Config = new ConfigurationBuilder().AddInMemoryCollection(settings).Build() };
            fixture.Work.SetupGet(w => w.GuestId).Returns(guest.Id); fixture.Work.SetupGet(w => w.GuestRegistration).Returns(guest);
            await db.SaveChangesAsync(); return fixture;
        }
        public ValueTask DisposeAsync() => Db.DisposeAsync();
    }
}
