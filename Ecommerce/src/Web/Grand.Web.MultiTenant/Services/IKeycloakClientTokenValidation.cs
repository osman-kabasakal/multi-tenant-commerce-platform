using System.Security.Claims;

namespace Grand.Web.MultiTenant.Services;

public interface IKeycloakClientTokenValidation
{
    Task<ClaimsPrincipal?> ValidateJwt(string jwt,string audience, bool validateLifetime = true);
}