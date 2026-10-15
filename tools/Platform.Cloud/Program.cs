using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Google;
using Platform.Security;

if (args.Length == 0 || args[0] is "--help" or "help")
{
    Console.WriteLine("export-mobile --config <file> --tenant <business-guid-N> --output <directory>");
    Console.WriteLine("distribute --config <file> --tenant <business-guid-N> --platform <android|ios> --binary <apk|ipa>");
    return 0;
}
try
{
    var command = args[0];
    if (command is not ("export-mobile" or "distribute") || args.Length % 2 != 1) throw new ArgumentException();
    var flags = new Dictionary<string,string>();
    for (var i = 1; i < args.Length; i += 2)
        if (!args[i].StartsWith("--", StringComparison.Ordinal) || !flags.TryAdd(args[i], args[i+1])) throw new ArgumentException();
    var allowed = command == "export-mobile" ? new[] { "--config", "--tenant", "--output" } : ["--config", "--tenant", "--platform", "--binary"];
    if (flags.Count != allowed.Length || allowed.Any(key => !flags.ContainsKey(key))) throw new ArgumentException();
    var tenant = flags["--tenant"];
    if (!Guid.TryParseExact(tenant, "N", out var id) || id == Guid.Empty) throw new ArgumentException();
    var config = new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(flags["--config"]), optional:false)
        .AddEnvironmentVariables().AddInMemoryCollection(new Dictionary<string,string?> {
            ["PlatformSecurity:ReadOnly"] = "true", ["PlatformSecurity:InitializeSchema"] = "false"
        }).Build();
    var services = new ServiceCollection();
    services.AddPlatformSecurity(config, Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT") ?? "Production");
    if (command == "distribute")
    {
        if (config["Provisioning:Google:Provider"] != "Google") throw new InvalidOperationException();
        services.AddGoogleCloud(config);
    }
    using var provider = services.BuildServiceProvider();
    var value = await provider.GetRequiredService<ITenantSecrets>().GetAsync(tenant, TenantFirebaseConfiguration.SecretName);
    var firebase = JsonSerializer.Deserialize<TenantFirebaseConfiguration>(value) ?? throw new InvalidOperationException();
    if (firebase.TenantId != tenant) throw new InvalidOperationException();
    if (command == "export-mobile")
    {
        await FirebaseClientFiles.ExportAsync(firebase, Path.GetFullPath(flags["--output"]));
        Console.WriteLine("Public Firebase SDK configuration exported.");
    }
    else
    {
        var release = await provider.GetRequiredService<FirebaseAppDistribution>().UploadAndDistributeAsync(firebase, flags["--platform"], flags["--binary"]);
        Console.WriteLine("Distributed release: " + release);
    }
    return 0;
}
catch (Exception error)
{
    // Do not print secret values, credential paths, database exceptions or provider response bodies.
    Console.Error.WriteLine("Cloud operation failed (" + error.GetType().Name + "). Check configuration and provider permissions.");
    return 1;
}
