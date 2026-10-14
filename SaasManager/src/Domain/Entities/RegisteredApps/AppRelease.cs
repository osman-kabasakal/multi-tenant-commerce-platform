using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.RegisteredApps;

public class AppRelease : AuditableEntity
{
    public AppRelease()
    {
        
    }
    
    public Guid BusinessAppId { get; set; }
    public string? Platform { get; set; }
    public Guid AppBuildId { get; set; }
    public string? Version { get; set; }
    public string? ReleaseNotes { get; set; }
    public string? ReleaseStatus { get; set; }
    public DateTime? SubmissionDate { get; set; }
    public DateTime? PublishedDate { get; set; }
    public string? RejectionReason { get; set; }
    
    // Navigation properties
    public BusinessApp BusinessApp { get; set; } = null!;
    public AppBuild AppBuild { get; set; } = null!;
}
