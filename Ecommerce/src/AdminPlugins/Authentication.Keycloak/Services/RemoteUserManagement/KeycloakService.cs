using Keycloak.Net;
using System.Net.Http;

namespace Authentication.Keycloak.Services.RemoteUserManagement;

public class KeycloakService : IKeycloakService
{
    private readonly KeycloakSettings _keycloakSettings;
    private readonly HttpClient _httpClient;
    private string _accessToken;
    private DateTime _tokenExpiration;
    public KeycloakService(KeycloakSettings keycloakSettings, IHttpClientFactory httpClientFactory)
    {
        _keycloakSettings = keycloakSettings;
        _httpClient = httpClientFactory.CreateClient();
    }
    
    public KeycloakClient GetKeycloakClientAsync()
    {
        return new KeycloakClient(_keycloakSettings.Authority, _keycloakSettings.ClientSecret, new KeycloakOptions(adminClientId: _keycloakSettings.ClientId, authenticationRealm: _keycloakSettings.Realm));
    }
}