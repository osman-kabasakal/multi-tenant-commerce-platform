using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;
using FluentValidation.Results;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Platform.Provisioning;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;
using SaasManager.Application.Common.Utilities;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;
using ValidationException = SaasManager.Application.Common.Exceptions.ValidationException;

namespace SaasManager.Application.Stores.Provisioning;

[Authorize]
public sealed record EnrollTrialBusiness(Guid RegistrationId, BusinessRegistrationModel Business, string AdminPassword, Guid? DomainRequestId = null) : IRequest<TrialEnrollmentResult>;

public sealed record TrialEnrollmentResult(Guid BusinessId,string Slug,string StatusUrl);

public sealed record TrialEnrollmentPolicy(Guid PlanId, string DeploymentId)
{
    public static TrialEnrollmentPolicy Read(IConfiguration config, IHostEnvironment environment)
    {
        var deployment=config["Provisioning:DeploymentId"]??"";
        if (!config.GetValue<bool>("TenantOnboarding:Trial:Enabled") || environment.EnvironmentName is not ("Production" or "Staging") ||
            config.GetValue<bool>("LocalDemo:Enabled") || !config.GetValue<bool>("Provisioning:Enabled") || config["Provisioning:Profile"]!="Portable" ||
            config["PlatformSecurity:Provider"] is not ("AesGcm" or "Azure") || config.GetValue<bool>("PlatformSecurity:ReadOnly") ||
            (config["Provisioning:Mobile:Provider"]??"Disabled") is not ("Disabled" or "AndroidAppDistribution" or "AndroidIosAppDistribution") ||
            !Guid.TryParse(config["TenantOnboarding:Trial:PlanId"],out var plan) || plan==Guid.Empty || !Regex.IsMatch(deployment,"^[a-zA-Z0-9][a-zA-Z0-9._-]{0,99}$"))
            throw new InvalidOperationException("Trial enrollment requires explicit Production/Staging Portable provisioning, a deployment id, a public trial plan and writable shared secrets.");
        TenantMobileApplicationId.Prefix(config);
        return new(plan,deployment);
    }
    public static SaasManager.Domain.Entities.IdentityManagement.GuestRegistration Owner(IWorkContext work)
    {
        var guest=work.GuestRegistration;
        if(work.KeycloakId==null || work.KeycloakId==Guid.Empty || guest==null || guest.Id==Guid.Empty || !guest.IsConverted || !guest.IsEmailVerified ||
            guest.KeycloakUserId!=work.KeycloakId.Value.ToString() || string.IsNullOrWhiteSpace(guest.Email))
            throw new UnauthorizedAccessException("Sign in with a verified identity account.");
        return guest;
    }
}

public sealed class EnrollmentConflictException(string code) : Exception("This enrollment conflicts with an existing business or subscription.")
{
    public string Code { get; } = code;
}

public sealed class EnrollTrialBusinessHandler(IApplicationDbContext db,IWorkContext work,ISender sender,
    IConfiguration config,IHostEnvironment environment,TenantDomainRegistry? domains = null,MobileIdentityRegistry? identities=null) : IRequestHandler<EnrollTrialBusiness,TrialEnrollmentResult>
{
    public async Task<TrialEnrollmentResult> Handle(EnrollTrialBusiness request,CancellationToken ct)
    {
        var policy=TrialEnrollmentPolicy.Read(config,environment);
        var guest=TrialEnrollmentPolicy.Owner(work);
        var errors=new List<ValidationFailure>();
        if(request.RegistrationId==Guid.Empty)errors.Add(new("RegistrationId","A stable registration id is required."));
        if(string.IsNullOrEmpty(request.AdminPassword) || request.AdminPassword.Length is < 12 or > 128)errors.Add(new("AdminPassword","Use 12-128 characters for the store administrator password."));
        var details=request.Business;
        if(details==null)errors.Add(new("Business","Company and contact information are required."));
        else
        {
            var validation=new List<System.ComponentModel.DataAnnotations.ValidationResult>();
            Validator.TryValidateObject(details,new System.ComponentModel.DataAnnotations.ValidationContext(details),validation,true);
            errors.AddRange(validation.SelectMany(error=>error.MemberNames.DefaultIfEmpty("Business").Select(name=>new ValidationFailure("Business."+name,error.ErrorMessage??"Invalid company information."))));
        }
        if(errors.Count>0)throw new ValidationException(errors);
        TenantDomainBinding? domain = null;
        if (request.DomainRequestId is {} domainId)
        {
            if (!config.GetValue<bool>("Provisioning:CustomDomains:Enabled") || domains == null) throw new TenantDomainException("DomainNotVerified");
            domain = await domains.RequireVerifiedAsync(domainId,work.KeycloakId!.Value,request.RegistrationId.ToString("N"),policy.DeploymentId,ct);
        }
        var business=await db.Businesses.FirstOrDefaultAsync(b=>b.Id==request.RegistrationId,ct);
        if(business!=null)
        {
            if(business.IsDeleted || business.CreatedByGuestId!=guest.Id)throw new UnauthorizedAccessException("This registration does not belong to the authenticated owner.");
            if(business.Name!=details!.Name || business.LegalCompanyName!=details.LegalCompanyName || business.TaxNumber!=details.TaxNumber ||
                business.TaxOffice!=details.TaxOffice || business.OwnerName!=details.OwnerName || business.Phone!=details.Phone || business.Address!=details.Address ||
                business.City!=details.City || business.District!=details.District || business.PostalCode!=details.PostalCode)
                throw new EnrollmentConflictException("registration-changed");
            var trial=await db.BusinessSubscriptions.SingleOrDefaultAsync(s=>s.BusinessId==business.Id && s.IsTrial && !s.IsDeleted,ct);
            if(trial==null || trial.PlanId!=policy.PlanId || !trial.IsActive || trial.IsExpired() || trial.IsTrialExpired())throw new EnrollmentConflictException("trial-unavailable");
        }
        else
        {
            if(await db.Businesses.AnyAsync(b=>!b.IsDeleted && (b.CreatedByGuestId==guest.Id || b.Email==guest.Email || b.TaxNumber==details!.TaxNumber),ct))
                throw new EnrollmentConflictException("business-exists");
            var plan=await db.SubscriptionPlans.SingleOrDefaultAsync(p=>p.Id==policy.PlanId && p.IsActive && !p.IsDeleted && p.IsPublic && p.TrialDays>0,ct)
                ??throw new EnrollmentConflictException("trial-plan-unavailable");
            business=new Business(details!.Name,details.OwnerName,guest.Email!,details.Phone,details.TaxNumber,details.TaxOffice,
                details.Address,details.City,details.District,details.PostalCode,details.LegalCompanyName,guest.Id){Id=request.RegistrationId};
            try{new TenantProvisioningRequest(business.Id.ToString("N"),business.ToSubdomain(),business.Name,guest.Email!,guest.Firstname??details.OwnerName,guest.Lastname??"Owner",business.Address,business.Phone,business.Email,DeploymentId:policy.DeploymentId).Validate();}
            catch(ArgumentException){throw new ValidationException([new("Business.Name","Use a business name that produces an available 3-40 character tenant DNS label.")]);}
            business.UpdateStatus(BusinessStatus.UnderSetup);guest.ConvertToBusiness(business);db.Businesses.Add(business);
            var now=DateTime.UtcNow;
            db.BusinessSubscriptions.Add(new BusinessSubscription(business.Id,plan.Id,now,now.AddDays(plan.TrialDays),0,PaymentPeriod.Monthly,true,now.AddDays(plan.TrialDays)));
            // One transaction persists company, selected trial and app. Queue failures are replayable without a second trial or charge.
            try{await TenantMobileApplicationId.AddInitialAsync(db,config,business.Id,business.Name,business.Name,ct,domain,identities);}
            catch(DbUpdateException)
            {
                if(await db.Businesses.AsNoTracking().AnyAsync(b=>b.Id==request.RegistrationId || b.CreatedByGuestId==guest.Id || b.Email==guest.Email || b.TaxNumber==details.TaxNumber,ct))
                    throw new EnrollmentConflictException("business-exists");
                throw;
            }
        }
        var queued=await sender.Send(new RegisterStoreCommand{BusinessId=business.Id,DomainRequestId=request.DomainRequestId,StoreName=business.Name,StoreSubDomain=business.ToSubdomain(),LogoUrl="no-logo.png",
            OwnerEmail=guest.Email!,Password=request.AdminPassword,FirstName=guest.Firstname??details!.OwnerName,Lastname=guest.Lastname??"Owner",Role="business_owner",
            CompanyName=business.LegalCompanyName,CompanyAddress=business.Address,CompanyEmail=business.Email,CompanyPhoneNumber=business.Phone},ct);
        if(!queued.IsSuccess)throw new InvalidOperationException("Tenant setup could not be queued.");
        return new(business.Id,business.ToSubdomain(),"/api/Provisioning/"+business.Id);
    }
}
