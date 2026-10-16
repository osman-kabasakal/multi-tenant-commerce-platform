using System.Diagnostics;
using Npgsql;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Platform.Provisioning;

internal static class IosReleaseQueueFixture
{
    private static void Check(bool value, string message)
    {
        if (!value) throw new Exception("FAILED: " + message);
        Console.WriteLine("PASS: " + message);
    }
    private static async Task Reject<T>(Func<Task> action, string message) where T : Exception
    {
        try { await action(); } catch (T) { Check(true, message); return; }
        throw new Exception("FAILED: " + message);
    }
    internal static async Task<int> ReadChildAsync(string connection, string tenant)
    {
        await using var queue = new PostgresIosReleaseQueue(connection);
        var job = await queue.GetAsync(tenant);
        return job?.State == "Succeeded" && job.Receipt?.IpaSha256 == new string('f', 64) ? 0 : 9;
    }
    private static IosReleaseReceipt Receipt(IosReleasePlan plan) => new(new string('f', 64), plan.SourceHash,
        plan.SigningCertificateSha256, plan.FirebaseSdkSha256, plan.BuildNumber,
        "11111111-1111-1111-1111-111111111111", "22222222-2222-2222-2222-222222222222",
        $"projects/{plan.ProjectNumber}/apps/{plan.IosAppId}/releases/fixture", true);

    private sealed class WaitingStep : IProvisioningStep
    {
        public int Calls;
        public string Name => "mobile-ios-release";
        public Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
        {
            if (++Calls == 1) throw new ProvisioningDeferredException("mobile-ios-release:WaitingForMac", TimeSpan.FromSeconds(30));
            return Task.FromResult(new ProvisioningStepResult("fixture", new Dictionary<string, string>()));
        }
    }
    private static async Task VerifyParentWaitAsync(PostgresProvisioningQueue queue, string connection, TenantProvisioningRequest parent)
    {
        var waiting = parent with { TenantId = Guid.NewGuid().ToString("N"), Slug = "waiting-mac-fixture" };
        var sibling = parent with { TenantId = Guid.NewGuid().ToString("N"), Slug = "ready-sibling-fixture" };
        await queue.EnqueueAsync(waiting); await queue.EnqueueAsync(sibling);
        var lease = (await queue.ClaimAsync(TimeSpan.FromSeconds(30)))!;
        Check(lease.Job.Request.TenantId == waiting.TenantId, "The Mac wait fixture owns only its intended parent job");
        await queue.FailAsync(lease, "earlier:TemporaryFailure", 5);
        await using var db = new NpgsqlConnection(connection); await db.OpenAsync();
        async Task MakeAvailable()
        {
            await using var command = new NpgsqlCommand("UPDATE platform_provisioning.jobs SET available_at=created_at WHERE tenant_id=$1", db);
            command.Parameters.AddWithValue(waiting.TenantId); await command.ExecuteNonQueryAsync();
        }
        await MakeAvailable();
        var resumed = (await queue.ClaimAsync(TimeSpan.FromSeconds(30)))!;
        var step = new WaitingStep();
        using var services = new ServiceCollection().AddSingleton<IProvisioningStep>(step).BuildServiceProvider();
        using var worker = new ProvisioningWorker(queue, services.GetRequiredService<IServiceScopeFactory>(), new(), NullLogger<ProvisioningWorker>.Instance);
        await worker.RunAsync(resumed, default);
        var saved = (await queue.GetAsync(waiting.TenantId))!;
        Check(saved.State == "Pending" && saved.Attempts == 1 && saved.ErrorCode == "mobile-ios-release:WaitingForMac" && saved.Steps.Count == 0,
            "A dependency wait preserves existing failures without spending another failed attempt or claiming completion");
        await Reject<ProvisioningLeaseLostException>(() => queue.DeferAsync(resumed, new("waiting", TimeSpan.FromSeconds(30))), "An old claim cannot rewrite a deferred parent");
        var ready = (await queue.ClaimAsync(TimeSpan.FromSeconds(30)))!;
        Check(ready.Job.Request.TenantId == sibling.TenantId, "Waiting for a Mac frees the onboarding worker for another business");
        await queue.CompleteAsync(ready);
        await MakeAvailable();
        var retry = (await queue.ClaimAsync(TimeSpan.FromSeconds(30)))!;
        await worker.RunAsync(retry, default);
        Check((await queue.GetAsync(waiting.TenantId))?.State == "Succeeded" && retry.Job.Attempts == 2 && step.Calls == 2,
            "The deferred parent resumes after its dependency becomes ready");
    }

    private sealed class Executor(Func<IosReleasePlan, CancellationToken, Task<IosReleaseReceipt>> execute) : IIosReleaseExecutor
    {
        public int Calls;
        public bool Canceled;
        public readonly TaskCompletionSource Started = new(TaskCreationOptions.RunContinuationsAsynchronously);
        public async Task<IosReleaseReceipt> ExecuteAsync(IosReleasePlan plan, CancellationToken ct)
        {
            Interlocked.Increment(ref Calls); Started.TrySetResult();
            try { return await execute(plan, ct); }
            catch (OperationCanceledException) when (ct.IsCancellationRequested) { Canceled = true; throw; }
        }
    }
    private static async Task VerifyConsumerAsync(PostgresProvisioningQueue parents, PostgresIosReleaseQueue queue,
        string connection, TenantProvisioningRequest parent, IosReleasePlan template)
    {
        var identity = new IosWorkerIdentity(template.DeploymentId, template.DevelopmentTeam, template.SigningCertificateSha256, template.SourceHash);
        var options = new IosReleaseWorkerOptions { Identity = identity, LeaseDuration = TimeSpan.FromSeconds(6), PollInterval = TimeSpan.FromMilliseconds(100), MaxAttempts = 1 };
        IosReleaseWorker Worker(Executor executor, IosReleaseWorkerOptions? settings = null) => new(queue, executor, settings ?? options, NullLogger<IosReleaseWorker>.Instance);
        async Task<IosReleasePlan> Schedule()
        {
            var tenant = Guid.NewGuid().ToString("N");
            await parents.EnqueueAsync(parent with { TenantId = tenant, Slug = "mac-worker-" + tenant[..10] });
            var plan = template with { TenantId = tenant, IosBundleId = "dev.commerce.t" + tenant };
            await queue.EnqueueAsync(plan); return plan;
        }
        async Task Expire(string tenant)
        {
            await using var db = new NpgsqlConnection(connection); await db.OpenAsync();
            await using var update = new NpgsqlCommand("UPDATE platform_provisioning.ios_release_jobs SET lease_until=now()-interval '1 second' WHERE tenant_id=$1 AND state='Running'", db);
            update.Parameters.AddWithValue(tenant); await update.ExecuteNonQueryAsync();
        }
        await using var other = new PostgresIosReleaseQueue(connection);
        var longPlan = await Schedule();
        var longBuild = new Executor(async (plan, ct) => { await Task.Delay(TimeSpan.FromSeconds(8), ct); return Receipt(plan); });
        using (var worker = Worker(longBuild))
        {
            await worker.StartAsync(default); await longBuild.Started.Task.WaitAsync(TimeSpan.FromSeconds(10));
            var unrelated = new Executor((plan, ct) => Task.FromResult(Receipt(plan)));
            using var wrong = Worker(unrelated, new() { Identity = identity with { DevelopmentTeam = "ZZZZZ99999" } });
            await Reject<InvalidOperationException>(async () => await wrong.RunAsync(new((await queue.GetAsync(longPlan.TenantId))!, Guid.NewGuid()), default),
                "A direct Mac worker invocation cannot substitute another signing team");
            Check(unrelated.Calls == 0, "A mismatched Mac identity performs no provider or build work");
            await Task.Delay(TimeSpan.FromMilliseconds(6500));
            Check(await other.ClaimAsync(identity, TimeSpan.FromSeconds(6)) == null && (await queue.GetAsync(longPlan.TenantId))?.State == "Running",
                "The actual hosted Mac consumer renews its lease beyond the initial build interval");
            using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(10));
            while ((await queue.GetAsync(longPlan.TenantId, deadline.Token))?.State != "Succeeded") await Task.Delay(100, deadline.Token);
            await worker.StopAsync(deadline.Token);
            Check((await queue.GetAsync(longPlan.TenantId))?.Receipt == Receipt(longPlan) && longBuild.Calls == 1,
                "The actual hosted Mac consumer commits a matching receipt after its independent build executor completes");
        }
        var invalidPlan = await Schedule(); var invalidLease = (await queue.ClaimAsync(identity, options.LeaseDuration))!;
        var invalid = new Executor((plan, ct) => Task.FromResult(Receipt(plan) with { BuildNumber = plan.BuildNumber + 1 }));
        using (var worker = Worker(invalid))
        {
            await worker.RunAsync(invalidLease, default);
            var job = (await queue.GetAsync(invalidPlan.TenantId))!;
            Check(job.State == "Failed" && job.Receipt == null && job.ErrorCode == "ios-release:ArgumentException",
                "An incompatible native receipt never reports success and persists only a safe error code");
            await worker.RunAsync(invalidLease, default);
            Check(invalid.Calls == 1, "A finished stale claim is rejected before the build executor runs again");
        }
        var interruptedPlan = await Schedule(); var interruptedLease = (await queue.ClaimAsync(identity, options.LeaseDuration))!;
        var interrupted = new Executor(async (plan, ct) => { await Task.Delay(Timeout.Infinite, ct); return Receipt(plan); });
        using (var worker = Worker(interrupted))
        using (var shutdown = new CancellationTokenSource())
        {
            var running = worker.RunAsync(interruptedLease, shutdown.Token);
            await interrupted.Started.Task.WaitAsync(TimeSpan.FromSeconds(10)); shutdown.Cancel();
            await running.WaitAsync(TimeSpan.FromSeconds(10));
            Check(interrupted.Canceled && (await queue.GetAsync(interruptedPlan.TenantId)) is { State: "Running", Attempts: 1, Receipt: null, ErrorCode: null },
                "Mac shutdown cancels its own executor and leaves the durable claim recoverable without a fabricated failure");
            await Expire(interruptedPlan.TenantId);
            var recovered = (await other.ClaimAsync(identity, options.LeaseDuration))!;
            await other.CompleteAsync(recovered, Receipt(interruptedPlan));
            Check((await queue.GetAsync(interruptedPlan.TenantId))?.State == "Succeeded", "Another connection resumes the exact plan after shutdown and lease expiry");
        }
        var lostPlan = await Schedule(); var lostLease = (await queue.ClaimAsync(identity, options.LeaseDuration))!;
        var lost = new Executor(async (plan, ct) => { await Task.Delay(Timeout.Infinite, ct); return Receipt(plan); });
        using (var worker = Worker(lost))
        {
            var running = worker.RunAsync(lostLease, default); await lost.Started.Task.WaitAsync(TimeSpan.FromSeconds(10));
            await Expire(lostPlan.TenantId); var winner = (await other.ClaimAsync(identity, options.LeaseDuration))!;
            await running.WaitAsync(TimeSpan.FromSeconds(10));
            Check(lost.Canceled && winner.Token != lostLease.Token && (await queue.GetAsync(lostPlan.TenantId)) is { State: "Running", Receipt: null },
                "Loss of the real PostgreSQL claim cancels the old Mac executor without overwriting the new owner");
            await other.CompleteAsync(winner, Receipt(lostPlan));
        }
    }

    internal static async Task RunAsync(PostgresProvisioningQueue parents, string connection, string childConfig, TenantProvisioningRequest parent)
    {
        await VerifyParentWaitAsync(parents, connection, parent);
        await using var queue = new PostgresIosReleaseQueue(connection);
        await using var otherWorker = new PostgresIosReleaseQueue(connection);
        var plan = new IosReleasePlan(parent.TenantId, "ios-fixture", "dev.commerce.fixture", "ABCDE12345",
            new string('a', 64), new string('b', 64), 7, "ios-fixture-demo", "123456789", "1:123456789:ios:bbbbbbbb",
            new string('c', 64), "https://ios-coffee.example.test");
        var identity = new IosWorkerIdentity(plan.DeploymentId, plan.DevelopmentTeam, plan.SigningCertificateSha256, plan.SourceHash);
        await Reject<PostgresException>(() => queue.EnqueueAsync(plan with { TenantId = Guid.NewGuid().ToString("N") }), "iOS job requires its existing onboarding parent");
        await Reject<ArgumentException>(() => queue.EnqueueAsync(plan with { DevelopmentTeam = "ABCDE12345\n" }), "iOS worker identifiers reject trailing control characters");
        await Task.WhenAll(Enumerable.Range(0, 16).Select(i => (i % 2 == 0 ? queue : otherWorker).EnqueueAsync(plan)));
        Check((await queue.GetAsync(plan.TenantId))?.Attempts == 0, "Concurrent scheduling preserves one pending immutable iOS plan");
        await Reject<ProvisioningConflictException>(() => queue.EnqueueAsync(plan with { BuildNumber = 8 }), "iOS scheduling cannot replace the original version");
        foreach (var wrong in new[] { identity with { DeploymentId = "other" }, identity with { DevelopmentTeam = "ZZZZZ99999" },
                     identity with { SigningCertificateSha256 = new string('d', 64) }, identity with { SourceHash = new string('e', 64) } })
            Check(await queue.ClaimAsync(wrong, TimeSpan.FromSeconds(30)) == null, "A different deployment/team/certificate/source cannot claim the iOS job");
        var claims = await Task.WhenAll(Enumerable.Range(0, 16).Select(i => (i % 2 == 0 ? queue : otherWorker).ClaimAsync(identity, TimeSpan.FromSeconds(30))));
        Check(claims.Count(x => x != null) == 1, "Independent Mac queue connections obtain only one active claim");
        var lease = claims.Single(x => x != null)!;
        var another = parent with { TenantId = Guid.NewGuid().ToString("N"), Slug = "another-ios-fixture" };
        await parents.EnqueueAsync(another);
        var secondPlan = plan with { TenantId = another.TenantId, IosBundleId = "dev.commerce.another" };
        await queue.EnqueueAsync(secondPlan);
        var secondLease = await otherWorker.ClaimAsync(identity, TimeSpan.FromSeconds(30));
        Check(secondLease?.Job.Plan.TenantId == another.TenantId, "A running iOS tenant does not block another tenant's job");
        await otherWorker.CompleteAsync(secondLease!, Receipt(secondPlan));
        await using var db = new NpgsqlConnection(connection); await db.OpenAsync();
        await using (var change = new NpgsqlCommand("UPDATE platform_provisioning.ios_release_jobs SET request=jsonb_set(request,'{buildNumber}','8') WHERE tenant_id=$1", db))
        {
            change.Parameters.AddWithValue(plan.TenantId);
            await Reject<PostgresException>(() => change.ExecuteNonQueryAsync(), "Database guard refuses direct iOS plan mutation");
        }
        await using (var expire = new NpgsqlCommand("UPDATE platform_provisioning.ios_release_jobs SET lease_until=now()-interval '1 second' WHERE tenant_id=$1", db))
        { expire.Parameters.AddWithValue(plan.TenantId); await expire.ExecuteNonQueryAsync(); }
        var recovered = (await otherWorker.ClaimAsync(identity, TimeSpan.FromSeconds(30)))!;
        Check(recovered.Token != lease.Token && recovered.Job.Attempts == 2, "An interrupted Mac job is reclaimed with a fresh token");
        await Reject<ProvisioningLeaseLostException>(() => queue.RenewAsync(lease, TimeSpan.FromSeconds(30)), "Stale Mac cannot renew the recovered lease");
        await Reject<ProvisioningLeaseLostException>(() => queue.CompleteAsync(lease, Receipt(plan)), "Stale Mac cannot publish completion");
        await Reject<ProvisioningLeaseLostException>(() => queue.FailAsync(lease, "stale", 1), "Stale Mac cannot fail the recovered job");
        var receipt = Receipt(plan);
        foreach (var wrong in new[] { receipt with { SourceHash = new string('d', 64) }, receipt with { BuildNumber = 8 },
                     receipt with { SigningCertificateSha256 = new string('e', 64) }, receipt with { FirebaseSdkSha256 = new string('e', 64) },
                     receipt with { SymbolsUploaded = false }, receipt with { ReleaseResource = "projects/999/apps/foreign/releases/fixture" } })
            await Reject<ArgumentException>(() => otherWorker.CompleteAsync(recovered, wrong), "A foreign or incomplete iOS receipt cannot complete its original plan");
        var forged = recovered with { Job = recovered.Job with { Plan = plan with { SourceHash = new string('e', 64) } } };
        await Reject<ProvisioningLeaseLostException>(() => otherWorker.CompleteAsync(forged, receipt with { SourceHash = new string('e', 64) }), "Even a live claim cannot substitute a different plan when completing");
        await otherWorker.FailAsync(recovered, "symbols:TemporaryFailure", 1);
        Check((await queue.GetAsync(plan.TenantId))?.State == "Failed", "iOS failure is durable with only a safe public error code");
        Check(await queue.RetryAsync(plan.TenantId), "An operator can retry the same failed iOS plan");
        var retried = (await queue.ClaimAsync(identity, TimeSpan.FromSeconds(30)))!;
        Check(retried.Job.Attempts == 1 && retried.Job.Plan == plan, "iOS retry preserves the plan and resets attempt accounting");
        await queue.CompleteAsync(retried, receipt);
        Check(!await queue.RetryAsync(plan.TenantId) && (await queue.EnqueueAsync(plan)).Receipt == receipt,
            "A completed release stays immutable across duplicate scheduling and retry requests");
        var start = new ProcessStartInfo("dotnet") { UseShellExecute = false };
        foreach (var arg in new[] { typeof(IosReleaseQueueFixture).Assembly.Location, childConfig, "ios-child", plan.TenantId }) start.ArgumentList.Add(arg);
        using var process = Process.Start(start)!;
        using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(30)); await process.WaitForExitAsync(deadline.Token);
        Check(process.ExitCode == 0, "An independent process recovers the persisted iOS completion receipt");
        await VerifyConsumerAsync(parents, queue, connection, parent, plan);
    }
}
