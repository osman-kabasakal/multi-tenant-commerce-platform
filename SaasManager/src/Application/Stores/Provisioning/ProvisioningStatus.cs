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

public sealed class ProvisioningStatusHandler(IApplicationDbContext db, IWorkContext work, IProvisioningQueue queue, IConfiguration config)
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
        return await queue.GetAsync(request.BusinessId.ToString("N"), cancellationToken);
    }
    public async Task<bool> Handle(RetryProvisioning request, CancellationToken cancellationToken)
    {
        await AuthorizeAsync(request.BusinessId, cancellationToken);
        await TenantProvisioningEntitlement.RequireAsync(db, work, config, request.BusinessId, cancellationToken);
        return await queue.RetryAsync(request.BusinessId.ToString("N"), cancellationToken);
    }
}
