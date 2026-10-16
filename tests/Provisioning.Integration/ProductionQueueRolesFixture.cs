using System.Diagnostics;
using System.Text.Json;
using System.Text.RegularExpressions;
using Npgsql;

// Execute the actual installer grants with unique test-role names, inside only the fixture database.
internal sealed class ProductionQueueRolesFixture(string ownerConnection, string[] roles) : IAsyncDisposable
{
    public string WorkerConnection => Connection(roles[1]);
    public string SaasConnection => Connection(roles[0]);
    private string Connection(string role) => new NpgsqlConnectionStringBuilder(ownerConnection) { Options = "-c role=" + role, Pooling = false }.ConnectionString;
    public static async Task<ProductionQueueRolesFixture> CreateAsync(string connection)
    {
        var suffix = Guid.NewGuid().ToString("N")[..16];
        var roles = new[] { "ios_fixture_saas_" + suffix, "ios_fixture_worker_" + suffix, "ios_fixture_reader_" + suffix };
        var result = new ProductionQueueRolesFixture(connection, roles);
        var grant = await InstallerGrantsAsync();
        foreach (var (original, index) in new[] { ("platform_saas", 0), ("platform_worker", 1), ("platform_reader", 2) })
            grant = Regex.Replace(grant, "\\b" + original + "\\b", roles[index]);
        await using var db = new NpgsqlConnection(connection); await db.OpenAsync();
        await using var transaction = await db.BeginTransactionAsync();
        foreach (var role in roles)
        {
            // The identifier is generated here from fixed lowercase ASCII and a hexadecimal nonce.
            await using var create = new NpgsqlCommand("CREATE ROLE " + role + " NOLOGIN", db, transaction); await create.ExecuteNonQueryAsync();
        }
        // This queue-only fixture needs a marker table solely because the real installer grants runtime reads to it.
        await using (var markers = new NpgsqlCommand("CREATE SCHEMA IF NOT EXISTS platform_bootstrap; CREATE TABLE IF NOT EXISTS platform_bootstrap.queue_state(singleton integer PRIMARY KEY)", db, transaction))
            await markers.ExecuteNonQueryAsync();
        await using (var permissions = new NpgsqlCommand(grant, db, transaction)) await permissions.ExecuteNonQueryAsync();
        await transaction.CommitAsync();
        foreach (var (target, role) in new[] { (result.SaasConnection, roles[0]), (result.WorkerConnection, roles[1]) })
        {
            await using var actor = new NpgsqlConnection(target); await actor.OpenAsync();
            await using var query = new NpgsqlCommand("SELECT current_user", actor);
            if ((string)(await query.ExecuteScalarAsync())! != role) throw new InvalidOperationException("The runtime role fixture did not assume its restricted role.");
        }
        Console.WriteLine("PASS: The actual installer grants are applied to isolated non-superuser SaaS and worker roles");
        return result;
    }
    private static async Task<string> InstallerGrantsAsync()
    {
        var root = new DirectoryInfo(AppContext.BaseDirectory);
        while (root != null && !File.Exists(Path.Combine(root.FullName, "scripts", "production.py"))) root = root.Parent;
        if (root == null) throw new InvalidOperationException("The production grant fixture requires the source checkout.");
        var start = new ProcessStartInfo("python3") { RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false };
        start.ArgumentList.Add("-B"); start.ArgumentList.Add("-c"); start.ArgumentList.Add("""
            import json,sys
            sys.path.insert(0,sys.argv[1])
            import production
            class Collector:
                def __init__(self): self.grants=[]
                def sql(self,value,database='postgres'):
                    if database=='platform_security': self.grants.append(value)
            collector=Collector()
            production.Deployment.grant_runtime(collector)
            assert len(collector.grants)==1
            print(json.dumps(collector.grants[0]))
            """);
        start.ArgumentList.Add(Path.Combine(root.FullName, "scripts"));
        using var process = Process.Start(start)!; using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(30));
        var output = process.StandardOutput.ReadToEndAsync(timeout.Token); var errors = process.StandardError.ReadToEndAsync(timeout.Token);
        try
        {
            await process.WaitForExitAsync(timeout.Token); var json = await output; await errors;
            if (process.ExitCode != 0) throw new InvalidOperationException("The installer grant collector could not run.");
            return JsonSerializer.Deserialize<string>(json) ?? throw new InvalidOperationException("The installer grant collector returned no SQL.");
        }
        finally
        {
            if (!process.HasExited) { process.Kill(entireProcessTree: true); await process.WaitForExitAsync(); }
        }
    }
    public async ValueTask DisposeAsync()
    {
        await using var db = new NpgsqlConnection(ownerConnection); await db.OpenAsync();
        foreach (var role in roles)
        {
            await using var drop = new NpgsqlCommand("DROP OWNED BY " + role + "; DROP ROLE " + role, db); await drop.ExecuteNonQueryAsync();
        }
    }
}
