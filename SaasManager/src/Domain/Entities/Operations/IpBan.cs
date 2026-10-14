using System.Text.Json;
using SaasManager.Domain.Entities.IdentityManagement;

namespace SaasManager.Domain.Entities.Operations;

public class IpBan : AuditableEntity
    {
        public string IpAddress { get; private set; } = null!;
        public DateTime ExpiresAt { get; private set; }
        public string Reason { get; private set; } = null!;
        public BanType Type { get; private set; }
        public int FailedAttempts { get; private set; }
        public DateTime? LastAttempt { get; private set; }
        public Guid? RelatedGuestId { get; private set; }
        public JsonDocument? AdditionalData { get; private set; }

        // Navigation property
        public GuestRegistration? RelatedGuest { get; private set; }

        protected IpBan() { } // EF Core için

        public IpBan(
            string ipAddress,
            DateTime expiresAt,
            string reason,
            BanType type,
            int failedAttempts = 0,
            Guid? relatedGuestId = null,
            JsonDocument? additionalData = null)
        {
            IpAddress = ipAddress;
            ExpiresAt = expiresAt;
            Reason = reason;
            Type = type;
            FailedAttempts = failedAttempts;
            RelatedGuestId = relatedGuestId;
            AdditionalData = additionalData;
            LastAttempt = DateTime.UtcNow;
            CreatedAt = DateTime.UtcNow;
            IsActive = true;
        }

        // Domain methods
        public void IncrementAttempts()
        {
            FailedAttempts++;
            LastAttempt = DateTime.UtcNow;
            Update();
        }

        public void ExtendBan(TimeSpan duration)
        {
            ExpiresAt = DateTime.UtcNow.Add(duration);
            Update();
        }

        public void UpdateReason(string newReason)
        {
            Reason = newReason;
            Update();
        }

        public void UpdateType(BanType newType)
        {
            Type = newType;
            Update();
        }

        public bool IsExpired() => DateTime.UtcNow > ExpiresAt;

        public bool ShouldExtendBan() => 
            FailedAttempts > 0 && 
            LastAttempt.HasValue && 
            DateTime.UtcNow.Subtract(LastAttempt.Value).TotalMinutes < 30;
    }
