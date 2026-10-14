using Authentication.Keycloak;
using Grand.Infrastructure.Plugins;

[assembly: PluginInfo(
    FriendlyName = "Keycloak authentication",
    Group = "Authentication methods",
    SystemName = KeycloakAuthenticationDefaults.ProviderSystemName,
    Author = "Local business Team",
    Version = "2.1.3"
)]