using System.Text.Json.Serialization;

namespace Famizyo.TrendyolIntegration.Models;

public class TrendyolMenuModel
{
    [JsonPropertyName("ingredients")] public List<Ingredient> ingredients { get; set; }

    [JsonPropertyName("modifierGroups")] public List<ModifierGroup> modifierGroups { get; set; }

    [JsonPropertyName("products")] public List<TrendyolProduct> products { get; set; }

    [JsonPropertyName("sections")] public List<TrendyolMenuSection> sections { get; set; }
}