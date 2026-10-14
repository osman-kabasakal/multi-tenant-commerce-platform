using Famizyo.Integration.Adisyo.Models;
using Grand.Domain.Orders;

namespace Famizyo.Integration.Adisyo.Services;

public interface IAdisyoOrderService
{
    /// <summary>
    /// Converts GrandNode order to Adisyo order format and sends it
    /// </summary>
    Task<AdisyoOrderResponse> SendOrderToAdisyoAsync(Order order);
    
    /// <summary>
    /// Cancels order in Adisyo system
    /// </summary>
    Task<bool> CancelOrderInAdisyoAsync(string grandNodeOrderId, string? cancelReason = null);
    
    /// <summary>
    /// Synchronizes order status from Adisyo to GrandNode
    /// </summary>
    Task SyncOrderStatusAsync();
    
    /// <summary>
    /// Checks if order can be sent to Adisyo (has required products, payment method, etc.)
    /// </summary>
    Task<bool> CanSendOrderToAdisyoAsync(Order order);
    
    /// <summary>
    /// Gets Adisyo order ID from GrandNode order custom values
    /// </summary>
    int? GetAdisyoOrderId(Order order);
    
    /// <summary>
    /// Stores Adisyo order ID in GrandNode order custom values
    /// </summary>
    Task StoreAdisyoOrderIdAsync(Order order, int adisyoOrderId);

    Task SyncCompletedOrdersAsync();
}