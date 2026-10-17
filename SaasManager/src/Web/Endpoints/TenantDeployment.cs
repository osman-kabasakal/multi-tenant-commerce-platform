using Microsoft.AspNetCore.Antiforgery;
using Platform.Provisioning;
using SaasManager.Application.Stores.Provisioning;

namespace SaasManager.Web.Endpoints;

public sealed class TenantDeployment:EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        var enabled=app.Configuration["Provisioning:Profile"]=="Portable";
        var group=app.MapGroup(this).RequireAuthorization();
        group.MapGet("/availability",()=>Results.Ok(new{enabled})).AllowAnonymous();
        if(!enabled)return;
        group.AddEndpointFilter(async(context,next)=>{
            context.HttpContext.Response.Headers.CacheControl="no-store";
            if(!HttpMethods.IsGet(context.HttpContext.Request.Method))
            {
                try{await context.HttpContext.RequestServices.GetRequiredService<IAntiforgery>().ValidateRequestAsync(context.HttpContext);}
                catch(AntiforgeryValidationException){return Results.BadRequest(new{code="RefreshRequired",message="Sayfayı yenileyip tekrar deneyin."});}
            }
            try{return await next(context);}
            catch(ProvisioningConflictException){return Results.Conflict(new{code="DeploymentChanged",message="Kurulum durumu değişti veya başka bir işlem devam ediyor. Durumu yenileyin."});}
            catch(TenantDomainException error)
            {
                var message=error.Code switch {
                    "TenantNotReady"=>"Mağazanızın ilk kurulumu devam ediyor. Tamamlandığında bu sayfayı kullanabilirsiniz.",
                    "SubscriptionRequired"=>"Bu işlem için etkin deneme veya abonelik gerekiyor.",
                    "MobileIdentityUnchanged"=>"Uygulamanız zaten bu paket kimliğini kullanıyor.",
                    "MobileIdentityDisabled"=>"İki platform için imzalı derleme hizmeti henüz yapılandırılmamış.",
                    "DomainAlreadyActive"=>"Bu alan adı zaten mağazanızın ana adresi.",
                    _=>"İşlem başlatılamadı. Sahiplik ve kurulum durumunu kontrol edin."};
                return Results.Conflict(new{code=error.Code,message});
            }
            catch(ArgumentException){return Results.BadRequest(new{code="InvalidRequest",message="İşlem bilgileri geçersiz. Sayfayı yenileyin."});}
        });
        group.MapGet("/configuration",(HttpContext http,IAntiforgery antiforgery,SaasManager.Application.Common.Interfaces.Identity.IWorkContext work)=>{
            TrialEnrollmentPolicy.Owner(work);return Results.Ok(new{requestToken=antiforgery.GetAndStoreTokens(http).RequestToken});
        });
        group.MapGet("",async(ISender sender,CancellationToken ct)=>await sender.Send(new GetTenantDeployment(),ct));
        group.MapPost("/domain",async(ActivateTenantDomain command,ISender sender,CancellationToken ct)=>await sender.Send(command,ct));
        group.MapPost("/identity",async(CreateMobileIdentity command,ISender sender,CancellationToken ct)=>await sender.Send(command,ct));
        group.MapPost("/retry",async(RetryTenantDeployment command,ISender sender,CancellationToken ct)=>
            await sender.Send(command,ct)?Results.Ok(new{requested=true}):Results.Conflict(new{code="RetryUnavailable",message="Bu işlem şu an yeniden başlatılamıyor. Durumu yenileyin."}));
    }
}
