using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Platform.Provisioning.Adapters;

public sealed class AndroidBuildWorker(AndroidBuildQueue builds,IProvisioningQueue onboarding,PortableOnboardingOptions deployment,
    IServiceScopeFactory scopes,ILogger<AndroidBuildWorker> logger):BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while(!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var lease=await builds.ClaimAsync(deployment.DeploymentId,stoppingToken);
                if(lease==null)await Task.Delay(TimeSpan.FromSeconds(2),stoppingToken);
                else await RunAsync(lease,stoppingToken);
            }
            catch(OperationCanceledException)when(stoppingToken.IsCancellationRequested){break;}
            catch(Exception error){logger.LogWarning("Android build polling interrupted ({ErrorType})",error.GetType().Name);await Task.Delay(TimeSpan.FromSeconds(2),stoppingToken);}
        }
    }
    public async Task RunAsync(AndroidBuildLease lease,CancellationToken ct)
    {
        using var owned=CancellationTokenSource.CreateLinkedTokenSource(ct);
        var heartbeat=KeepLeaseAsync(lease,owned);
        try
        {
            await builds.RenewAsync(lease,owned.Token);
            var original=await onboarding.GetAsync(lease.Job.TenantId,owned.Token);
            if(original==null || original.State!="Succeeded" || original.Request.DeploymentId!=deployment.DeploymentId)
                throw new InvalidOperationException("A verified tenant in this deployment is required for a rebuild.");
            using var scope=scopes.CreateScope();
            var receipt=await scope.ServiceProvider.GetRequiredService<AndroidReleasePipeline>().ExecuteAsync(
                original.Request,original.Steps,owned.Token,lease.Job.Id,lease.Job.BuildNumber);
            await builds.CompleteAsync(lease,receipt,owned.Token);
        }
        catch(OperationCanceledException)when(owned.IsCancellationRequested){}
        catch(ProvisioningLeaseLostException){}
        catch(Exception error)
        {
            logger.LogWarning("Android build {BuildId} failed ({ErrorType})",lease.Job.Id,error.GetType().Name);
            try{await builds.FailAsync(lease,error,ct);}catch(ProvisioningLeaseLostException){}
        }
        finally{owned.Cancel();await heartbeat;}
    }
    private async Task KeepLeaseAsync(AndroidBuildLease lease,CancellationTokenSource owned)
    {
        try{while(!owned.IsCancellationRequested){await Task.Delay(TimeSpan.FromSeconds(30),owned.Token);await builds.RenewAsync(lease,owned.Token);}}
        catch(OperationCanceledException)when(owned.IsCancellationRequested){}
        catch(Exception){owned.Cancel();}
    }
}
