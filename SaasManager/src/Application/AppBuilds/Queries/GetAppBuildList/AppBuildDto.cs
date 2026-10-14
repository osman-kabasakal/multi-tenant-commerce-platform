namespace SaasManager.Application.AppBuilds.Queries.GetAppBuildList;

public class AppBuildDto
{
    public Guid Id { get; set; }
    public string Platform { get; set; } = null!;
    public string Version { get; set; } = null!;
    public int BuildNumber { get; set; }
    public string BuildStatus { get; set; } = null!;
    public DateTime BuildDate { get; set; } 
    public long FileSize { get; set; }
}
