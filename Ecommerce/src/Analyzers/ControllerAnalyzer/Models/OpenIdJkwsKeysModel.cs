using System.Text.Json.Serialization;

namespace ControllerAnalyzer.Models;

public record Key(
    [property: JsonPropertyName("kid")] string Kid,
    [property: JsonPropertyName("kty")] string Kty,
    [property: JsonPropertyName("alg")] string Alg,
    [property: JsonPropertyName("use")] string Use,
    [property: JsonPropertyName("x")] string X,
    [property: JsonPropertyName("y")] string Y,
    [property: JsonPropertyName("crv")] string Crv,
    [property: JsonPropertyName("n")] string N,
    [property: JsonPropertyName("e")] string E,
    [property: JsonPropertyName("x5c")] List<string> X5c,
    [property: JsonPropertyName("x5t")] string X5t,
    [property: JsonPropertyName("x5t#S256")]
    string X5tS256
);

public record OpenIdJkwsKeysModel(
    [property: JsonPropertyName("keys")] IReadOnlyList<Key> Keys
);
