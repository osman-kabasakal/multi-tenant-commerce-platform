using Core.Models.Persistence;
using Core.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Exceptions;
using SaasManager.Domain.Common;
using SaasManager.Domain.Events;

namespace SaasManager.Infrastructure.Data.Interceptors;

public class ConcurrencyHandlingInterceptor(
    ILogger<ConcurrencyHandlingInterceptor> logger,
    IServiceProvider serviceProvider)
    : SaveChangesInterceptor
{
    private readonly ILogger<ConcurrencyHandlingInterceptor> _logger = logger;

    public override async ValueTask<InterceptionResult<int>> SavingChangesAsync(
        DbContextEventData eventData, 
        InterceptionResult<int> result, 
        CancellationToken cancellationToken = default)
    {
        try
        {
            return await base.SavingChangesAsync(eventData, result, cancellationToken);
        }
        catch (DbUpdateConcurrencyException ex)
        {
            var resolution = await HandleConcurrencyConflictAsync(eventData.Context, ex, cancellationToken);
            
            if (resolution.IsResolved)
            {
                // Çözülen çakışmalar için domain event yayınla
                foreach (var entry in ex.Entries)
                {
                    if (entry.Entity is BaseEntity entity)
                    {
                        entity.AddDomainEvent(new ConcurrencyConflictResolvedEvent(
                            entity.Id,
                            entry.Metadata.Name,
                            resolution.Message));
                    }
                }

                // İşlemi tekrar dene
                return await base.SavingChangesAsync(eventData, result, cancellationToken);
            }

            // Çözülemeyen çakışmalar için özel exception fırlat
            throw new UnresolvedConcurrencyConflictException(
                "Concurrency conflicts could not be automatically resolved.",
                resolution.Conflicts);
        }
    }

    private async Task<ConflictResolutionResult> HandleConcurrencyConflictAsync(
        DbContext? context,
        DbUpdateConcurrencyException exception,
        CancellationToken cancellationToken)
    {
        if (context == null) 
            throw new ArgumentNullException(nameof(context));

        foreach (var entry in exception.Entries)
        {
            var resolverType = typeof(IConcurrencyConflictResolver<>)
                .MakeGenericType(entry.Entity.GetType());

            var resolver = serviceProvider.GetService(resolverType) as dynamic;

            if (resolver == null)
            {
                entry.OriginalValues.SetValues(entry.CurrentValues);
                continue;
            }

            var databaseValues = await entry.GetDatabaseValuesAsync(cancellationToken);
                
            if (databaseValues == null)
            {
                throw new Exception(
                    $"The record of type {entry.Entity.GetType().Name} was deleted by another user.");
            }

            // Resolver'ı çağır
            ConflictResolutionResult resolution = await resolver.ResolveConflictAsync(
                entry.Entity,
                databaseValues,
                cancellationToken);

            if (resolution.IsResolved)
            {
                // Çözüm stratejisine göre değerleri güncelle
                switch (resolution.Strategy)
                {
                    case ConflictResolutionStrategy.UseProposed:
                        entry.OriginalValues.SetValues(entry.CurrentValues);
                        break;

                    case ConflictResolutionStrategy.UseDatabase:
                        entry.CurrentValues.SetValues(databaseValues);
                        break;

                    case ConflictResolutionStrategy.RequireManual:
                        throw new UnresolvedConcurrencyConflictException(
                            resolution.Message,
                            resolution.Conflicts);
                }
            }
            else
            {
                return resolution;
            }
        }

        return ConflictResolutionResult.Resolved();
    }
}
