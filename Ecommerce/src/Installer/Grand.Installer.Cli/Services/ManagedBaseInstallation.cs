using Grand.Data;
using Grand.Domain.Catalog;
using Grand.Domain.Customers;
using Grand.Domain.Pages;
using Grand.Domain.Permissions;
using Grand.Domain.Tasks;
using Microsoft.Extensions.DependencyInjection;

namespace Grand.Installer.Cli.Services;

public static class ManagedBaseInstallation
{
    public static bool IsComplete(IEnumerable<string> taskTypes, bool layoutsPresent, bool permissionsPresent, bool ownerPasswordHashed)
    {
        var actual = taskTypes.ToHashSet(StringComparer.Ordinal);
        return layoutsPresent && permissionsPresent && ownerPasswordHashed &&
            ScheduleTaskDefaults.Create().All(task => actual.Contains(task.Type));
    }

    public static bool IsComplete(IServiceScope scope, string ownerEmail)
    {
        var services = scope.ServiceProvider;
        var owner = services.GetRequiredService<IRepository<Customer>>().Table
            .FirstOrDefault(customer => customer.Email == ownerEmail.ToLowerInvariant());
        return IsComplete(
            services.GetRequiredService<IRepository<ScheduleTask>>().Table.Select(task => task.Type).ToList(),
            services.GetRequiredService<IRepository<ProductLayout>>().Table.Any() &&
            services.GetRequiredService<IRepository<CategoryLayout>>().Table.Any() &&
            services.GetRequiredService<IRepository<BrandLayout>>().Table.Any() &&
            services.GetRequiredService<IRepository<CollectionLayout>>().Table.Any() &&
            services.GetRequiredService<IRepository<PageLayout>>().Table.Any(),
            services.GetRequiredService<IRepository<PermissionAction>>().Table.Any(),
            owner?.PasswordFormatId == PasswordFormat.Hashed);
    }

    public static void RequireComplete(IServiceScope scope, string ownerEmail)
    {
        if (!IsComplete(scope, ownerEmail))
            throw new InvalidOperationException("The base GrandNode installation is incomplete. Use the owned base-installation reconciliation before publishing this tenant.");
    }
}
