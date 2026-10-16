using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace TenantManager.Provisioning;

public static class WorkerHost
{
    public static async Task RunAsync(string[] args)
    {
        var builder=Host.CreateApplicationBuilder(args);
        var path=builder.Configuration["Provisioning:ConfigPath"]??builder.Configuration["LocalDemo:ConfigPath"];
        if (!string.IsNullOrWhiteSpace(path)) builder.Configuration.AddJsonFile(path,optional:false);
        builder.Configuration.AddEnvironmentVariables();
        if (!builder.Configuration.GetValue<bool>("Provisioning:Enabled")) throw new InvalidOperationException("Enable provisioning explicitly.");
        builder.Services.AddPlatformSecurity(builder.Configuration,builder.Environment.EnvironmentName);
        builder.Services.AddPlatformProvisioning(builder.Configuration);
        if (builder.Configuration["Provisioning:Profile"]=="Local")
            builder.Services.AddLocalOnboarding(builder.Configuration,builder.Environment.EnvironmentName);
        else if (builder.Configuration["Provisioning:Profile"]=="Portable")
            builder.Services.AddPortableOnboarding(builder.Configuration,builder.Environment.EnvironmentName);
        else throw new InvalidOperationException("Choose an implemented Local or Portable provisioning profile explicitly.");
        builder.Services.AddProvisioningWorker(builder.Configuration.GetSection("Provisioning:Worker").Get<ProvisioningWorkerOptions>());
        using var host=builder.Build();
        await host.RunAsync();
    }
}
