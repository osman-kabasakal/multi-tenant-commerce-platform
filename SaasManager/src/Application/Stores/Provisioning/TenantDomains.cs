using Microsoft.Extensions.Configuration;
using Platform.Provisioning;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;

namespace SaasManager.Application.Stores.Provisioning;

[Authorize]
public sealed record CreateTenantDomain(Guid Id,Guid RegistrationId,string Domain) : IRequest<TenantDomainView>;
[Authorize]
public sealed record GetTenantDomain(Guid Id) : IRequest<TenantDomainView?>;
[Authorize]
public sealed record VerifyTenantDomain(Guid Id) : IRequest<bool>;
public sealed record TenantDomainView(Guid Id,string TenantId,string Domain,string StoreUrl,string AdminUrl,string State,
    string ChallengeName,string ChallengeValue,DateTimeOffset ExpiresAt,string? ErrorCode,string? Message,bool IsPrimary)
{
    public static TenantDomainView From(TenantDomainBinding b)
    {
        var expired=b.ExpiresAt<=DateTimeOffset.UtcNow && (b.State is "PendingCheck" or "AwaitingOwnership");
        var state=expired?"Expired":b.State=="AwaitingOwnership" && b.VerificationRequested?"CheckingOwnership":b.State;
        var message=b.ErrorCode switch {
            "DomainDnsConflict"=>"Bu alan adındaki DNS kayıtları güvenle taşınamıyor. Adres zaten platform sunucusunu gösteriyor, başka bir işletmeye ait veya desteklenmeyen bir kayıt çakışması var. Kayıtları kontrol edin ya da başka bir alan adı girin.",
            "DomainAlreadyAssigned"=>"Bu alan adı başka bir işletmeye atanmış. Başka bir alan adı girin.",
            "DomainNotAccessible"=>"Alan adı Cloudflare hesabında bulunamadı veya API erişimi yok. Alan adı aktarımını ve API kapsamını kontrol edin.",
            "DomainProofMissing"=>"Sahiplik TXT kaydı henüz doğrulanamadı. Kaydı kontrol edip tekrar doğrulayın.",
            "DomainReservedForPlatform"=>"Bu alan adı platform hizmetleri için ayrılmış. İşletmenize ait başka bir alan adı girin.",
            null=>null,_=>"Alan adı kontrolü tamamlanamadı. Destek ile iletişime geçin."};
        return new(b.Request.Id,b.Request.TenantId,b.Request.StoreHost,"https://"+b.Request.StoreHost,"https://"+b.Request.AdminHost+"/Admin",state,
            TenantDomainNames.ChallengeName(b.Request.StoreHost),b.Challenge,b.ExpiresAt,b.ErrorCode,message,b.IsPrimary);
    }
}
public sealed class TenantDomainHandler(IApplicationDbContext db,IWorkContext work,IConfiguration config,TenantDomainRegistry registry)
    : IRequestHandler<CreateTenantDomain,TenantDomainView>,IRequestHandler<GetTenantDomain,TenantDomainView?>,IRequestHandler<VerifyTenantDomain,bool>
{
    private Guid Owner()
    {
        if(!config.GetValue<bool>("Provisioning:CustomDomains:Enabled") || config["Provisioning:Profile"]!="Portable" || config.GetValue<bool>("LocalDemo:Enabled"))
            throw new InvalidOperationException("Custom domain registration is not enabled for this deployment.");
        TrialEnrollmentPolicy.Owner(work);return work.KeycloakId!.Value;
    }
    public async Task<TenantDomainView> Handle(CreateTenantDomain request,CancellationToken ct)
    {
        var owner=Owner();
        if(request.RegistrationId==Guid.Empty || request.Id==Guid.Empty)throw new ArgumentException("Use a stable registration and domain request id.");
        var business=await db.Businesses.Where(b=>b.Id==request.RegistrationId).Select(b=>new{b.IsDeleted,b.CreatedByGuestId}).SingleOrDefaultAsync(ct);
        if(business!=null && (business.IsDeleted || business.CreatedByGuestId!=work.GuestRegistration!.Id))throw new UnauthorizedAccessException("Business ownership is required.");
        var domain=TenantDomainNames.Normalize(request.Domain);
        var binding=await registry.CreateAsync(new(request.Id,request.RegistrationId.ToString("N"),owner,config["Provisioning:DeploymentId"]??"",domain,"manage."+domain),ct);
        return TenantDomainView.From(binding);
    }
    public async Task<TenantDomainView?> Handle(GetTenantDomain request,CancellationToken ct)
    {
        var binding=await registry.GetAsync(request.Id,Owner(),ct);return binding==null?null:TenantDomainView.From(binding);
    }
    public Task<bool> Handle(VerifyTenantDomain request,CancellationToken ct)=>registry.RequestVerificationAsync(request.Id,Owner(),ct);
}
