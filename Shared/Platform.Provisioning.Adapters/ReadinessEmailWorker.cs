using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

/// <summary>SMTP acceptance is journaled separately from tenant readiness; ambiguous transport failures may resend the same Message-ID.</summary>
public sealed class ReadinessEmailWorker(PostgresReadinessDeliveryQueue queue,ReadinessEmailOptions options,
    OnboardingInfrastructureOptions infrastructure,IReadinessEmailTransport transport,ISecretStore secrets,ILogger<ReadinessEmailWorker> logger) : BackgroundService
{
    public async Task InitializeAsync(CancellationToken ct=default)
    {
        await queue.VerifyAsync(options.Deployment(infrastructure),options.Fingerprint(infrastructure),ct);
        var saved=await secrets.GetOrCreateAsync("system",options.BindingName(infrastructure),()=>options.Fingerprint(infrastructure),ct);
        if(saved!=options.Fingerprint(infrastructure))throw new InvalidOperationException("Restore the original readiness SMTP target or migrate it explicitly.");
    }
    public override async Task StartAsync(CancellationToken cancellationToken)
    {await InitializeAsync(cancellationToken);await base.StartAsync(cancellationToken);}
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while(!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var lease=await queue.ClaimAsync(options.Deployment(infrastructure),options.Fingerprint(infrastructure),options.LeaseDuration,stoppingToken);
                if(lease==null)await Task.Delay(options.PollInterval,stoppingToken);
                else await RunAsync(lease,stoppingToken);
            }
            catch(OperationCanceledException)when(stoppingToken.IsCancellationRequested){break;}
            catch(Exception error)
            {
                logger.LogWarning("Readiness delivery poll interrupted ({ErrorType})",error.GetType().Name);
                await Task.Delay(options.PollInterval,stoppingToken);
            }
        }
    }
    public async Task RunAsync(ReadinessDeliveryLease lease,CancellationToken ct=default)
    {
        using var owned=CancellationTokenSource.CreateLinkedTokenSource(ct);var heartbeat=KeepLeaseAsync(lease,owned);
        try
        {
            if(await secrets.GetAsync("system",options.BindingName(infrastructure),owned.Token)!=options.Fingerprint(infrastructure))
                throw new InvalidOperationException("The original readiness SMTP binding is missing or changed.");
            var message=ReadinessEmailMessage.Create(lease,options,infrastructure);
            await transport.SendAsync(message,owned.Token);
            await queue.SentAsync(lease,owned.Token);
            logger.LogInformation("Tenant {TenantId}: readiness email accepted by SMTP",lease.Request.TenantId);
        }
        catch(OperationCanceledException)when(owned.IsCancellationRequested){ }
        catch(ProvisioningLeaseLostException){ }
        catch(Exception error)
        {
            var code="smtp:"+error.GetType().Name;
            logger.LogWarning("Tenant {TenantId}: readiness email failed ({ErrorCode})",lease.Request.TenantId,code);
            try{await queue.FailedAsync(lease,code,options.MaxAttempts,ct);}catch(ProvisioningLeaseLostException){ }
        }
        finally{owned.Cancel();await heartbeat;}
    }
    private async Task KeepLeaseAsync(ReadinessDeliveryLease lease,CancellationTokenSource owned)
    {
        try
        {
            while(!owned.IsCancellationRequested)
            {await Task.Delay(options.LeaseDuration/3,owned.Token);await queue.RenewAsync(lease,options.LeaseDuration,owned.Token);}
        }
        catch(OperationCanceledException)when(owned.IsCancellationRequested){ }
        catch(Exception){owned.Cancel();}
    }
}
