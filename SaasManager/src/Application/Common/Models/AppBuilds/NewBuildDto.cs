using SaasManager.Domain.Enums;

namespace SaasManager.Application.Common.Models.AppBuilds;

public class NewBuildDto
{
    public Guid BusinessAppId { get; set; }
    // public BuildPlatform Platform { get; set; }
    public string Version { get; set; } = null!;
    public int BuildNumber { get; set; }
    public string BuildStatus { get; set; } = null!;
}
