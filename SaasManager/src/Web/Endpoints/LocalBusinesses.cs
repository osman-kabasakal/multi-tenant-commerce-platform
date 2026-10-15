using Microsoft.AspNetCore.Antiforgery;
using Microsoft.EntityFrameworkCore;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Stores.Provisioning;

namespace SaasManager.Web.Endpoints;

public sealed class LocalBusinesses : EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        if (!app.Environment.IsDevelopment() || !app.Configuration.GetValue<bool>("LocalDemo:Enabled") ||
            !app.Configuration.GetValue<bool>("LocalDemo:SelfService")) return;
        var group=app.MapGroup(this).RequireAuthorization();
        group.MapGet("/configuration",async (HttpContext http,IAntiforgery antiforgery,IApplicationDbContext db,IWorkContext work,CancellationToken ct) => {
            var token=antiforgery.GetAndStoreTokens(http);
            var owner=work.GuestRegistration?.Id;
            var business=owner==null?null:await db.Businesses.Where(b=>b.CreatedByGuestId==owner && !b.IsDeleted).Select(b=>new {b.Id,b.Name,b.Status,databaseReady=db.DatabaseConfigs.Any(d=>d.BusinessId==b.Id && d.IsMigrated)}).FirstOrDefaultAsync(ct);
            return Results.Ok(new {requestToken=token.RequestToken,billingMode="LocalTrial",business});
        });
        group.MapPost("",async (EnrollLocalBusiness command,ISender sender,CancellationToken ct)=>await sender.Send(command,ct))
            .AddEndpointFilter(async (context,next)=> {
                try {await context.HttpContext.RequestServices.GetRequiredService<IAntiforgery>().ValidateRequestAsync(context.HttpContext);}
                catch (AntiforgeryValidationException) {return Results.BadRequest(new {message="Refresh the page and try again."});}
                return await next(context);
            });
    }
}
