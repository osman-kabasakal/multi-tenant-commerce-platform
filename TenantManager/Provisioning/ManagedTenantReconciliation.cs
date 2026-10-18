using Microsoft.Extensions.DependencyInjection;
using Platform.Provisioning;
using Platform.Security;
using Platform.Provisioning.Adapters;

namespace TenantManager.Provisioning;

// Maintenance mode does not start queue pollers, create cloud resources or send mail.
// Stop all provisioning workers before invoking it for an existing completed tenant.
public static class ManagedTenantReconciliation
{
    public static async Task RunAsync(string tenant,IServiceProvider services,CancellationToken ct,bool repairBase=false)
    {
        if (!Guid.TryParseExact(tenant,"N",out var id) || id==Guid.Empty || id.ToString("N")!=tenant)
            throw new ArgumentException("Choose a canonical owned tenant id.");
        var job=await services.GetRequiredService<IProvisioningQueue>().GetAsync(tenant,ct);
        if(job==null || job.State!="Succeeded")throw new InvalidOperationException("Reconcile only an existing completed tenant; retry failed or pending jobs through their durable queue.");
        var completed=job.Steps.ToDictionary(x=>x.Key,x=>x.Value);
        foreach(var guard in services.GetServices<IProvisioningGuard>())await guard.ValidateAsync(job.Request,completed,ct);
        var options=services.GetRequiredService<OnboardingInfrastructureOptions>();
        var lockPath=Path.Combine(options.WorkingDirectory,tenant,"reconciliation.lock");
        Directory.CreateDirectory(Path.GetDirectoryName(lockPath)!);
        var file=new FileStreamOptions {Mode=FileMode.OpenOrCreate,Access=FileAccess.ReadWrite,Share=FileShare.None};
        if(!OperatingSystem.IsWindows())file.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
        using var maintenance=new FileStream(lockPath,file);
        if (repairBase)
        {
            await new StoreInstallerStep(options, services.GetRequiredService<ITenantSecrets>())
                .RepairBaseAsync(job.Request, completed, ct);
            Console.WriteLine("Completed owned maintenance phase: tenant-base-repair");
        }
        foreach(var step in services.GetServices<IProvisioningStep>().OfType<ManagedTenantStep>())
        {
            completed[step.Name]=await step.ExecuteAsync(job.Request,completed,ct);
            Console.WriteLine("Completed owned maintenance phase: "+step.Name);
        }
        // Historical request/checkpoints are immutable. Phase receipts record this explicit repair.
    }
}
