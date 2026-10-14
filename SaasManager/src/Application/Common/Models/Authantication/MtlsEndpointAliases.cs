using System.Text.Json.Serialization;

namespace SaasManager.Application.Common.Models.Authantication;

public record MtlsEndpointAliases(
    [property: JsonPropertyName("token_endpoint")] string TokenEndpoint,
    [property: JsonPropertyName("revocation_endpoint")] string RevocationEndpoint,
    [property: JsonPropertyName("introspection_endpoint")] string IntrospectionEndpoint,
    [property: JsonPropertyName("device_authorization_endpoint")] string DeviceAuthorizationEndpoint,
    [property: JsonPropertyName("registration_endpoint")] string RegistrationEndpoint,
    [property: JsonPropertyName("userinfo_endpoint")] string UserinfoEndpoint,
    [property: JsonPropertyName("pushed_authorization_request_endpoint")] string PushedAuthorizationRequestEndpoint,
    [property: JsonPropertyName("backchannel_authentication_endpoint")] string BackchannelAuthenticationEndpoint
);
