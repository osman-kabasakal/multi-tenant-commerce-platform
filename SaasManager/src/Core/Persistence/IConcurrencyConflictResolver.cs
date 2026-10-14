using Core.Models.Persistence;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Core.Persistence;

public interface IConcurrencyConflictResolver<TEntity> where TEntity : class
{
    Task<ConflictResolutionResult> ResolveConflictAsync(
        TEntity current, 
        PropertyValues databaseValues, 
        CancellationToken cancellationToken = default);
}
