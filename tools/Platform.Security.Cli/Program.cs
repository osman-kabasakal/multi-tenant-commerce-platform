using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Security;

if (args.Length != 2 || args[0] != "initialize")
    throw new ArgumentException("Usage: initialize /absolute/path/to/security-config.json");
var configuration = new ConfigurationBuilder().AddJsonFile(Path.GetFullPath(args[1]),false).AddEnvironmentVariables().Build();
var environment = Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT") ?? "Production";
using var services = new ServiceCollection().AddPlatformSecurity(configuration,environment).BuildServiceProvider();
await services.GetRequiredService<PostgresSecretStore>().InitializeAsync();
var secrets = services.GetRequiredService<ISecretStore>();
foreach (var item in configuration.GetSection("PlatformSecurity:BootstrapSecrets").GetChildren())
    await secrets.GetOrCreateAsync("system",item.Key,()=>item.Value ?? throw new InvalidOperationException("Bootstrap secret is empty."));
Console.WriteLine("Shared security schema and bootstrap secrets are ready. No values are printed.");
