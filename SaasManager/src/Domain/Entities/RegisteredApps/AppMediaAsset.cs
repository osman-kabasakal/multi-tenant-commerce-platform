using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.RegisteredApps;

public class AppMediaAsset : AuditableEntity
{
    public AppMediaAsset()
    {
        
    }
    public Guid BusinessAppId { get; set; }
    public AppMediaAssetType AssetType { get; set; }
    public string Platform { get; set; } = null!;
    public string FileName { get; set; }  = null!;
    public string FilePath { get; set; }  = null!;
    public int FileSize { get; set; }
    public int Width { get; set; }
    public int Height { get; set; }
    public bool IsDefault { get; set; }
    
    // Navigation property
    public BusinessApp BusinessApp { get; set; } = null!;
}
