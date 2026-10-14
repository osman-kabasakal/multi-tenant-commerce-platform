using System.Text.Json;
using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.Operations;

public class SystemLog : BaseEntity
{
    public Guid? BusinessId { get; private set; }
    public LogType Type { get; private set; }
    public string Message { get; private set; } = null!;
    public JsonDocument? Metadata { get; private set; } = null!;
    public LogSeverity Severity { get; private set; }
    public string? Source { get; private set; } = null!;
    public string? UserName { get; private set; } = null!;
    public string? UserRole { get; private set; } = null!;
    public string? IpAddress { get; private set; } = null!;
    public string? UserAgent { get; private set; } = null!;
    public DateTime CreatedAt { get; private set; }
    public int EventId { get; private set; }
    public string? CorrelationId { get; private set; } = null!;
    public string? Exception { get; private set; } = null!;
    public string? StackTrace { get; private set; } = null!;

    // Navigation Property
    public Business Business { get; private set; } = null!;

    // Constructor for EF Core
    protected SystemLog() { }

    public SystemLog(
        LogType type,
        string message,
        LogSeverity severity,
        Guid? businessId = null,
        JsonDocument? metadata = null,
        string? source = null,
        string? userName = null,
        string? userRole = null,
        string? ipAddress = null,
        string? userAgent = null,
        int eventId = 0,
        string? correlationId = null,
        string? exception = null,
        string? stackTrace = null)
    {
        BusinessId = businessId;
        Type = type;
        Message = message;
        Metadata = metadata;
        Severity = severity;
        Source = source;
        UserName = userName;
        UserRole = userRole;
        IpAddress = ipAddress;
        UserAgent = userAgent;
        CreatedAt = DateTime.UtcNow;
        EventId = eventId;
        CorrelationId = correlationId;
        Exception = exception;
        StackTrace = stackTrace;
    }

    // Factory methods
    public static SystemLog CreateInfoLog(
        string message,
        Guid? businessId = null,
        JsonDocument? metadata = null)
    {
        return new SystemLog(
            LogType.Info,
            message,
            LogSeverity.Information,
            businessId,
            metadata);
    }

    public static SystemLog CreateErrorLog(
        string message,
        Exception ex,
        Guid? businessId = null,
        JsonDocument? metadata = null)
    {
        return new SystemLog(
            LogType.Error,
            message,
            LogSeverity.Error,
            businessId,
            metadata,
            exception: ex.Message,
            stackTrace: ex.StackTrace);
    }

    public static SystemLog CreateSecurityLog(
        string message,
        string userName,
        string userRole,
        string ipAddress,
        Guid? businessId = null,
        JsonDocument? metadata = null)
    {
        return new SystemLog(
            LogType.Security,
            message,
            LogSeverity.Information,
            businessId,
            metadata,
            userName: userName,
            userRole: userRole,
            ipAddress: ipAddress);
    }

    public static SystemLog CreatePerformanceLog(
        string message,
        JsonDocument metrics,
        string source)
    {
        return new SystemLog(
            LogType.Performance,
            message,
            LogSeverity.Information,
            metadata: metrics,
            source: source);
    }

    // Domain methods
    public void EnrichWithCorrelation(string? correlationId)
    {
        CorrelationId = correlationId;
    }

    public void EnrichWithUserContext(string? userName, string? userRole)
    {
        UserName = userName;
        UserRole = userRole;
    }

    public void EnrichWithRequestContext(string? ipAddress, string? userAgent)
    {
        IpAddress = ipAddress;
        UserAgent = userAgent;
    }
}
