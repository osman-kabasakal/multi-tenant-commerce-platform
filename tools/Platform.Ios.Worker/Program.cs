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
    Console.WriteLine("Repair only: --config <file> --repair-ios-source --tenant <tenantN> --identity <guid> --repair-id <new-guid> --expected-source <previous-sha256> --reason <operator-reason> --confirm-workers-stopped");
    return 0;
}
try
{
    var repair = args.Contains("--repair-ios-source", StringComparer.Ordinal);
    if (args.Length < 2 || args[0] != "--config" || !repair && args.Length != 2) throw new ArgumentException();
    var repairValues = new Dictionary<string,string>(StringComparer.Ordinal);
    if (repair)
    {
        if (args.Length != 14 || args.Count(x=>x=="--repair-ios-source")!=1 || args.Count(x=>x=="--confirm-workers-stopped")!=1) throw new ArgumentException();
        var allowed = new HashSet<string>(StringComparer.Ordinal) {"--tenant","--identity","--repair-id","--expected-source","--reason"};
        for (var i=2;i<args.Length;i++)
        {
            if (args[i] is "--repair-ios-source" or "--confirm-workers-stopped") continue;
            if (!allowed.Contains(args[i]) || i+1>=args.Length || !repairValues.TryAdd(args[i],args[++i])) throw new ArgumentException();
        }
        if (repairValues.Count!=5) throw new ArgumentException();
    }
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
    builder.Services.AddSingleton(_ => new AndroidBuildQueue(connection));
    builder.Services.AddSingleton(_ => new IosBuildQueue(connection));
    builder.Services.AddSingleton(_ => new MobileBrandingStore(connection));
    builder.Services.AddSingleton(_ => new MobileIdentityRegistry(connection));
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
    if (repair)
    {
        var identityId=Guid.ParseExact(repairValues["--identity"],"D");
        var version=await host.Services.GetRequiredService<MobileIdentityRegistry>().GetForWorkerAsync(repairValues["--tenant"],identityId,startup.Token);
        var androidSource=await new AndroidReleaseBuilder(new AndroidReleaseOptions {SourceDirectory=options.SourceDirectory,PythonPath=options.PythonPath}).SourceHashAsync(startup.Token);
        if(version?.Prepared==null || version.Prepared.AndroidSourceHash!=androidSource)
            throw new InvalidOperationException("The completed Android recipe must remain unchanged during an iOS-only repair.");
        await using var repairs = new MobileIdentitySourceRepair(connection);
        var receipt = await repairs.ApplyAsync(Guid.ParseExact(repairValues["--repair-id"],"D"),repairValues["--tenant"],
            identityId,repairValues["--expected-source"],options.Identity,repairValues["--reason"],startup.Token);
        Console.WriteLine(System.Text.Json.JsonSerializer.Serialize(receipt,new System.Text.Json.JsonSerializerOptions(System.Text.Json.JsonSerializerDefaults.Web)));
        return 0;
    }
    await host.RunAsync(); return 0;
}
catch (Exception error)
{
    Console.Error.WriteLine("Mac iOS worker could not start (" + error.GetType().Name + "). Check private configuration, permissions and tools.");
    return 1;
}
