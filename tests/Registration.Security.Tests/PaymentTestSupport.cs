using System.Collections.Concurrent;
using Moq;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.PaymentProviders;

namespace Registration.Security.Tests;

internal sealed class PaymentTestLock : IPaymentAttemptLock
{
    private readonly ConcurrentDictionary<Guid, byte> owners = new();
    public Task<IPaymentAttemptLease?> TryAcquireAsync(Guid businessId, CancellationToken ct = default) =>
        Task.FromResult<IPaymentAttemptLease?>(owners.TryAdd(businessId, 0) ? new Lease(() => owners.TryRemove(businessId, out _)) : null);
    internal sealed class Lease(Action? release = null) : IPaymentAttemptLease
    {
        public bool Held = true;
        public Task EnsureHeldAsync(CancellationToken ct = default) { if (!Held) throw new IOException("Lost test lease"); ct.ThrowIfCancellationRequested(); return Task.CompletedTask; }
        public ValueTask DisposeAsync() { Held = false; release?.Invoke(); return ValueTask.CompletedTask; }
    }
    public static Mock<ITenantSecrets> Secrets(ConcurrentDictionary<string,string>? records = null)
    {
        records ??= new(); var values = records; var result = new Mock<ITenantSecrets>();
        result.Setup(s => s.GetOrCreateAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<Func<string>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((string tenant, string name, Func<string> generate, CancellationToken _) => values.GetOrAdd(tenant + "/" + name, _ => generate()));
        result.Setup(s => s.SetAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()))
            .Callback<string,string,string,CancellationToken>((tenant, name, value, _) => values[tenant + "/" + name] = value).Returns(Task.CompletedTask);
        return result;
    }
}
