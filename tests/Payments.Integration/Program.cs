using System.Diagnostics;
using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Npgsql;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using SaasManager.Application.Common.Models.PaymentProviders;
using SaasManager.Application.Common.Models.Security;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Financial;
using SaasManager.Domain.Enums;
using SaasManager.Infrastructure.PaymentProviders;

static void Check(bool condition, string description)
{
    if (!condition) throw new InvalidOperationException("FAILED: " + description);
    Console.WriteLine("PASS: " + description);
}
static Process Child(string file, string mode, string? extra = null)
{
    var start = new ProcessStartInfo("dotnet") { UseShellExecute = false };
    foreach (var arg in new[] { typeof(Program).Assembly.Location, file, mode }) start.ArgumentList.Add(arg);
    if (extra != null) start.ArgumentList.Add(extra);
    return Process.Start(start) ?? throw new InvalidOperationException("Child process did not start.");
}
static async Task<int> Wait(Process child)
{
    using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(25));
    try { await child.WaitForExitAsync(deadline.Token); return child.ExitCode; }
    finally { if (!child.HasExited) { child.Kill(true); await child.WaitForExitAsync(); } }
}
var configFile = Path.GetFullPath(args[0]);
var config = new ConfigurationBuilder().AddJsonFile(configFile).Build();
if (args.Length > 1)
{
    var data = config.GetSection("Fixture").Get<Fixture>()!;
    var locks = new PostgresPaymentAttemptLock(config);
    if (args[1] is "try" or "hold")
    {
        var business = args[1] == "try" ? Guid.Parse(args[2]) : data.Business;
        await using var lease = await locks.TryAcquireAsync(business);
        if (lease == null) return 11;
        await lease.EnsureHeldAsync();
        if (args[1] == "hold") { await File.WriteAllTextAsync(args[2], "ready"); await Task.Delay(TimeSpan.FromSeconds(60)); }
        return 0;
    }
    using var secrets = new PostgresSecretStore(config["PlatformSecurity:ConnectionString"]!, new PortableEncryptionService(data.Master), false);
    await secrets.InitializeAsync();
    await using var childLease = await locks.TryAcquireAsync(data.Business) ?? throw new InvalidOperationException("Child payment lease unavailable.");
    var journal = await Open(secrets, childLease, data);
    if (args[1] == "read")
    {
        Check(journal.CurrentPhase == SubscriptionPaymentJournal.Phase.Active && journal.Receipt.PaymentId == data.Receipt,
            "Independent process resumes the original encrypted provider receipt");
        Check(journal.Card.EncryptedNumber == "nested-test-ciphertext", "Protected card metadata survives a process restart without CVV");
        return 0;
    }
    throw new InvalidOperationException("Unknown fixture mode.");
}
var original = new NpgsqlConnectionStringBuilder(config["PlatformSecurity:ConnectionString"]!);
var database = "payment_test_" + Guid.NewGuid().ToString("N");
await using var admin = new NpgsqlConnection(new NpgsqlConnectionStringBuilder(original.ConnectionString) { Database = "postgres" }.ConnectionString);
await admin.OpenAsync();
await using (var create = new NpgsqlCommand($"CREATE DATABASE {database}", admin)) await create.ExecuteNonQueryAsync();
var folder = Path.Combine(Path.GetTempPath(), database);
Directory.CreateDirectory(folder);
if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(folder, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute);
try
{
    var connection = new NpgsqlConnectionStringBuilder(original.ConnectionString) { Database = database }.ConnectionString;
    var data = new Fixture(Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid().ToString("D"),
        Guid.NewGuid().ToString("D"), Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)));
    var file = Path.Combine(folder, "fixture.json");
    await File.WriteAllTextAsync(file, JsonSerializer.Serialize(new { PlatformSecurity = new { ConnectionString = connection },
        Payments = new { ExclusiveSessionConfirmed = true }, Fixture = data }));
    if (!OperatingSystem.IsWindows()) File.SetUnixFileMode(file, UnixFileMode.UserRead | UnixFileMode.UserWrite);
    var settings = new ConfigurationBuilder().AddJsonFile(file).Build();
    var locks = new PostgresPaymentAttemptLock(settings);
    using var secrets = new PostgresSecretStore(connection, new PortableEncryptionService(data.Master), true);
    await secrets.InitializeAsync(); await secrets.ProvisionAsync(data.Business.ToString("N"), "payment-fixture");
    await using (var lease = await locks.TryAcquireAsync(data.Business) ?? throw new InvalidOperationException("Initial payment lease unavailable."))
    {
        using (var contender = Child(file, "try", data.Business.ToString("D")))
            Check(await Wait(contender) == 11, "A second process cannot initialize a payment for the same business");
        using (var other = Child(file, "try", Guid.NewGuid().ToString("D")))
            Check(await Wait(other) == 0, "A different business does not wait for another business's provider call");
        var journal = await Open(secrets, lease, data);
        await journal.BeginAsync(new EncryptedCardData { EncryptedNumber = "nested-test-ciphertext", ExpiryMonth = "09", ExpiryYear = "34" }, default);
        await journal.RecordInitializationAsync(new PaymentResponse { IsSuccess = true, InitializationOutcome = PaymentInitializationOutcome.Initialized,
            PaymentId = data.Receipt, RawResult = "{\"verified\":true}" }, default);
        await journal.RecordActiveAsync(default);
    }
    using (var reader = Child(file, "read")) Check(await Wait(reader) == 0, "A new process can acquire a released lease and resume payment");
    await using (var inspect = new NpgsqlConnection(connection))
    {
        await inspect.OpenAsync();
        await using var command = new NpgsqlCommand("SELECT ciphertext FROM platform_security.secrets WHERE name LIKE 'subscription-payment-%'", inspect);
        var ciphertext = (string)(await command.ExecuteScalarAsync())!;
        Check(!ciphertext.Contains(data.Receipt) && !ciphertext.Contains("nested-test-ciphertext"), "PostgreSQL stores an encrypted receipt rather than provider or card metadata in plaintext");
    }
    var ready = Path.Combine(folder, "ready");
    using (var crashed = Child(file, "hold", ready))
    {
        try
        {
            using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(20));
            while (!File.Exists(ready)) { if (crashed.HasExited) throw new InvalidOperationException("Holder exited early."); await Task.Delay(50, deadline.Token); }
            await using (var busy = await locks.TryAcquireAsync(data.Business)) Check(busy == null, "A separate live process retains its payment session");
        }
        finally { if (!crashed.HasExited) crashed.Kill(true); await crashed.WaitForExitAsync(); }
    }
    IPaymentAttemptLease? recovered = null;
    using (var recoveryDeadline = new CancellationTokenSource(TimeSpan.FromSeconds(5)))
        while (recovered == null) { recoveryDeadline.Token.ThrowIfCancellationRequested(); recovered = await locks.TryAcquireAsync(data.Business, recoveryDeadline.Token); if (recovered == null) await Task.Delay(50, recoveryDeadline.Token); }
    await using (recovered) Check(true, "Process loss releases the PostgreSQL session without a time-based lock override");
    await using (var terminated = await locks.TryAcquireAsync(data.Business) ?? throw new InvalidOperationException("Termination fixture lease unavailable."))
    {
        await using var killer = new NpgsqlConnection(connection); await killer.OpenAsync();
        await using var terminate = new NpgsqlCommand("""
            SELECT pg_terminate_backend(a.pid) FROM pg_stat_activity a
            WHERE a.datname=current_database() AND a.application_name='commerce-payment-lock-v1'
              AND EXISTS(SELECT 1 FROM pg_locks l WHERE l.pid=a.pid AND l.locktype='advisory' AND l.granted)
            """, killer);
        Check(await terminate.ExecuteScalarAsync() is true, "Only the held session in this unique fixture database is terminated");
        var lost = false;
        try { await terminated.EnsureHeldAsync(); } catch (Exception error) when (error is NpgsqlException or InvalidOperationException) { lost = true; }
        Check(lost, "A disconnected session cannot authorize the next payment progress write");
    }
    var unconfirmed = new PostgresPaymentAttemptLock(new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
        ["PlatformSecurity:ConnectionString"] = connection }).Build());
    var refused = false;
    try { await unconfirmed.TryAcquireAsync(data.Business); } catch (InvalidOperationException) { refused = true; }
    Check(refused, "Unconfirmed transaction-pool connectivity cannot submit merchant payments");
    Console.WriteLine("Cross-process payment integration checks passed; no merchant API was called.");
}
finally
{
    NpgsqlConnection.ClearAllPools();
    await using var drop = new NpgsqlCommand($"DROP DATABASE {database} WITH (FORCE)", admin);
    await drop.ExecuteNonQueryAsync(); Directory.Delete(folder, true);
}
return 0;

static Task<SubscriptionPaymentJournal> Open(ITenantSecrets secrets, IPaymentAttemptLease lease, Fixture data)
{
    var plan = new SubscriptionPlan("Fixture", data.Pricing, 49.95m, 1, 1, 1, false, false, JsonDocument.Parse("{}"), 0, "Fixture", 0, true, 0, 1, 0) { Id = data.Plan };
    var subscription = new BusinessSubscription(data.Business, plan.Id, DateTime.UtcNow, DateTime.UtcNow.AddMonths(1), plan.Price, PaymentPeriod.Monthly) { Id = data.Subscription };
    return SubscriptionPaymentJournal.OpenAsync(secrets, lease, data.Guest, subscription, plan, new IdentityProvider(data.Provider), default);
}
sealed record Fixture(Guid Business, Guid Guest, Guid Plan, Guid Subscription, Guid Provider, string Pricing, string Receipt, string Master);
sealed class IdentityProvider(Guid id) : IPaymentProvider
{
    public Guid Id => id; public string Code => "FIXTURE"; public string Name => "Fixture";
    public PaymentProviderType Type => PaymentProviderType.CreditCard; public bool IsActive => true;
    public string ConfigurationFingerprint => new string('a',64);
    public Task<CardTokenResponse> CreateCardTokenAsync(CardData request) => throw new NotSupportedException();
    public Task<PaymentResponse> ProcessPaymentAsync(BusinessSubscription request, CardData card) => throw new NotSupportedException();
    public Task<RefundResponse> ProcessRefundAsync(Payment request) => throw new NotSupportedException();
    public Task<bool> ValidateCardAsync(CardData request) => throw new NotSupportedException();
    public Task<bool> ActivateSubscriptionAsync(PaymentResponse payment) => throw new NotSupportedException();
}
