using Grand.Domain.Tasks;
using Grand.Installer.Cli.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace LocalDemo.Tests;

[TestClass]
public class ManagedBaseInstallationTests
{
    [TestMethod]
    public void ExistingStoreAndPluginTasksDoNotProveBaseInstallationCompleted()
    {
        Assert.IsFalse(ManagedBaseInstallation.IsComplete(["Plugin.Task, Plugin"], false, false, false));
    }

    [TestMethod]
    public void MissingCoreTaskOrPermissionsOrLayoutsOrPasswordBlocksCompletion()
    {
        var types = ScheduleTaskDefaults.Create().Select(task => task.Type).ToArray();
        Assert.IsFalse(ManagedBaseInstallation.IsComplete(types.Skip(1), true, true, true));
        Assert.IsFalse(ManagedBaseInstallation.IsComplete(types, false, true, true));
        Assert.IsFalse(ManagedBaseInstallation.IsComplete(types, true, false, true));
        Assert.IsFalse(ManagedBaseInstallation.IsComplete(types, true, true, false));
    }

    [TestMethod]
    public void CompleteBaseInstallationAllowsAdditionalPluginTasks()
    {
        var types = ScheduleTaskDefaults.Create().Select(task => task.Type).Append("Plugin.Task, Plugin");
        Assert.IsTrue(ManagedBaseInstallation.IsComplete(types, true, true, true));
    }
}
