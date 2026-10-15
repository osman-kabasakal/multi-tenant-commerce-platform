using Npgsql;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace Platform.Security;

public sealed class PostgresSecretStore : ISecretStore, ITenantSecrets, IDisposable
{
    private readonly NpgsqlDataSource _source;
    private readonly ITenantEncryptionService _encryption;
    private readonly bool _initializeSchema;
    private readonly bool _readOnly;
    private readonly SemaphoreSlim _readyLock = new(1,1);
    private bool _ready;
    private sealed record SecretValue(string Scope, string Name, string Value);
    public PostgresSecretStore(string connectionString, ITenantEncryptionService encryption, bool initializeSchema = false, bool readOnly = false)
    {
        _source = NpgsqlDataSource.Create(connectionString);
        _encryption = encryption; _initializeSchema = initializeSchema; _readOnly = readOnly;
        if (readOnly && initializeSchema) throw new ArgumentException("Readers cannot initialize the secret schema.");
    }
    public void Dispose() { _source.Dispose(); _readyLock.Dispose(); }
    private static void Validate(string value)
    {
        if (string.IsNullOrWhiteSpace(value) || value.Length > 160 || !Regex.IsMatch(value, "^[a-zA-Z0-9_-]+$"))
            throw new ArgumentException("Invalid secret scope, name or tenant identifier.");
    }
    private void RequireWriter()
    {
        if (_readOnly) throw new UnauthorizedAccessException("This service has read-only secret access.");
    }
    private static NpgsqlCommand Command(NpgsqlConnection connection, string sql, params object[] args)
    {
        var command = new NpgsqlCommand(sql, connection);
        foreach(var arg in args) command.Parameters.Add(new NpgsqlParameter { Value = arg });
        return command;
    }
    public async Task InitializeAsync(CancellationToken ct = default)
    {
        if (_ready) return;
        await _readyLock.WaitAsync(ct);
        try
        {
            if (_ready) return;
            await using var connection = await _source.OpenConnectionAsync(ct);
            if (_initializeSchema)
            {
                await using var transaction = await connection.BeginTransactionAsync(ct);
                await using var schema = Command(connection, """
                    SELECT pg_advisory_xact_lock(778234919);
                    CREATE SCHEMA IF NOT EXISTS platform_security;
                    CREATE TABLE IF NOT EXISTS platform_security.secrets (
                        scope text NOT NULL, name text NOT NULL, ciphertext text NOT NULL,
                        updated_at timestamptz NOT NULL DEFAULT now(), PRIMARY KEY(scope,name));
                    CREATE TABLE IF NOT EXISTS platform_security.tenants (id text PRIMARY KEY);
                    CREATE TABLE IF NOT EXISTS platform_security.aliases (
                        alias text PRIMARY KEY, tenant_id text NOT NULL REFERENCES platform_security.tenants(id));
                    """);
                await schema.ExecuteNonQueryAsync(ct);
                var probe = await Encrypt("system", "deployment-probe", "platform-security-v1");
                await using var insert = Command(connection,
                    "INSERT INTO platform_security.secrets(scope,name,ciphertext) VALUES('system','deployment-probe',$1) ON CONFLICT DO NOTHING", probe);
                await insert.ExecuteNonQueryAsync(ct);
                await transaction.CommitAsync(ct);
            }
            await using var get = Command(connection,
                "SELECT ciphertext FROM platform_security.secrets WHERE scope='system' AND name='deployment-probe'");
            var stored = await get.ExecuteScalarAsync(ct) as string ?? throw new InvalidOperationException("Initialize the shared secret schema before starting services.");
            if (await Decrypt("system", "deployment-probe", stored) != "platform-security-v1")
                throw new CryptographicException("Secret store deployment key mismatch.");
            _ready = true;
        }
        finally { _readyLock.Release(); }
    }
    private Task<string> Encrypt(string scope,string name,string value) =>
        _encryption.EncryptAsync(JsonSerializer.Serialize(new SecretValue(scope,name,value)), scope);
    private async Task<string> Decrypt(string scope,string name,string cipher)
    {
        var record = JsonSerializer.Deserialize<SecretValue>(await _encryption.DecryptAsync(cipher,scope));
        if(record is null || record.Scope != scope || record.Name != name)
            throw new CryptographicException("Secret record context mismatch.");
        return record.Value;
    }
    public async Task<string?> FindAsync(string scope,string name,CancellationToken cancellationToken = default)
    {
        Validate(scope); Validate(name); await InitializeAsync(cancellationToken);
        await using var connection = await _source.OpenConnectionAsync(cancellationToken);
        await using var command = Command(connection,"SELECT ciphertext FROM platform_security.secrets WHERE scope=$1 AND name=$2",scope,name);
        var cipher = await command.ExecuteScalarAsync(cancellationToken) as string;
        return cipher is null ? null : await Decrypt(scope,name,cipher);
    }
    public async Task<string> GetAsync(string scope,string name,CancellationToken cancellationToken = default) =>
        await FindAsync(scope,name,cancellationToken) ?? throw new KeyNotFoundException("Required secret has not been provisioned.");
    public async Task SetAsync(string scope,string name,string value,CancellationToken cancellationToken = default)
    {
        RequireWriter(); Validate(scope); Validate(name); ArgumentException.ThrowIfNullOrEmpty(value);
        await InitializeAsync(cancellationToken);
        var cipher = await Encrypt(scope,name,value);
        await using var connection = await _source.OpenConnectionAsync(cancellationToken);
        await using var command = Command(connection,"""
            INSERT INTO platform_security.secrets(scope,name,ciphertext) VALUES($1,$2,$3)
            ON CONFLICT(scope,name) DO UPDATE SET ciphertext=EXCLUDED.ciphertext, updated_at=now()
            """,scope,name,cipher);
        await command.ExecuteNonQueryAsync(cancellationToken);
    }
    public async Task<string> GetOrCreateAsync(string scope,string name,Func<string> generate,CancellationToken cancellationToken = default)
    {
        RequireWriter(); Validate(scope); Validate(name);
        var current = await FindAsync(scope,name,cancellationToken);
        if (current != null) return current;
        var value = generate();
        ArgumentException.ThrowIfNullOrEmpty(value);
        var cipher = await Encrypt(scope,name,value);
        await using var connection = await _source.OpenConnectionAsync(cancellationToken);
        await using var command = Command(connection,"""
            INSERT INTO platform_security.secrets(scope,name,ciphertext) VALUES($1,$2,$3)
            ON CONFLICT(scope,name) DO NOTHING
            """,scope,name,cipher);
        await command.ExecuteNonQueryAsync(cancellationToken);
        // Read the committed winner, including when another host inserted concurrently.
        return await GetAsync(scope,name,cancellationToken);
    }
    public async Task ProvisionAsync(string tenantId,string alias,CancellationToken cancellationToken = default)
    {
        RequireWriter(); Validate(tenantId); Validate(alias); await InitializeAsync(cancellationToken);
        await using var connection = await _source.OpenConnectionAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);
        await using var create = Command(connection,"INSERT INTO platform_security.tenants(id) VALUES($1) ON CONFLICT DO NOTHING",tenantId);
        await create.ExecuteNonQueryAsync(cancellationToken);
        foreach(var name in new[]{tenantId,alias}.Distinct().OrderBy(x=>x,StringComparer.Ordinal))
        {
            await using var bind = Command(connection,"INSERT INTO platform_security.aliases(alias,tenant_id) VALUES($1,$2) ON CONFLICT DO NOTHING",name,tenantId);
            await bind.ExecuteNonQueryAsync(cancellationToken);
            await using var check = Command(connection,"SELECT tenant_id FROM platform_security.aliases WHERE alias=$1",name);
            if ((string?)await check.ExecuteScalarAsync(cancellationToken) != tenantId)
                throw new InvalidOperationException("Tenant alias already belongs to another business.");
        }
        await transaction.CommitAsync(cancellationToken);
        foreach(var name in new[]{TenantSecretNames.FrontendApi,TenantSecretNames.BackendApi})
            await GetOrCreateAsync("tenant-"+tenantId,name,()=>Convert.ToBase64String(RandomNumberGenerator.GetBytes(48)),cancellationToken);
    }
    public async Task<string> ResolveAsync(string tenantIdOrAlias,CancellationToken cancellationToken = default)
    {
        Validate(tenantIdOrAlias); await InitializeAsync(cancellationToken);
        await using var connection = await _source.OpenConnectionAsync(cancellationToken);
        await using var command = Command(connection,"SELECT tenant_id FROM platform_security.aliases WHERE alias=$1",tenantIdOrAlias);
        return await command.ExecuteScalarAsync(cancellationToken) as string ?? throw new KeyNotFoundException("Tenant has not been provisioned.");
    }
    public async Task BindAliasAsync(string tenantIdOrAlias,string alias,CancellationToken cancellationToken = default) =>
        await ProvisionAsync(await ResolveAsync(tenantIdOrAlias,cancellationToken),alias,cancellationToken);
    async Task<string> ITenantSecrets.GetAsync(string tenant,string name,CancellationToken ct) =>
        await GetAsync("tenant-"+await ResolveAsync(tenant,ct),name,ct);
    async Task ITenantSecrets.SetAsync(string tenant,string name,string value,CancellationToken ct) =>
        await SetAsync("tenant-"+await ResolveAsync(tenant,ct),name,value,ct);
    async Task<string> ITenantSecrets.GetOrCreateAsync(string tenant,string name,Func<string> generate,CancellationToken ct) =>
        await GetOrCreateAsync("tenant-"+await ResolveAsync(tenant,ct),name,generate,ct);
}
