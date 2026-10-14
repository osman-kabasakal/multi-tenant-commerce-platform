using System.Text.Json;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.Operations;

public class Notification : AuditableEntity
{
    public Guid BusinessId { get; private set; }
    public NotificationType Type { get; private set; }
    public NotificationPriority Priority { get; private set; }
    public string Title { get; private set; } = null!;
    public string Content { get; private set; } = null!;
    public JsonDocument? Metadata { get; private set; }
    public bool IsRead { get; private set; }
    public DateTime? ReadAt { get; private set; }
    public NotificationStatus Status { get; private set; }
    public DateTime? ExpiresAt { get; private set; }
    public string? DeepLink { get; private set; }
    public string? ActionText { get; private set; }
    public int RetryCount { get; private set; }
    public string? ErrorMessage { get; private set; }

    // Navigation Property
    public Business Business { get; private set; } = null!;

    // Constructor for EF Core
    protected Notification() { }

    public Notification(
        Guid businessId,
        NotificationType type,
        string title,
        string content,
        NotificationPriority priority = NotificationPriority.Normal,
        JsonDocument? metadata = null,
        DateTime? expiresAt = null,
        string? deepLink = null,
        string? actionText = null)
    {
        BusinessId = businessId;
        Type = type;
        Title = title;
        Content = content;
        Priority = priority;
        Metadata = metadata;
        IsRead = false;
        Status = NotificationStatus.New;
        ExpiresAt = expiresAt;
        DeepLink = deepLink;
        ActionText = actionText;
        RetryCount = 0;
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    // Domain methods
    public void MarkAsRead()
    {
        if (!IsRead)
        {
            IsRead = true;
            ReadAt = DateTime.UtcNow;
            Status = NotificationStatus.Read;
            UpdatedAt = DateTime.UtcNow;
        }
    }

    public void UpdateStatus(NotificationStatus newStatus, string? errorMessage = null)
    {
        Status = newStatus;
        ErrorMessage = errorMessage;
        UpdatedAt = DateTime.UtcNow;
    }

    public void IncrementRetry()
    {
        RetryCount++;
        UpdatedAt = DateTime.UtcNow;
    }

    public bool CanRetry()
    {
        return Status == NotificationStatus.Failed 
               && RetryCount < 3 
               && !IsExpired();
    }

    public bool IsExpired()
    {
        return ExpiresAt.HasValue && DateTime.UtcNow > ExpiresAt.Value;
    }

    public void UpdateMetadata(JsonDocument metadata)
    {
        Metadata = metadata;
        UpdatedAt = DateTime.UtcNow;
    }
}
