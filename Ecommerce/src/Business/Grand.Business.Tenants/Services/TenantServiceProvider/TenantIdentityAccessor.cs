using Grand.Infrastructure.MultiTenant;

namespace Grand.Business.Tenants.Services.TenantServiceProvider;

public class TenantIdentityAccessor: ITenantIdentityAccessor
{
    private static readonly AsyncLocal<TenantIdentityHolder> _tenantIdentityCurrent = new AsyncLocal<TenantIdentityHolder>();

    public string TenantId {
        get => _tenantIdentityCurrent.Value?.TenantId;
        set {
            var holder = _tenantIdentityCurrent.Value;
            if (holder != null)
            {
                // Clear current HttpContext trapped in the AsyncLocals, as its done.
                holder.TenantId = null;
            }

            if (value != null)
            {
                // Use an object indirection to hold the HttpContext in the AsyncLocal,
                // so it can be cleared in all ExecutionContexts when its cleared.
                _tenantIdentityCurrent.Value = new TenantIdentityHolder { TenantId = value };
            }
        }
    }

    private sealed class TenantIdentityHolder
    {
        public string TenantId;
    }
}