namespace Famizyo.TrendyolIntegration.Models;

public class RestaurantList
{
    public List<Restaurant> restaurants { get; set; } = new List<Restaurant>();
    public int totalPages { get; set; }
    public int totalElements { get; set; }
}