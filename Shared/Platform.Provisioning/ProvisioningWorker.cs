using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Platform.Provisioning;

public sealed class ProvisioningWorkerOptions
{
    public TimeSpan LeaseDuration { get; init; } = TimeSpan.FromMinutes(2);
    public TimeSpan PollInterval { get; init; } = TimeSpan.FromSeconds(2);
    public int MaxAttempts { get; init; } = 5;
}

public sealed class ProvisioningWorker(PostgresProvisioningQueue queue, IServiceScopeFactory scopes,
    ProvisioningWorkerOptions options, ILogger<ProvisioningWorker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var lease = await queue.ClaimAsync(options.LeaseDuration, stoppingToken);
                if (lease == null) await Task.Delay(options.PollInterval, stoppingToken);
                else await RunAsync(lease, stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested) { break; }
            catch (Exception exception)
            {
                // Provider response bodies, tokens and connection strings must never enter logs.
                logger.LogWarning("Provisioning poll interrupted ({ErrorType})", exception.GetType().Name);
                await Task.Delay(options.PollInterval, stoppingToken);
            }
        }
    }

    public async Task RunAsync(ProvisioningLease lease, CancellationToken ct)
    {
        using var owned = CancellationTokenSource.CreateLinkedTokenSource(ct);
        var heartbeat = KeepLeaseAsync(lease, owned);
        var currentStep = "pipeline";
        try
        {
            using var scope = scopes.CreateScope();
            foreach (var guard in scope.ServiceProvider.GetServices<IProvisioningGuard>())
                await guard.ValidateAsync(lease.Job.Request,lease.Job.Steps,owned.Token);
            var steps = scope.ServiceProvider.GetServices<IProvisioningStep>().ToArray();
            if (steps.Length == 0 || steps.Select(s => s.Name).Distinct().Count() != steps.Length)
                throw new InvalidOperationException("Configure a nonempty provisioning pipeline with unique step names.");
            var completed = new Dictionary<string, ProvisioningStepResult>(lease.Job.Steps);
            foreach (var step in steps)
            {
                currentStep = step.Name;
                if (completed.ContainsKey(step.Name)) continue;
                var result = await step.ExecuteAsync(lease.Job.Request, completed, owned.Token);
                await queue.CheckpointAsync(lease, step.Name, result, owned.Token);
                completed.Add(step.Name, result);
                logger.LogInformation("Tenant {TenantId}: provisioning step {Step} completed", lease.Job.Request.TenantId, step.Name);
            }
            await queue.CompleteAsync(lease, owned.Token);
        }
        catch (OperationCanceledException) when (owned.IsCancellationRequested) { /* Restart safely after lease expiry. */ }
        catch (ProvisioningLeaseLostException) { }
        catch (ProvisioningDeferredException waiting)
        {
            try { await queue.DeferAsync(lease, waiting, ct); }
            catch (ProvisioningLeaseLostException) { }
        }
        catch (Exception exception)
        {
            var code = currentStep + ":" + exception.GetType().Name;
            logger.LogWarning("Tenant {TenantId}: provisioning failed ({ErrorCode})", lease.Job.Request.TenantId, code);
            try { await queue.FailAsync(lease, code, options.MaxAttempts, ct); }
            catch (ProvisioningLeaseLostException) { }
        }
        finally
        {
            owned.Cancel();
            await heartbeat;
        }
    }

    private async Task KeepLeaseAsync(ProvisioningLease lease, CancellationTokenSource owned)
    {
        try
        {
            while (!owned.IsCancellationRequested)
            {
                await Task.Delay(options.LeaseDuration / 3, owned.Token);
                await queue.RenewAsync(lease, options.LeaseDuration, owned.Token);
            }
        }
        catch (OperationCanceledException) when (owned.IsCancellationRequested) { }
        catch (Exception) { owned.Cancel(); }
    }
}
