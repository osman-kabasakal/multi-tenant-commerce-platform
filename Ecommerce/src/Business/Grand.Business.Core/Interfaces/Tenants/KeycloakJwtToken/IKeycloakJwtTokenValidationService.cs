using Grand.Domain.Tenants;
using System;
using System.Security.Claims;

namespace Grand.Business.Core.Interfaces.Tenants.KeycloakJwtToken;

public interface IKeycloakJwtTokenValidationService
{
    Task<ClaimsPrincipal> ValidateJwt(string jwt, bool validateLifetime = true);
    Task<OpenIdDiscoveryModel> GetDiscoveryDocumentAsync();
    Task<bool> RemoteValidationTokenAsync(string token);
}
