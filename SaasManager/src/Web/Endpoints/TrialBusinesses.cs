using Microsoft.AspNetCore.Antiforgery;
using Microsoft.EntityFrameworkCore;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Models.IdentityManagement;
using SaasManager.Application.Common.Utilities;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;
using SaasManager.Application.Stores.Provisioning;

namespace SaasManager.Web.Endpoints;

public sealed class TrialBusinesses : EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        var enabled=app.Configuration.GetValue<bool>("TenantOnboarding:Trial:Enabled");
        var group=app.MapGroup(this);
        group.MapGet("/availability",()=>Results.Ok(new{enabled})).AllowAnonymous();
        if(!enabled)return;
        var policy=TrialEnrollmentPolicy.Read(app.Configuration,app.Environment);
        group.MapGet("/configuration",async(HttpContext http,IAntiforgery antiforgery,IApplicationDbContext db,IWorkContext work,CancellationToken ct)=>{
            var owner=TrialEnrollmentPolicy.Owner(work);
            var plan=await db.SubscriptionPlans.Where(p=>p.Id==policy.PlanId && p.IsPublic && p.IsActive && !p.IsDeleted && p.TrialDays>0)
                .Select(p=>new{p.Id,p.Name,p.TrialDays}).SingleOrDefaultAsync(ct);
            if(plan==null)throw new EnrollmentConflictException("trial-plan-unavailable");
            var business=await db.Businesses.Where(b=>b.CreatedByGuestId==owner.Id && !b.IsDeleted).Select(b=>new{
                b.Id,b.Name,b.Status,databaseReady=db.DatabaseConfigs.Any(d=>d.BusinessId==b.Id && d.IsMigrated),
                trialEndsAt=db.BusinessSubscriptions.Where(s=>s.BusinessId==b.Id && s.IsTrial && !s.IsDeleted).OrderByDescending(s=>s.CreatedAt).Select(s=>s.TrialEndsAt).FirstOrDefault(),
                form=new BusinessRegistrationModel{Name=b.Name,LegalCompanyName=b.LegalCompanyName,OwnerName=b.OwnerName,TaxNumber=b.TaxNumber,TaxOffice=b.TaxOffice,Phone=b.Phone,Address=b.Address,City=b.City,District=b.District,PostalCode=b.PostalCode}
            }).FirstOrDefaultAsync(ct);
            var fields=DynamicFormExtensions.ToDynamicFormParameters<BusinessRegistrationModel>();
            fields["adminPassword"]=new FieldDefinition{Type="password",Label="Mağaza yönetici parolası",Required=true,
                Validations=new(){{"minLength",12},{"maxLength",128}},ValidationMessages=new(){{"required","Mağaza parolanızı belirleyin."},{"minlength","En az 12 karakter kullanın."},{"maxlength","En fazla 128 karakter kullanın."}}};
            http.Response.Headers.CacheControl="no-store";
            return Results.Ok(new{requestToken=antiforgery.GetAndStoreTokens(http).RequestToken,ownerId=owner.Id,billingMode="ConfiguredTrial",plan,fields,business});
        }).RequireAuthorization();
        group.MapPost("",async(EnrollTrialBusiness command,ISender sender,CancellationToken ct)=>await sender.Send(command,ct))
            .RequireAuthorization().AddEndpointFilter(async(context,next)=>{
                try{await context.HttpContext.RequestServices.GetRequiredService<IAntiforgery>().ValidateRequestAsync(context.HttpContext);}
                catch(AntiforgeryValidationException){return Results.BadRequest(new{message="Refresh the page and try again."});}
                return await next(context);
            });
    }
}
