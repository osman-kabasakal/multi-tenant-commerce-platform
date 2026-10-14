using System.Text.Json.Serialization;

namespace Famizyo.TrendyolIntegration.Models;

public class TrendyolMenuSection
{
    [JsonPropertyName("id")] public int id { get; set; }

    [JsonPropertyName("name")] public string name { get; set; }

    [JsonPropertyName("position")] public int position { get; set; }

    [JsonPropertyName("products")] public List<TrendyolProduct> products { get; set; }

    [JsonPropertyName("status")] public string status { get; set; }
}