using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Platform.Provisioning;

public interface IIosReleaseExecutor
{
    Task<IosReleaseReceipt> ExecuteAsync(IosReleasePlan plan, CancellationToken ct);
}

public sealed class IosReleaseWorkerOptions
{
    public required IosWorkerIdentity Identity { get; init; }
    public TimeSpan LeaseDuration { get; init; } = TimeSpan.FromMinutes(2);
    public TimeSpan PollInterval { get; init; } = TimeSpan.FromSeconds(5);
    public int MaxAttempts { get; init; } = 5;
    public void Validate()
    {
        Identity.Validate();
        if (LeaseDuration < TimeSpan.FromSeconds(3) || LeaseDuration > TimeSpan.FromMinutes(15) ||
            PollInterval < TimeSpan.FromMilliseconds(100) || PollInterval > TimeSpan.FromMinutes(5) || MaxAttempts is < 1 or > 20)
            throw new ArgumentException("Invalid iOS worker timing or retry limit.");
    }
}

/// <summary>One sequential Mac build lane. Lease loss cancels its own child build; completion writes remain fenced.</summary>
public sealed class IosReleaseWorker(PostgresIosReleaseQueue queue, IIosReleaseExecutor executor,
    IosReleaseWorkerOptions options, ILogger<IosReleaseWorker> logger,MobileIdentityRegistry? identities=null) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        options.Validate();
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var lease = await queue.ClaimAsync(options.Identity, options.LeaseDuration, stoppingToken);
                if(lease!=null)await RunAsync(lease,stoppingToken);
                else if(identities!=null && await identities.ClaimIosAsync(options.Identity,stoppingToken) is {} identityLease)
                    await RunIdentityAsync(identityLease,stoppingToken);
                else await Task.Delay(options.PollInterval,stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested) { break; }
            catch (Exception error)
            {
                logger.LogWarning("iOS queue poll interrupted ({ErrorType})", error.GetType().Name);
                try { await Task.Delay(options.PollInterval, stoppingToken); }
                catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested) { break; }
            }
        }
    }
    public async Task RunAsync(IosReleaseLease lease, CancellationToken ct)
    {
        options.Validate(); lease.Job.Plan.Validate();
        var plan = lease.Job.Plan;
        if (new IosWorkerIdentity(plan.DeploymentId, plan.DevelopmentTeam, plan.SigningCertificateSha256, plan.SourceHash) != options.Identity)
            throw new InvalidOperationException("The iOS lease belongs to another Mac worker identity.");
        using var owned = CancellationTokenSource.CreateLinkedTokenSource(ct);
        var heartbeat = KeepLeaseAsync(lease, owned);
        try
        {
            // Recheck the token before provider work, including direct/recovered invocation.
            await queue.RenewAsync(lease, options.LeaseDuration, owned.Token);
            var receipt = await executor.ExecuteAsync(plan, owned.Token);
            owned.Token.ThrowIfCancellationRequested();
            await queue.CompleteAsync(lease, receipt, owned.Token);
            logger.LogInformation("Tenant {TenantId}: iOS release completed", plan.TenantId);
        }
        catch (OperationCanceledException) when (owned.IsCancellationRequested) { }
        catch (ProvisioningLeaseLostException) { }
        catch (Exception error)
        {
            var code = "ios-release:" + error.GetType().Name;
            logger.LogWarning("Tenant {TenantId}: iOS release failed ({ErrorCode})", plan.TenantId, code);
            try { await queue.FailAsync(lease, code, options.MaxAttempts, ct); }
            catch (ProvisioningLeaseLostException) { }
        }
        finally
        {
            owned.Cancel(); await heartbeat;
        }
    }
    public async Task RunIdentityAsync(MobileIdentityLease lease,CancellationToken ct)
    {
        if(identities==null || lease.Platform!="ios" || lease.Version.Prepared==null)throw new ProvisioningLeaseLostException();
        using var owned=CancellationTokenSource.CreateLinkedTokenSource(ct);
        async Task KeepAsync()
        {
            try{while(!owned.IsCancellationRequested){await Task.Delay(TimeSpan.FromSeconds(30),owned.Token);await identities.RenewAsync(lease,owned.Token);}}
            catch(OperationCanceledException)when(owned.IsCancellationRequested){}catch(Exception){owned.Cancel();}
        }
        var heartbeat=KeepAsync();
        try
        {
            await identities.RenewAsync(lease,owned.Token);
            var receipt=await executor.ExecuteAsync(lease.Version.Prepared.IosPlan,owned.Token);
            await identities.CompleteIosAsync(lease,receipt,owned.Token);
            logger.LogInformation("Tenant {TenantId}: iOS identity {IdentityId} is ready",lease.Version.Request.TenantId,lease.Version.Request.Id);
        }
        catch(OperationCanceledException)when(owned.IsCancellationRequested){}
        catch(ProvisioningLeaseLostException){}
        catch(Exception error)
        {
            logger.LogWarning("iOS identity {IdentityId} failed ({ErrorType})",lease.Version.Request.Id,error.GetType().Name);
            try{await identities.FailAsync(lease,"MobileIos."+error.GetType().Name,ct);}catch(ProvisioningLeaseLostException){}
        }
        finally{owned.Cancel();await heartbeat;}
    }
    private async Task KeepLeaseAsync(IosReleaseLease lease, CancellationTokenSource owned)
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
