using Core.Models.Helpers;
using Core.Models.Responses;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Models.AppBuilds;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.AppBuilds.Queries.GetNewBuildVm;

public record GetNewBuildVmQuery:IRequest<ServiceResponse<NewBuildVm>>;
[Authorize]
public class GetNewBuildVmQueryHandler(IApplicationDbContext context,IWorkContext workContext,IPortableAppBuilds? portable=null)
    :IRequestHandler<GetNewBuildVmQuery,ServiceResponse<NewBuildVm>>
{
    public async Task<ServiceResponse<NewBuildVm>> Handle(GetNewBuildVmQuery request,CancellationToken ct)
    {
        var eligibility=await BuildEligibility.CheckAsync(context,workContext,ct);
        var app=eligibility.App;
        var state=app!=null && portable!=null?await portable.StateAsync(app,ct):null;
        var busy=state?.Busy ?? (app!=null && (app.BuildStatus is BuildStatus.Queued or BuildStatus.Building ||
            await context.AppBuilds.AnyAsync(b=>b.BusinessAppId==app.Id && !b.IsDeleted && (b.BuildStatus=="Queued" || b.BuildStatus=="Building"),ct)));
        var reason=eligibility.BlockReason ?? state?.BlockReason;
        return ServiceResponse<NewBuildVm>.Success(new()
        {
            RequestId=Guid.NewGuid(),BusinessAppId=app?.Id??Guid.Empty,Version=app?.Version??"",BuildNumber=state?.NextBuildNumber??(app?.BuildNumber??0)+1,
            BuildStatus="Queued",CanBuild=eligibility.Allowed && (state?.Ready??true) && !busy,HasActiveBuild=busy,
            BlockReason=reason,UsesExistingBranding=portable!=null,
            Platforms=[new DropdownListItem{Text="Android",Value=BuildPlatform.Android.ToString()}]
        });
    }
}
