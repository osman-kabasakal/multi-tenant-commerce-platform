using SaasManager.Application.Common.Models.Authantication.Keycloak;

namespace SaasManager.Application.Common.Interfaces.Keycloak;

public interface IKeycloakService
{
    Task<TokenResponse> RefreshTokenAsync(string refreshToken);
    Task<bool> ValidateTokenAsync(string token);
    Task RevokeTokenAsync(string token);
}
