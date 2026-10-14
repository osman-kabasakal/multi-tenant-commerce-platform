namespace Authentication.Keycloak.Services.RemoteUserManagement;

public class KeycloakSettings {
    public string Authority { get; set; }
    public string Realm { get; set; }
    public string ClientId { get; set; }
    public string ClientSecret { get; set; }
}