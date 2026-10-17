using Core.Models.Helpers;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.Common.Models.AppBuilds;

public class NewBuildVm: NewBuildDto
{
    
    public bool HasActiveBuild { get; set; }
    
    public ICollection<DropdownListItem> Platforms { get; set; } = new List<DropdownListItem>();
    public bool CanBuild { get; set; }
    public string? BlockReason { get; set; }
    public bool UsesExistingBranding { get; set; }
}
