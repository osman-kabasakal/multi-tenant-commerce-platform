namespace Shipping.FixedRateShipping.Models;

public class DeliveryArea
{
    public string Id { get; set; } = Guid.NewGuid().ToString();
    
    public string Name { get; set; }
    
    public string GeoJsonData { get; set; }
    
    public double ShippingRate { get; set; }
    
    public double MinimumOrderAmount { get; set; }
    
    public bool UseFreeShipping { get; set; }
    
    public double FreeShippingOrderAmount { get; set; }
}