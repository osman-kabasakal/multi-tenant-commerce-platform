using Famizyo.Notification.Models;
using Grand.Data;
using MongoDB.Driver;
using MongoDB.Driver.Linq;

namespace Famizyo.Notification.Services;

/// <summary>
/// Service for managing order notifications
/// </summary>
public class OrderNotificationService : IOrderNotificationService
{
    private readonly IRepository<FamizyoOrderNotification> _orderNotificationRepository;
    
    public OrderNotificationService(IRepository<FamizyoOrderNotification> orderNotificationRepository)
    {
        _orderNotificationRepository = orderNotificationRepository;
    }
    
    /// <summary>
    /// Creates a new order notification
    /// </summary>
    public async Task<FamizyoOrderNotification> CreateOrderNotificationAsync(string orderId, string storeId)
    {
        var notification = new FamizyoOrderNotification
        {
            OrderId = orderId,
            StoreId = storeId,
            CreatedOnUtc = DateTime.UtcNow,
            SendCount = 1,
            LastSentOnUtc = DateTime.UtcNow
        };
        
        await _orderNotificationRepository.InsertAsync(notification);
        return notification;
    }
    
    /// <summary>
    /// Records that a notification has been viewed
    /// </summary>
    public async Task MarkAsViewedAsync(string notificationId, string customerId)
    {
        var notification = await _orderNotificationRepository.GetByIdAsync(notificationId);
        if (notification == null)
            return;
            
        notification.ViewedByCustomerId = customerId;
        notification.ViewedOnUtc = DateTime.UtcNow;
        
        await _orderNotificationRepository.UpdateAsync(notification);
    }
    
    /// <summary>
    /// Records that a notification has been interacted with (clicked)
    /// </summary>
    public async Task MarkAsInteractedAsync(string notificationId, string customerId)
    {
        var notification = await _orderNotificationRepository.GetByIdAsync(notificationId);
        if (notification == null)
            return;
            
        notification.InteractedByCustomerId = customerId;
        notification.InteractedOnUtc = DateTime.UtcNow;
        
        await _orderNotificationRepository.UpdateAsync(notification);
    }
    
    /// <summary>
    /// Gets a notification by order ID
    /// </summary>
    public async Task<FamizyoOrderNotification> GetNotificationByOrderIdAsync(string orderId)
    {
        return await _orderNotificationRepository.Table
            .FirstOrDefaultAsync(n => n.OrderId == orderId);
    }
    
    /// <summary>
    /// Gets all notifications that need to be resent (unviewed or non-interacted)
    /// </summary>
    public async Task<IList<FamizyoOrderNotification>> GetNotificationsToResendAsync(string storeId)
    {
        var notifications = await _orderNotificationRepository.Table
            .Where(n => n.StoreId == storeId && 
                       (n.ViewedOnUtc == null || n.InteractedOnUtc == null))
            .OrderByDescending(n => n.CreatedOnUtc)
            .ToListAsync();
            
        return notifications;
    }
    
    /// <summary>
    /// Increments the send count for a notification
    /// </summary>
    public async Task IncrementSendCountAsync(string notificationId)
    {
        var notification = await _orderNotificationRepository.GetByIdAsync(notificationId);
        if (notification == null)
            return;
            
        notification.SendCount++;
        notification.LastSentOnUtc = DateTime.UtcNow;
        
        await _orderNotificationRepository.UpdateAsync(notification);
    }
}