using System.ComponentModel.DataAnnotations;

namespace SaasManager.Domain.Common;

public abstract class AuditableEntity : BaseEntity, IAuditableEntity, ISoftDelete, IActivatable, IOptimisticConcurrency
{
    public DateTime CreatedAt { get; set; }
    public Guid CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public Guid? DeletedBy { get; set; } = null!;
    public bool IsActive { get; set; } = true;
    [Timestamp]
    public uint RowVersion { get; set; }
    
    public void SoftDelete(Guid? deletedBy = null)
    {
        IsActive = false;
        IsDeleted = true;
        DeletedAt = DateTime.UtcNow;
        DeletedBy = deletedBy;
    }

    public void Update()
    {
        UpdatedAt = DateTime.UtcNow;
    }
}
