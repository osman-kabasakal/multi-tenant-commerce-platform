using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.FileStorage;
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

    public DownloadBuildQueryHandler(
        IApplicationDbContext context,
        IBlobStorageService blobStorageService
        )
    {
        _context = context;
        _blobStorageService = blobStorageService;
    }

    public async Task<DownloadAppBuildResponse> Handle(DownloadBuildQuery request, CancellationToken cancellationToken)
    {
        var appBuild = await _context.AppBuilds.FirstOrDefaultAsync((x)=>x.Id == request.AppBuildId, cancellationToken: cancellationToken);
        if(appBuild == null || string.IsNullOrEmpty(appBuild.FilePath))
            throw new NotFoundException(nameof(AppBuild), request.AppBuildId.ToString());
        var downloadedBlob = await _blobStorageService.DownloadFileAsync(appBuild.FilePath);
        return new DownloadAppBuildResponse()
        {
            FileStream = downloadedBlob.Value.Content,
            MimeType = MimeTypeHelper.GetMimeType(appBuild.FilePath),
            FileName = Path.GetFileName(appBuild.FilePath)
        };
    }
}
