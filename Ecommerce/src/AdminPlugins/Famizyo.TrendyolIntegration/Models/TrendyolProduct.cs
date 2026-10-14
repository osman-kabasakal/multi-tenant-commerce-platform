using System.Text.Json.Serialization;

namespace Famizyo.TrendyolIntegration.Models;

public class TrendyolProduct
{
    [JsonPropertyName("id")] public int id { get; set; }

    [JsonPropertyName("description")] public string description { get; set; }

    [JsonPropertyName("ingredients")] public List<int> ingredients { get; set; }

    [JsonPropertyName("extraIngredients")] public List<int> extraIngredients { get; set; }

    [JsonPropertyName("modifierGroups")] public List<ModifierGroup> modifierGroups { get; set; }

    [JsonPropertyName("name")] public string name { get; set; }

    [JsonPropertyName("originalPrice")] public decimal? originalPrice { get; set; }

    [JsonPropertyName("sellingPrice")] public decimal? sellingPrice { get; set; }

    [JsonPropertyName("status")] public string status { get; set; }

    [JsonPropertyName("position")] public int position { get; set; }
}