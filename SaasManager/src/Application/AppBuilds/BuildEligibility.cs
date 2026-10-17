using Microsoft.EntityFrameworkCore;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.AppBuilds;

public sealed record BuildEligibility(BusinessApp? App, string? BlockReason)
{
    public bool Allowed => App != null && BlockReason == null;
    public static async Task<BuildEligibility> CheckAsync(IApplicationDbContext db, IWorkContext owner, CancellationToken ct)
    {
        var id = BusinessOwnerContext.BusinessId(owner);
        if (id == null) return new(null, "Doğrulanmış işletme sahibi hesabıyla giriş yapın.");
        var business = await db.Businesses.SingleOrDefaultAsync(b => b.Id == id && !b.IsDeleted && b.IsActive, ct);
        var app = await db.BusinessApps.FirstOrDefaultAsync(a => a.BusinessId == id && a.Type == AppType.CustomerMobile && !a.IsDeleted && a.IsActive, ct);
        if (business == null) return new(null, "İşletme bulunamadı.");
        if (business.Status is BusinessStatus.Pending or BusinessStatus.WaitingForApproval or BusinessStatus.UnderSetup)
            return new(app, "İşletmenizin kurulumu devam ediyor. Kurulum tamamlanınca derleme başlatabilirsiniz.");
        if (business.Status is not (BusinessStatus.Trial or BusinessStatus.Active))
            return new(app, "İşletmeniz derleme için uygun durumda değil. Aboneliğinizi kontrol edin.");
        var now = DateTime.UtcNow;
        var subscribed = await db.BusinessSubscriptions.AnyAsync(s => s.BusinessId == id && !s.IsDeleted && s.IsActive &&
            s.Status == SubscriptionStatus.Active && s.StartDate <= now && s.EndDate > now &&
            (!s.IsTrial || (s.TrialEndsAt.HasValue && s.TrialEndsAt > now)) &&
            (business.Status != BusinessStatus.Trial || s.IsTrial), ct);
        if (!subscribed) return new(app, "Deneme süreniz veya aboneliğiniz sona ermiş. Devam etmek için aboneliğinizi yenileyin.");
        return app == null ? new(null, "İşletmenizin mobil uygulaması henüz hazırlanmamış.") : new(app, null);
    }
}
