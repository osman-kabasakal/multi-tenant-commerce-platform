

using Authentication.Keycloak.Services.RemoteUserManagement;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Data.Mongo;
using Grand.Domain.Tasks;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Plugins;
using Grand.Infrastructure.TypeSearch;
using Hangfire;
using Hangfire.Common;
using Hangfire.Storage.Monitoring;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using System.Reflection;

namespace Authentication.Keycloak.MultitenantTasks;

public class MultitenantBackgroundTaskService(
    ILogger<MultitenantBackgroundTaskService> logger,
    ITypeSearcher typeSearcher,
    IServiceProvider serviceProvider) : BackgroundService
{
    public static string TenantTaskQueue = "tenant_tasks";
    private readonly ILogger<MultitenantBackgroundTaskService> _logger = logger;
    private readonly ITypeSearcher typeSearcher = typeSearcher;
    private readonly IServiceProvider _serviceProvider = serviceProvider;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var keycloakClient = _serviceProvider.GetRequiredService<IKeycloakService>().GetKeycloakClientAsync();
        var keycloakSetting = _serviceProvider.GetRequiredService<KeycloakSettings>();
        var cacheBase = _serviceProvider.GetRequiredService<ICacheBase>();
        var api = JobStorage.Current.GetMonitoringApi();

        //Kayıtlı tüm işleri al
        var scheduleTasks = typeSearcher.ClassesOfType<IScheduleTask>();
        var scheduleTasksInstalled = scheduleTasks
            .Where(PluginExtensions.OnlyInstalledPlugins);

        while (!stoppingToken.IsCancellationRequested)
        {

            foreach (var task in scheduleTasksInstalled)
            {
                var taskAssemblyName = task.Assembly.GetName().Name;
                var taskFullname= $"{task.FullName}, {taskAssemblyName}";
                try
                {
                    var groups = await cacheBase.GetAsync("groups", async () =>
                    {
                        //TODO: bu listeyi tenant managerdan çekmem lazım
                        return await keycloakClient.GetGroupHierarchyAsync(keycloakSetting.Realm, cancellationToken: stoppingToken);
                    });
                    var tenantDbs = groups.Where(x => x.Attributes.ContainsKey("StoreMongoConnectionString") && x.Attributes["StoreMongoConnectionString"].Count() > 0).Select(x => new DataSettings() {
                        ConnectionString = x.Attributes["StoreMongoConnectionString"].First(),
                        DbProvider = DbProvider.MongoDB
                    }).ToList();
                    foreach (var tenantDb in tenantDbs)
                    {

                        // Tüm job listelerini al
                        var allJobs = new Dictionary<string, Job>();
                        
                        var processingJobs = api.ProcessingJobs(0, int.MaxValue);
                        var enqueuedJobs = api.EnqueuedJobs(TenantTaskQueue, 0, int.MaxValue);
                        var scheduledJobs = api.ScheduledJobs(0, int.MaxValue);

                        // Tüm jobları birleştir
                        foreach (var job in processingJobs) allJobs.TryAdd(job.Key, job.Value.Job);
                        foreach (var job in enqueuedJobs) allJobs.TryAdd(job.Key, job.Value.Job);
                        foreach (var job in scheduledJobs) allJobs.TryAdd(job.Key, job.Value.Job);

                        // Bu tenant ve görev için çalışan bir iş var mı kontrol et
                        var hasExistingJob = allJobs.Any(job => 
                            job.Value.Type == typeof(MultitenantTask) &&
                            job.Value.Args.Count == 3 &&
                            job.Value.Args[2].ToString().Replace("\"", string.Empty) == taskFullname &&
                            ((MultitenantTaskContext)job.Value.Args[1]).TenantDbSettings.ConnectionString == tenantDb.ConnectionString);


                        if(!hasExistingJob)
                        {
                            _logger.LogInformation($"Scheduling new job task {taskFullname}");
                            BackgroundJob.Enqueue(() => MultitenantTask.RunForTenant(JobCancellationToken.Null, new MultitenantTaskContext
                            {
                                TenantDbSettings = tenantDb,
                            }, taskFullname));

                            await Task.Delay(TimeSpan.FromSeconds(1), stoppingToken);
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error occurred while processing tenant tasks");
                    await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
                }
            }


            await Task.Delay(TimeSpan.FromMinutes(20), stoppingToken);
        }
    }

    public override async Task StopAsync(CancellationToken cancellationToken)
    {
        try
        {
            var api = JobStorage.Current.GetMonitoringApi();

            var processingJobs = api.ProcessingJobs(0, int.MaxValue);
            var enqueuedJobs = api.EnqueuedJobs(TenantTaskQueue, 0, int.MaxValue);
            var scheduledJobs = api.ScheduledJobs(0, int.MaxValue);

            foreach (var job in processingJobs) BackgroundJob.Delete(job.Key);
            foreach (var job in enqueuedJobs) BackgroundJob.Delete(job.Key);
            foreach (var job in scheduledJobs) BackgroundJob.Delete(job.Key);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error occurred while stopping tenant tasks");
        }
        await base.StopAsync(cancellationToken);
    }




}