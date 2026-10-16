using System.Collections.Concurrent;
using System.Text.Json;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SaasManager.Application.Common.Models.PaymentProviders;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;

namespace Registration.Security.Tests;

[TestClass]
public sealed class SubscriptionPaymentJournalTests
{
    private static async Task<IyzicoSubscriptionTests.Fixture> Create()
    {
        var fixture = await IyzicoSubscriptionTests.Fixture.Create(true);
        new SaasManager.Infrastructure.PaymentProviders.PaymentProviderFactory(fixture.Db,
            Microsoft.Extensions.Options.Options.Create(new Core.Models.Configs.IyzicoConfiguration {
                ApiKey = "synthetic-merchant-key", SecretKey = "synthetic-merchant-secret", IsSandbox = true }),
            [fixture.Provider], Microsoft.Extensions.Logging.Abstractions.NullLogger<SaasManager.Infrastructure.PaymentProviders.PaymentProviderFactory>.Instance).GetDefaultProvider();
        return fixture;
    }
    private static EncryptedCardData Card() => new() { EncryptedNumber = "test-ciphertext", LastFourDigits = "4444", ExpiryYear = "34", ExpiryMonth = "09" };
    private static PaymentResponse Receipt() => new() { IsSuccess = true, InitializationOutcome = PaymentInitializationOutcome.Initialized,
        PaymentId = Guid.NewGuid().ToString("D"), RawResult = "{\"receipt\":\"synthetic\"}" };
    [TestMethod]
    public async Task NewProcessResumesTheExactOriginalReceiptAndProtectedCard()
    {
        await using var f = await Create();
        var records = new ConcurrentDictionary<string,string>(); var secrets = PaymentTestLock.Secrets(records).Object;
        var lease = new PaymentTestLock.Lease();
        var first = await SubscriptionPaymentJournal.OpenAsync(secrets, lease, f.Guest.Id, f.Subscription, f.Plan, f.Provider, default);
        await first.BeginAsync(Card(), default); var receipt = Receipt();
        Assert.IsTrue(await first.RecordInitializationAsync(receipt, default)); await first.RecordActiveAsync(default);
        var resumed = await SubscriptionPaymentJournal.OpenAsync(PaymentTestLock.Secrets(records).Object, new PaymentTestLock.Lease(),
            f.Guest.Id, f.Subscription, f.Plan, f.Provider, default);
        Assert.AreEqual(SubscriptionPaymentJournal.Phase.Active, resumed.CurrentPhase);
        Assert.AreEqual(receipt.PaymentId, resumed.Receipt.PaymentId); Assert.AreEqual("test-ciphertext", resumed.Card.EncryptedNumber);
        Assert.IsFalse(records.Single().Value.Contains("Cvv", StringComparison.OrdinalIgnoreCase));
        Assert.IsFalse(records.Single().Value.Contains("synthetic-merchant-key"));
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => resumed.BeginAsync(Card(), default));
    }
    [DataTestMethod]
    [DataRow(false)][DataRow(true)]
    public async Task ProcessLossOrUnknownResponseNeverReopensInitialization(bool responseReturned)
    {
        await using var f = await Create();
        var secrets = PaymentTestLock.Secrets().Object; var lease = new PaymentTestLock.Lease();
        var journal = await SubscriptionPaymentJournal.OpenAsync(secrets, lease, f.Guest.Id, f.Subscription, f.Plan, f.Provider, default);
        await journal.BeginAsync(Card(), default);
        if (responseReturned) Assert.IsFalse(await journal.RecordInitializationAsync(new PaymentResponse { InitializationOutcome = PaymentInitializationOutcome.Unknown }, default));
        var resumed = await SubscriptionPaymentJournal.OpenAsync(secrets, new PaymentTestLock.Lease(), f.Guest.Id, f.Subscription, f.Plan, f.Provider, default);
        Assert.AreEqual(SubscriptionPaymentJournal.Phase.Initializing, resumed.CurrentPhase);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => resumed.BeginAsync(Card(), default));
    }
    [DataTestMethod]
    [DataRow(PaymentInitializationOutcome.NotSubmitted)][DataRow(PaymentInitializationOutcome.Rejected)]
    public async Task OnlyAnExplicitUncreatedResultCanReturnToReady(PaymentInitializationOutcome outcome)
    {
        await using var f = await Create(); var secrets = PaymentTestLock.Secrets().Object;
        var journal = await SubscriptionPaymentJournal.OpenAsync(secrets, new PaymentTestLock.Lease(), f.Guest.Id, f.Subscription, f.Plan, f.Provider, default);
        await journal.BeginAsync(Card(), default); Assert.IsFalse(await journal.RecordInitializationAsync(new PaymentResponse { InitializationOutcome = outcome }, default));
        Assert.AreEqual(SubscriptionPaymentJournal.Phase.Ready, journal.CurrentPhase);
        await journal.BeginAsync(Card(), default);
        Assert.IsFalse(await journal.RecordInitializationAsync(new PaymentResponse { InitializationOutcome = outcome, PaymentId = "unexpected-reference" }, default));
        Assert.AreEqual(SubscriptionPaymentJournal.Phase.Initializing, journal.CurrentPhase);
    }
    [DataTestMethod]
    [DataRow("guest")][DataRow("price")][DataRow("merchant-plan")][DataRow("merchant-mode")]
    public async Task ChangedOwnerOrContractRequiresReconciliation(string changed)
    {
        await using var f = await Create(); var secrets = PaymentTestLock.Secrets().Object;
        await SubscriptionPaymentJournal.OpenAsync(secrets, new PaymentTestLock.Lease(), f.Guest.Id, f.Subscription, f.Plan, f.Provider, default);
        if (changed == "price") f.Subscription.UpdateAmount(100);
        if (changed == "merchant-plan") f.Plan.UpdateCode(Guid.NewGuid().ToString("D"));
        var provider = new Moq.Mock<SaasManager.Application.Common.Interfaces.PaymentProviders.IPaymentProvider>();
        provider.SetupGet(p => p.Id).Returns(f.Provider.Id); provider.SetupGet(p => p.Code).Returns(f.Provider.Code);
        provider.SetupGet(p => p.ConfigurationFingerprint).Returns(changed == "merchant-mode" ? new string('0',64) : f.Provider.ConfigurationFingerprint);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => SubscriptionPaymentJournal.OpenAsync(secrets, new PaymentTestLock.Lease(),
            changed == "guest" ? Guid.NewGuid() : f.Guest.Id, f.Subscription, f.Plan, provider.Object, default));
    }
    [TestMethod]
    public async Task LostLeaseCannotOverwriteDurableProgress()
    {
        await using var f = await Create(); var secrets = PaymentTestLock.Secrets(); var lease = new PaymentTestLock.Lease();
        var journal = await SubscriptionPaymentJournal.OpenAsync(secrets.Object, lease, f.Guest.Id, f.Subscription, f.Plan, f.Provider, default);
        lease.Held = false;
        await Assert.ThrowsExceptionAsync<IOException>(() => journal.BeginAsync(Card(), default));
        secrets.Verify(s => s.SetAsync(Moq.It.IsAny<string>(), Moq.It.IsAny<string>(), Moq.It.IsAny<string>(), Moq.It.IsAny<CancellationToken>()), Moq.Times.Never());
    }
}
