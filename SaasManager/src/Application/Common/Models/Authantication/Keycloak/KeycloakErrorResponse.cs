using System.Text.Json.Serialization;

namespace SaasManager.Application.Common.Models.Authantication.Keycloak;

public class KeycloakErrorResponse
{
    [JsonPropertyName("error")]
    public string Error { get; set; } = string.Empty;

    [JsonPropertyName("error_description")]
    public string ErrorDescription { get; set; } = string.Empty;
}