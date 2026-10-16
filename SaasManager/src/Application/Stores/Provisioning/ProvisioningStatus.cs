using Platform.Provisioning;
using Microsoft.Extensions.Configuration;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;

namespace SaasManager.Application.Stores.Provisioning;

[Authorize]
public sealed record GetProvisioningStatus(Guid BusinessId) : IRequest<ProvisioningJob?>;
[Authorize]
public sealed record RetryProvisioning(Guid BusinessId) : IRequest<bool>;

public sealed class ProvisioningStatusHandler(IApplicationDbContext db, IWorkContext work, IProvisioningQueue queue, IConfiguration config, IIosReleaseQueue? ios = null)
    : IRequestHandler<GetProvisioningStatus, ProvisioningJob?>, IRequestHandler<RetryProvisioning, bool>
{
    private async Task AuthorizeAsync(Guid id, CancellationToken ct)
    {
        var owner = work.GuestRegistration?.Id ?? work.GuestId;
        if (owner == null || !await db.Businesses.AnyAsync(b => b.Id == id && !b.IsDeleted && b.CreatedByGuestId == owner.Value, ct))
            throw new UnauthorizedAccessException("Business ownership is required.");
    }
    public async Task<ProvisioningJob?> Handle(GetProvisioningStatus request, CancellationToken cancellationToken)
    {
        await AuthorizeAsync(request.BusinessId, cancellationToken);
        var tenant = request.BusinessId.ToString("N");
        var job = await queue.GetAsync(tenant, cancellationToken);
        if (job != null && job.Request.TenantId != tenant) throw new InvalidOperationException("The provisioning status belongs to another tenant.");
        if (job?.Request.MobileReleaseProfile != "AndroidIosAppDistribution") return job;
        if (ios == null) throw new InvalidOperationException("Register the shared iOS queue for combined releases.");
        var child = await ios.GetAsync(tenant, cancellationToken);
        if (child != null && (child.Plan.TenantId != tenant || child.Plan.DeploymentId != job.Request.DeploymentId))
            throw new InvalidOperationException("The iOS status belongs to another tenant or deployment.");
        if (child != null)
        {
            child.Plan.Validate();
            if (child.State == "Succeeded") (child.Receipt ?? throw new InvalidOperationException("The iOS result is incomplete.")).Validate(child.Plan);
        }
        return job with { IosRelease = child == null ? new("NotQueued", 0, null) : new(child.State, child.Attempts, child.ErrorCode) };
    }
    public async Task<bool> Handle(RetryProvisioning request, CancellationToken cancellationToken)
    {
        await AuthorizeAsync(request.BusinessId, cancellationToken);
        await TenantProvisioningEntitlement.RequireAsync(db, work, config, request.BusinessId, cancellationToken);
        return await queue.RetryAsync(request.BusinessId.ToString("N"), cancellationToken);
    }
}
