using Platform.Security;
using System.Text.Json;
using System.Text.Json.Serialization;
using Core.Utilities;
using MediatR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Models;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Enums;
using SaasManager.Domain.Events;
using StackExchange.Redis;

namespace SaasManager.Infrastructure.BackgorundServices.RedisEventHandlers;

public class RedisBackgroundListenerHostedService : BackgroundService
{
    private readonly ISubscriber _subscriber;
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<RedisBackgroundListenerHostedService> _logger;

    private CancellationTokenSource _redisfailConnectionToken = new CancellationTokenSource();

    public RedisBackgroundListenerHostedService(ISubscriber subscriber,
        IServiceProvider serviceProvider,
        ILogger<RedisBackgroundListenerHostedService> logger)
    {
        _subscriber = subscriber;
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    private const string CHANNEL_NAME = "COMPLETED_MIGRATION";
    private const string NEW_BUILD_CHANNEL_NAME = "NEW_BUILD_COMPLETED";
    private const string SCREENSHOT_CHANNEL_NAME = "SCREENSHOTS";

    private const string UPGRADE_ALL_APPS_CHANNEL_NAME = "UPGRADE_ALL_APPS";

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _subscriber.Multiplexer.ConnectionFailed += (sender, args) =>
        {
            _logger.LogError(args.Exception, "Redis bağlantısı kesildi");
            _redisfailConnectionToken.Cancel();
            _redisfailConnectionToken = new CancellationTokenSource();
        };
        while (!stoppingToken.IsCancellationRequested)
        {
            if (!_subscriber.Multiplexer.IsConnected)
            {
                _logger.LogWarning("Redis bağlantısı koptu. Yeniden bağlanılıyor...");
                await Task.Delay(5000, stoppingToken);
                continue;
            }

            await SubscribeToChannelAsync(CHANNEL_NAME, MigrationCompletedHandler);

            await SubscribeToChannelAsync(NEW_BUILD_CHANNEL_NAME, NewBuildHandler);

            await SubscribeToChannelAsync(SCREENSHOT_CHANNEL_NAME, ScreenshotHandler);
            
            await SubscribeToChannelAsync(UPGRADE_ALL_APPS_CHANNEL_NAME, UpgradeAllAppsHandler);

            using var wait = CancellationTokenSource.CreateLinkedTokenSource(stoppingToken,_redisfailConnectionToken.Token);
            try { await Task.Delay(Timeout.Infinite,wait.Token); }
            catch (OperationCanceledException) when(stoppingToken.IsCancellationRequested) { break; }
            catch (OperationCanceledException) { /* Redis reconnect: subscribe again. */ }
        }
    }

    void UpgradeAllAppsHandler(RedisChannel channel, RedisValue message)
    {
        _logger.LogInformation($"UpgradeAllApps Message: {message}");

        if (message == RedisValue.Null)
        {
            _logger.LogCritical($"Completed event null mesaj gönderdi!");
            return;
        }

        async Task UpgradeAllApp()
        {
            
            var model = JsonSerializer.Deserialize<AllAppBuildsRedisMessage>(message.ToString());

            using (var scope = _serviceProvider.CreateScope())
            {
                var _context = scope.ServiceProvider.GetRequiredService<IApplicationDbContext>();
                var logger = scope.ServiceProvider.GetRequiredService<ILogger<RedisBackgroundListenerHostedService>>();
                try
                {
                    var businessApps = _context.BusinessApps
                        .ToList();

                    var _mediator = scope.ServiceProvider.GetRequiredService<IMediator>();

                    foreach (var businessApp in businessApps)
                    {
                        var buildConf = businessApp.BuildConfiguration.Deserialize<AppBuildsConfig>();
                        if (model.ClientIds.Contains(buildConf.AuthClientId))
                        {
                            try
                            {
                                var logoMedia = await _context.AppMediaAssets
                                    .Where(x => x.AssetType == AppMediaAssetType.Logo && x.IsDefault && !x.IsDeleted &&
                                         x.BusinessAppId == businessApp.Id)
                                    .FirstOrDefaultAsync(CancellationToken.None);
                                buildConf.StoreLogo =
                                    logoMedia?.FilePath ?? "https://sanal-donusum.commerce.test/images/logo.svg";

                                var iconMedia = await _context.AppMediaAssets
                                    .Where(x => x.AssetType == AppMediaAssetType.Icon && x.IsDefault && !x.IsDeleted &&
                                         x.BusinessAppId == businessApp.Id)
                                    .FirstOrDefaultAsync(CancellationToken.None);
                                buildConf.StoreIcon =
                                    iconMedia?.FilePath ?? "https://sanal-donusum.commerce.test/favicon-96x96.png";

                                buildConf.BusinessAppId = businessApp.Id;
                                buildConf.Version = businessApp.Version;
                                buildConf.BuildNumber = businessApp.BuildNumber + 1;

                                var entity = new AppBuild()
                                {
                                    BusinessAppId = businessApp!.Id,
                                    Platform = BuildPlatform.Android,
                                    Version = businessApp.Version,
                                    BuildNumber = businessApp.BuildNumber + 1,
                                    BuildStatus = BuildStatus.Queued.ToString(),
                                    IsActive = true,
                                    Configuration = JsonDocument.Parse(JsonSerializer.Serialize(buildConf)),
                                    FileSize = 0,
                                };
                                await _context.AppBuilds.AddAsync(entity);

                                businessApp.SetBuildConfiguration(
                                    JsonDocument.Parse(JsonSerializer.Serialize(buildConf)));
                                businessApp.UpdateBuildStatus(BuildStatus.Queued);
                                businessApp.UpdateVersion(businessApp.Version, businessApp.BuildNumber + 1);
                                _context.BusinessApps.Update(businessApp);

                                await _context.SaveChangesAsync(CancellationToken.None);
                                await _mediator.Publish(new EntityCreatedEvent<AppBuild>(entity),
                                    CancellationToken.None);
                            }
                            catch (Exception e)
                            {
                                logger.LogError(e, e.Message);
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    logger.LogError(e, e.Message);
                }
            }
        }

        _ = Task.Run(UpgradeAllApp);
    }

    void ScreenshotHandler(RedisChannel channel, RedisValue message)
    {
        _logger.LogInformation($"Screenshot Message: {message}");

        if (message == RedisValue.Null)
        {
            _logger.LogCritical($"Completed event null mesaj gönderdi!");
            return;
        }

        var model = JsonSerializer.Deserialize<ScreenShotsRedisMessageModel>(message.ToString());
        if (model == null || model.ScreenshotModels.Count == 0)
        {
            _logger.LogCritical($"redis mesajı dönüştürülemedi {message}");
        }

        using var scope = _serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<IApplicationDbContext>();
        context.AppScreenshots.AddRange(
            model.ScreenshotModels.Select((ss) => new AppScreenshot()
            {
                BusinessAppId = ss.BusinessAppId,
                DisplayOrder = ss.DisplayOrder,
                FileName = ss.FileName,
                FilePath = ss.FilePath,
                ScreenType = ss.ScreenType
            })
        );

        context.SaveChangesAsync(default).GetAwaiter().GetResult();
    }

    void NewBuildHandler(RedisChannel channel, RedisValue message)
    {
        try
        {
            _logger.LogInformation($"NewBuild Message: {message}");

            if (message == RedisValue.Null)
            {
                _logger.LogCritical($"Completed event null mesaj gönderdi!");
                return;
            }

            var model = JsonSerializer.Deserialize<NewBuildRedisMessage>(message.ToString());
            if (model == null || model.BusinessAppId == Guid.Empty)
            {
                _logger.LogCritical($"redis mesajı dönüştürülemedi {message}");
            }

            using var scope = _serviceProvider.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<IApplicationDbContext>();
            var relatedAppBuilds = context.AppBuilds.Where((ab) =>
                ab.BusinessAppId == model!.BusinessAppId &&
                ab.BuildNumber == model.BuildNumber &&
                ab.Version == model.Version).ToList();

            if (relatedAppBuilds.Count == 0)
            {
                _logger.LogError("İlgili uygulama bulunamadı");
                return;
            }

            var allreadyBuildApp = relatedAppBuilds.FirstOrDefault(x =>
                (x.BuildStatus != BuildStatus.Queued.ToString() && x.Platform != model!.Platform));

            if (allreadyBuildApp != null)
            {
                _logger.LogError($"{model.Platform} için yeni derleme ekleniyor");

                context.AppBuilds.Add(new AppBuild
                {
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = default,
                    UpdatedAt = null,
                    IsDeleted = false,
                    DeletedAt = null,
                    DeletedBy = null,
                    IsActive = false,
                    BusinessAppId = allreadyBuildApp.BusinessAppId,
                    Platform = model.Platform,
                    Version = allreadyBuildApp.Version,
                    BuildNumber = allreadyBuildApp.BuildNumber,
                    FileSize = 0,
                    FilePath = model.FilePath,
                    FileHash = null,
                    BuildStatus = BuildStatus.Built.ToString(),
                    BuildDate = DateTime.UtcNow,
                    ExpiryDate = null,
                    Configuration = allreadyBuildApp.Configuration,
                });
            }
            else if (relatedAppBuilds.Any(x =>
                         (x.BuildStatus == BuildStatus.Queued.ToString() && x.Platform == model!.Platform)))
            {
                var relatedAppBuild = relatedAppBuilds.First(x =>
                    (x.BuildStatus == BuildStatus.Queued.ToString() && x.Platform == model!.Platform));

                relatedAppBuild.BuildStatus = BuildStatus.Built.ToString();
                relatedAppBuild.BuildDate = DateTime.UtcNow;
                relatedAppBuild.FilePath = model!.FilePath;
                relatedAppBuild.IsActive = false;
                // Güvenli bir şekilde güncelleme yapmak için önce varlığı kontrol edin
                var appBuildToUpdate = context.AppBuilds
                    .FirstOrDefault(x => x.Id == relatedAppBuild.Id);
                if (appBuildToUpdate != null)
                {
                    appBuildToUpdate.BuildStatus = BuildStatus.Built.ToString();
                    appBuildToUpdate.BuildDate = DateTime.UtcNow;
                    appBuildToUpdate.FilePath = model!.FilePath;
                    appBuildToUpdate.IsActive = false;
                    context.AppBuilds.Update(appBuildToUpdate);
                    _logger.LogInformation("AppBuild güncelleniyor - ID: {AppBuildId}, BuildStatus: {BuildStatus}",
                        appBuildToUpdate.Id, appBuildToUpdate.BuildStatus);
                }
            }

            var businessApp = context.BusinessApps
                .FirstOrDefault(ba => ba.Id == model.BusinessAppId);

            if (businessApp == null)
            {
                _logger.LogError("BusinessApp with ID {BusinessAppId} not found", model.BusinessAppId);
                return;
            }

            _logger.LogInformation(
                "Found BusinessApp - ID: {BusinessAppId}, BusinessId: {BusinessId}, Type: {AppType}, AppName: {AppName}",
                businessApp.Id, businessApp.BusinessId, businessApp.Type, businessApp.AppName);

            var quededBuilds = context.AppBuilds.Any(ab =>
                ab.BusinessAppId == model.BusinessAppId &&
                ab.BuildStatus == BuildStatus.Queued.ToString() &&
                ab.BuildNumber == model.BuildNumber &&
                ab.Version == model.Version);

            if (!quededBuilds)
            {
                // İşletme bilgisini de logla
                var business = context.Businesses
                    .FirstOrDefault(b => b.Id == businessApp.BusinessId);

                if (business != null)
                {
                    _logger.LogInformation(
                        "Related Business - ID: {BusinessId}, Name: {BusinessName}, CreatedByGuestId: {CreatedByGuestId}",
                        business.Id, business.Name, business.CreatedByGuestId);
                }

                businessApp.UpdateBuildStatus(BuildStatus.Built);
                context.BusinessApps.Update(businessApp);
                _logger.LogInformation(
                    "BusinessApp updated to status Built - ID: {BusinessAppId}, BusinessId: {BusinessId}",
                    businessApp.Id, businessApp.BusinessId);
            }

            context.SaveChangesAsync(default).GetAwaiter().GetResult();
        }
        catch (Exception e)
        {
            _logger.LogError(e, "NewBuildHandler da hata oluştu");
        }
    }

    void MigrationCompletedHandler(RedisChannel channel, RedisValue message)
    {
        try
        {
            _logger.LogInformation("Tenant migration completion received.");

            if (message == RedisValue.Null)
            {
                _logger.LogCritical($"Completed event null mesaj gönderdi!");
                return;
            }

            using var scope = _serviceProvider.CreateScope();

            var context = scope.ServiceProvider.GetRequiredService<IApplicationDbContext>();
            var model = JsonSerializer.Deserialize<ResponseWithCredentialsModel>(message.ToString());

            if (model == null || !model.IsSuccess)
                return;

            if (!Guid.TryParseExact(model.Message.TenantId, "N", out var businessId))
                throw new InvalidOperationException("Migration completion requires the stable business tenant ID.");
            var tenantSecrets = scope.ServiceProvider.GetRequiredService<ITenantSecrets>();
            if (tenantSecrets.ResolveAsync(model.Message.StoreSubDomain!).GetAwaiter().GetResult() != businessId.ToString("N"))
                throw new InvalidOperationException("Migration tenant alias does not match its business.");
            var bussinessByEmail = from guestRegistration in context.GuestRegistrations
                join business in context.Businesses on guestRegistration.ConvertedBusinessId equals business.Id
                where business.Id == businessId && guestRegistration.KeycloakUserId != null
                select new { guestRegistration, business };

            var businessWithGuest = bussinessByEmail.FirstOrDefault();
            if (businessWithGuest == null)
            {
                _logger.LogError($"Kullanıcı bulunamadı: {model.Message!.OwnerEmail}");
                return;
            }

            _logger.LogInformation(
                "Updating business status to Active - BusinessId: {BusinessId}, BusinessName: {BusinessName}",
                businessWithGuest.business.Id, businessWithGuest.business.Name);

            businessWithGuest.business.UpdateStatus(BusinessStatus.Active);
            context.Businesses.Update(businessWithGuest.business);
            context.SaveChangesAsync(default).GetAwaiter().GetResult();

            _logger.LogInformation("Finding BusinessApp for BusinessId: {BusinessId}", businessWithGuest.business.Id);

            var businessApps = context.BusinessApps
                .Where(b => b.BusinessId == businessWithGuest.business!.Id)
                .ToList();

            if (businessApps.Count > 1)
            {
                _logger.LogWarning("Multiple BusinessApps found for BusinessId: {BusinessId}, Count: {Count}",
                    businessWithGuest.business.Id, businessApps.Count);

                foreach (var app in businessApps)
                {
                    _logger.LogInformation(
                        "BusinessApp - ID: {AppId}, BusinessId: {BusinessId}, Type: {AppType}, Name: {AppName}",
                        app.Id, app.BusinessId, app.Type, app.AppName);
                }
            }

            var businessApp = businessApps.FirstOrDefault(b => b.Type == AppType.CustomerMobile);

            if (businessApp == null)
            {
                _logger.LogError($"Uygulama bulunamadı: {businessWithGuest.business!.Id}");
                return;
            }

            businessApp.SetBuildConfiguration(
                JsonDocument.Parse(JsonSerializer.Serialize(
                    new AppBuildsConfig
                    {
                        BusinessAppId = businessApp.Id,
                        GCloudProjectId = model.Message.Firebase?.ProjectId,
                        Flavor = model.Message!.StoreSubDomain!.ToFlutterFlavorName(),
                        StoreUrl = $"https://{model.Message!.StoreSubDomain}.commerce.test",
                        AuthUrl = "https://identity.commerce.test",
                        AuthRealm = "localhost",
                        AuthClientId = model.FrontEndCredentialInfo.ClientId,
                        KeycloakClientSecret = "", // Worker resolves it from ITenantSecrets at execution time.
                        StoreLogo = model.Message.LogoUrl ?? "",
                        StoreLogoId = model.Message.LogoId ?? "",
                        PackageNameAndroid = businessApp.PackageName,
                        PackageNameIos = businessApp.PackageName,
                        AppTitle = model.Message!.CompanyName
                    }
                ))
            );

            context.BusinessSettings.Add(new BusinessSettings(
                businessApp.BusinessId,
                "ApiUserName",
                model.BackendCredential.ApiUserName,
                businessWithGuest.business.Email,
                "E-ticaret api iletişim bilgileri",
                SettingType.Integration,
                SettingDataType.String,
                false,
                isRequired: false,
                groupName: "BackendApiCredentials"
            ));

            context.BusinessSettings.Add(new BusinessSettings(
                businessApp.BusinessId,
                "ApiPassword",
                "tenant-secret:" + businessId.ToString("N") + "/" + TenantSecretNames.BackendUserPassword,
                "",
                "E-ticaret api iletişim bilgileri",
                SettingType.Integration,
                SettingDataType.String,
                false,
                isRequired: false,
                groupName: "BackendApiCredentials"
            ));
            context.SaveChangesAsync(default).GetAwaiter().GetResult();
        }
        catch (Exception e)
        {
            _logger.LogError(e, "MigrationCompletedHandler da hata oluştu");
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
}

public class AllAppBuildsRedisMessage
{
    public List<string> ClientIds { get; set; } = new List<string>();
}

public class BasicResponseModel
{
    [JsonPropertyName("isSuccess")] public bool IsSuccess { get; set; }

    [JsonPropertyName("message")] public TenantStatusMessage? Message { get; set; }
}

public class ResponseWithCredentialsModel
{
    [JsonPropertyName("isSuccess")] public bool IsSuccess { get; set; }

    [JsonPropertyName("message")] public TenantStatusMessage Message { get; set; }

    [JsonPropertyName("frontEndCredentialInfo")]
    public FrontEndCredentialInfo FrontEndCredentialInfo { get; set; }

    [JsonPropertyName("backendCredential")]
    public BackendCredential BackendCredential { get; set; }
}

public class FrontEndCredentialInfo
{
    [JsonPropertyName("clientId")] public string ClientId { get; set; }

    [JsonIgnore] public string? ClientSecret { get; set; }
}

public class BackendCredential
{
    [JsonPropertyName("apiUserName")] public string ApiUserName { get; set; }

    [JsonIgnore] public string? ApiPassword { get; set; }
}

public class NewBuildRedisMessage
{
    public Guid BusinessAppId { get; set; }
    public string Version { get; set; } = null!;
    public int BuildNumber { get; set; }
    public BuildPlatform Platform { get; set; }
    public string FilePath { get; set; } = null!;
}

class ScreenShotsRedisMessageModel
{
    public List<ScreenshotModel> ScreenshotModels
    {
        get;
        set;
    } = new List<ScreenshotModel>();
}

class ScreenshotModel
{
    public Guid BusinessAppId { get; set; }
    public string? ScreenType { get; set; }
    public string? FileName { get; set; }
    public string? FilePath { get; set; }
    public int DisplayOrder { get; set; }
}
