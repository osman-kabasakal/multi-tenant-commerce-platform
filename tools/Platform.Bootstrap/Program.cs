using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Platform.Security;
using Npgsql;
using SaasManager.Infrastructure.Data;

if(args.Length==0 || args[0] is "--help" or "help")
{
    Console.WriteLine("initialize|verify --config /absolute/private/bootstrap.json");
    Console.WriteLine("Create the explicitly named empty databases first. Initialization requires Bootstrap:AllowSchemaChanges and owner credentials; runtime hosts only verify.");
    return 0;
}
try
{
    if(args.Length!=3 || args[0] is not ("initialize" or "verify") || args[1]!="--config" || !Path.IsPathFullyQualified(args[2]))throw new ArgumentException();
    var initialize=args[0]=="initialize";
    var config=new ConfigurationBuilder().AddJsonFile(args[2],optional:false).AddEnvironmentVariables().AddInMemoryCollection(new Dictionary<string,string?>{
        ["PlatformSecurity:InitializeSchema"]=initialize?"true":"false",["PlatformSecurity:ReadOnly"]=initialize?"false":"true"
    }).Build();
    var environment=Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT")??"Production";
    if(environment is not ("Production" or "Staging"))throw new InvalidOperationException("Use an explicit Production or Staging bootstrap environment.");
    var options=PortableBootstrapOptions.Read(config,initialize);
    using var services=new ServiceCollection().AddPlatformSecurity(config,environment).BuildServiceProvider();
    var bootstrap=new PortableDatabaseBootstrap(options,services.GetRequiredService<ISecretStore>(),services.GetRequiredService<PostgresSecretStore>());
    using var stopped=new CancellationTokenSource();Console.CancelKeyPress+=(_,eventArgs)=>{eventArgs.Cancel=true;stopped.Cancel();};
    if(initialize)await bootstrap.InitializeAsync(stopped.Token);else await bootstrap.VerifyAsync(stopped.Token);
    Console.WriteLine("Portable database bootstrap "+(initialize?"initialized":"verified")+" for deployment "+options.Spec.DeploymentId+"; public trial plan "+options.Spec.Plan.Id+". No provider or credential was invented.");
    return 0;
}
catch(Exception error)
{
    Console.Error.WriteLine("Database bootstrap failed ("+error.GetType().Name+(error is PostgresException pg?", SQLSTATE="+pg.SqlState:"")+"). Verify the explicit targets, ownership, existing encryption key and owner/runtime permissions. No connection strings or provider bodies are printed.");
    return 1;
}
