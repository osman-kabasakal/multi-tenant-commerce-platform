using System.Security.Claims;
using SaasManager.Application.Common.Models.Authantication;

namespace SaasManager.Application.Common.Interfaces.Keycloak;

public interface IKeyCloakJwtValidationService
{
    Task<ClaimsPrincipal?> ValidateJwt(string jwt, bool validateLifetime = true);
    Task<OpenIdDiscoveryModel?> GetDiscoveryDocumentAsync();
}
