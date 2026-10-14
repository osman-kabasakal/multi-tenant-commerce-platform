namespace Famizyo.TrendyolIntegration.Models;

public class Restaurant
{
    public int id { get; set; }
    public string name { get; set; }
    public int supplierId { get; set; }
    public string workingStatus { get; set; }
    public string address { get; set; }
    public RestaurantLocation RestaurantLocation { get; set; }
    public int averageOrderPreparationTimeInMin { get; set; }
    public string deliveryType { get; set; }
    public string phoneNumber { get; set; }
    public string email { get; set; }
    public long creationDate { get; set; }
    public long lastModifiedDate { get; set; }
    public List<WorkingHour> workingHours { get; set; }
}