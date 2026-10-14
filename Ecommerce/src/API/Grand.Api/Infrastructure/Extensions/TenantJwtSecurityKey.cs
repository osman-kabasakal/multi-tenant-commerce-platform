using Grand.Infrastructure.MultiTenant;
using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace Grand.Api.Infrastructure.Extensions;

public static class TenantJwtSecurityKey
{
    public static SymmetricSecurityKey Create(string secret)
    {
        return new SymmetricSecurityKey(Encoding.ASCII.GetBytes(secret));
    }

    public static async Task<SymmetricSecurityKey> CreateBackendAsync(ITenantSecretService tenantSecretService, string tenantId = null)
    {
        var secret = await tenantSecretService.GetBackendSecretAsync(tenantId);
        return Create(secret);
    }

    public static async Task<SymmetricSecurityKey> CreateFrontendAsync(ITenantSecretService tenantSecretService, string tenantId = null)
    {
        var secret = await tenantSecretService.GetFrontendSecretAsync(tenantId);
        return Create(secret);
    }
}