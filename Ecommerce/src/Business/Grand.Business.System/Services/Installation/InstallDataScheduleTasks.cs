using Grand.Domain.Tasks;

namespace Grand.Business.System.Services.Installation;

public partial class InstallationService
{
    protected virtual Task InstallScheduleTasks()
    {
        //these tasks are default - they are created in order to insert them into database
        //and nothing above it
        //there is no need to send arguments into ctor - all are null
        foreach (var task in ScheduleTaskDefaults.Create())
            if (!_scheduleTaskRepository.Table.Any(existing => existing.Type == task.Type))
                _scheduleTaskRepository.Insert(task);
        return Task.CompletedTask;
    }
}