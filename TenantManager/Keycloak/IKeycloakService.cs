using Keycloak.Net;

namespace TenantManager.Keycloak;

public interface IKeycloakService
{
    KeycloakClient GetKeycloakClientAsync();
}