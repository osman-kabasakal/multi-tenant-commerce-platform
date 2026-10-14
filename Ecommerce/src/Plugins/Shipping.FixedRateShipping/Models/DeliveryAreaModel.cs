using Grand.Infrastructure.ModelBinding;

namespace Shipping.FixedRateShipping.Models;

public class DeliveryAreaModel
{
    public string Id { get; set; }
    
    [GrandResourceDisplayName("Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.Name")]
    public string Name { get; set; }
    
    [GrandResourceDisplayName("Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.GeoJsonData")]
    public string GeoJsonData { get; set; }
    
    [GrandResourceDisplayName("Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.ShippingRate")]
    public double ShippingRate { get; set; }
    
    [GrandResourceDisplayName("Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.MinimumOrderAmount")]
    public double MinimumOrderAmount { get; set; }
    
    [GrandResourceDisplayName("Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.UseFreeShipping")]
    public bool UseFreeShipping { get; set; }
    
    [GrandResourceDisplayName("Plugins.Shipping.FixedRateShipping.DeliveryArea.Fields.FreeShippingOrderAmount")]
    public double FreeShippingOrderAmount { get; set; }
    
    public string ShippingMethodId { get; set; }
    
    [GrandResourceDisplayName("Plugins.Shipping.FixedRateShipping.Fields.ShippingMethodName")]
    public string ShippingMethodName { get; set; }
}