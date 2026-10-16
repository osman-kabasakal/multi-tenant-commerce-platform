using System.Text.Json;
using Core.Models.Configs;
using MediatR;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Platform.Provisioning;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.Mongo;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Utilities;
using SaasManager.Application.IdentityManagement.Commands.Registration;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Infrastructure.PaymentProviders;
using StackExchange.Redis;
using Iyzipay;
using Iyzipay.Model;
using Iyzipay.Model.V2;
using Iyzipay.Model.V2.Subscription;
using Iyzipay.Request;
using Iyzipay.Request.V2.Subscription;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Models.PaymentProviders;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;
using SaasManager.Infrastructure.Data;
using SaasManager.Infrastructure.PaymentProviders.IyzicoProvider;
using DomainSubscriptionStatus = SaasManager.Domain.Enums.SubscriptionStatus;

namespace Registration.Security.Tests;

[TestClass]
public sealed class IyzicoSubscriptionTests
{
    [DataTestMethod]
    [DataRow(false)][DataRow(true)]
    public async Task BothMerchantModesRequireRealPlanAndInitializeResponse(bool sandbox)
    {
        await using var f = await Fixture.Create(sandbox);
        var result = await f.Provider.ProcessPaymentAsync(f.Subscription, Card());
        Assert.IsTrue(result.IsSuccess, $"Plan reads: {f.Api.PlanReads}; initializations: {f.Api.Initializations}"); Assert.AreEqual(f.Api.SubscriptionId, result.PaymentId);
        Assert.AreEqual(1, f.Api.PlanReads); Assert.AreEqual(1, f.Api.Initializations);
        Assert.AreEqual(sandbox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com", f.Api.LastOrigin);
        Assert.AreEqual("PENDING", f.Api.Request!.SubscriptionInitialStatus);
        Assert.AreEqual("2034", f.Api.Request.PaymentCard.ExpireYear); Assert.AreEqual("09", f.Api.Request.PaymentCard.ExpireMonth);
        Assert.AreEqual(f.Plan.Code, f.Api.Request.PricingPlanReferenceCode);
        Assert.AreEqual(f.Api.PlanId, f.Plan.Code, "Checkout must not replace the merchant pricing reference.");
        Assert.IsFalse(JsonSerializer.Serialize(result).Contains(Card().Number));
    }
    [DataTestMethod]
    [DataRow(false, false)][DataRow(true, false)][DataRow(false, true)][DataRow(true, true)]
    public async Task RejectionOrTransportFailureCannotBecomeSyntheticSuccess(bool sandbox, bool transportFailure)
    {
        await using var f = await Fixture.Create(sandbox);
        f.Api.RejectInitialize = !transportFailure; f.Api.ThrowInitialize = transportFailure;
        var result = await f.Provider.ProcessPaymentAsync(f.Subscription, Card());
        Assert.IsFalse(result.IsSuccess); Assert.IsNull(result.PaymentId); Assert.IsNull(result.RawResult);
        Assert.IsFalse(JsonSerializer.Serialize(result).Contains("private-provider-detail"));
        Assert.AreEqual(1, f.Api.Initializations);
    }
    [DataTestMethod]
    [DataRow("price")][DataRow("currency")][DataRow("interval")][DataRow("trial")][DataRow("foreign-plan")]
    public async Task DifferentRemotePricingTermsNeverInitializeSubscription(string mismatch)
    {
        await using var f = await Fixture.Create(false);
        f.Api.PricingMismatch = mismatch;
        Assert.IsFalse((await f.Provider.ProcessPaymentAsync(f.Subscription, Card())).IsSuccess);
        Assert.AreEqual(0, f.Api.Initializations);
    }
    [TestMethod]
    public async Task MissingOrSyntheticMerchantPlanCodeNeverCallsProvider()
    {
        await using var f = await Fixture.Create(true); f.Plan.UpdateCode("old-synthetic-plan");
        Assert.IsFalse((await f.Provider.ProcessPaymentAsync(f.Subscription, Card())).IsSuccess);
        Assert.AreEqual(0, f.Api.PlanReads); Assert.AreEqual(0, f.Api.Initializations);
    }
    [TestMethod]
    public async Task ActivationIsConfirmedByReadingTheSameProviderCustomerAndPlan()
    {
        await using var f = await Fixture.Create(true);
        var payment = await f.Provider.ProcessPaymentAsync(f.Subscription, Card());
        Assert.IsTrue(await f.Provider.ActivateSubscriptionAsync(payment));
        Assert.AreEqual(1, f.Api.Activations); Assert.AreEqual(2, f.Api.SubscriptionReads);
        // A completed activation replay reads ACTIVE and does not activate or charge again.
        Assert.IsTrue(await f.Provider.ActivateSubscriptionAsync(payment));
        Assert.AreEqual(1, f.Api.Activations); Assert.AreEqual(1, f.Api.Initializations);
    }
    [DataTestMethod]
    [DataRow("foreign-before")][DataRow("foreign-after")][DataRow("not-active")][DataRow("rejected")]
    public async Task ActivationCannotAcceptForeignOrUnconfirmedResources(string mismatch)
    {
        await using var f = await Fixture.Create(false);
        var payment = await f.Provider.ProcessPaymentAsync(f.Subscription, Card());
        f.Api.WrongSubscriptionBefore = mismatch == "foreign-before"; f.Api.WrongSubscriptionAfter = mismatch == "foreign-after";
        f.Api.AfterActivationState = mismatch == "not-active" ? "PENDING" : "ACTIVE"; f.Api.RejectActivation = mismatch == "rejected";
        Assert.IsFalse(await f.Provider.ActivateSubscriptionAsync(payment));
        if (mismatch == "foreign-before") Assert.AreEqual(0, f.Api.Activations);
    }
    [TestMethod]
    public async Task MissingInitializationReceiptCannotActivateAnything()
    {
        await using var f = await Fixture.Create(true);
        Assert.IsFalse(await f.Provider.ActivateSubscriptionAsync(new PaymentResponse { IsSuccess = true, PaymentId = f.Api.SubscriptionId }));
        Assert.AreEqual(0, f.Api.SubscriptionReads); Assert.AreEqual(0, f.Api.Activations);
    }
    [DataTestMethod]
    [DataRow(false)][DataRow(true)]
    public async Task SandboxBinFailuresAreNotValidCards(bool transportFailure)
    {
        await using var f = await Fixture.Create(true); f.Api.ThrowBin = transportFailure; f.Api.RejectBin = !transportFailure;
        Assert.IsFalse(await f.Provider.ValidateCardAsync(Card()));
    }
    [TestMethod]
    public async Task DefaultProviderCreatesOnlyMetadataAndWorksOnTheFirstCall()
    {
        await using var f = await Fixture.Create(true);
        var factory = new PaymentProviderFactory(f.Db, Microsoft.Extensions.Options.Options.Create(new IyzicoConfiguration {
            ApiKey = "synthetic-merchant-key", SecretKey = "synthetic-merchant-secret", IsSandbox = true }),
            [f.Provider], NullLogger<PaymentProviderFactory>.Instance);
        Assert.AreSame(f.Provider, factory.GetDefaultProvider());
        var stored = await f.Db.PaymentProviders.SingleAsync();
        Assert.AreEqual(stored.Id, f.Provider.Id); Assert.IsTrue(stored.IsSandbox);
        Assert.AreEqual(string.Empty, stored.ApiKey); Assert.AreEqual(string.Empty, stored.ApiSecret);
        Assert.IsFalse(stored.Configuration.RootElement.GetRawText().Contains("synthetic-merchant"));
        Assert.AreSame(f.Provider, factory.GetDefaultProvider()); Assert.AreEqual(1, await f.Db.PaymentProviders.CountAsync());
        Assert.AreEqual(0, f.Api.Initializations);
    }
    [DataTestMethod]
    [DataRow("Production")][DataRow("Staging")]
    public void ProductionDoesNotReadLegacyDevelopmentMerchantSecrets(string environment)
    {
        var host = Host.CreateApplicationBuilder(new HostApplicationBuilderSettings { EnvironmentName = environment, DisableDefaults = true });
        host.Configuration.AddInMemoryCollection(new Dictionary<string, string?> { ["Dev:Iyzico:ApiKey"] = "legacy-fixture", ["Dev:Iyzico:SecretKey"] = "legacy-fixture" });
        Core.DependencyInjections.ConfigureSettings(host);
        using var provider = host.Services.BuildServiceProvider(); var value = provider.GetRequiredService<IOptions<IyzicoConfiguration>>().Value;
        Assert.AreEqual(string.Empty, value.ApiKey); Assert.AreEqual(string.Empty, value.SecretKey); Assert.IsTrue(value.IsSandbox);
    }
    [DataTestMethod]
    [DataRow(false)][DataRow(true)]
    public void ExplicitMerchantConfigurationSelectsTheRequestedMode(bool sandbox)
    {
        var host = Host.CreateApplicationBuilder(new HostApplicationBuilderSettings { EnvironmentName = "Production", DisableDefaults = true });
        host.Configuration.AddInMemoryCollection(new Dictionary<string, string?> { ["Payments:Provider"] = "Iyzico", ["Payments:Iyzico:ApiKey"] = "configured-fixture",
            ["Payments:Iyzico:SecretKey"] = "configured-fixture", ["Payments:Iyzico:IsSandbox"] = sandbox.ToString() });
        Core.DependencyInjections.ConfigureSettings(host);
        using var provider = host.Services.BuildServiceProvider(); var value = provider.GetRequiredService<IOptions<IyzicoConfiguration>>().Value;
        Assert.AreEqual("configured-fixture", value.ApiKey); Assert.AreEqual(sandbox, value.IsSandbox);
    }
    [TestMethod]
    public void ExplicitlyDisabledPaymentsIgnoreRetainedMerchantKeys()
    {
        var host = Host.CreateApplicationBuilder(new HostApplicationBuilderSettings { EnvironmentName = "Development", DisableDefaults = true });
        host.Configuration.AddInMemoryCollection(new Dictionary<string, string?> { ["Payments:Provider"] = "Disabled",
            ["Payments:Iyzico:ApiKey"] = "retained-fixture", ["Payments:Iyzico:SecretKey"] = "retained-fixture",
            ["Dev:Iyzico:ApiKey"] = "legacy-fixture", ["Dev:Iyzico:SecretKey"] = "legacy-fixture" });
        Core.DependencyInjections.ConfigureSettings(host);
        using var provider = host.Services.BuildServiceProvider(); var value = provider.GetRequiredService<IOptions<IyzicoConfiguration>>().Value;
        Assert.AreEqual(string.Empty, value.ApiKey); Assert.AreEqual(string.Empty, value.SecretKey);
    }
    [DataTestMethod]
    [DataRow(false, false)][DataRow(true, false)][DataRow(false, true)]
    public async Task PaidRegistrationRequiresConfirmedActivationAndNeverReinitializesSavedAttempt(bool rejectActivation, bool unknownInitialization)
    {
        await using var f = await Fixture.Create(true); f.Api.RejectActivation = rejectActivation; f.Api.ThrowInitialize = unknownInitialization;
        var selection = new SubscriptionSelectionState(f.Guest); selection.SelectPlan(f.Plan, false); selection.Complete();
        var state = new PaymentSetupState(f.Guest); f.Db.SubscriptionSelectionStates.Add(selection); f.Db.PaymentSetupStates.Add(state); await f.Db.SaveChangesAsync();
        var factory = new PaymentProviderFactory(f.Db, Microsoft.Extensions.Options.Options.Create(new IyzicoConfiguration {
            ApiKey = "synthetic-merchant-key", SecretKey = "synthetic-merchant-secret", IsSandbox = true }), [f.Provider], NullLogger<PaymentProviderFactory>.Instance);
        var configuration = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
            ["Provisioning:Enabled"] = "true", ["Provisioning:Profile"] = "Portable" }).Build();
        var secrets = PaymentTestLock.Secrets(); var queue = new Mock<IProvisioningQueue>();
        queue.Setup(q => q.EnqueueAsync(It.IsAny<TenantProvisioningRequest>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((TenantProvisioningRequest request, CancellationToken _) => new ProvisioningJob(request, "Pending", 0,
                new Dictionary<string,ProvisioningStepResult>(), null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow));
        var register = new RegisterStoreCommandHandler(f.Db, new Mock<IMongoAtlasManager>(MockBehavior.Strict).Object,
            new Mock<ISubscriber>(MockBehavior.Strict).Object, configuration, secrets.Object, f.Work.Object, queue.Object);
        var sender = new Mock<ISender>();
        sender.Setup(s => s.Send(It.IsAny<RegisterStoreCommand>(), It.IsAny<CancellationToken>()))
            .Returns<RegisterStoreCommand,CancellationToken>((command, ct) => register.Handle(command, ct));
        var card = new Mock<ICardDataProtector>(); card.Setup(c => c.ValidateAsync(It.IsAny<CardData>())).ReturnsAsync(true);
        card.Setup(c => c.EncryptAsync(It.IsAny<CardData>())).ReturnsAsync(new EncryptedCardData {
            EncryptedNumber = "synthetic-encrypted-card", LastFourDigits = "4444", CardType = "Synthetic", CardHolderName = "Synthetic Owner",
            ExpiryMonth = "09", ExpiryYear = "34", KeyIdentifier = "fixture-key" });
        var clock = new Mock<IDateTime>(); clock.SetupGet(c => c.Now).Returns(DateTime.UtcNow);
        var step = new PaymentVerificationStep(f.Db, f.Work.Object, clock.Object, NullLogger<PaymentVerificationStep>.Instance,
            card.Object, factory, sender.Object, new Mock<IMediator>().Object, secrets.Object, configuration, new PaymentTestLock());
        f.Db.SavingChanges += (_, _) => {
            if (f.Db.ChangeTracker.Entries<SaasManager.Domain.Entities.Financial.PaymentMethod>().Any(e => e.State == EntityState.Added))
            {
                Assert.IsTrue(state.IsCompleted, "Payment metadata cannot commit before registration completion.");
                Assert.AreEqual(DomainSubscriptionStatus.Active, f.Subscription.Status);
            }
        };
        await step.ValidateAsync(new RegistrationCommand { Data = new Dictionary<string,object> { ["cardHolderName"] = "Synthetic Owner",
            ["cardNumber"] = Card().Number, ["expireMonth"] = "09", ["expireYear"] = "34", ["cvc"] = "123" } }, default);
        Assert.AreEqual(!rejectActivation && !unknownInitialization, state.IsCompleted);
        Assert.AreEqual(rejectActivation || unknownInitialization ? DomainSubscriptionStatus.AwaitingPayment : DomainSubscriptionStatus.Active, f.Subscription.Status);
        Assert.AreEqual(rejectActivation || unknownInitialization ? 0 : 1, await f.Db.PaymentMethods.CountAsync());
        queue.Verify(q => q.EnqueueAsync(It.IsAny<TenantProvisioningRequest>(), It.IsAny<CancellationToken>()), rejectActivation || unknownInitialization ? Times.Never() : Times.Once());
        Assert.AreEqual(1, f.Api.Initializations);
        if (unknownInitialization)
        {
            f.Api.ThrowInitialize = false;
            Assert.IsFalse((await step.ValidateAsync(new RegistrationCommand(), default)).IsValid);
            Assert.AreEqual(1, f.Api.Initializations); Assert.AreEqual(0, f.Api.Activations);
            card.Verify(c => c.ValidateAsync(It.IsAny<CardData>()), Times.Once());
            return;
        }
        Assert.AreEqual(1, f.Api.Activations);
        if (!rejectActivation)
        {
            await step.ValidateAsync(new RegistrationCommand(), default);
            Assert.AreEqual(1, f.Api.Initializations); Assert.AreEqual(1, f.Api.Activations);
            Assert.AreEqual(1, await f.Db.PaymentMethods.CountAsync());
            queue.Verify(q => q.EnqueueAsync(It.IsAny<TenantProvisioningRequest>(), It.IsAny<CancellationToken>()), Times.Exactly(2));
        }
        else
        {
            f.Api.RejectActivation = false;
            Assert.IsTrue((await step.ValidateAsync(new RegistrationCommand(), default)).IsValid,
                "A saved provider receipt must resume without receiving card data again.");
            Assert.IsTrue(state.IsCompleted); Assert.AreEqual(1, f.Api.Initializations);
            Assert.AreEqual(1, await f.Db.PaymentMethods.CountAsync());
        }
    }
    private static CardData Card() => new() { Number = "1111222233334444", Cvv = "123", ExpiryMonth = "09", ExpiryYear = "34", CardHolderName = "Synthetic Owner" };
    internal sealed class Fixture : IAsyncDisposable
    {
        public required ApplicationDbContext Db; public required GuestRegistration Guest; public required Business Business;
        public required SubscriptionPlan Plan; public required BusinessSubscription Subscription; public required IyzicoPaymentProvider Provider;
        public required Mock<IWorkContext> Work; public required Api Api;
        public static async Task<Fixture> Create(bool sandbox)
        {
            var db = new TestContext(new DbContextOptionsBuilder<ApplicationDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
            var guest = new GuestRegistration("owner@example.test", "synthetic-owner") { Id = Guid.NewGuid(), Firstname = "Test", Lastname = "Owner" };
            var business = new Business("Test Shop", "Owner", guest.Email!, "000", "123", "Test", "Street", "City", "District", "00000", "Test Ltd", guest.Id) { Id = Guid.NewGuid() };
            guest.ConvertToBusiness(business); var api = new Api();
            var plan = new SubscriptionPlan("Paid fixture", api.PlanId, 49.95m, 10, 2, 100, false, false, JsonDocument.Parse("{}"), 0, "Contract", 0, true, 0, 1, 0) { Id = Guid.NewGuid() };
            var subscription = new BusinessSubscription(business.Id, plan.Id, DateTime.UtcNow, DateTime.UtcNow.AddMonths(1), plan.Price, PaymentPeriod.Monthly);
            subscription.UpdateStatus(DomainSubscriptionStatus.AwaitingPayment);
            db.GuestRegistrations.Add(guest); db.Businesses.Add(business); db.SubscriptionPlans.Add(plan); db.BusinessSubscriptions.Add(subscription);
            await db.SaveChangesAsync(); Assert.AreEqual(business.Id, subscription.BusinessId); Assert.AreEqual(plan.Id, subscription.PlanId); var work = new Mock<IWorkContext>(); work.SetupGet(w => w.GuestRegistration).Returns(guest); work.SetupGet(w => w.GuestId).Returns(guest.Id);
            var provider = new IyzicoPaymentProvider(db, work.Object, Microsoft.Extensions.Options.Options.Create(new IyzicoConfiguration {
                ApiKey = "synthetic-merchant-key", SecretKey = "synthetic-merchant-secret", IsSandbox = sandbox }), NullLogger<IyzicoPaymentProvider>.Instance, api);
            return new() { Db = db, Guest = guest, Business = business, Plan = plan, Subscription = subscription, Work = work, Api = api, Provider = provider };
        }
        public ValueTask DisposeAsync() => Db.DisposeAsync();
    }
    internal sealed class Api : IIyzicoSubscriptionApi
    {
        public string PlanId = Guid.NewGuid().ToString("D"), SubscriptionId = Guid.NewGuid().ToString("D"), CustomerId = Guid.NewGuid().ToString("D");
        public int PlanReads, Initializations, Activations, SubscriptionReads;
        public string? LastOrigin, PricingMismatch; public string State = "PENDING", AfterActivationState = "ACTIVE";
        public bool RejectInitialize, ThrowInitialize, RejectActivation, WrongSubscriptionBefore, WrongSubscriptionAfter, ThrowBin, RejectBin;
        public SubscriptionInitializeRequest? Request;
        public ResponseData<PlanResource> ReadPlan(RetrievePlanRequest request, Iyzipay.Options options)
        {
            PlanReads++; LastOrigin = options.BaseUrl;
            return new() { Status = "success", Data = new PlanResource { ReferenceCode = PricingMismatch == "foreign-plan" ? Guid.NewGuid().ToString("D") : PlanId,
                Status = "ACTIVE", Price = PricingMismatch == "price" ? "100.00" : "49.95", CurrencyCode = PricingMismatch == "currency" ? "USD" : "TRY",
                PaymentInterval = PricingMismatch == "interval" ? "YEARLY" : "MONTHLY", PaymentIntervalCount = 1, PlanPaymentType = "RECURRING",
                TrialPeriodDays = PricingMismatch == "trial" ? 30 : 0 } };
        }
        public ResponseData<SubscriptionCreatedResource> Initialize(SubscriptionInitializeRequest request, Iyzipay.Options options)
        {
            Initializations++; Request = request; LastOrigin = options.BaseUrl;
            if (ThrowInitialize) throw new IOException("private-provider-detail");
            return new() { Status = RejectInitialize ? "failure" : "success", ErrorMessage = "private-provider-detail", Data = new SubscriptionCreatedResource {
                ReferenceCode = SubscriptionId, PricingPlanReferenceCode = PlanId, CustomerReferenceCode = CustomerId, SubscriptionStatus = "PENDING" } };
        }
        public IyzipayResourceV2 Activate(ActivateSubscriptionRequest request, Iyzipay.Options options)
        {
            Activations++; if (!RejectActivation) State = AfterActivationState;
            return new() { Status = RejectActivation ? "failure" : "success" };
        }
        public ResponseData<SubscriptionResource> ReadSubscription(RetrieveSubscriptionRequest request, Iyzipay.Options options)
        {
            SubscriptionReads++; var wrong = SubscriptionReads == 1 ? WrongSubscriptionBefore : WrongSubscriptionAfter;
            return new() { Status = "success", Data = new SubscriptionResource { ReferenceCode = SubscriptionId, CustomerReferenceCode = CustomerId,
                PricingPlanReferenceCode = wrong ? Guid.NewGuid().ToString("D") : PlanId, SubscriptionStatus = State } };
        }
        public Task<BinNumber> ReadBinAsync(RetrieveBinNumberRequest request, Iyzipay.Options options) => ThrowBin
            ? Task.FromException<BinNumber>(new IOException("private-provider-detail")) : Task.FromResult(new BinNumber { Status = RejectBin ? "failure" : "success" });
    }
}
