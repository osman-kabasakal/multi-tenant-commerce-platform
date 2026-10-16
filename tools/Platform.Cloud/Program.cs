using System.Collections.Concurrent;
using System.Text.Json;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Google;
using Platform.Security;

if (args.Length == 0 || args[0] is "--help" or "help")
{
    Console.WriteLine("check-access --credentials <service-account-file> [--parent organizations/ID|folders/ID]");
    Console.WriteLine("export-mobile --config <file> --tenant <business-guid-N> --output <directory>");
    Console.WriteLine("distribute --config <file> --tenant <business-guid-N> --platform <android|ios> --binary <apk|ipa>");
    return 0;
}
try
{
    var command = args[0];
    if (command == "check-access")
    {
        if (args.Length is not (3 or 5) || args[1] != "--credentials" ||
            (args.Length == 5 && args[3] != "--parent")) throw new ArgumentException();
        using var input = File.OpenRead(Path.GetFullPath(args[2]));
        // Explicit service-account parsing prevents fallback to another logged-in identity or ADC.
        var account = ServiceAccountCredential.FromServiceAccountData(input);
        using var http = new HttpClient(new SocketsHttpHandler { AllowAutoRedirect = false }) { Timeout = TimeSpan.FromSeconds(45) };
        using var timeout = new CancellationTokenSource(TimeSpan.FromMinutes(3));
        var report = await new GoogleAccessVerifier(new GoogleRestClient(http,
            new ExplicitServiceAccountTokens(account))).CheckAsync(account.ProjectId, args.Length == 5 ? args[4] : null, timeout.Token);
        Console.WriteLine(JsonSerializer.Serialize(report, new JsonSerializerOptions(JsonSerializerDefaults.Web) { WriteIndented = true }));
        return report.Checks.All(check => check.Status == "passed") ? 0 : 2;
    }
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

internal sealed class ExplicitServiceAccountTokens(ServiceAccountCredential account) : IGoogleAccessTokenSource
{
    private readonly GoogleCredential credential = GoogleCredential.FromServiceAccountCredential(account);
    private readonly ConcurrentDictionary<string, GoogleCredential> scoped = new();
    public Task<string> GetAsync(string scope, CancellationToken ct) =>
        ((ITokenAccess)scoped.GetOrAdd(scope, value => credential.CreateScoped(value))).GetAccessTokenForRequestAsync(cancellationToken: ct);
}
