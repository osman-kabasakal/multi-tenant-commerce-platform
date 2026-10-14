using Grand.Business.Core.Interfaces.Customers;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Customers;
using Grand.Domain.Stores;
using Grand.Domain.Tasks;
using Grand.Infrastructure;
using Grand.Infrastructure.MultiTenant;
using Hangfire;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using System;

namespace Authentication.Keycloak.MultitenantTasks;

public class MultitenantTask
{
    public static async Task RunForTenant(IJobCancellationToken jobCancellationToken,MultitenantTaskContext taskContext,string taskType)
    {
        var mongourl = new MongoUrl(taskContext.TenantDbSettings.ConnectionString);
        var databaseName = mongourl.DatabaseName;
        var database = new MongoClient(taskContext.TenantDbSettings.ConnectionString).GetDatabase(databaseName);
        var storeRepository = database.GetCollection<Store>(nameof(Store));
        var store = await storeRepository.AsQueryable()
            .FirstOrDefaultAsync();
        using (var scope = taskContext.ScopedServiceProvider!.CreateScopeWithReplacement(database,store?.Id))
        {
            var tenantIdentityAccessor = scope.ServiceProvider.GetRequiredService<ITenantIdentityAccessor>();
            tenantIdentityAccessor.TenantId = store?.Id;
            var dbContext = scope.ServiceProvider.GetRequiredService<IDatabaseContext>();
            dbContext.SetConnection(taskContext.TenantDbSettings.ConnectionString);
            if (!await dbContext.DatabaseExist())
            {
                return;
            }
            
            var delayTime= await RunTask(jobCancellationToken,scope,taskType);
            if(jobCancellationToken.ShutdownToken.IsCancellationRequested || delayTime==null)
            {
                return;
            }

            BackgroundJob.Schedule(MultitenantBackgroundTaskService.TenantTaskQueue,() => MultitenantTask.RunForTenant(JobCancellationToken.Null,new MultitenantTaskContext{
                TenantDbSettings= taskContext.TenantDbSettings,
            },taskType),delayTime.Value);
        }
    }

    private static async Task<TimeSpan?> RunTask(IJobCancellationToken stoppingToken, IServiceScope scope,string _taskType)
    {
        var serviceProvider = scope.ServiceProvider;
        var logger = serviceProvider.GetRequiredService<ILogger<MultitenantTask>>();
        var scheduleTaskService = serviceProvider.GetRequiredService<IScheduleTaskService>();
        var task = await scheduleTaskService.GetTaskByType(_taskType);
        if (_taskType.Contains("TrendyolIntegration"))
        {
            var debug = true;
        }
        if (task == null)
        {
            logger.LogInformation("Task {TaskType} is not exists in the database", _taskType);

            return null;
        }

        var machineName = Environment.MachineName;
        var timeInterval = task.TimeInterval > 0 ? task.TimeInterval : 1;
        if (task.Enabled && (string.IsNullOrEmpty(task.LeasedByMachineName) ||
                             machineName == task.LeasedByMachineName))
        {
            var typeofTask = Type.GetType(_taskType);
            if (typeofTask != null)
            {
                var scheduleTask = serviceProvider.GetServices<IScheduleTask>()
                    .FirstOrDefault(x => x.GetType() == typeofTask);
                if (scheduleTask != null)
                {
                    //assign current customer (background task) / current store (from task)
                    await WorkContext(serviceProvider, task);
                    var runTask = true;
                    if (task.LastStartUtc.HasValue)
                    {
                        var dateTimeNow = DateTime.UtcNow;
                        if (dateTimeNow < task.LastStartUtc.Value.AddMinutes(task.TimeInterval))
                        {
                            runTask = false;
                            timeInterval =
                                (int)(task.LastStartUtc.Value.AddMinutes(task.TimeInterval) - dateTimeNow)
                                .TotalMinutes;
                        }
                        else
                        {
                            runTask = true;
                            timeInterval = task.TimeInterval > 0 ? task.TimeInterval : 1;
                        }
                    }

                    if (runTask)
                    {
                        task.LastStartUtc = DateTime.UtcNow;
                        try
                        {
                            //TODO - add settings
                            //logger.Information($"Task {_taskType} execute");
                            await scheduleTask.Execute();
                            task.LastSuccessUtc = DateTime.UtcNow;
                            task.LastNonSuccessEndUtc = null;
                        }
                        catch (Exception exc)
                        {
                            task.LastNonSuccessEndUtc = DateTime.UtcNow;
                            task.Enabled = !task.StopOnError;
                            logger.LogError(exc,
                                "Error while running the \'{TaskScheduleTaskName}\' schedule task",
                                task.ScheduleTaskName);
                        }
                    }
                }
                else
                {
                    task.Enabled = !task.StopOnError;
                    task.LastNonSuccessEndUtc = DateTime.UtcNow;
                    logger.LogError("Type {TaskType} is not registered", _taskType);
                }
            }
            else
            {
                task.Enabled = !task.StopOnError;
                task.LastNonSuccessEndUtc = DateTime.UtcNow;
                logger.LogError("Type {TaskType} is null (type not exists)", _taskType);
            }

            await scheduleTaskService.UpdateTask(task);
            return TimeSpan.FromMinutes(timeInterval);
        }
        else
        {
            return null; ;
        }
    }

    private static async Task WorkContext(IServiceProvider serviceProvider, ScheduleTask scheduleTask)
    {
        var workContext = serviceProvider.GetRequiredService<IWorkContextSetter>();
        var storeHelper = serviceProvider.GetRequiredService<IStoreHelper>();
        var customerService = serviceProvider.GetRequiredService<ICustomerService>();
        var storeRepo = serviceProvider.GetRequiredService<IRepository<Store>>();
        var store = storeRepo.Table.First();
        await workContext.SetCurrentCustomer( await customerService.GetCustomerBySystemName(SystemCustomerNames.BackgroundTask));
        await storeHelper.SetCurrentStore(store.Id);
    }
}
