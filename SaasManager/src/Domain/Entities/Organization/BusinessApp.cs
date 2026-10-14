using System.Text.Json;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Domain.Entities.Organization;

public class BusinessApp : AuditableEntity
{
    public Guid BusinessId { get; private set; }
    public AppType Type { get; private set; }
    public string AppName { get; private set; } = null!;
    public string PackageName { get; private set; } = null!;
    public string Version { get; private set; } = null!;
    public int BuildNumber { get; private set; }
    public BuildStatus BuildStatus { get; private set; }
    public BuildPriority BuildPriority { get; private set; }
    public string StoreUrl { get; private set; } = null!;
    public JsonDocument BuildConfiguration { get; private set; } = null!;
    public JsonDocument BuildLogs { get; private set; } = null!;
    public DateTime? LastBuiltAt { get; private set; }
    public DateTime? LastPublishedAt { get; private set; }
    public DateTime? NextScheduledBuildAt { get; private set; }
    public string? ErrorMessage { get; private set; }

    // Navigation Property
    public Business Business { get; private set; } = null!;
    
    public ICollection<AppRelease> Releases { get; set; } = new List<AppRelease>();
    
    public ICollection<AppBuild>  Builds { get; set; } = new List<AppBuild>();
    
    public ICollection<AppMediaAsset>  MediaAssets { get; set; } = new List<AppMediaAsset>();
    
    public ICollection<AppScreenshot>  Screenshots { get; set; } = new List<AppScreenshot>();
    
    public ICollection<AppStoreMetadata>  Stores { get; set; } = new List<AppStoreMetadata>();

    // Constructor for EF Core
    protected BusinessApp() { }

    public BusinessApp(
        Guid businessId,
        AppType type,
        string appName,
        string packageName,
        BuildPriority priority = BuildPriority.Normal)
    {
        BusinessId = businessId;
        Type = type;
        AppName = appName;
        PackageName = packageName;
        Version = "1.0.0";
        BuildNumber = 1;
        BuildStatus = BuildStatus.NotBuilt;
        BuildPriority = priority;
        CreatedAt = DateTime.UtcNow;
        StoreUrl = "";
        IsActive = true;
        BuildConfiguration = JsonDocument.Parse(JsonSerializer.Serialize(new AppBuildsConfig()));
        BuildLogs = JsonDocument.Parse("[]");
    }

    // Domain methods
    public void UpdateBuildStatus(BuildStatus status, string? errorMessage = null)
    {
        BuildStatus = status;
        ErrorMessage = errorMessage;
            
        if (status == BuildStatus.Built)
        {
            LastBuiltAt = DateTime.UtcNow;
        }
            
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateVersion(string newVersion, int newBuildNumber)
    {
        Version = newVersion;
        BuildNumber = newBuildNumber;
        UpdatedAt = DateTime.UtcNow;
    }

    public void SetBuildConfiguration(JsonDocument configuration)
    {
        BuildConfiguration = configuration;
        UpdatedAt = DateTime.UtcNow;
    }

    public void AppendBuildLog(JsonDocument logEntry)
    {
        // Mevcut logları al ve yeni log ekle
        var existingLogs = BuildLogs?.RootElement.EnumerateArray().ToList() ?? new List<JsonElement>();
        var newLog = JsonSerializer.Serialize(new
        {
            timestamp = DateTime.UtcNow,
            entry = logEntry
        });

        var options = new JsonDocumentOptions
        {
            AllowTrailingCommas = true
        };

        BuildLogs = JsonDocument.Parse(JsonSerializer.Serialize(existingLogs.Append(JsonDocument.Parse(newLog).RootElement)));
        UpdatedAt = DateTime.UtcNow;
    }

    public void ScheduleBuild(DateTime scheduledTime, BuildPriority priority)
    {
        NextScheduledBuildAt = scheduledTime;
        BuildPriority = priority;
        BuildStatus = BuildStatus.Queued;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateStoreUrl(string url)
    {
        StoreUrl = url;
        if (BuildStatus == BuildStatus.Built)
        {
            BuildStatus = BuildStatus.Published;
            LastPublishedAt = DateTime.UtcNow;
        }
        UpdatedAt = DateTime.UtcNow;
    }

    public bool NeedsBuild()
    {
        return BuildStatus == BuildStatus.NotBuilt
               || BuildStatus == BuildStatus.Failed
               || BuildStatus == BuildStatus.UpdateRequired;
    }
}
