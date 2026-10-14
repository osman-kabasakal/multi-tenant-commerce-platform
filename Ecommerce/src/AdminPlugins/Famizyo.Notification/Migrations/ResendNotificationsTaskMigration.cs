using Famizyo.Notification.Tasks;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Data;
using Grand.Domain.Tasks;
using Grand.Infrastructure.Migrations;
using Grand.SharedKernel.Extensions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Famizyo.Notification.Migrations;

/// <summary>
/// Migration to register the resend unseen notifications task
/// </summary>
public class ResendNotificationsTaskMigration : IMigration
{
    public int Priority => 1;
    public bool UpgradeProcess(IDatabaseContext database, IServiceProvider serviceProvider)
    {
        var logger = serviceProvider.GetRequiredService<ILogger<ResendNotificationsTaskMigration>>();
        try
        {
            var scheduleTaskService = serviceProvider.GetRequiredService<IScheduleTaskService>();
            var scheduleType = typeof(ResendUnseenNotificationsTask);
            var taskAssemblyName = scheduleType.Assembly.GetName().Name;
            var taskFullname = $"{scheduleType.FullName}, {taskAssemblyName}";
            var task = scheduleTaskService.GetTaskByType(taskFullname).GetAwaiter().GetResult();
            if(task != null)
            {
                logger.LogInformation("resend unseen notifications Task is already installed.");
                return true;
            }
            scheduleTaskService.InsertTask(new ScheduleTask() {
                ScheduleTaskName = "resend unseen notifications Task",
                Type = taskFullname,
                Enabled = true,
                StopOnError = false,
                TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(1).TotalMinutes)
            }).GetAwaiter().GetResult();
            logger.LogInformation("resend unseen notifications Task has been added to the schedule task list.");
            return true;
        }
        catch (System.Exception ex)
        {
            logger.LogError(ex,"resend unseen notifications Task has not been added to the schedule task list.");
            return false;
        }
    }

    public DbVersion Version => new(0, 1);
    
    public Guid Identity => new("02485b9e-68e4-4227-bf51-45dbe1a60ec0");
    
    public string Name => "Register resend unseen notifications task";
    
}