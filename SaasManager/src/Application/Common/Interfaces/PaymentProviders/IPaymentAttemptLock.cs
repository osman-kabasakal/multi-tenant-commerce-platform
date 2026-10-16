namespace SaasManager.Application.Common.Interfaces.PaymentProviders;

public interface IPaymentAttemptLock
{
    Task<IPaymentAttemptLease?> TryAcquireAsync(Guid businessId, CancellationToken ct = default);
}

public interface IPaymentAttemptLease : IAsyncDisposable
{
    Task EnsureHeldAsync(CancellationToken ct = default);
}
