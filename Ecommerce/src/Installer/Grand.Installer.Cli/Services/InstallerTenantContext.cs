using Grand.Infrastructure.MultiTenant;

namespace Grand.Installer.Cli.Services;

/// <summary>Supplies the installed store namespace to cache invalidation and service events.</summary>
public sealed class InstallerTenantContext : IDisposable
{
    private readonly ITenantIdentityAccessor identity;
    private readonly bool assigned;

    public InstallerTenantContext(ITenantIdentityAccessor identity, string storeId)
    {
        if (string.IsNullOrWhiteSpace(storeId))
            throw new InvalidOperationException("Installer operations require the installed store identity.");
        this.identity = identity;
        assigned = string.IsNullOrEmpty(identity.TenantId);
        if (!assigned && identity.TenantId != storeId)
            throw new InvalidOperationException("Installer operations cannot replace another tenant context.");
        if (assigned) identity.TenantId = storeId;
    }

    public void Dispose()
    {
        if (assigned) identity.TenantId = null;
    }
}
