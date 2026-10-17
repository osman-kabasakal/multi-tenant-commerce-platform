using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Platform.Provisioning.Adapters;

/// <summary>Checks Cloudflare access and user-created TXT proof without creating DNS records or changing a running tenant.</summary>
public sealed class TenantDomainOwnershipWorker(TenantDomainRegistry registry,ITenantDomainOwnership ownership,
    CustomDomainOptions options,ILogger<TenantDomainOwnershipWorker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        options.Validate();
        while(!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var lease=await registry.ClaimAsync(options.DeploymentId,stoppingToken);
                if(lease==null)await Task.Delay(TimeSpan.FromSeconds(3),stoppingToken);
                else await RunAsync(lease,stoppingToken);
            }
            catch(OperationCanceledException)when(stoppingToken.IsCancellationRequested){break;}
            catch(Exception error)
            {
                logger.LogWarning("Domain ownership poll failed ({ErrorType}).",error.GetType().Name);
                await Task.Delay(TimeSpan.FromSeconds(5),stoppingToken);
            }
        }
    }
    public async Task RunAsync(TenantDomainLease lease,CancellationToken ct)
    {
        using var owned=CancellationTokenSource.CreateLinkedTokenSource(ct);var heartbeat=RenewAsync(lease,owned);
        try
        {
            await registry.RenewCheckAsync(lease,owned.Token);
            var access=await ownership.CheckAsync(lease.Binding,lease.Binding.State=="AwaitingOwnership",owned.Token);
            owned.Token.ThrowIfCancellationRequested();await registry.CompleteCheckAsync(lease,access,owned.Token);
        }
        catch(OperationCanceledException)when(owned.IsCancellationRequested){}
        catch(ProvisioningLeaseLostException){}
        catch(Exception error)
        {
            var code=error is TenantDomainException domain?domain.Code:"DomainProviderUnavailable";
            var permanent=code is not ("DomainProofMissing" or "DomainProviderUnavailable") || code=="DomainProviderUnavailable" && lease.Binding.Attempts>=5;
            // Provider outages retry within a bounded attempt budget. Missing TXT proof waits for another explicit owner request.
            try{await registry.FailCheckAsync(lease,code,permanent,ct);}catch(ProvisioningLeaseLostException){}
            logger.LogInformation("Tenant {TenantId}: custom domain check stopped ({ErrorCode}).",lease.Binding.Request.TenantId,code);
        }
        finally{owned.Cancel();await heartbeat;}
    }
    private async Task RenewAsync(TenantDomainLease lease,CancellationTokenSource owned)
    {
        try
        {
            while(!owned.IsCancellationRequested){await Task.Delay(TimeSpan.FromSeconds(30),owned.Token);await registry.RenewCheckAsync(lease,owned.Token);}
        }
        catch(OperationCanceledException)when(owned.IsCancellationRequested){}
        catch{owned.Cancel();}
    }
}
