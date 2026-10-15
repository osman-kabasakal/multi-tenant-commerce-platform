using Core.Models.Helpers;
using Core.Models.Responses;
using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Models.AppBuilds;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.AppBuilds.Queries.GetNewBuildVm;

public record GetNewBuildVmQuery : IRequest<ServiceResponse<NewBuildVm>>
{
}

public class GetNewBuildVmQueryValidator : AbstractValidator<GetNewBuildVmQuery>
{
    public GetNewBuildVmQueryValidator()
    {
    }
}

[Authorize]
public class GetNewBuildVmQueryHandler : IRequestHandler<GetNewBuildVmQuery, ServiceResponse<NewBuildVm>>
{
    private readonly IApplicationDbContext _context;
    private readonly IWorkContext _workContext;

    public GetNewBuildVmQueryHandler(IApplicationDbContext context,
        IWorkContext workContext
    )
    {
        _context = context;
        _workContext = workContext;
    }

    public async Task<ServiceResponse<NewBuildVm>> Handle(GetNewBuildVmQuery request,
        CancellationToken cancellationToken)
    {
        
        var ownerBusiness=BusinessOwnerContext.BusinessId(_workContext);
        var businessAppQuery = from businessApp in _context.BusinessApps
            join business in _context.Businesses on businessApp.BusinessId equals business.Id
            where businessApp.Type == AppType.CustomerMobile &&
                  businessApp.BusinessId == ownerBusiness && !businessApp.IsDeleted && !business.IsDeleted &&
                  (businessApp.BuildStatus != BuildStatus.Queued && businessApp.BuildStatus != BuildStatus.Building)
                  // (!appBuilds.Any() || !(appBuilds.Any(ab => ab.IsActive && ab.Platform == BuildPlatform.Android) &&
                  //                        appBuilds.Any(ab => ab.IsActive && ab.Platform == BuildPlatform.Ios)))
            select new
            {
                businessApp,
                business
            };
        
        var businessApps = await businessAppQuery.FirstOrDefaultAsync(cancellationToken);

        var vm = new NewBuildVm
        {
            BusinessAppId = businessApps?.businessApp?.Id??Guid.Empty,
            Version = businessApps?.businessApp?.Version??"",
            BuildNumber = (businessApps?.businessApp?.BuildNumber ?? 0)+1,
            BuildStatus = BuildStatus.Queued.ToString(),
            CanBuild = businessApps?.business?.Status != null && businessApps!.business!.Status! == BusinessStatus.Active,
            HasActiveBuild = businessApps == null,
            Platforms = new List<DropdownListItem>()
            {
                new DropdownListItem() { Text = "Google", Value = BuildPlatform.Android.ToString() },
                new DropdownListItem() { Text = "Apple", Value = BuildPlatform.Ios.ToString() }
            }
        };

        return ServiceResponse<NewBuildVm>.Success(vm);
    }
}
