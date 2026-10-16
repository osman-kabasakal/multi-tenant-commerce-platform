using System.Text.Json;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using SaasManager.Application.Common.Models.PaymentProviders;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Domain.Entities.Billing;

namespace SaasManager.Application.IdentityManagement.Commands.Registration.Steps;

/// <summary>Encrypted, durable progress. An uncertain initialization is never automatically resubmitted.</summary>
public sealed class SubscriptionPaymentJournal
{
    public enum Phase { Ready, Initializing, Initialized, Active }
    public sealed record Identity(Guid BusinessId, Guid GuestId, Guid SubscriptionId, Guid PlanId,
        string PricingReference, decimal Amount, int TrialDays, string Period, Guid ProviderId,
        string ProviderCode, string ConfigurationFingerprint);
    public sealed record Entry(int Version, Identity Identity, Phase Phase, Guid AttemptId,
        EncryptedCardData? Card, PaymentResponse? Receipt);
    private readonly ITenantSecrets secrets;
    private readonly IPaymentAttemptLease lease;
    private readonly string tenant;
    private readonly string name;
    private Entry entry;
    private SubscriptionPaymentJournal(ITenantSecrets secrets, IPaymentAttemptLease lease, Entry entry)
    {
        this.secrets = secrets; this.lease = lease; this.entry = entry;
        tenant = entry.Identity.BusinessId.ToString("N"); name = "subscription-payment-" + entry.Identity.SubscriptionId.ToString("N");
    }
    public Phase CurrentPhase => entry.Phase;
    public PaymentResponse Receipt => entry.Receipt ?? throw new InvalidOperationException("A verified payment receipt is required.");
    public EncryptedCardData Card => entry.Card ?? throw new InvalidOperationException("Protected payment metadata is required.");
    public static async Task<SubscriptionPaymentJournal> OpenAsync(ITenantSecrets secrets, IPaymentAttemptLease lease,
        Guid guestId, BusinessSubscription subscription, SubscriptionPlan plan, IPaymentProvider provider, CancellationToken ct)
    {
        var identity = new Identity(subscription.BusinessId, guestId, subscription.Id, plan.Id, plan.Code,
            subscription.Amount, plan.TrialDays, subscription.Period.ToString(), provider.Id, provider.Code, provider.ConfigurationFingerprint);
        if (identity.BusinessId == Guid.Empty || guestId == Guid.Empty || identity.SubscriptionId == Guid.Empty ||
            identity.ProviderId == Guid.Empty || identity.Amount <= 0 || plan.Id != subscription.PlanId ||
            identity.ConfigurationFingerprint?.Length != 64)
            throw new InvalidOperationException("A complete payment identity is required.");
        await lease.EnsureHeldAsync(ct);
        var raw = await secrets.GetOrCreateAsync(identity.BusinessId.ToString("N"), "subscription-payment-" + subscription.Id.ToString("N"),
            () => JsonSerializer.Serialize(new Entry(1, identity, Phase.Ready, Guid.Empty, null, null)), ct);
        if (raw.Length > 65536) throw new InvalidOperationException("Invalid payment progress record.");
        var entry = JsonSerializer.Deserialize<Entry>(raw) ?? throw new InvalidOperationException("Missing payment progress record.");
        if (entry.Version != 1 || entry.Identity != identity || !Enum.IsDefined(entry.Phase) ||
            (entry.Phase == Phase.Ready && (entry.AttemptId != Guid.Empty || entry.Card != null || entry.Receipt != null)) ||
            (entry.Phase == Phase.Initializing && entry.Receipt != null) ||
            (entry.Phase != Phase.Ready && (entry.AttemptId == Guid.Empty || string.IsNullOrWhiteSpace(entry.Card?.EncryptedNumber))) ||
            (entry.Phase >= Phase.Initialized && (entry.Receipt?.IsSuccess != true || entry.Receipt.InitializationOutcome != PaymentInitializationOutcome.Initialized ||
                string.IsNullOrWhiteSpace(entry.Receipt.PaymentId) || string.IsNullOrWhiteSpace(entry.Receipt.RawResult))))
            throw new InvalidOperationException("Payment progress requires merchant reconciliation before continuing.");
        await lease.EnsureHeldAsync(ct);
        return new(secrets, lease, entry);
    }
    public Task BeginAsync(EncryptedCardData card, CancellationToken ct)
    {
        if (entry.Phase != Phase.Ready || string.IsNullOrWhiteSpace(card.EncryptedNumber))
            throw new InvalidOperationException("Payment initialization cannot be repeated.");
        return SaveAsync(entry with { Phase = Phase.Initializing, AttemptId = Guid.NewGuid(), Card = card, Receipt = null }, ct);
    }
    public async Task<bool> RecordInitializationAsync(PaymentResponse result, CancellationToken ct)
    {
        if (entry.Phase != Phase.Initializing) throw new InvalidOperationException("No pending payment attempt.");
        if (result.IsSuccess && result.InitializationOutcome == PaymentInitializationOutcome.Initialized &&
            !string.IsNullOrWhiteSpace(result.PaymentId) && !string.IsNullOrWhiteSpace(result.RawResult))
        {
            await SaveAsync(entry with { Phase = Phase.Initialized, Receipt = result }, ct); return true;
        }
        if (!result.IsSuccess && result.InitializationOutcome is PaymentInitializationOutcome.NotSubmitted or PaymentInitializationOutcome.Rejected &&
            result.PaymentId == null && result.RawResult == null)
            await SaveAsync(entry with { Phase = Phase.Ready, AttemptId = Guid.Empty, Card = null, Receipt = null }, ct);
        // Unknown outcome: retain Initializing even across a process restart. No second initialization.
        return false;
    }
    public Task RecordActiveAsync(CancellationToken ct)
    {
        if (entry.Phase is not (Phase.Initialized or Phase.Active)) throw new InvalidOperationException("A payment receipt is required.");
        return SaveAsync(entry with { Phase = Phase.Active }, ct);
    }
    private async Task SaveAsync(Entry updated, CancellationToken ct)
    {
        await lease.EnsureHeldAsync(ct);
        await secrets.SetAsync(tenant, name, JsonSerializer.Serialize(updated), ct);
        await lease.EnsureHeldAsync(ct);
        entry = updated;
    }
}
