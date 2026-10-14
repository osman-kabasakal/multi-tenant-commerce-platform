using Shipping.FixedRateShipping.Models;

namespace Shipping.FixedRateShipping.Services;

public interface IDeliveryAreaService
{
    /// <summary>
    /// Checks if the given coordinates are within any of the delivery areas for the specified shipping method
    /// </summary>
    /// <param name="shippingMethodId">The ID of the shipping method</param>
    /// <param name="latitude">The latitude coordinate</param>
    /// <param name="longitude">The longitude coordinate</param>
    /// <returns>The delivery area that contains the coordinates, or null if none found</returns>
    Task<DeliveryArea> GetMatchingDeliveryArea(string shippingMethodId, double latitude, double longitude);
    
    /// <summary>
    /// Gets all delivery areas for a specific shipping method
    /// </summary>
    /// <param name="shippingMethodId">The ID of the shipping method</param>
    /// <returns>List of delivery areas</returns>
    Task<IList<DeliveryArea>> GetDeliveryAreas(string shippingMethodId);
    
    /// <summary>
    /// Saves a delivery area for a shipping method
    /// </summary>
    /// <param name="shippingMethodId">The ID of the shipping method</param>
    /// <param name="deliveryArea">The delivery area to save</param>
    Task SaveDeliveryArea(string shippingMethodId, DeliveryArea deliveryArea);
    
    /// <summary>
    /// Deletes a delivery area for a shipping method
    /// </summary>
    /// <param name="shippingMethodId">The ID of the shipping method</param>
    /// <param name="deliveryAreaId">The ID of the delivery area to delete</param>
    Task DeleteDeliveryArea(string deliveryAreaId);
}