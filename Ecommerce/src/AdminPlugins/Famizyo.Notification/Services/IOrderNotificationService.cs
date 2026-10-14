using Famizyo.Notification.Models;

namespace Famizyo.Notification.Services;

/// <summary>
/// Interface for order notification service
/// </summary>
public interface IOrderNotificationService
{
    /// <summary>
    /// Creates a new order notification
    /// </summary>
    Task<FamizyoOrderNotification> CreateOrderNotificationAsync(string orderId, string storeId);
    
    /// <summary>
    /// Records that a notification has been viewed
    /// </summary>
    Task MarkAsViewedAsync(string notificationId, string customerId);
    
    /// <summary>
    /// Records that a notification has been interacted with (clicked)
    /// </summary>
    Task MarkAsInteractedAsync(string notificationId, string customerId);
    
    /// <summary>
    /// Gets a notification by order ID
    /// </summary>
    Task<FamizyoOrderNotification> GetNotificationByOrderIdAsync(string orderId);
    
    /// <summary>
    /// Gets all notifications that need to be resent (unviewed or non-interacted)
    /// </summary>
    Task<IList<FamizyoOrderNotification>> GetNotificationsToResendAsync(string storeId);
    
    /// <summary>
    /// Increments the send count for a notification
    /// </summary>
    Task IncrementSendCountAsync(string notificationId);
}