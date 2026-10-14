namespace SaasManager.Application.Common.Exceptions;

public class UnresolvedConcurrencyConflictException(
    string resolutionMessage,
    IDictionary<string, (object? CurrentValue, object? DatabaseValue)> resolutionConflicts)
    : Exception
{
    public string ResolutionMessage { get; set; } = resolutionMessage;
    public IDictionary<string, (object? CurrentValue, object? DatabaseValue)> ResolutionConflicts { get; set; } = resolutionConflicts;
}
