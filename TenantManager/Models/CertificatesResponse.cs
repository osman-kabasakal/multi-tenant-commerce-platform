using System.Text.Json.Serialization;

namespace TenantManager.Models;

public class CertificatesResponse
{
    [JsonPropertyName("certificates")]
    public List<Certificate> Certificates { get; set; }
}