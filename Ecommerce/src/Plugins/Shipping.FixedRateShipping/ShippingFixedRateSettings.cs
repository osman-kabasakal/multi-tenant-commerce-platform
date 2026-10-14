using Grand.Domain.Configuration;
using Shipping.FixedRateShipping.Models;
using System.Collections.Generic;

namespace Shipping.FixedRateShipping;

public class ShippingFixedRateSettings : ISettings
{
    public ShippingFixedRateSettings()
    {
        DeliveryAreas = new Dictionary<string, List<DeliveryArea>>();
    }
    
    public int DisplayOrder { get; set; }
    
    /// <summary>
    /// Dictionary of shipping method IDs to their delivery areas
    /// </summary>
    public Dictionary<string, List<DeliveryArea>> DeliveryAreas { get; set; }
}