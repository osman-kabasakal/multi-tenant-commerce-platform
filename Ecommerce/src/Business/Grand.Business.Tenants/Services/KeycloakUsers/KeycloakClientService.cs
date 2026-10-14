using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Domain.Tenants;
using Keycloak.Net;
using System;
using System.Net.Http;

namespace Grand.Business.Tenants.Services.KeycloakUsers;

public class KeycloakClientService : IKeycloakClientService
{
    private readonly KeycloakSettings _keycloakSettings;
    public KeycloakClientService(KeycloakSettings keycloakSettings)
    {
        _keycloakSettings = keycloakSettings;
    }

    public KeycloakClient GetKeycloakClientAsync()
    {
        return new KeycloakClient(_keycloakSettings.Authority, _keycloakSettings.ClientSecret, new KeycloakOptions(adminClientId: _keycloakSettings.ClientId, authenticationRealm: _keycloakSettings.Realm));
    }
}
