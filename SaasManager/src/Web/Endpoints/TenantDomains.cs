using Microsoft.AspNetCore.Antiforgery;
using Platform.Provisioning;
using SaasManager.Application.Stores.Provisioning;

namespace SaasManager.Web.Endpoints;

public sealed class TenantDomains : EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        var enabled=app.Configuration.GetValue<bool>("Provisioning:CustomDomains:Enabled");
        var group=app.MapGroup(this);
        group.MapGet("/availability",()=>Results.Ok(new{enabled})).AllowAnonymous();
        if(!enabled)return;
        group.RequireAuthorization();
        group.AddEndpointFilter(async(context,next)=>{
            context.HttpContext.Response.Headers.CacheControl="no-store";
            if(!HttpMethods.IsGet(context.HttpContext.Request.Method))
            {
                try{await context.HttpContext.RequestServices.GetRequiredService<IAntiforgery>().ValidateRequestAsync(context.HttpContext);}
                catch(AntiforgeryValidationException){return Results.BadRequest(new{code="RefreshRequired",message="Sayfayı yenileyip tekrar deneyin."});}
            }
            try{return await next(context);}
            catch(TenantDomainException error){return Results.Conflict(new{code=error.Code,message="Alan adı doğrulanamadı. Mevcut durumu kontrol edin."});}
            catch(ArgumentException){return Results.BadRequest(new{code="InvalidDomain",message="Adres, yol veya port içermeyen geçerli bir alan adı girin."});}
        });
        group.MapGet("/configuration",(HttpContext http,IAntiforgery antiforgery,SaasManager.Application.Common.Interfaces.Identity.IWorkContext work)=>{
            TrialEnrollmentPolicy.Owner(work);return Results.Ok(new{requestToken=antiforgery.GetAndStoreTokens(http).RequestToken});
        });
        group.MapPost("",async(CreateTenantDomain command,ISender sender,CancellationToken ct)=>await sender.Send(command,ct));
        group.MapGet("/{id:guid}",async(Guid id,ISender sender,CancellationToken ct)=>{
            var result=await sender.Send(new GetTenantDomain(id),ct);return result==null?Results.NotFound():Results.Ok(result);
        });
        group.MapPost("/{id:guid}/verify",async(Guid id,ISender sender,CancellationToken ct)=>Results.Ok(new{requested=await sender.Send(new VerifyTenantDomain(id),ct)}));
    }
}
