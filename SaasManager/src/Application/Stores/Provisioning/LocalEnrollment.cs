using Core.Models.Responses;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Platform.Provisioning;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;
using SaasManager.Application.Common.Utilities;
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.Stores.Provisioning;

[Authorize]
public sealed record EnrollLocalBusiness(Guid RegistrationId,string Name,string AdminPassword) : IRequest<LocalEnrollmentResult>;
public sealed record LocalEnrollmentResult(Guid BusinessId,string Slug,string StatusUrl);

public sealed class EnrollLocalBusinessHandler(IApplicationDbContext db,IWorkContext work,ISender sender,
    IConfiguration config,IHostEnvironment environment) : IRequestHandler<EnrollLocalBusiness,LocalEnrollmentResult>
{
    public async Task<LocalEnrollmentResult> Handle(EnrollLocalBusiness request,CancellationToken ct)
    {
        if (environment.EnvironmentName!="Development" || !config.GetValue<bool>("LocalDemo:Enabled") ||
            !config.GetValue<bool>("LocalDemo:SelfService") || !config.GetValue<bool>("Provisioning:Enabled"))
            throw new InvalidOperationException("Local trial enrollment requires the explicit Development profile.");
        var guest=work.GuestRegistration;
        if (work.KeycloakId==null || guest==null || !guest.IsConverted || !guest.IsEmailVerified || guest.KeycloakUserId!=work.KeycloakId.Value.ToString())
            throw new UnauthorizedAccessException("Sign in with a verified local Keycloak account.");
        if (request.RegistrationId==Guid.Empty || string.IsNullOrWhiteSpace(request.Name) || request.Name.Length>80 ||
            string.IsNullOrEmpty(request.AdminPassword) || request.AdminPassword.Length<12 || request.AdminPassword.Length>128)
            throw new ArgumentException("Supply a business name and an administrator password of 12-128 characters.");
        var business=await db.Businesses.FirstOrDefaultAsync(b=>b.Id==request.RegistrationId,ct);
        if (business!=null && (business.CreatedByGuestId!=guest.Id || business.Name!=request.Name || business.IsDeleted))
            throw new UnauthorizedAccessException("The registration ID belongs to a different business.");
        if (business==null)
        {
            if (await db.Businesses.AnyAsync(b=>b.CreatedByGuestId==guest.Id && !b.IsDeleted,ct))
                throw new InvalidOperationException("This account already has a business. Open its existing provisioning status.");
            var plan=await db.SubscriptionPlans.Where(p=>p.IsActive && !p.IsDeleted && p.IsPublic && p.TrialDays>0).OrderBy(p=>p.Price).FirstAsync(ct);
            business=new Business(request.Name,guest.Fullname,guest.Email!,"0000000000",
                "local"+request.RegistrationId.ToString("N")[..15],"Local demo","Demo Street","Demo City","Demo District","00000",request.Name,guest.Id) {
                    Id=request.RegistrationId
                };
            // Validate the same identifiers the worker will receive before persisting anything.
            new TenantProvisioningRequest(business.Id.ToString("N"),business.ToSubdomain(),business.Name,guest.Email!,
                guest.Firstname??"Demo",guest.Lastname??"Owner",business.Address,business.Phone,business.Email).Validate();
            business.UpdateStatus(BusinessStatus.UnderSetup);
            guest.ConvertToBusiness(business);
            db.Businesses.Add(business);
            db.BusinessApps.Add(new BusinessApp(business.Id,AppType.CustomerMobile,business.Name,"com.example.tenant"+business.Id.ToString("N")));
            var now=DateTime.UtcNow;
            db.BusinessSubscriptions.Add(new BusinessSubscription(business.Id,plan.Id,now,now.AddDays(plan.TrialDays),0,PaymentPeriod.Monthly,true,now.AddDays(plan.TrialDays)));
            // Business and trial subscription commit together; a failed queue write is safe to replay.
            await db.SaveChangesAsync(ct);
        }
        var queued=await sender.Send(new RegisterStoreCommand {
            BusinessId=business.Id,StoreName=business.Name,StoreSubDomain=business.ToSubdomain(),LogoUrl="no-logo.png",
            OwnerEmail=guest.Email!,Password=request.AdminPassword,FirstName=guest.Firstname??"Demo",Lastname=guest.Lastname??"Owner",Role="business_owner",
            CompanyName=business.Name,CompanyAddress=business.Address,CompanyEmail=business.Email,CompanyPhoneNumber=business.Phone
        },ct);
        if (!queued.IsSuccess) throw new InvalidOperationException("Tenant setup could not be queued.");
        return new(business.Id,business.ToSubdomain(),"/api/Provisioning/"+business.Id);
    }
}
