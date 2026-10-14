using Grand.Domain;

namespace Famizyo.Notification.Models;

/// <summary>
/// Represents a notification for an order that needs to be tracked
/// </summary>
public class FamizyoOrderNotification : BaseEntity
{
    /// <summary>
    /// Gets or sets the order ID
    /// </summary>
    public string OrderId { get; set; }
    
    /// <summary>
    /// Gets or sets the store ID
    /// </summary>
    public string StoreId { get; set; }
    
    /// <summary>
    /// Gets or sets the customer ID who viewed the notification
    /// </summary>
    public string? ViewedByCustomerId { get; set; }
    
    /// <summary>
    /// Gets or sets the time when notification was viewed
    /// </summary>
    public DateTime? ViewedOnUtc { get; set; }
    
    /// <summary>
    /// Gets or sets the customer ID who interacted with the notification
    /// </summary>
    public string? InteractedByCustomerId { get; set; }
    
    /// <summary>
    /// Gets or sets the time when notification was interacted with
    /// </summary>
    public DateTime? InteractedOnUtc { get; set; }
    
    /// <summary>
    /// Gets or sets the number of times this notification has been sent
    /// </summary>
    public int SendCount { get; set; }
    
    /// <summary>
    /// Gets or sets the last time this notification was sent
    /// </summary>
    public DateTime? LastSentOnUtc { get; set; }
    
    /// <summary>
    /// Indicates if this notification needs to be resent
    /// </summary>
    public bool NeedsResend => !ViewedOnUtc.HasValue || !InteractedOnUtc.HasValue;
}