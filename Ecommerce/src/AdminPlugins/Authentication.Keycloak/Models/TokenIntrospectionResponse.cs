using System.Text.Json.Serialization;

namespace Authentication.Keycloak.Models;

public class TokenIntrospectionResponse
{
    [JsonPropertyName("active")]
    public bool Active { get; set; }

    [JsonPropertyName("exp")]
    public long ExpirationTime { get; set; }

    [JsonPropertyName("iat")]
    public long IssuedAt { get; set; }

    [JsonPropertyName("jti")]
    public string TokenId { get; set; } = string.Empty;

    [JsonPropertyName("iss")]
    public string Issuer { get; set; } = string.Empty;

    [JsonPropertyName("aud")]
    public string[] Audience { get; set; } = Array.Empty<string>();

    [JsonPropertyName("sub")]
    public string Subject { get; set; } = string.Empty;

    [JsonPropertyName("typ")]
    public string TokenType { get; set; } = string.Empty;

    [JsonPropertyName("azp")]
    public string AuthorizedParty { get; set; } = string.Empty;

    [JsonPropertyName("auth_time")]
    public long AuthTime { get; set; }

    [JsonPropertyName("session_state")]
    public string SessionState { get; set; } = string.Empty;

    [JsonPropertyName("realm_access")]
    public RealmAccess? RealmAccess { get; set; }

    [JsonPropertyName("resource_access")]
    public Dictionary<string, ResourceAccess>? ResourceAccess { get; set; }

    [JsonPropertyName("scope")]
    public string Scope { get; set; } = string.Empty;
}

public class RealmAccess
{
    [JsonPropertyName("roles")]
    public string[] Roles { get; set; } = Array.Empty<string>();
}

public class ResourceAccess
{
    [JsonPropertyName("roles")]
    public string[] Roles { get; set; } = Array.Empty<string>();
}
