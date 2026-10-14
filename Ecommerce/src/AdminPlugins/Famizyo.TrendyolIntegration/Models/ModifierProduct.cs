using System.Text.Json.Serialization;

namespace Famizyo.TrendyolIntegration.Models;

public class ModifierProduct
{
    [JsonPropertyName("id")] public int id { get; set; }

    [JsonPropertyName("position")] public int position { get; set; }

    [JsonPropertyName("price")] public decimal? price { get; set; }
}