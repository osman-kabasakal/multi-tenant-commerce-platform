using System.Text.Json.Serialization;

namespace Famizyo.TrendyolIntegration.Models;

public class Ingredient
{
    [JsonPropertyName("id")] public int id { get; set; }

    [JsonPropertyName("name")] public string name { get; set; }

    [JsonPropertyName("price")] public decimal? price { get; set; }

    [JsonPropertyName("status")] public string status { get; set; }
}