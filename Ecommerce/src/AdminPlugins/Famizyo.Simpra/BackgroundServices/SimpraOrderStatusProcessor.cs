using Famizyo.Simpra.Models;
using Famizyo.Simpra.Services;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Core.Interfaces.Tenants.TenantServiceProvider;
using Grand.Business.Tenants.Services.Hangfire;
using Grand.Data;
using Grand.Domain.Tenants;
using Grand.Infrastructure.Caching;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using StackExchange.Redis;
using System.Text.Json;

namespace Famizyo.Simpra.BackgroundServices;

public class SimpraOrderStatusProcessor : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly IConnectionMultiplexer _redis;
    private readonly ILogger<SimpraOrderStatusProcessor> _logger;

    public SimpraOrderStatusProcessor(
        IServiceProvider serviceProvider,
        IConnectionMultiplexer redis,
        ILogger<SimpraOrderStatusProcessor> logger)
    {
        _serviceProvider = serviceProvider;
        _redis = redis;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Simpra Order Status Processor started");

        try
        {
            using var scope = _serviceProvider.CreateScope();
            var settingService = scope.ServiceProvider.GetRequiredService<ISettingService>();
            var settings = settingService.LoadSetting<SimpraSettings>();

            var subscriber = _redis.GetSubscriber();
            var channel = $"{settings.RedisChannelPrefix}:order:status:updates";

            await subscriber.SubscribeAsync(channel, async (channelName, message) =>
            {
                try
                {
                    if (!message.HasValue)
                        return;

                    var statusUpdate = JsonSerializer.Deserialize<SimpraOrderStatusUpdate>(message);
                    if (statusUpdate != null)
                    {
                        await ProcessOrderStatusUpdate(statusUpdate, stoppingToken);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing Redis message: {Message}", message);
                }
            });

            // Keep the service running
            while (!stoppingToken.IsCancellationRequested)
            {
                await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);
            }
        }
        catch (OperationCanceledException)
        {
            _logger.LogInformation("Simpra Order Status Processor cancelled");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in Simpra Order Status Processor");
        }
    }

    private async Task ProcessOrderStatusUpdate(SimpraOrderStatusUpdate statusUpdate, CancellationToken stoppingToken)
    {
        try
        {
            var keycloakClient = _serviceProvider.GetRequiredService<IKeycloakClientService>().GetKeycloakClientAsync();
            var keycloakSetting = _serviceProvider.GetRequiredService<KeycloakSettings>();
            var cacheBase = _serviceProvider.GetRequiredService<ICacheBase>();

            var groups = await cacheBase.GetAsync("groups", async () =>
            {
                //TODO: bu listeyi tenant managerdan çekmem lazım
                return await keycloakClient.GetGroupHierarchyAsync(keycloakSetting.Realm,
                    cancellationToken: stoppingToken);
            });

            var tenantDb = groups.Where(x =>
                x.Attributes.ContainsKey("StoreMongoConnectionString") &&
                x.Attributes["StoreMongoConnectionString"].Count() > 0 && x.Attributes.ContainsKey("StoreId") &&
                x.Attributes["StoreId"].First() == statusUpdate.Tenant.StoreId).Select(x => new DataSettings() {
                ConnectionString = x.Attributes["StoreMongoConnectionString"].First(),
                DbProvider = DbProvider.MongoDB
            }).FirstOrDefault();

            var taskContext = new MultitenantTaskContext<SimpraOrderStatusUpdate> {
                CustomerId = null,
                JobArgs = statusUpdate,
                TenantDbSettings = tenantDb,
                ScopedServiceProvider =
                    _serviceProvider.GetRequiredService<ITenantScopedServiceProvider<IMongoDatabase>>()
            };

            await taskContext.RunInTenantScope(async serviceScope =>
                {
                    var orderService = serviceScope.ServiceProvider.GetRequiredService<ISimpraOrderService>();
                    var logger = serviceScope.ServiceProvider.GetRequiredService<ILogger<SimpraOrderStatusProcessor>>();
                    logger.LogInformation("Processing order status update: Order {OrderId}, Status: {Status}",
                        statusUpdate.OrderId, statusUpdate.NewStatus);
                    await orderService.ProcessOrderStatusUpdateAsync(statusUpdate);
                }
            );
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing order status update for order {OrderId}",
                statusUpdate.OrderId);
        }
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Simpra Order Status Processor stopping");
        return base.StopAsync(cancellationToken);
    }
}