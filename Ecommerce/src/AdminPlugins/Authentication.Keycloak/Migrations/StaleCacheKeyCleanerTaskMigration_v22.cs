using Authentication.Keycloak.Tasks;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Tasks;
using Grand.Infrastructure.Migrations;
using Grand.SharedKernel.Extensions;
using Grand.Web.Common.Extensions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;

namespace Authentication.Keycloak.Migrations;

public class StaleCacheKeyCleanerTaskMigration_v22 : IMigration
{
    public int Priority => 0;

    public DbVersion Version => new(2, 2);

    public Guid Identity => new("81ab1505-0925-4f24-b963-f2ebd1115b70");

    public string Name => "StaleCacheKeyCleanerTaskMigration_v22";

    public bool UpgradeProcess(IDatabaseContext database, IServiceProvider serviceProvider)
    {
        var logger = serviceProvider.GetRequiredService<ILogger<StaleCacheKeyCleanerTaskMigration_v22>>();
        try
        {
            var scheduleTaskService = serviceProvider.GetRequiredService<IScheduleTaskService>();
            var scheduleType = typeof(StaleCacheKeyCleanerTask);
            var taskAssemblyName = scheduleType.Assembly.GetName().Name;
            var taskFullname = $"{scheduleType.FullName}, {taskAssemblyName}";
            var task = scheduleTaskService.GetTaskByType(taskFullname).GetAwaiter().GetResult();
            if(task != null)
            {
                logger.LogInformation("Stale Cache Key Cleaner Task is already installed.");
                return true;
            }
            scheduleTaskService.InsertTask(new ScheduleTask() {
                ScheduleTaskName = "Stale Cache Key Cleaner Task",
                Type = taskFullname,
                Enabled = true,
                StopOnError = false,
                TimeInterval = CommonHelper.To<int>(TimeSpan.FromHours(5).TotalMinutes)
            }).GetAwaiter().GetResult();
            logger.LogInformation("Stale Cache Key Cleaner Task has been added to the schedule task list.");
            return true;
        }
        catch (System.Exception ex)
        {
            logger.LogError(ex,"Stale Cache Key Cleaner Task has not been added to the schedule task list.");
            return false;
        }
    }
}
