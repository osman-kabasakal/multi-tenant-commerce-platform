using Keycloak.Net;

namespace Authentication.Keycloak.Services.RemoteUserManagement;

public interface IKeycloakService
{
    KeycloakClient GetKeycloakClientAsync();
    
}