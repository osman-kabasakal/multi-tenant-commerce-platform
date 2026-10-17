using SaasManager.Application.AppBuilds.Queries.DownloadBuild;
using SaasManager.Application.AppBuilds.Queries.GetAppBuildList;
using SaasManager.Application.Common.Models.AppBuilds;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Application.AppBuilds;

public sealed record PortableBuildState(bool Ready, bool Busy, int NextBuildNumber, string? BlockReason)
{ public bool HasBranding {get;init;}=true; }
public interface IPortableAppBuilds
{
    Task<PortableBuildState> StateAsync(BusinessApp app, CancellationToken ct);
    Task<NewBuildDto> EnqueueAsync(BusinessApp app, NewBuildDto request, CancellationToken ct);
    Task<AppBuildList> ListAsync(Guid business, int page, int size, CancellationToken ct);
    Task<DownloadAppBuildResponse> DownloadAsync(Guid business, Guid build, CancellationToken ct);
}
