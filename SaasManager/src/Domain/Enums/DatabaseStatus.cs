namespace SaasManager.Domain.Enums;

public enum DatabaseStatus
{
    Created = 0,
    Initializing = 1,
    Migrating = 2,
    Ready = 3,
    ConnectionError = 4,
    MigrationError = 5,
    Maintenance = 6,
    Suspended = 7
}
