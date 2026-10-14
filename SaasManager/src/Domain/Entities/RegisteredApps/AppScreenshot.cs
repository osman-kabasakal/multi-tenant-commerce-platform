using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.RegisteredApps;

public class AppScreenshot : AuditableEntity
{
    public AppScreenshot()
    {
        
    }
    
    public Guid BusinessAppId { get; set; }
    public string? ScreenType { get; set; }
    public string? FileName { get; set; }
    public string? FilePath { get; set; }
    public int FileSize { get; set; }
    public int Width { get; set; }
    public int Height { get; set; }
    public int DisplayOrder { get; set; }
    
    // Navigation property
    public BusinessApp BusinessApp { get; set; } = null!;
}
