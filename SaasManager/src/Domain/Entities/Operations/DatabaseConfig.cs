using SaasManager.Domain.Entities.Organization;

namespace SaasManager.Domain.Entities.Operations;

public class DatabaseConfig : AuditableEntity
{
    public Guid BusinessId { get; private set; }
    public string InstanceName { get; private set; } = null!;
    public string Host { get; private set; } = null!;
    public int Port { get; private set; }
    public string DatabaseName { get; private set; } = null!;
    public string Username { get; private set; } = null!;
    public string EncryptedPassword { get; private set; } = null!;
    public bool IsMigrated { get; private set; }
    public DateTime? LastMigrationDate { get; private set; }
    public DateTime? LastConnectionTest { get; private set; }
    public string ConnectionString { get; private set; } = null!;
    public DatabaseStatus Status { get; private set; }

    // Navigation Property
    public Business Business { get; private set; } = null!;

    // Constructor for EF Core
    protected DatabaseConfig() { }

    public DatabaseConfig(
        Guid businessId,
        string instanceName,
        string host,
        int port,
        string databaseName,
        string username,
        string encryptedPassword)
    {
        BusinessId = businessId;
        InstanceName = instanceName;
        Host = host;
        Port = port;
        DatabaseName = databaseName;
        Username = username;
        EncryptedPassword = encryptedPassword;
        Status = DatabaseStatus.Created;
        IsMigrated = false;
        ConnectionString = GenerateConnectionString();
        CreatedAt = DateTime.UtcNow;
        IsActive = true;
    }

    // Domain methods
    private string GenerateConnectionString()
    {
        return $"Server={Host};Port={Port};Database={DatabaseName};User Id={Username};";
    }

    public void UpdateConnectionInfo(
        string host,
        int port,
        string username,
        string encryptedPassword)
    {
        Host = host;
        Port = port;
        Username = username;
        EncryptedPassword = encryptedPassword;
        ConnectionString = GenerateConnectionString();
        UpdatedAt = DateTime.UtcNow;
    }

    public void MarkAsMigrated()
    {
        IsMigrated = true;
        LastMigrationDate = DateTime.UtcNow;
        Status = DatabaseStatus.Ready;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateLastConnectionTest(bool successful)
    {
        LastConnectionTest = DateTime.UtcNow;
        Status = successful ? DatabaseStatus.Ready : DatabaseStatus.ConnectionError;
        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateStatus(DatabaseStatus newStatus)
    {
        Status = newStatus;
        UpdatedAt = DateTime.UtcNow;
    }

    public bool IsReady()
    {
        return Status == DatabaseStatus.Ready && IsMigrated && IsActive;
    }

    public void SetConnectionString(string connectionString)
    {
        ConnectionString = connectionString;
    }

    public void SetBusiness(Business business)
    {
        BusinessId= business.Id;
        Business = business;
    }
}
