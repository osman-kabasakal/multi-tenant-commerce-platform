using Keycloak.Net;
using System;

namespace Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;

public interface IKeycloakClientService
{
    KeycloakClient GetKeycloakClientAsync();
}
