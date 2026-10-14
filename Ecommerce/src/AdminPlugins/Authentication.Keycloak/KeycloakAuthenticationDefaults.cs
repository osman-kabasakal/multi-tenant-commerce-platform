namespace Authentication.Keycloak;

public class KeycloakAuthenticationDefaults
{
    public const string ProviderSystemName = "ExternalAuth.Keycloak";
    public const string AuthenticationScheme = "KeycloakOidcScheme";
    public const string SignInButtonWidgetName = "KeycloakSignInButton";
    public const string RefreshTokenName = "refresh_token";
    public const string AccessTokenName = "access_token";
    public const string TenantMigrationQueue = "tenant_migrations";
    public const string TenantApplinkQueue = "tenant_applinks";
}