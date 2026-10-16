using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

if (args.Length == 1 && args[0] == "--help")
{
    Console.WriteLine("Platform.Ios.Worker --config <absolute-private-mac-json>");
    return 0;
}
try
{
    if (args.Length != 2 || args[0] != "--config") throw new ArgumentException();
    var selected = IosReleaseOptions.ReadConfiguration(args[1]);
    var builder = Host.CreateApplicationBuilder(Array.Empty<string>());
    builder.Configuration.Sources.Clear();
    builder.Configuration.AddConfiguration(selected).AddEnvironmentVariables();
    var config = builder.Configuration;
    var options = config.GetSection("Provisioning:Mobile:Ios:Worker").Get<IosReleaseOptions>() ?? throw new InvalidOperationException();
    options.Validate(config, builder.Environment.EnvironmentName);
    var apple = AppleApiOptions.Read(options.AppleConfigFile); apple.Validate(writes: true);
    if (apple.DevelopmentTeam != options.DevelopmentTeam || config["Provisioning:Google:DeploymentId"] != options.DeploymentId)
        throw new InvalidOperationException();
    builder.Logging.ClearProviders();
    builder.Logging.AddSimpleConsole();
    // Hosting/provider failures are reported below by type; only the worker's sanitized events are logged.
    builder.Logging.AddFilter((category, level) => category == typeof(IosReleaseWorker).FullName && level >= LogLevel.Information);
    builder.Services.AddPlatformSecurity(config, builder.Environment.EnvironmentName);
    builder.Services.AddGoogleCloud(config);
    var connection = config["Provisioning:ConnectionString"] ?? config["PlatformSecurity:ConnectionString"] ?? throw new InvalidOperationException();
    builder.Services.AddSingleton(_ => new PostgresProvisioningQueue(connection));
    builder.Services.AddSingleton<IProvisioningQueue>(sp => sp.GetRequiredService<PostgresProvisioningQueue>());
    builder.Services.AddSingleton(_ => new PostgresIosReleaseQueue(connection));
    builder.Services.AddSingleton(options); builder.Services.AddSingleton(apple);
    builder.Services.AddSingleton(_ => AppleApiClient.CreateHttpClient());
    builder.Services.AddSingleton<IAppleApiTokens, AppleApiTokens>();
    builder.Services.AddSingleton<AppleApiClient>();
    builder.Services.AddSingleton<IAppleSigningIdentityVerifier, MacAppleSigningIdentityVerifier>();
    builder.Services.AddSingleton<AppleTenantProvisioner>();
    builder.Services.AddSingleton<IIosReleaseBuilder, IosReleaseBuilder>();
    builder.Services.AddSingleton<IIosReleaseExecutor, IosReleaseExecutor>();
    builder.Services.AddSingleton(new IosReleaseWorkerOptions { Identity = options.Identity });
    builder.Services.AddHostedService<IosReleaseWorker>();
    using var host = builder.Build();
    using var startup = new CancellationTokenSource(TimeSpan.FromMinutes(2));
    if (await host.Services.GetRequiredService<IIosReleaseBuilder>().SourceHashAsync(startup.Token) != options.ExpectedSourceHash)
        throw new InvalidOperationException("The Mac checkout differs from its selected immutable source.");
    await host.RunAsync(); return 0;
}
catch (Exception error)
{
    Console.Error.WriteLine("Mac iOS worker could not start (" + error.GetType().Name + "). Check private configuration, permissions and tools.");
    return 1;
}
