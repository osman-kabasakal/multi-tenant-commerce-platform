using System.Text.Json.Serialization;

namespace Grand.Data.Uploader.Models;


// Root myDeserializedClass = JsonSerializer.Deserialize<Root>(myJsonResponse);
    public class Ingredient
    {
        [JsonPropertyName("id")]
        public int id { get; set; }

        [JsonPropertyName("name")]
        public string name { get; set; }

        [JsonPropertyName("price")]
        public decimal? price { get; set; }

        [JsonPropertyName("status")]
        public string status { get; set; }
    }

    public class ModifierGroup
    {
        [JsonPropertyName("id")]
        public int id { get; set; }

        [JsonPropertyName("max")]
        public int max { get; set; }

        [JsonPropertyName("min")]
        public int min { get; set; }

        [JsonPropertyName("modifierProducts")]
        public List<ModifierProduct> modifierProducts { get; set; }

        [JsonPropertyName("name")]
        public string name { get; set; }

        [JsonPropertyName("position")]
        public int position { get; set; }
    }

    public class ModifierProduct
    {
        [JsonPropertyName("id")]
        public int id { get; set; }

        [JsonPropertyName("position")]
        public int position { get; set; }

        [JsonPropertyName("price")]
        public decimal? price { get; set; }
    }

    public class TrendyolProduct
    {
        [JsonPropertyName("id")]
        public int id { get; set; }

        [JsonPropertyName("description")]
        public string description { get; set; }

        [JsonPropertyName("ingredients")]
        public List<int> ingredients { get; set; }

        [JsonPropertyName("extraIngredients")]
        public List<int> extraIngredients { get; set; }

        [JsonPropertyName("modifierGroups")]
        public List<ModifierGroup> modifierGroups { get; set; }

        [JsonPropertyName("name")]
        public string name { get; set; }

        [JsonPropertyName("originalPrice")]
        public decimal? originalPrice { get; set; }

        [JsonPropertyName("sellingPrice")]
        public decimal? sellingPrice { get; set; }

        [JsonPropertyName("status")]
        public string status { get; set; }

        [JsonPropertyName("position")]
        public int position { get; set; }
    }

    public class TrendyolMenuModel
    {
        [JsonPropertyName("ingredients")]
        public List<Ingredient> ingredients { get; set; }

        [JsonPropertyName("modifierGroups")]
        public List<ModifierGroup> modifierGroups { get; set; }

        [JsonPropertyName("products")]
        public List<TrendyolProduct> products { get; set; }

        [JsonPropertyName("sections")]
        public List<Section> sections { get; set; }
    }

    public class Section
    {
        [JsonPropertyName("id")]
        public int id { get; set; }

        [JsonPropertyName("name")]
        public string name { get; set; }

        [JsonPropertyName("position")]
        public int position { get; set; }

        [JsonPropertyName("products")]
        public List<TrendyolProduct> products { get; set; }

        [JsonPropertyName("status")]
        public string status { get; set; }
    }

