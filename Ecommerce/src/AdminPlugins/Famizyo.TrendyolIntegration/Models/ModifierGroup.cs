using System.Text.Json.Serialization;

namespace Famizyo.TrendyolIntegration.Models;

public class ModifierGroup
{
    [JsonPropertyName("id")] public int id { get; set; }

    [JsonPropertyName("max")] public int max { get; set; }

    [JsonPropertyName("min")] public int min { get; set; }

    [JsonPropertyName("modifierProducts")] public List<ModifierProduct> modifierProducts { get; set; }

    [JsonPropertyName("name")] public string name { get; set; }

    [JsonPropertyName("position")] public int position { get; set; }
}