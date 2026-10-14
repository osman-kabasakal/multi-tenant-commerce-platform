using System.Text.Json.Serialization;

namespace TenantManager.Models;

public class Certificate
{
    [JsonPropertyName("name")]
    public string Name { get; set; }

    [JsonPropertyName("shaHash")]
    public string ShaHash { get; set; }

    [JsonPropertyName("certType")]
    public string CertType { get; set; }
}
