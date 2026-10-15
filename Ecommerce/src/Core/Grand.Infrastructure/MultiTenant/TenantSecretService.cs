using Grand.Infrastructure.Extensions;
using Microsoft.AspNetCore.Http;
using Platform.Security;

namespace Grand.Infrastructure.MultiTenant;

public interface ITenantSecretService
{
    Task<string> GetBackendSecretAsync(string tenantId = null);
    Task<string> GetFrontendSecretAsync(string tenantId = null);
}

/// <summary>No default-tenant fallback and no stale process-local secret cache.</summary>
public sealed class TenantSecretService(IHttpContextAccessor context, ITenantSecrets secrets) : ITenantSecretService
{
    private string Tenant(string tenantId) => tenantId ?? context.HttpContext?.GetTenantId()
        ?? throw new InvalidOperationException("An authenticated tenant context is required.");
    public Task<string> GetBackendSecretAsync(string tenantId = null) => secrets.GetAsync(Tenant(tenantId), TenantSecretNames.BackendApi);
    public Task<string> GetFrontendSecretAsync(string tenantId = null) => secrets.GetAsync(Tenant(tenantId), TenantSecretNames.FrontendApi);
}
