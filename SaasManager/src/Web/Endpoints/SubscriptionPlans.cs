using Core.Models.Responses;
using Microsoft.AspNetCore.Http.HttpResults;
using SaasManager.Application.Common.Models.SubscriptionPlans;
using SaasManager.Application.SubscriptionPlans.Queries.GetSubscriptionPlans;

namespace SaasManager.Web.Endpoints;

public class SubscriptionPlans: EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        app.MapGroup(this,"subscription")
            .AllowAnonymous()
            .MapGet(GetSubscriptionPlans,"plans");
    }
    
    public async Task<Ok<ServiceResponse<List<SubscriptionPlanDto>>>> GetSubscriptionPlans(ISender sender)
    {
        var plans = await sender.Send(new GetSubscriptionPlansQuery());
        
        return TypedResults.Ok(plans);
    }
}
