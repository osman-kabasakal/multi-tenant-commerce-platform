using Famizyo.Simpra.Models;
using Grand.Domain.Orders;

namespace Famizyo.Simpra.Services;

public interface ISimpraOrderService
{
    /// <summary>
    /// Converts GrandNode order to Simpra order format and sends it (only for Preparing status orders)
    /// </summary>
    Task<SimpraCrudCheckResponse> SendOrderToSimpraAsync(Order order);
    
    /// <summary>
    /// Cancels order in Simpra system
    /// </summary>
    Task<bool> CancelOrderInSimpraAsync(string grandNodeOrderId, string? cancelReason = null);
    
    /// <summary>
    /// Synchronizes order status from Simpra to GrandNode
    /// </summary>
    Task SyncOrderStatusAsync();
    
    /// <summary>
    /// Checks if order can be sent to Simpra (has required products, payment method, etc.)
    /// </summary>
    Task<bool> CanSendOrderToSimpraAsync(Order order);
    
    /// <summary>
    /// Gets Simpra check ID from GrandNode order custom values
    /// </summary>
    string? GetSimpraCheckId(Order order);
    
    /// <summary>
    /// Stores Simpra check ID in GrandNode order custom values
    /// </summary>
    Task StoreSimpraCheckIdAsync(Order order, string simpraCheckId);
    
    /// <summary>
    /// Processes order status updates from Redis messages
    /// </summary>
    Task ProcessOrderStatusUpdateAsync(SimpraOrderStatusUpdate statusUpdate);
    
    /// <summary>
    /// Publishes order status update to Redis channel
    /// </summary>
    Task PublishOrderStatusUpdateAsync(string storeId, string orderId, string newStatus, string deliveryStatus);
}