using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Platform.Provisioning.Adapters;
using Platform.Security;

namespace TenantManager.Provisioning;

public static class ReadinessEmailHost
{
    public static async Task RunAsync(string[] args)
    {
        var builder=Host.CreateApplicationBuilder(args);
        var path=builder.Configuration["Provisioning:ConfigPath"];
        if(string.IsNullOrWhiteSpace(path) || !Path.IsPathFullyQualified(path))throw new InvalidOperationException("Supply the absolute private readiness configuration path.");
        builder.Configuration.AddJsonFile(path,optional:false).AddEnvironmentVariables();
        var config=builder.Configuration;
        if(!config.GetValue<bool>("Provisioning:Enabled") || config["Provisioning:ReadinessEmail:Provider"]!="Smtp" ||
            config.GetValue<bool>("PlatformSecurity:InitializeSchema") || config.GetValue<bool>("Provisioning:InitializeSchema"))
            throw new InvalidOperationException("Enable SMTP explicitly and apply schemas separately before starting a delivery-only worker.");
        OnboardingInfrastructureOptions infrastructure=config["Provisioning:Profile"] switch
        {
            "Portable"=>config.GetSection("Provisioning:Portable").Get<PortableOnboardingOptions>()??throw new InvalidOperationException("Configure owned public deployment targets."),
            "Local"=>config.GetSection("Provisioning:Local").Get<LocalOnboardingOptions>()??new LocalOnboardingOptions(),
            _=>throw new InvalidOperationException("Choose Local or Portable readiness targets explicitly.")
        };
        builder.Services.AddPlatformSecurity(config,builder.Environment.EnvironmentName);
        builder.Services.AddSingleton(infrastructure);
        builder.Services.AddReadinessEmail(config,builder.Environment.EnvironmentName,infrastructure);
        using var host=builder.Build();await host.RunAsync();
    }
}
