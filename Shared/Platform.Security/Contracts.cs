namespace Platform.Security;

public interface ITenantEncryptionService
{
    Task<string> EncryptAsync(string plainText, string keyName);
    Task<string> DecryptAsync(string cipherText, string keyName);
    Task<string> EncryptWithHybridMethod(string plainText, string keyName);
    Task<string> DecryptWithHybridMethod(string cipherText, string keyName);
}

/// <summary>Trusted server-side access only. Never expose this API directly to browsers/mobile clients.</summary>
public interface ISecretStore
{
    Task<string?> FindAsync(string scope, string name, CancellationToken cancellationToken = default);
    Task<string> GetAsync(string scope, string name, CancellationToken cancellationToken = default);
    Task SetAsync(string scope, string name, string value, CancellationToken cancellationToken = default);
    Task<string> GetOrCreateAsync(string scope, string name, Func<string> generate, CancellationToken cancellationToken = default);
}

public interface ITenantSecrets
{
    Task ProvisionAsync(string tenantId, string alias, CancellationToken cancellationToken = default);
    Task BindAliasAsync(string tenantIdOrAlias, string alias, CancellationToken cancellationToken = default);
    Task<string> ResolveAsync(string tenantIdOrAlias, CancellationToken cancellationToken = default);
    Task<string> GetAsync(string tenantIdOrAlias, string name, CancellationToken cancellationToken = default);
    Task SetAsync(string tenantIdOrAlias, string name, string value, CancellationToken cancellationToken = default);
    Task<string> GetOrCreateAsync(string tenantIdOrAlias, string name, Func<string> generate, CancellationToken cancellationToken = default);
}

public static class TenantSecretNames
{
    public const string FrontendApi = "frontend-api";
    public const string BackendApi = "backend-api";
    public const string DatabaseConnection = "database-connection";
    public const string InitialPassword = "initial-password";
    public const string BackendUserPassword = "backend-user-password";
    public const string KeycloakClient = "keycloak-client";
    public const string AndroidSigningKey = "android-signing-key";
}
