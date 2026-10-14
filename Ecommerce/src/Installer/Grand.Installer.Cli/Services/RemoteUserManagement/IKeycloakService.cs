using Keycloak.Net;

namespace Grand.Installer.Cli.Services.RemoteUserManagement;

public interface IKeycloakService
{
    KeycloakClient GetKeycloakClientAsync();
    
}