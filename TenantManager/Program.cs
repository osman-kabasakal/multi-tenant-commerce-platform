using Platform.Security;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Mail;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using Azure.Identity;
using Google.Cloud.ResourceManager.V3;
using Hangfire;
using Hangfire.MemoryStorage;
using Hangfire.Server;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;
using TenantManager;
using TenantManager.Email;
using TenantManager.Keycloak;
using TenantManagerClaude;

// Models


public class AllAppBuildsRedisMessage
{
    public List<string> ClientIds { get; set; } = new List<string>();
}
public enum TenantStatusEvent
{
    Registered,
    EmployeeRegistered,
    Deactivated,
    UserDeleted
}

public class ProcessTenantMessageParams
{
    public TenantStatusMessage TenantStatusMessage { get; set; }
    public PerformContext Context { get; set; }
}

public class TenantStatusMessage
{
    public string? TenantId { get; set; }
    public TenantStatusEvent? StatusEventType { get; set; }
    public string? StoreName { get; set; }
    public string? StoreSubDomain { get; set; }
    public string? LogoUrl { get; set; }
    public string? OwnerEmail { get; set; }
    [JsonIgnore]
    public string? Password { get; set; }
    public string? FirstName { get; set; }
    public string? Lastname { get; set; }
    public string? Role { get; set; }
    [JsonIgnore]
    public string? MongoConnectionString { get; set; }
    public string CompanyName { get; set; } = string.Empty;
    public string CompanyAddress { get; set; } = string.Empty;
    public string CompanyPhoneNumber { get; set; } = string.Empty;
    public string CompanyEmail { get; set; } = string.Empty;
    
    // Firebase settings
    public FirebaseSettings? Firebase { get; set; }
}


public class FirebaseSettings
{
    [JsonPropertyName("projectId")]
    public string? ProjectId { get; set; }
    
    [JsonPropertyName("iosAppId")]
    public string? IosAppId { get; set; }
    
    [JsonPropertyName("iosTeamId")]
    public string? IosTeamId { get; set; }
    
    [JsonPropertyName("iosBundleId")]
    public string? IosBundleId { get; set; }
    
    [JsonPropertyName("iosAppStoreId")]
    public string? IosAppStoreId { get; set; }
    
    [JsonPropertyName("androidPackageName")]
    public string? AndroidPackageName { get; set; }
    
    [JsonPropertyName("androidSha256Fingerprint")]
    public string? AndroidSha256Fingerprint { get; set; }
}


public class BusinessReadyMessage
{
    public string StoreName { get; set; }
    public string StoreSubDomain { get; set; }
    public string OwnerEmail { get; set; }
    public string Password { get; set; }
    public string FirstName { get; set; }
    public string Lastname { get; set; }
    public string Role { get; set; }
    public string WarehouseUrl { get; set; }
}


public class ResponseWithCredentialsModel
{
    [JsonPropertyName("isSuccess")] public bool IsSuccess { get; set; }

    [JsonPropertyName("message")] public TenantStatusMessage Message { get; set; }

    [JsonPropertyName("frontEndCredentialInfo")]
    public FrontEndCredentialInfo FrontEndCredentialInfo { get; set; }
}

public class FrontEndCredentialInfo
{
    [JsonPropertyName("clientId")] public string ClientId { get; set; }

    [JsonIgnore] public string ClientSecret { get; set; }
}

public class BasicResponseModel
{
    [JsonPropertyName("isSuccess")] public bool IsSuccess { get; set; }

    [JsonPropertyName("message")] public TenantStatusMessage Message { get; set; }
}

// Background Job Filter
public class CustomJobFilter : IServerFilter
{
    private static void InjectPerformContext(PerformContext context)
    {
        foreach (var x in context.BackgroundJob.Job.Args)
        {
            switch (x)
            {
                case null:
                    return;
                case ProcessTenantMessageParams jobArgs:
                    jobArgs.Context = context;
                    break;
            }
        }
    }

    private readonly JobOutputStore _outputStore;

    public CustomJobFilter(JobOutputStore outputStore)
    {
        _outputStore = outputStore;
    }

    public void OnPerforming(PerformingContext filterContext)
    {
        var jobId = filterContext.BackgroundJob.Id;
        _outputStore.AppendOutput(jobId, $"Job başladı - {DateTime.Now}");
        InjectPerformContext(filterContext);
        filterContext.Items["JobOutputStore"] = _outputStore;
        filterContext.Items["JobId"] = jobId;
    }

    public void OnPerformed(PerformedContext filterContext)
    {
        var jobId = filterContext.BackgroundJob.Id;
        _outputStore.AppendOutput(jobId, $"Job tamamlandı - {DateTime.Now}");

        if (filterContext.Exception != null)
        {
            _outputStore.AppendOutput(jobId, $"Hata oluştu: {filterContext.Exception.Message}");
        }

        _outputStore?.SaveOutput(jobId!,
            (filterContext.BackgroundJob.Job.Args.OfType<ProcessTenantMessageParams>().First()).TenantStatusMessage
            .StoreSubDomain!);
    }
}


public class SubscriberHandlers
{
    public async Task SendWelcomMessage(ProcessTenantMessageParams param, string userName, string password)
    {
        try
        {
            using (var serviceScope = Program.ServiceProvider.CreateScope())
            {
                TenantStatusMessage message = param.TenantStatusMessage;
                var context = param.Context;
                var jobId = context?.Items["JobId"]?.ToString();
                var outputStore = context?.Items["JobOutputStore"] as JobOutputStore;
                outputStore?.AppendOutput(jobId!,
                    $"Hoşgeldin maili gönderiliyor: {message.StoreName}({message.OwnerEmail})");
                using var mailClient = new SmtpMailClient(userName, password, "smtp-relay.gmail.com", 587);
                var emailRenderService = serviceScope.ServiceProvider.GetRequiredService<ITemplateEngine>();
                await mailClient.SendEmailAsync(
                    "donotreply@commerce.test",
                    message.OwnerEmail, "Famizyo cemiyetine hoşgeldiniz",
                    emailRenderService.Render(
                        File.ReadAllText(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets",
                            "WelcomeMail.html")), message), true);
            }
        }
        catch (Exception e)
        {
            var outputStore = param.Context?.Items["JobOutputStore"] as JobOutputStore;
            outputStore?.AppendOutput(param.Context!.Items["JobId"]!.ToString(), e.ToString());
        }
    }
    
    private async Task<TCommandType?> RunFirebaseCommand<TCommandType>(string flutterAppPath, string gcloudProject, string serviceAccountJsonPath, string commands)
    {
        var process = new Process
        {
            StartInfo = new ProcessStartInfo
            {
                FileName = "firebase",
                Arguments = commands + $" --project=\"{gcloudProject}\" --non-interactive -j",
                WorkingDirectory = flutterAppPath,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
                Environment = { }
            }
        };

        // process.StartInfo.Environment["FIREBASE_TOKEN"] = token;
        process.StartInfo.Environment["GOOGLE_APPLICATION_CREDENTIALS"] = serviceAccountJsonPath;

        var outputBuilder = new StringBuilder();
        var errorBuilder = new StringBuilder();

        process.OutputDataReceived += (sender, e) =>
        {
            if (e.Data != null)
            {
                outputBuilder.AppendLine(e.Data);
                // _outputStore.AppendOutput(_jobId, e.Data);
            }
        };

        process.ErrorDataReceived += (sender, e) =>
        {
            if (e.Data != null)
            {
                errorBuilder.AppendLine(e.Data);
                // _outputStore.AppendOutput(_jobId, e.Data);
            }
        };

        process.Start();
        process.BeginOutputReadLine();
        process.BeginErrorReadLine();

        await process.WaitForExitAsync();
    
    

        var input = outputBuilder.ToString();

        var result = JsonSerializer.Deserialize<TCommandType>(input);
        return result;
    }


    [AutomaticRetry(Attempts = 3, OnAttemptsExceeded = AttemptsExceededAction.Delete)]
    [DisableConcurrentExecution(timeoutInSeconds: 1800)]
    public async Task ProcessTenantMessage(ProcessTenantMessageParams param)
    {
        // Work on a private copy; the queued message remains a reference without secrets.
        TenantStatusMessage message = JsonSerializer.Deserialize<TenantStatusMessage>(JsonSerializer.Serialize(param.TenantStatusMessage))!;
        if (!string.IsNullOrWhiteSpace(message.TenantId))
        {
            var secrets = Program.ServiceProvider.GetRequiredService<ITenantSecrets>();
            message.MongoConnectionString = await secrets.GetAsync(message.TenantId, TenantSecretNames.DatabaseConnection);
            message.Password = await secrets.GetAsync(message.TenantId, TenantSecretNames.InitialPassword);
        }
        var context = param.Context;
        var jobId = context?.Items["JobId"]?.ToString();
        var outputStore = context?.Items["JobOutputStore"] as JobOutputStore;
        try
        {
            outputStore?.AppendOutput(jobId!, $"Message işleniyor: {message.StoreName}");
            Dictionary<string, string> TypeToEnv(Type type, object? instance)
            {
                var envVars = new Dictionary<string, string>();
                foreach (var prop in type.GetProperties())
                {
                    var value = prop.GetValue(instance);
                    if (value is not string)
                        continue;
                    var stringValue = value.ToString();
                    if (!string.IsNullOrEmpty(stringValue))
                    {
                        envVars.Add(prop.Name, stringValue);
                    }
                }

                return envVars;
            }

            var envVars = TypeToEnv(typeof(TenantStatusMessage),message);
            if (message.Firebase != null)
            {
                var googleParent = Program.ServiceProvider.GetRequiredService<IConfiguration>()["Provisioning:Google:Parent"];
                if (googleParent == null || !System.Text.RegularExpressions.Regex.IsMatch(googleParent, "^(folders|organizations)/[1-9][0-9]*$"))
                    throw new InvalidOperationException("Configure Provisioning:Google:Parent before using legacy Firebase provisioning.");

                var firebaseService = new FirebaseService();
                if (await firebaseService.InitializeFirebaseAdminAsync())
                {
                    var gCloudProject = await firebaseService.GetProjectAsync(message.Firebase!.ProjectId);
                    if (gCloudProject == null)
                    {
                        gCloudProject = await firebaseService.CreateProjectAsync(new Project
                        {
                            ProjectId = message.Firebase!.ProjectId,
                            // Name = projectName,
                            // DisplayName = message.StoreName,
                            Parent = googleParent
                        });

                        if (gCloudProject == null)
                        {
                            Console.WriteLine("Failed to create project");
                            return;
                        }
                    }
                    
                    await firebaseService.AddUserToOwnerRole(gCloudProject.ProjectId, "maintainer@example.invalid");

                    var serviceCredential =
                        await firebaseService.AddServiceAccountWithFCMAdminRole(gCloudProject.ProjectId, "fcm-admin", "fcm-admin");
                    
                    string assetsDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets");
                    var serviceAccountPath = Path.Combine(assetsDir, $"{gCloudProject.ProjectId}-service-account.json");

                    if (serviceCredential)
                    {
                        if (File.Exists(serviceAccountPath))
                        {
                            var blobStorageservice = new BlobStorageService(
                                "https://storage.example.invalid",
                                Environment.GetEnvironmentVariable("AZURE_STORAGEBLOB_CONNECTIONSTRING"));
                            using (var fileStream = File.OpenRead(serviceAccountPath))
                            {
                                await blobStorageservice.UploadFileAsync(fileStream,
                                    $"{gCloudProject.ProjectId}-service-account.json", "service-accounts");
                            }
                        }
                    }
                    
                    await firebaseService.AddFirebaseToProjectAsync(gCloudProject.ProjectId, new AppBuildsConfig()
                    {
                        PackageNameAndroid = message.Firebase!.AndroidPackageName,
                        AppTitle=message.StoreName,
                        Flavor = message.StoreSubDomain,
                        PackageNameIos = message.Firebase.IosBundleId
                    });
                    
                    
                    try
                    {
                        var groupAlias = message.Firebase!.AndroidPackageName!.ToLowerInvariant().Split(".").Last();
                        try
                        {
                            var firebaseGroupCreateRepsponse = await RunFirebaseCommand<FirebaseGroupsResponse>("",
                                gCloudProject.ProjectId,
                                Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets", "service-account.json"),
                                $"appdistribution:group:create {message.StoreName} {groupAlias}");
                        }
                        catch (Exception e)
                        {
                            outputStore.AppendOutput(jobId,e.ToString());
                        }

                        try
                        {
                            var firebaseAddUSerToGroup = await RunFirebaseCommand<FirebaseGroupsResponse>("",
                                gCloudProject.ProjectId,
                                Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets", "service-account.json"),
                                $"appdistribution:testers:add --group-alias=\"{groupAlias}\" {message.OwnerEmail} {message.CompanyEmail}");
                        }
                        catch (Exception e)
                        {
                            outputStore.AppendOutput(jobId,e.ToString());
                        }
                    }
                    catch (Exception e)
                    {
                        outputStore.AppendOutput(jobId,e.ToString());
                    }
                }
                
                var firebaseEnvVars = TypeToEnv(typeof(FirebaseSettings), message.Firebase);
                foreach (var envVar in firebaseEnvVars)
                {
                    envVars.TryAdd($"{nameof(TenantStatusMessage.Firebase)}__{envVar.Key}", envVar.Value);
                }
            }
            
            var nodeInstallerPath = Environment.GetEnvironmentVariable("NodeInstallerPath");

            var processStartInfo = new ProcessStartInfo
            {
                FileName = "dotnet",
                Arguments = $"{Path.GetFileName(nodeInstallerPath)}",
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                WorkingDirectory = Path.GetDirectoryName(nodeInstallerPath),
                EnvironmentVariables = { },
                CreateNoWindow = false
            };


            foreach (var envVar in envVars)
                processStartInfo.EnvironmentVariables[$"TenantMessage__{envVar.Key}"] = envVar.Value;
            var workerConfig = Program.ServiceProvider.GetRequiredService<IConfiguration>();
            foreach (var entry in workerConfig.AsEnumerable().Where(x =>
                x.Key.StartsWith("PlatformSecurity:") || x.Key.StartsWith("LocalDemo:") || x.Key == "ConnectionStrings:kvUri"))
                if (entry.Value != null) processStartInfo.EnvironmentVariables[entry.Key.Replace(":", "__")] = entry.Value;
            processStartInfo.EnvironmentVariables["ASPNETCORE_ENVIRONMENT"] =
                Program.ServiceProvider.GetRequiredService<IHostEnvironment>().EnvironmentName;
            // Child credentials are passed in memory, never rendered into the job output.
            outputStore?.AppendOutput(jobId!, "Starting tenant installer with shared security configuration.");
            using var process = new Process { StartInfo = processStartInfo };

            process.OutputDataReceived += (sender, args) =>
            {
                if (!string.IsNullOrEmpty(args.Data))
                {
                    outputStore?.AppendOutput(jobId!, $"Process Output: {args.Data}");
                }
            };

            process.ErrorDataReceived += (sender, args) =>
            {
                if (!string.IsNullOrEmpty(args.Data))
                {
                    outputStore?.AppendOutput(jobId!, $"Process Error: {args.Data}");
                }
            };

            outputStore?.AppendOutput(jobId!, "Process başlatılıyor...");
            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();

            if (!process.WaitForExit(1800000 * 3))
            {
                outputStore?.AppendOutput(jobId!, "Process timeout - killing process");
                process.Kill();
                throw new TimeoutException("Process 30 dakika içinde tamamlanamadı.");
            }
            
            outputStore?.AppendOutput(jobId!,
                $"Hoşgeldin maili gönderiliyor: {message.StoreName}({message.OwnerEmail})");
            var configuration = Program.ServiceProvider.GetRequiredService<IConfiguration>();
            using var mailClient = new SmtpMailClient("maintainer@example.invalid", configuration["Email:Password"], "smtp-relay.gmail.com", 587);
            var emailRenderService = Program.ServiceProvider.GetRequiredService<ITemplateEngine>();
            await mailClient.SendEmailAsync(
                "donotreply@commerce.test",
                message.OwnerEmail, "Mağazanızın kurulumu tamamlandı",
                emailRenderService.Render(
                    File.ReadAllText(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets",
                        "ReadyBusinessMail.html")), new BusinessReadyMessage()
                    {
                        FirstName = message.FirstName,
                        Lastname = message.Lastname,
                        OwnerEmail = message.OwnerEmail,
                        Password = message.Password,
                        Role = message.Role,
                        StoreName = message.StoreName,
                        StoreSubDomain = message.StoreSubDomain,
                        WarehouseUrl = "https://sanal-depo.commerce.test"
                    }), true);

            outputStore?.AppendOutput(jobId!, $"Process tamamlandı. Exit code: {process.ExitCode}");
        }
        catch (Exception e)
        {
            Console.WriteLine("Error: " + e);
            outputStore?.AppendOutput(jobId!, e.ToString());
            await File.WriteAllTextAsync(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"ErrorMessages","TenantMessages",$"{message.StoreSubDomain}.json"),JsonSerializer.Serialize(param.TenantStatusMessage));
        }
    }

    [AutomaticRetry(Attempts = 3, OnAttemptsExceeded = AttemptsExceededAction.Delete)]
    [DisableConcurrentExecution(timeoutInSeconds: 3600)]
    public async Task ProcessNewBuild(ProcessTenantMessageParams param, AppBuildsConfig buildConf,
        string redisConnectionString,
        string gitPass)
    {
        var context = param.Context;
        var jobId = context?.Items["JobId"]?.ToString();
        var outputStore = context?.Items["JobOutputStore"] as JobOutputStore;
        var keycloakClient = Program.ServiceProvider.GetRequiredService<IKeycloakUserService>();
        
        var group = await keycloakClient.GetGroupByPathAsync(buildConf.AuthClientId);
        if (group == null)
        {
            outputStore?.AppendOutput(jobId!, $"Group bulunamadı: {buildConf.AuthClientId}");
            return;
        }
        
        
        if(!group.Attributes.TryGetValue("StoreMongoConnectionString",out var mongoConnectionString ) 
           && (mongoConnectionString == null || 
               string.IsNullOrEmpty(mongoConnectionString.ToList().FirstOrDefault())))
        {
            outputStore?.AppendOutput(jobId!, $"Mongo connection string bulunamadı: {buildConf.AuthClientId}");
            return;
        }
        
        if (!group.Attributes.TryGetValue("StoreId", out var storeId)&& 
            (storeId == null || 
             string.IsNullOrEmpty(storeId.ToList().FirstOrDefault())))
        {
            outputStore?.AppendOutput(jobId!, $"StoreId bulunamadı: {buildConf.AuthClientId}");
            return;
        }
        
        // Resolve only when executing; job arguments and persisted build configuration contain no client secret.
        buildConf = JsonSerializer.Deserialize<AppBuildsConfig>(JsonSerializer.Serialize(buildConf))!;
        buildConf.KeycloakClientSecret = await Program.ServiceProvider.GetRequiredService<ITenantSecrets>()
            .GetAsync(buildConf.AuthClientId, TenantSecretNames.KeycloakClient);
        var buildManager = new TenantManagerClaude.BuildManager(
            buildConf,
            "https://storage.example.invalid",
            new Uri("https://storage.example.invalid"),
            Program.ServiceProvider.GetRequiredService<ITenantSecrets>(),
            redisConnectionString,
            $"https://osman-kabasakal:{gitPass}@github.com/osman-kabasakal/LocalBusinessEcommerce_BusinessEcommerce.git",
            outputStore!,
            jobId!
        );
        try
        {
            await buildManager.HandleBuild();
        }
        catch (Exception e)
        {
            outputStore?.AppendOutput(jobId!, e.ToString());
        }
    }
}

// Background Service
public class GrandnodeInstallerService : IHostedService
{
    private readonly ILogger<GrandnodeInstallerService> _logger;
    private readonly IBackgroundJobClient _backgroundJobClient;
    private readonly IConnectionMultiplexer _redis;
    private ISubscriber _subscriber;
    private readonly JobOutputStore _outputStore;
    private readonly IConfiguration _configuration;
    private bool _isRunning = false;
    private CancellationTokenSource _cancellationTokenSource;
    private readonly IRecurringJobManager _recurringJobManager;

    public GrandnodeInstallerService(
        IBackgroundJobClient backgroundJobClient,
        IConnectionMultiplexer redis,
        IRecurringJobManager recurringJobManager,
        JobOutputStore outputStore,
        ILogger<GrandnodeInstallerService> logger,
        IConfiguration configuration)
    {
        _logger = logger;
        _backgroundJobClient = backgroundJobClient;
        _redis = redis;
        _recurringJobManager = recurringJobManager;
        _outputStore = outputStore;
        _configuration = configuration;
        _cancellationTokenSource = new CancellationTokenSource();
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        _isRunning = true;
        InitializeSubscriptionsAsync();
    }

    private async Task InitializeSubscriptionsAsync()
    {
        while (_isRunning)
        {
            try
            {
                if (!_redis.IsConnected)
                {
                    _logger.LogWarning("Redis bağlantısı koptu. Yeniden bağlanılıyor...");
                    await Task.Delay(5000, _cancellationTokenSource.Token);
                    continue;
                }

                _subscriber = _redis.GetSubscriber();

                await SubscribeToChannelAsync("test-channel",
                    async (channel, message) => { _logger.LogInformation($"Message: {message}"); });

                // Tenant Status Events Subscription
                await SubscribeToChannelAsync("tenant-status-events", async (channel, message) =>
                {
                    try
                    {
                        var tenantMessage = JsonSerializer.Deserialize<TenantStatusMessage>(message);
                        if (tenantMessage != null)
                        {
                            await ProcessTenantStatusMessageAsync(tenantMessage);
                        }
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "tenant-status-events message işlenirken hata oluştu");
                    }
                });

                // Frontend Credential Subscription
                await SubscribeToChannelAsync("FRONTEND_CREDENTIAL", async (channel, message) =>
                {
                    try
                    {
                        await ProcessFrontendCredentialMessageAsync(message);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "FRONTEND_CREDENTIAL message işlenirken hata oluştu");
                    }
                });

                // Completed Migration Subscription
                await SubscribeToChannelAsync("COMPLETED_MIGRATION", async (channel, message) =>
                {
                    try
                    {
                        // await ProcessCompletedMigrationMessageAsync(message);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "COMPLETED_MIGRATION message işlenirken hata oluştu");
                    }
                });

                await SubscribeToChannelAsync("NEW_BUILD", async (channel, message) =>
                {
                    try
                    {
                        await ProcessNewBuildMessageAsync(message);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "COMPLETED_MIGRATION message işlenirken hata oluştu");
                    }
                });

                // Subscription başarılı olduktan sonra sonsuz bekleme
                await Task.Delay(Timeout.Infinite, _cancellationTokenSource.Token);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Subscription sırasında hata oluştu. Yeniden deneniyor...");
                await Task.Delay(5000, _cancellationTokenSource.Token);
            }
        }
    }

    private async Task SubscribeToChannelAsync(string channelName, Action<RedisChannel, RedisValue> handler)
    {
        try
        {
            await _subscriber.SubscribeAsync(RedisChannel.Literal(channelName), handler);
            _logger.LogInformation($"{channelName} kanalına başarıyla subscribe olundu");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"{channelName} kanalına subscribe olurken hata oluştu");
            throw;
        }
    }

    private async Task ProcessNewBuildMessageAsync(RedisValue message)
    {
        try
        {
            var tenantMessage = JsonSerializer.Deserialize<AppBuildsConfig>(message);
            if(tenantMessage == null)
                return;
            
            var redisConnection = _configuration["redispublisher"]!;
            var  githubToken = _configuration["Cli:GithubToken"]!;
            BackgroundJob.Enqueue<SubscriberHandlers>((x) =>
                x.ProcessNewBuild(new ProcessTenantMessageParams()
                    {
                        TenantStatusMessage = new TenantStatusMessage()
                    }, tenantMessage,
                    redisConnection,
                    githubToken
                    ));

            _logger.LogInformation($"newBuildMessage  başarıyla kuyruğa eklendi: {tenantMessage.Flavor}");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Tenant message işlenirken hata: {message}");
        }
    }

    private async Task ProcessTenantStatusMessageAsync(TenantStatusMessage tenantMessage)
    {
        try
        {
            BackgroundJob.Enqueue<SubscriberHandlers>((x) =>
                x.SendWelcomMessage(new ProcessTenantMessageParams()
                    {
                        TenantStatusMessage = tenantMessage
                    }, "maintainer@example.invalid",
                    _configuration["Email:Password"]!));
            BackgroundJob.Enqueue<SubscriberHandlers>(
                (c) => c.ProcessTenantMessage(new ProcessTenantMessageParams()
                {
                    TenantStatusMessage = tenantMessage
                })
            );
            _logger.LogInformation($"Tenant message başarıyla kuyruğa eklendi: {tenantMessage.StoreName}");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Tenant message işlenirken hata: {tenantMessage.StoreName}");
        }
    }

    private async Task ProcessFrontendCredentialMessageAsync(RedisValue message)
    {
        try
        {
            var tenantMessage = JsonSerializer.Deserialize<ResponseWithCredentialsModel>(message);
            using (var scope = Program.ServiceProvider.CreateScope())
            {
                var environments = scope.ServiceProvider.GetRequiredService<IHostEnvironment>();
                var credentialsFolder = Path.Combine(environments.ContentRootPath, "Credentials");

                if (!Directory.Exists(credentialsFolder))
                {
                    Directory.CreateDirectory(credentialsFolder);
                }

                if (!string.IsNullOrEmpty(message))
                {
                    var filePath = Path.Combine(credentialsFolder,
                        $"{tenantMessage.Message.StoreName}_client_credential.json");
                    await File.WriteAllTextAsync(filePath, message.ToString());
                    _logger.LogInformation($"Credential dosyası kaydedildi: {filePath}");
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Frontend credential işlenirken hata oluştu");
        }
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        _isRunning = false;
        _cancellationTokenSource.Cancel();

        try
        {
            _subscriber?.UnsubscribeAll();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Service durdurulurken hata oluştu");
        }
    }
}


public class Program
{
    private static IHost? _host;
    private static readonly AutoResetEvent _waitHandle = new AutoResetEvent(false);
    private static bool _isRunning = true;

    public static async Task Main(string[] args)
    {
        if (args.Count(x => x is "--readiness-email-worker" or "--provisioning-worker" or "--tenant-schedule-worker") > 1)
            throw new ArgumentException("Choose one worker mode.");
        if (args.Contains("--tenant-schedule-worker"))
        {
            await TenantManager.Provisioning.TenantScheduleHost.RunAsync(args.Where(x => x != "--tenant-schedule-worker").ToArray());
            return;
        }
        if(args.Contains("--readiness-email-worker"))
        {
            if(args.Contains("--provisioning-worker"))throw new ArgumentException("Choose one worker mode.");
            await TenantManager.Provisioning.ReadinessEmailHost.RunAsync(args.Where(x=>x!="--readiness-email-worker").ToArray());
            return;
        }
        if (args.Contains("--provisioning-worker"))
        {
            await TenantManager.Provisioning.WorkerHost.RunAsync(args.Where(x=>x!="--provisioning-worker").ToArray());
            return;
        }
        _host = CreateHostBuilder(args).Build();

        ServiceProvider = _host.Services;
        var logger = ServiceProvider.GetRequiredService<ILogger<Program>>();
        // Hangfire global configuration
        GlobalConfiguration.Configuration
            .UseFilter(new AutomaticRetryAttribute { Attempts = 3 });

        logger.LogInformation($"isOutput redirected:{Console.IsOutputRedirected}");

        // Ctrl+C yakalamak için
        Console.CancelKeyPress += (sender, e) =>
        {
            e.Cancel = true;
            _isRunning = false;
            _waitHandle.Set();
        };

        // Service'i başlat
        _host.Start();
        // UI thread'ini başlat
        var uiThread = new Thread(RunUserInterface)
        {
            IsBackground = true
        };
        uiThread.Start();

        // Ana thread'i beklet
        _waitHandle.WaitOne();

        // Uygulama kapatılırken
        await _host.StopAsync();
    }

    private static void RunUserInterface()
    {
        while (_isRunning)
        {
            Console.Clear();
            Console.WriteLine("=== Tenant Manager Konsol ===");
            Console.WriteLine("1. Arkaplan hizmet durumlarını göster");
            Console.WriteLine("2. Aktif hizmeti durdur ve sil");
            Console.WriteLine("3. Bekleyen hizmeti sil");
            Console.WriteLine("4. Konsol çıktılarını göster");
            Console.WriteLine("5. Redis bağlantısını test et");
            Console.WriteLine("6. Son işlem loglarını göster");
            Console.WriteLine("7. Migration Test");
            Console.WriteLine("8. Build Test");
            Console.WriteLine("9. All Build Event Trigger");
            Console.WriteLine("0. Çıkış");
            Console.WriteLine("\nSeçiminiz: ");

            var keyInfo = Console.ReadKey(true);
            Console.WriteLine();

            try
            {
                switch (keyInfo.KeyChar)
                {
                    case '1':
                        ShowBackgroundJobs();
                        break;
                    case '2':
                        DeleteActiveJob();
                        break;
                    case '3':
                        DeleteEnqueuedJob();
                        break;
                    case '4':
                        ShowJobConsoleOutput();
                        break;
                    case '5':
                        TestRedisConnection();
                        break;
                    case '6':
                        ShowLastLogs();
                        break;
                    case '7':
                        RunMigrationTest();
                        break;
                    case '8':
                        RunBuildTest();
                        break;
                    case '9':
                        AllBuildEvent();
                        break;
                    case '0':
                        _isRunning = false;
                        _waitHandle.Set();
                        return;
                }

                Console.WriteLine("\nDevam etmek için bir tuşa basın...");
                Console.ReadKey(true);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\nHata oluştu: {ex.Message}");
                Console.WriteLine("Devam etmek için bir tuşa basın...");
                Console.ReadKey(true);
            }
        }
    }

    private static void RunBuildTest() =>
        throw new NotSupportedException("Configure your own tenant before running a cloud build.");

    private static void RunMigrationTest() =>
        throw new NotSupportedException("Use the local demo bootstrap to create sample tenants.");

    private static void ShowBackgroundJobs()
    {
        Console.WriteLine("\nArkaplan Hizmet Durumları:");
        using var connection = JobStorage.Current.GetConnection();
        var monitoring = JobStorage.Current.GetMonitoringApi();

        var statistics = monitoring.GetStatistics();
        Console.WriteLine($"Aktif işler: {statistics.Processing}");
        Console.WriteLine($"Bekleyen işler: {statistics.Enqueued}");
        Console.WriteLine($"Başarılı işler: {statistics.Succeeded}");
        Console.WriteLine($"Başarısız işler: {statistics.Failed}");

        if (statistics.Processing > 0)
        {
            Console.WriteLine("\nAktif İşler:");
            var processingJobs = monitoring.ProcessingJobs(0, 10);
            foreach (var job in processingJobs)
            {
                Console.WriteLine($"Job ID: {job.Key} - Başlangıç: {job.Value.StartedAt}");
            }
        }
    }

    private static void TestRedisConnection()
    {
        Console.WriteLine("\nRedis Bağlantısı Test Ediliyor...");
        var redis = ServiceProvider.GetRequiredService<IConnectionMultiplexer>();

        if (redis.IsConnected)
        {
            Console.WriteLine("Redis bağlantısı aktif");
            Console.WriteLine($"Endpoint: {redis.Configuration}");

            var subscriber = redis.GetSubscriber();
            var channels = subscriber.Publish("test-channel", "test-message");
            Console.WriteLine($"Test mesajı gönderildi. Aktif dinleyici sayısı: {channels}");
        }
        else
        {
            Console.WriteLine("Redis bağlantısı kapalı!");
            Console.WriteLine("Bağlantı detayları:");
            foreach (var endpoint in redis.GetEndPoints())
            {
                var server = redis.GetServer(endpoint);
                Console.WriteLine($"Endpoint: {endpoint} - Durum: {server.ServerType}");
            }
        }
    }
    
    private static void AllBuildEvent()
    {
        Console.WriteLine("\nAll Build event triggered...");
        var redis = ServiceProvider.GetRequiredService<IConnectionMultiplexer>();

        if (redis.IsConnected)
        {
            Console.WriteLine("Redis bağlantısı aktif");
            Console.WriteLine($"Endpoint: {redis.Configuration}");

            var subscriber = redis.GetSubscriber();
            var channels = subscriber.Publish("UPGRADE_ALL_APPS", JsonSerializer.Serialize(new AllAppBuildsRedisMessage()
            {
                ClientIds = new List<string>()
                {
                    // "atolye",
                    // "davetiyen-store",
                    // "diamond-famizyo",
                    // "famizyo-butik",
                    // "saray-pastanesi",
                    "yasemin-doner"
                }
            }));
            Console.WriteLine($"Test mesajı gönderildi. Aktif dinleyici sayısı: {channels}");
        }
        else
        {
            Console.WriteLine("Redis bağlantısı kapalı!");
            Console.WriteLine("Bağlantı detayları:");
            foreach (var endpoint in redis.GetEndPoints())
            {
                var server = redis.GetServer(endpoint);
                Console.WriteLine($"Endpoint: {endpoint} - Durum: {server.ServerType}");
            }
        }
    }

    private static void ShowLastLogs()
    {
        var logsPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Logs");
        if (!Directory.Exists(logsPath))
        {
            Console.WriteLine("Henüz log dosyası oluşturulmamış.");
            return;
        }

        var lastLogFile = Directory
            .GetFiles(logsPath, "log-*.txt")
            .OrderByDescending(f => File.GetLastWriteTime(f))
            .FirstOrDefault();

        if (lastLogFile == null)
        {
            Console.WriteLine("Log dosyası bulunamadı.");
            return;
        }

        Console.WriteLine($"\nSon loglar ({Path.GetFileName(lastLogFile)}):");
        var lastLogs = File.ReadLines(lastLogFile).TakeLast(20);
        foreach (var log in lastLogs)
        {
            Console.WriteLine(log);
        }
    }

    private static void DeleteActiveJob()
    {
        Console.WriteLine("\nAktif İşler Siliniyor...");
        var api = JobStorage.Current.GetMonitoringApi();
        var processingJobs = api.ProcessingJobs(0, int.MaxValue);

        foreach (var job in processingJobs)
        {
            BackgroundJob.Delete(job.Key);
            Console.WriteLine($"Job silindi: {job.Key}");
        }
    }

    private static void DeleteEnqueuedJob()
    {
        Console.WriteLine("\nBekleyen İşler Siliniyor...");
        var api = JobStorage.Current.GetMonitoringApi();
        var enqueuedJobs = api.EnqueuedJobs("default", 0, int.MaxValue);

        foreach (var job in enqueuedJobs)
        {
            BackgroundJob.Delete(job.Key);
            Console.WriteLine($"Job silindi: {job.Key}");
        }
    }

    private static void ShowJobConsoleOutput()
    {
        var api = JobStorage.Current.GetMonitoringApi();
        var processingJobs = api.ProcessingJobs(0, int.MaxValue);
        var outputStore = ServiceProvider.GetRequiredService<JobOutputStore>();

        Console.WriteLine("\nAktif İş Çıktıları:");
        foreach (var job in processingJobs)
        {
            Console.WriteLine($"\nJob ID: {job.Key}");
            Console.WriteLine($"Job Tipi: {job.Value.Job.Type}");
            Console.WriteLine($"Job Methodu: {job.Value.Job.Method.Name}");
            Console.WriteLine($"Başlangıç Zamanı: {job.Value.StartedAt}");
            Console.WriteLine("--- Job Çıktısı ---");
            Console.WriteLine(outputStore.GetOutput(job.Key));
            Console.WriteLine("------------------------");
        }

        if (!processingJobs.Any())
        {
            Console.WriteLine("Aktif iş bulunamadı.");
        }
    }

    public static IServiceProvider ServiceProvider;

    public static IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .ConfigureLogging((hostContext, logging) => { })
            .ConfigureAppConfiguration((context, confBuilder) =>
            {
                confBuilder.AddJsonFile("appsettings.json", optional: true).AddEnvironmentVariables();
                var config = confBuilder.Build();
                var localPath = config["LocalDemo:ConfigPath"];
                if (!string.IsNullOrWhiteSpace(localPath)) confBuilder.AddJsonFile(localPath, optional: false);
                confBuilder.AddEnvironmentVariables();
                config = confBuilder.Build();
                var vault = config["AZURE_KEY_VAULT_ENDPOINT"];
                if (!config.GetValue<bool>("LocalDemo:Enabled") && !string.IsNullOrWhiteSpace(vault))
                    confBuilder.AddAzureKeyVault(new Uri(vault), new DefaultAzureCredential());
            })
            .ConfigureServices((hostContext, services) =>
            {
                services.AddLogging(builder =>
                {
                    builder.ClearProviders();
                    builder.SetMinimumLevel(LogLevel.Trace);
                    // builder.AddDebug();
                    // builder.AddConsole();
                    builder.AddFile(Path.Combine("Logs", "log-{Date}.txt"));
                });
                // Singleton JobOutputStore ekle
                services.AddSingleton<JobOutputStore>();

                // Redis configuration
                services.AddSingleton<IConnectionMultiplexer>((sp) =>
                    {
                        var configuration =
                            ConfigurationOptions.Parse(hostContext.Configuration.GetValue<string>("redispublisher"));
                        configuration.AbortOnConnectFail = false;
                        configuration.ConnectRetry = 5;
                        configuration.ReconnectRetryPolicy = new LinearRetry(5000);
                        configuration.KeepAlive = 60;
                        return ConnectionMultiplexer.Connect(configuration);
                    }
                );

                // Hangfire configuration
                services.AddHangfire(config =>
                {
                    config.SetDataCompatibilityLevel(CompatibilityLevel.Version_180)
                        .UseSimpleAssemblyNameTypeSerializer()
                        .UseRecommendedSerializerSettings()
                        .UseInMemoryStorage();
                        // .UseSqlServerStorage(
                        //     "Server=localhost,1433;Database=local_business_jobs;trusted_connection=false;Integrated Security=False;Persist Security Info=False;User ID=sa;Password=CHANGE_ME;Encrypt=False");
                    config.UseFilter(new AutomaticRetryAttribute { Attempts = 3 });
                    config.UseFilter<CustomJobFilter>(
                        new CustomJobFilter(services.BuildServiceProvider().GetRequiredService<JobOutputStore>()));
                });
                services.AddHangfireServer(options =>
                {
                    options.ServerTimeout = TimeSpan.FromMinutes(180);
                    options.ShutdownTimeout = TimeSpan.FromMinutes(180);
                    options.ServerName = $"TenantManager-{Environment.MachineName}";
                });

                // Configure email template settings
                var config = new EmailTemplateConfig();

                // Register services
                services.AddSingleton(config);
                services.AddSingleton<ITemplateEngine>(sp =>
                {
                    var baseTemplate = File.ReadAllText(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets",
                        "MailTemplate.html"));
                    return new EmailTemplateEngine(config, baseTemplate);
                });

                services.AddHostedService<GrandnodeInstallerService>();
                
                var conf = new KeycloakSettings();
                
                hostContext.Configuration.GetSection("KeyCloakServiceClient").Bind(conf);
                conf.ClientSecret = hostContext.Configuration[$"ClientSecret-{conf.ClientId}"];
                
                services.AddSingleton(conf);
                
                services.Configure<KeycloakSettings>(hostContext.Configuration.GetSection("KeyCloakServiceClient"));

                services.AddPlatformSecurity(hostContext.Configuration, hostContext.HostingEnvironment.EnvironmentName);
                services.AddSingleton<IKeycloakService, KeycloakService>();
                services.AddSingleton<IKeycloakUserService, KeycloakUserService>();
                services.AddHttpClient();
            });
}