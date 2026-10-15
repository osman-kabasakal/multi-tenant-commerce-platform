using SaasManager.Application.AppBuilds.Queries.DownloadBuild;
using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.FileStorage;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Application.AppBuilds.Queries.DownloadAsset;

public sealed record DownloadAssetQuery(Guid AssetId):IRequest<DownloadAppBuildResponse>;

public sealed class DownloadAssetHandler(IApplicationDbContext context,IBlobStorageService storage,IWorkContext owner):IRequestHandler<DownloadAssetQuery,DownloadAppBuildResponse>
{
    public async Task<DownloadAppBuildResponse> Handle(DownloadAssetQuery request,CancellationToken ct)
    {
        var business=BusinessOwnerContext.BusinessId(owner);
        if(business==null)throw new NotFoundException(nameof(AppMediaAsset),request.AssetId.ToString());
        var asset=await context.AppMediaAssets.FirstOrDefaultAsync(x=>x.Id==request.AssetId && !x.IsDeleted &&
            context.BusinessApps.Any(a=>a.Id==x.BusinessAppId && a.BusinessId==business && !a.IsDeleted),ct);
        if(asset==null)throw new NotFoundException(nameof(AppMediaAsset),request.AssetId.ToString());
        var file=await storage.DownloadFileAsync(asset.FilePath,ct);
        return new(){FileStream=file.Content,MimeType=file.ContentType,FileName=Path.GetFileName(asset.FileName.Replace('\\','/'))};
    }
}
