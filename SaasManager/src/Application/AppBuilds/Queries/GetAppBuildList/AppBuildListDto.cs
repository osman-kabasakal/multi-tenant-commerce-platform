using SaasManager.Application.Common.Models;

namespace SaasManager.Application.AppBuilds.Queries.GetAppBuildList;

public class AppBuildList
{
    public AppBuildList(PaginatedList<AppBuildDto> appBuilds)
    {
        AppBuilds = appBuilds;
    }

    public PaginatedList<AppBuildDto> AppBuilds { get; set; }
}
