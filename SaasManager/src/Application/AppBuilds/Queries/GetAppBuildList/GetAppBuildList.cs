using Core.Models.Responses;
using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Mappings;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.AppBuilds.Queries.GetAppBuildList;

public record GetAppBuildListQuery : IRequest<ServiceResponse<AppBuildList>>
{
    public int PageNumber { get; init; } = 1;
    public int PageSize { get; init; } = 10;
}

public class GetAppBuildListQueryValidator : AbstractValidator<GetAppBuildListQuery>
{
    public GetAppBuildListQueryValidator()
    {
        RuleFor(x => x.PageNumber).GreaterThan(0);
        RuleFor(x => x.PageSize).InclusiveBetween(1, 100);
    }
}

[Authorize]
public class GetAppBuildListQueryHandler : IRequestHandler<GetAppBuildListQuery, ServiceResponse<AppBuildList>>
{
    private readonly IApplicationDbContext _context;
    private readonly IWorkContext _workContext;
    private readonly IPortableAppBuilds? _portable;

    public GetAppBuildListQueryHandler(
        IApplicationDbContext context,
        IWorkContext workContext, IPortableAppBuilds? portable = null
        )
    {
        _context = context;
        _workContext = workContext;
        _portable = portable;
    }

    public async Task<ServiceResponse<AppBuildList>> Handle(GetAppBuildListQuery request, CancellationToken cancellationToken)
    {
        var owner = BusinessOwnerContext.BusinessId(_workContext);
        if (_portable != null && owner is {} business)
            return ServiceResponse<AppBuildList>.Success(await _portable.ListAsync(business, request.PageNumber, request.PageSize, cancellationToken));
        var query= (from businessApp  in _context.BusinessApps
            join appBuild in  _context.AppBuilds on businessApp.Id equals  appBuild.BusinessAppId
            where businessApp.BusinessId == owner
            && businessApp.Type == AppType.CustomerMobile && !businessApp.IsDeleted && !appBuild.IsDeleted
            select new AppBuildDto
            {
                Id = appBuild.Id,
                Platform = appBuild.Platform.ToString(),
                Version = appBuild.Version,
                BuildNumber = appBuild.BuildNumber,
                BuildStatus = appBuild.BuildStatus,
                BuildDate = appBuild.BuildDate??DateTime.UtcNow,
                FileSize = appBuild.FileSize,
            })
            .OrderByDescending(x => x.BuildDate);
        
        return ServiceResponse<AppBuildList>.Success(new AppBuildList(
            await query.PaginatedListAsync(request.PageNumber, request.PageSize)
            ));
    }
}
