using Npgsql;
using Platform.Provisioning;

internal static class ProductionPermissionsFixture
{
    public static async Task RunAsync(string connection)
    {
        static void Check(bool value, string message)
        {
            if (!value) throw new Exception("FAILED: " + message);
            Console.WriteLine("PASS: " + message);
        }
        var root = new DirectoryInfo(AppContext.BaseDirectory);
        while (root != null && !File.Exists(Path.Combine(root.FullName, "infra/production/runtime-security-grants.sql"))) root = root.Parent;
        if (root == null) throw new Exception("Run the integration checks from the complete source checkout.");
        var sql = await File.ReadAllTextAsync(Path.Combine(root.FullName, "infra/production/runtime-security-grants.sql"));
        var suffix = Guid.NewGuid().ToString("N");
        var saas = "probe_saas_" + suffix; var worker = "probe_worker_" + suffix; var reader = "probe_reader_" + suffix;
        await using var admin = new NpgsqlConnection(connection); await admin.OpenAsync();
        async Task Execute(string text) { await using var command = new NpgsqlCommand(text, admin); await command.ExecuteNonQueryAsync(); }
        await Execute($"CREATE ROLE {saas} NOLOGIN; CREATE ROLE {worker} NOLOGIN; CREATE ROLE {reader} NOLOGIN;");
        try
        {
            // The integration queue initializes its own tables; this external bootstrap marker is only read by runtime hosts.
            await Execute("CREATE SCHEMA IF NOT EXISTS platform_bootstrap; CREATE TABLE IF NOT EXISTS platform_bootstrap.queue_state(singleton boolean PRIMARY KEY);");
            await Execute(sql.Replace("platform_saas", saas).Replace("platform_worker", worker).Replace("platform_reader", reader));
            var limited = new NpgsqlConnectionStringBuilder(connection) { Options = "-c role=" + saas, Pooling = false };
            await using var portal = new TenantDomainRegistry(limited.ConnectionString);
            await using var owner = new TenantDomainRegistry(connection);
            var request = new TenantDomainRequest(Guid.NewGuid(), Guid.NewGuid().ToString("N"), Guid.NewGuid(), "role-" + suffix,
                "shop.runtime-permissions.example.net", "manage.shop.runtime-permissions.example.net");
            await portal.CreateAsync(request);
            var lease = await owner.ClaimAsync(request.DeploymentId, default) ?? throw new Exception("Missing owned fixture claim.");
            await owner.CompleteCheckAsync(lease, new TenantDomainAccess(Guid.NewGuid().ToString("N"), "runtime-permissions.example.net"), default);
            await Execute($"UPDATE platform_provisioning.domain_requests SET error_code='DomainProofMissing' WHERE id='{request.Id:D}';");
            Check(await portal.RequestVerificationAsync(request.Id, request.OwnerSubject), "The actual Production portal role can request TXT verification after a failed proof");
            var queued = await portal.GetAsync(request.Id, request.OwnerSubject);
            Check(queued is { VerificationRequested: true, ErrorCode: null }, "The limited portal role clears the previous proof error without taking a worker claim");
            await using var restricted = new NpgsqlConnection(limited.ConnectionString); await restricted.OpenAsync();
            async Task Denied(string text, string message)
            {
                try { await using var command = new NpgsqlCommand(text, restricted); await command.ExecuteNonQueryAsync(); }
                catch (PostgresException error) when (error.SqlState == "42501") { Check(true, message); return; }
                throw new Exception("FAILED: " + message);
            }
            await Denied($"UPDATE platform_provisioning.domain_requests SET state='Verified' WHERE id='{request.Id:D}'", "The Production portal role cannot certify its own domain proof");
            await Denied($"UPDATE platform_provisioning.domain_requests SET challenge='forged' WHERE id='{request.Id:D}'", "The Production portal role cannot replace the ownership challenge");
            await Denied("CREATE TABLE platform_provisioning.forbidden_runtime_table(id integer)", "The Production portal role receives no schema creation permission");
        }
        finally
        {
            await Execute($"DROP OWNED BY {saas},{worker},{reader}; DROP ROLE {saas},{worker},{reader};");
        }
    }
}
