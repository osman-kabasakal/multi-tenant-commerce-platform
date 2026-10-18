using System.Text.Json;
using System.Text.Json.Nodes;
using Grand.Business.Core.Commands.System.Security;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.System.Services.Installation;
using Grand.Infrastructure.Caching;
using Grand.Installer.Cli.Models;
using MediatR;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Grand.Installer.Cli.Services;

public static class ManagedBaseInstallationRepair
{
    public static async Task RunAsync(IServiceScope scope, IConfiguration config, TenantStatusMessage message)
    {
        if (!ManagedBaseInstallation.IsComplete(scope, message.OwnerEmail!))
        {
            var installer = (InstallationService)scope.ServiceProvider.GetRequiredService<Grand.Business.Core.Interfaces.System.Installation.IInstallationService>();
            await installer.CompleteInterruptedBaseInstallation(message.OwnerEmail!, message.Password!);
            var permissions = scope.ServiceProvider.GetRequiredService<IPermissionProvider>();
            await scope.ServiceProvider.GetRequiredService<IMediator>()
                .Send(new InstallPermissionsCommand { PermissionProvider = permissions });
            ManagedBaseInstallation.RequireComplete(scope, message.OwnerEmail!);
            await scope.ServiceProvider.GetRequiredService<ICacheBase>().Clear();
        }
        var path = config["Provisioning:TenantOutput"]!;
        // Also replay settings when a previous repair completed the base data but stopped
        // before invalidating its old receipt. The next phase reloads typed settings.
        var settings = Path.Combine(Path.GetDirectoryName(path)!, message.StoreSubDomain + ".tenant-settings.json");
        if (File.Exists(settings)) File.Move(settings, settings + ".before-base-repair." + Guid.NewGuid().ToString("N"));
        var value = JsonNode.Parse(await File.ReadAllTextAsync(path))!.AsObject();
        if (value["baseInstallationVerified"]?.GetValue<bool>() != true)
        {
            File.Copy(path, path + ".before-base-repair." + Guid.NewGuid().ToString("N"));
            value["baseInstallationVerified"] = true;
            var temporary = path + "." + Guid.NewGuid().ToString("N") + ".tmp";
            var options = new FileStreamOptions { Mode = FileMode.CreateNew, Access = FileAccess.Write, Share = FileShare.None };
            if (!OperatingSystem.IsWindows()) options.UnixCreateMode = UnixFileMode.UserRead | UnixFileMode.UserWrite;
            try
            {
                await using (var output = new FileStream(temporary, options))
                    await JsonSerializer.SerializeAsync(output, value);
                File.Move(temporary, path, true);
            }
            finally { if (File.Exists(temporary)) File.Delete(temporary); }
        }
    }
}
