namespace Core.Models.Persistence;


public class ConflictResolutionResult
{
    public bool IsResolved { get; }
    public string Message { get; }
    public IDictionary<string, (object? CurrentValue, object? DatabaseValue)> Conflicts { get; }
    public ConflictResolutionStrategy Strategy { get; }

    private ConflictResolutionResult(
        bool isResolved, 
        string message, 
        IDictionary<string, (object? CurrentValue, object? DatabaseValue)> conflicts,
        ConflictResolutionStrategy strategy)
    {
        IsResolved = isResolved;
        Message = message;
        Conflicts = conflicts;
        Strategy = strategy;
    }

    public static ConflictResolutionResult Resolved(string message = "Conflict resolved automatically.", ConflictResolutionStrategy strategy = ConflictResolutionStrategy.UseProposed)
        => new(true, message, new Dictionary<string, (object?, object?)>(), strategy);

    public static ConflictResolutionResult Unresolved(
        IDictionary<string, (object? CurrentValue, object? DatabaseValue)> conflicts,
        string message = "Conflict resolution requires manual intervention.")
        => new(false, message, conflicts, ConflictResolutionStrategy.RequireManual);
}

public enum ConflictResolutionStrategy
{
    UseProposed,     // Önerilen değerleri kullan
    UseDatabase,     // Veritabanı değerlerini kullan
    RequireManual    // Manuel müdahale gerekli
}
