using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.FileStorage;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Entities.RegisteredApps;

namespace SaasManager.Application.AppBuilds.Queries.DownloadBuild;

public record DownloadBuildQuery : IRequest<DownloadAppBuildResponse>
{
    public Guid AppBuildId { get; set; }
}

public class DownloadBuildQueryValidator : AbstractValidator<DownloadBuildQuery>
{
    public DownloadBuildQueryValidator()
    {
    }
}

public class DownloadBuildQueryHandler : IRequestHandler<DownloadBuildQuery, DownloadAppBuildResponse>
{
    private readonly IApplicationDbContext _context;
    private readonly IBlobStorageService _blobStorageService;
    private readonly IWorkContext _workContext;

    public DownloadBuildQueryHandler(
        IApplicationDbContext context,
        IBlobStorageService blobStorageService,
        IWorkContext workContext
        )
    {
        _context = context;
        _blobStorageService = blobStorageService;
        _workContext = workContext;
    }

    public async Task<DownloadAppBuildResponse> Handle(DownloadBuildQuery request, CancellationToken cancellationToken)
    {
        var business=BusinessOwnerContext.BusinessId(_workContext);
        if(business==null)throw new NotFoundException(nameof(AppBuild),request.AppBuildId.ToString());
        var appBuild=await _context.AppBuilds.FirstOrDefaultAsync(x=>x.Id==request.AppBuildId && !x.IsDeleted &&
            _context.BusinessApps.Any(a=>a.Id==x.BusinessAppId && a.BusinessId==business && !a.IsDeleted),cancellationToken);
        if(appBuild == null || string.IsNullOrEmpty(appBuild.FilePath))
            throw new NotFoundException(nameof(AppBuild), request.AppBuildId.ToString());
        var downloadedBlob = await _blobStorageService.DownloadFileAsync(appBuild.FilePath,cancellationToken);
        return new DownloadAppBuildResponse()
        {
            FileStream = downloadedBlob.Content,
            MimeType = MimeTypeHelper.GetMimeType(appBuild.FilePath),
            FileName = Path.GetFileName(appBuild.FilePath)
        };
    }
}
