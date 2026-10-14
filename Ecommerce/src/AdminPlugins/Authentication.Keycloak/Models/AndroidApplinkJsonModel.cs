using System.Text.Json.Serialization;

namespace Authentication.Keycloak.Models;

public class AndroidApplinkJsonModel
{
    [JsonPropertyName("relation")]
    public List<string> Relation { get; set; }

    [JsonPropertyName("target")]
    public Target Target { get; set; }
}

public class Target
{
    [JsonPropertyName("namespace")]
    public string Namespace { get; set; }

    [JsonPropertyName("package_name")]
    public string PackageName { get; set; }

    [JsonPropertyName("sha256_cert_fingerprints")]
    public List<string> Sha256CertFingerprints { get; set; }
}
