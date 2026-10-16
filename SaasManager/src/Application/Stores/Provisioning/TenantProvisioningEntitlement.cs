using Microsoft.Extensions.Configuration;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.Stores.Provisioning;

internal static class TenantProvisioningEntitlement
{
    public static async Task RequireAsync(IApplicationDbContext db, IWorkContext work, IConfiguration config,
        Guid businessId, CancellationToken ct)
    {
        var guest = work.GuestRegistration;
        if (guest == null || guest.ConvertedBusinessId != businessId)
            throw new UnauthorizedAccessException("A registered subscription owner is required.");
        var now = DateTime.UtcNow;
        var subscriptions = await (
            from subscription in db.BusinessSubscriptions
            join plan in db.SubscriptionPlans on subscription.PlanId equals plan.Id
            where subscription.BusinessId == businessId && !subscription.IsDeleted && subscription.IsActive &&
                subscription.Status == SubscriptionStatus.Active && subscription.EndDate > now && subscription.Amount >= 0 &&
                !plan.IsDeleted && plan.IsActive
            select new { subscription.PlanId, subscription.IsTrial, subscription.TrialEndsAt, subscription.StartDate,
                subscription.Amount, plan.IsPublic, plan.TrialDays }).ToListAsync(ct);
        var localTrial = config.GetValue<bool>("LocalDemo:Enabled") && config.GetValue<bool>("LocalDemo:SelfService") &&
            (config["Provisioning:Profile"] ?? "Local") == "Local";
        var portableTrial = config.GetValue<bool>("TenantOnboarding:Trial:Enabled") &&
            config["Provisioning:Profile"] == "Portable" && Guid.TryParse(config["TenantOnboarding:Trial:PlanId"], out var configuredTrial)
            ? configuredTrial : Guid.Empty;
        if (subscriptions.Any(s => s.IsTrial && s.Amount == 0 && s.StartDate <= now && s.TrialEndsAt > now &&
            s.IsPublic && s.TrialDays > 0 && (localTrial || s.PlanId == portableTrial))) return;
        // A selected/active-looking plan alone is not payment proof. Completion is written by the server payment step.
        if (subscriptions.Count > 0 && await db.PaymentSetupStates.AnyAsync(s => s.GuestId == guest.Id && !s.IsDeleted &&
            s.CompletedAt != null && s.PreAuthAmount > 0 && s.AuthorizationCode != null && s.AuthorizationCode != "", ct)) return;
        throw new UnauthorizedAccessException("An active approved trial or confirmed subscription activation is required before tenant provisioning.");
    }
}
