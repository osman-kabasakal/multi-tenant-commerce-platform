using Microsoft.AspNetCore.Antiforgery;
using SaasManager.Application.Stores.Provisioning;

namespace SaasManager.Web.Endpoints;

public sealed class Provisioning : EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        if (!app.Configuration.GetValue<bool>("Provisioning:Enabled")) return;
        var group = app.MapGroup(this).RequireAuthorization();
        group.AddEndpointFilter(async (context,next) => {
            if (HttpMethods.IsPost(context.HttpContext.Request.Method))
            {
                try {await context.HttpContext.RequestServices.GetRequiredService<IAntiforgery>().ValidateRequestAsync(context.HttpContext);}
                catch (AntiforgeryValidationException) {return Results.BadRequest();}
            }
            return await next(context);
        });
        group.MapGet("/{businessId:guid}", async (Guid businessId, ISender sender, CancellationToken ct) => {
            try {var job=await sender.Send(new GetProvisioningStatus(businessId),ct);return job==null?Results.NotFound():Results.Ok(job);}
            catch (UnauthorizedAccessException) {return Results.StatusCode(StatusCodes.Status403Forbidden);}
        });
        group.MapPost("/{businessId:guid}/retry", async (Guid businessId, ISender sender, CancellationToken ct) => {
            try {return Results.Ok(await sender.Send(new RetryProvisioning(businessId),ct));}
            catch (UnauthorizedAccessException) {return Results.StatusCode(StatusCodes.Status403Forbidden);}
        });
    }
}
