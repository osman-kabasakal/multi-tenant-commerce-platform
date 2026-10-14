using System.Text.Json;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.RegisteredApps;

public class AppBuild : AuditableEntity
{
    public AppBuild()
    {
        
    }
    
    public Guid BusinessAppId { get; set; }
    public BuildPlatform Platform { get; set; }
    public string? Version { get; set; }
    public int BuildNumber { get; set; }
    public long FileSize { get; set; }
    public string? FilePath { get; set; }
    public string? FileHash { get; set; }
    public string? BuildStatus { get; set; }
    public DateTime? BuildDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public JsonDocument? Configuration { get; set; }
    
    // Navigation properties
    public BusinessApp BusinessApp { get; set; } = null!;
    public ICollection<AppRelease> Releases { get; set; } = new List<AppRelease>();
}
