using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.RegisteredApps;

public class AppStoreMetadata : AuditableEntity
{
    public AppStoreMetadata()
    {
        
    }
    
    public Guid BusinessAppId { get; set; }
    public StorePlatform Platform { get; set; }
    public string? AppTitle { get; set; }
    public string? ShortDescription { get; set; }
    public string? FullDescription { get; set; }
    public string? Keywords { get; set; }
    public string? PrimaryCategory { get; set; }
    public string? SecondaryCategory { get; set; }
    public string? MinimumOsVersion { get; set; }
    public string? SupportUrl { get; set; }
    public string? PrivacyPolicyUrl { get; set; }
    public string? AppleAppId { get; set; }
    public string? GooglePackageName { get; set; }
    
    // Navigation property
    public BusinessApp BusinessApp { get; set; } = null!;
}
