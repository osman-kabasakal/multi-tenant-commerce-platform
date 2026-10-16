using System.Diagnostics;
using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Npgsql;
using Platform.Provisioning;
using Platform.Security;
using System.Security.Cryptography;

static void Check(bool condition, string description)
{
    if (!condition) throw new Exception("FAILED: " + description);
    Console.WriteLine("PASS: " + description);
}
static async Task Reject<T>(Func<Task> action, string description) where T : Exception
{
    try { await action(); } catch (T) { Check(true, description); return; }
    throw new Exception("FAILED: " + description);
}
using var config = JsonDocument.Parse(await File.ReadAllTextAsync(args[0]));
var configuredConnection = config.RootElement.GetProperty("PlatformSecurity").GetProperty("ConnectionString").GetString()!;
if (args.Length > 1 && args[1] == "ios-child") return await IosReleaseQueueFixture.ReadChildAsync(configuredConnection,args[2]);
if (args.Length > 1 && args[1] == "child")
{
    await using var childQueue = new PostgresProvisioningQueue(configuredConnection);
    var childJob = await childQueue.GetAsync(args[2]);
    if (childJob?.Steps.ContainsKey("database") != true) return 7;
    return 0;
}

// Own only a unique disposable database; never touch application tables.
var admin = new NpgsqlConnectionStringBuilder(configuredConnection) { Database = "postgres" };
var name = "provisioning_test_" + Guid.NewGuid().ToString("N");
await using var adminDb = new NpgsqlConnection(admin.ConnectionString);
await adminDb.OpenAsync();
await using (var create = new NpgsqlCommand($"CREATE DATABASE {name}", adminDb)) await create.ExecuteNonQueryAsync();
var test = new NpgsqlConnectionStringBuilder(configuredConnection) { Database = name };
var childConfigPath = Path.Combine(Path.GetTempPath(), name + ".json");
try
{
    await using var queue = new PostgresProvisioningQueue(test.ConnectionString);
    await Task.WhenAll(Enumerable.Range(0, 8).Select(_ => queue.InitializeAsync()));
    Check(true, "Concurrent schema initialization");
    var request = new TenantProvisioningRequest(Guid.NewGuid().ToString("N"), "test-shop", "Test Shop", "owner@example.test", "Demo", "Owner", "Street", "000", "owner@example.test");
    await Task.WhenAll(Enumerable.Range(0, 32).Select(_ => queue.EnqueueAsync(request)));
    await using var db = new NpgsqlConnection(test.ConnectionString);
    await db.OpenAsync();
    await using (var count = new NpgsqlCommand("SELECT count(*) FROM platform_provisioning.jobs", db))
        Check((long)(await count.ExecuteScalarAsync())! == 1, "Concurrent registration creates one durable job");
    await Reject<ProvisioningConflictException>(() => queue.EnqueueAsync(request with { StoreName = "Hijacked" }), "Changed request cannot replace an existing job");
    await Reject<ProvisioningConflictException>(() => queue.EnqueueAsync(request with { TenantId = Guid.NewGuid().ToString("N") }), "Tenant slug cannot be claimed by a different business");
    await Reject<ArgumentException>(() => queue.EnqueueAsync(request with { Slug = "../unsafe" }), "Unsafe tenant identifiers rejected");
    var claims = await Task.WhenAll(Enumerable.Range(0, 12).Select(_ => queue.ClaimAsync(TimeSpan.FromSeconds(30))));
    Check(claims.Count(x => x != null) == 1, "Multiple workers obtain only one active lease");
    var lease = claims.Single(x => x != null)!;
    await queue.CheckpointAsync(lease, "database", new("Mongo", new Dictionary<string, string> { ["name"] = "tenant_database" }));
    await File.WriteAllTextAsync(childConfigPath, JsonSerializer.Serialize(new { PlatformSecurity = new { ConnectionString = test.ConnectionString } }));
    if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(childConfigPath, UnixFileMode.UserRead | UnixFileMode.UserWrite);
    var start = new ProcessStartInfo("dotnet") { UseShellExecute = false };
    foreach (var arg in new[] { typeof(Program).Assembly.Location, childConfigPath, "child", request.TenantId }) start.ArgumentList.Add(arg);
    using (var process = Process.Start(start)!)
    {
        using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(30));
        await process.WaitForExitAsync(deadline.Token);
        Check(process.ExitCode == 0, "Independent process reads persisted checkpoints");
    }
    await Reject<ProvisioningLeaseLostException>(() => queue.RenewAsync(lease with { Token = Guid.NewGuid() }, TimeSpan.FromSeconds(30)), "Foreign worker cannot renew lease");
    await using (var expire = new NpgsqlCommand("UPDATE platform_provisioning.jobs SET lease_until=now()-interval '1 second'", db)) await expire.ExecuteNonQueryAsync();
    var recovered = (await queue.ClaimAsync(TimeSpan.FromSeconds(30)))!;
    Check(recovered.Token != lease.Token && recovered.Job.Attempts == 2, "Worker crash allows a fresh fenced lease");
    await Reject<ProvisioningLeaseLostException>(() => queue.CheckpointAsync(lease, "wrong", new("none", new Dictionary<string, string>())), "Stale worker cannot overwrite recovered checkpoints");
    await Reject<ProvisioningLeaseLostException>(() => queue.CompleteAsync(lease), "Stale worker cannot complete recovered job");
    await Reject<ProvisioningLeaseLostException>(() => queue.FailAsync(lease, "wrong", 1), "Stale worker cannot fail recovered job");
    var first = new CountingStep("database");
    var flaky = new FlakyStep();
    using var services = new ServiceCollection().AddSingleton<IProvisioningStep>(first).AddSingleton<IProvisioningStep>(flaky).BuildServiceProvider();
    using var worker = new ProvisioningWorker(queue, services.GetRequiredService<IServiceScopeFactory>(), new() { MaxAttempts = 1 }, NullLogger<ProvisioningWorker>.Instance);
    await worker.RunAsync(recovered, default);
    var failed = (await queue.GetAsync(request.TenantId))!;
    Check(failed.State == "Failed" && failed.ErrorCode == "firebase:InvalidOperationException", "Step failure is durable and exposes only a safe error code");
    Check(first.Calls == 0, "Completed steps are skipped after recovery");
    Check(await queue.RetryAsync(request.TenantId), "Failed job can be explicitly retried");
    var retried = (await queue.ClaimAsync(TimeSpan.FromSeconds(30)))!;
    await worker.RunAsync(retried, default);
    var complete = (await queue.GetAsync(request.TenantId))!;
    Check(complete.State == "Succeeded" && complete.Steps.Count == 2 && flaky.Calls == 2, "Retry resumes missing steps and completes");
    Check(!await queue.RetryAsync(request.TenantId), "Succeeded job cannot be silently reset");
    Check((await queue.EnqueueAsync(request)).State == "Succeeded", "Repeated registration preserves completed resources");
    await using var row = new NpgsqlCommand("SELECT row_to_json(jobs)::text FROM platform_provisioning.jobs", db);
    var stored = (string)(await row.ExecuteScalarAsync())!;
    Check(!stored.Contains("provider-response-secret") && !stored.Contains("Password") && !stored.Contains("ConnectionString"), "Durable payload contains no credentials or exception bodies");
    var master = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));
    using var originalSecrets = new PostgresSecretStore(test.ConnectionString, new LocalEncryptionService(master), true);
    await originalSecrets.InitializeAsync();
    await originalSecrets.SetAsync("compatibility", "sample", "existing-value");
    await using var beforeCommand = new NpgsqlCommand("SELECT ciphertext FROM platform_security.secrets WHERE scope='compatibility'", db);
    var beforeCipher = (string)(await beforeCommand.ExecuteScalarAsync())!;
    using var portableSecrets = new PostgresSecretStore(test.ConnectionString, new PortableEncryptionService(master), false, true);
    await portableSecrets.InitializeAsync();
    Check(await portableSecrets.GetAsync("compatibility", "sample") == "existing-value", "Portable provider reads an existing encrypted PostgreSQL store");
    Check((string)(await beforeCommand.ExecuteScalarAsync())! == beforeCipher, "Portable reader initialization leaves stored ciphertext unchanged");
    var guardedRequest=request with {TenantId=Guid.NewGuid().ToString("N"),Slug="guarded-shop"};
    await queue.EnqueueAsync(guardedRequest);
    var guardedLease=(await queue.ClaimAsync(TimeSpan.FromSeconds(30)))!;
    await queue.CheckpointAsync(guardedLease,"finished",new("test",new Dictionary<string,string>()));
    var guardedJob=(await queue.GetAsync(guardedRequest.TenantId))!;
    var completedStep=new CountingStep("finished");var guard=new RejectingGuard();
    using var guardedServices=new ServiceCollection().AddSingleton<IProvisioningStep>(completedStep).AddSingleton<IProvisioningGuard>(guard).BuildServiceProvider();
    using var guardedWorker=new ProvisioningWorker(queue,guardedServices.GetRequiredService<IServiceScopeFactory>(),new(){MaxAttempts=1},NullLogger<ProvisioningWorker>.Instance);
    await guardedWorker.RunAsync(guardedLease with {Job=guardedJob},default);
    var rejected=(await queue.GetAsync(guardedRequest.TenantId))!;
    Check(guard.Calls==1 && completedStep.Calls==0 && rejected.State=="Failed" && rejected.ErrorCode=="pipeline:InvalidOperationException",
        "Deployment guards run before checkpoint-only replay and prevent false completion");
    await IosReleaseQueueFixture.RunAsync(queue,test.ConnectionString,childConfigPath,request);
    Console.WriteLine("Durable provisioning integration checks passed.");
}
finally
{
    File.Delete(childConfigPath);
    NpgsqlConnection.ClearAllPools();
    await using var drop = new NpgsqlCommand($"DROP DATABASE {name} WITH (FORCE)", adminDb);
    await drop.ExecuteNonQueryAsync();
}
return 0;

sealed class CountingStep(string name) : IProvisioningStep
{
    public int Calls;
    public string Name => name;
    public Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken cancellationToken)
    {
        Calls++;
        return Task.FromResult(new ProvisioningStepResult("test", new Dictionary<string, string>()));
    }
}
sealed class FlakyStep : IProvisioningStep
{
    public int Calls;
    public string Name => "firebase";
    public Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken cancellationToken)
    {
        Calls++;
        if (Calls == 1) throw new InvalidOperationException("provider-response-secret");
        return Task.FromResult(new ProvisioningStepResult("test", new Dictionary<string, string>()));
    }
}

sealed class RejectingGuard:IProvisioningGuard
{
    public int Calls;
    public Task ValidateAsync(TenantProvisioningRequest request,IReadOnlyDictionary<string,ProvisioningStepResult> completed,CancellationToken ct)
    {Calls++;throw new InvalidOperationException("provider-response-secret");}
}
