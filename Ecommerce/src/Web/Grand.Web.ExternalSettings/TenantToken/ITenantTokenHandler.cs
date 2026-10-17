namespace Grand.Web.ExternalSettings.TenantToken;

public interface ITenantTokenHandler
{
    Task<string> CreateTemporaryToken(string tenantId, bool isOtt = true, int expirationMinutes = 15);
    Task<string> ValidateAndGetTenant(string token);
}
