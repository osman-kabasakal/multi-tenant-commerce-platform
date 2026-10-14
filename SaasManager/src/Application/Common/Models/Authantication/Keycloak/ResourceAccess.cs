using System.Text.Json.Serialization;

namespace SaasManager.Application.Common.Models.Authantication.Keycloak;

public class ResourceAccess
{
    [JsonPropertyName("roles")]
    public string[] Roles { get; set; } = Array.Empty<string>();
}