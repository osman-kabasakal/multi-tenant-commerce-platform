using Core.Models.Persistence;
using Core.Persistence;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;

namespace SaasManager.Infrastructure.Persistence.ConcurrencyResolvers;

public class BusinessConflictResolver(
    ILogger<BusinessConflictResolver> logger,
    ICurrentUserService currentUserService)
    : IConcurrencyConflictResolver<Business>
{
    private static readonly HashSet<string> AutoResolvableProperties = new()
    {
        nameof(Business.Phone), nameof(Business.Email), nameof(Business.Address)
    };

    private static readonly HashSet<string> CriticalProperties = new()
    {
        nameof(Business.TaxNumber), nameof(Business.Status), nameof(Business.IsActive)
    };

    public async Task<ConflictResolutionResult> ResolveConflictAsync(
        Business current,
        PropertyValues databaseValues,
        CancellationToken cancellationToken = default)
    {
        var conflicts = new Dictionary<string, (object? CurrentValue, object? DatabaseValue)>();
        var databaseEntity = databaseValues.ToObject() as Business;

        if (databaseEntity == null)
            throw new InvalidOperationException("Database values could not be converted to Business entity.");

        // İş kurallarına göre çatışmaları değerlendir
        foreach (var property in typeof(Business).GetProperties())
        {
            var currentValue = property.GetValue(current);
            var databaseValue = property.GetValue(databaseEntity);

            if (Equals(currentValue, databaseValue))
                continue;

            conflicts.Add(property.Name, (currentValue, databaseValue));
        }

        if (!conflicts.Any())
            return ConflictResolutionResult.Resolved();

        // Sadece auto-resolvable propertyler çakışıyorsa
        if (conflicts.Keys.All(k => AutoResolvableProperties.Contains(k)))
        {
            logger.LogInformation(
                "Auto-resolving conflicts for Business {BusinessId}. User: {UserId}",
                current.Id, currentUserService.UserId);

            return ConflictResolutionResult.Resolved(
                "Non-critical property conflicts were automatically resolved.");
        }

        // Kritik property'lerde çakışma varsa
        if (conflicts.Keys.Any(k => CriticalProperties.Contains(k)))
        {
            logger.LogWarning(
                "Critical property conflicts detected for Business {BusinessId}. User: {UserId}",
                current.Id, currentUserService.UserId);

            return ConflictResolutionResult.Unresolved(conflicts,
                "Critical property conflicts require manual resolution.");
        }

        // Diğer durumlar için business rule'lara göre karar ver
        return await ResolveByBusinessRulesAsync(current, databaseEntity, conflicts);
    }

    private Task<ConflictResolutionResult> ResolveByBusinessRulesAsync(
        Business current,
        Business database,
        Dictionary<string, (object? CurrentValue, object? DatabaseValue)> conflicts)
    {
        // Status değişikliklerini kontrol et
        if (conflicts.ContainsKey(nameof(Business.Status)))
        {
            var currentStatus = conflicts[nameof(Business.Status)].CurrentValue as BusinessStatus?;
            var dbStatus = (BusinessStatus?)conflicts[nameof(Business.Status)].DatabaseValue;

            // Örnek business rule: Aktif statüye geçişler her zaman öncelikli
            if (currentStatus == BusinessStatus.Active && dbStatus != BusinessStatus.Active)
            {
                return Task.FromResult(ConflictResolutionResult.Resolved(
                    "Status change to Active takes precedence."));
            }
        }

        // Subscription ile ilgili değişiklikleri kontrol et
        if (conflicts.ContainsKey(nameof(Business.Subscriptions)))
        {
            // Subscription değişikliklerinde son yapılan değişiklik geçerli olsun
            var currentSubscription = current.Subscriptions.OrderByDescending(s => s.CreatedAt).First();
            var dbSubscription = database.Subscriptions.OrderByDescending(s => s.CreatedAt).First();

            if (currentSubscription.CreatedAt > dbSubscription.CreatedAt)
            {
                return Task.FromResult(ConflictResolutionResult.Resolved(
                    "Most recent subscription change takes precedence."));
            }
        }

        // Çözülemeyen durumlar için manuel müdahale gerekli
        return Task.FromResult(ConflictResolutionResult.Unresolved(conflicts));
    }
}
