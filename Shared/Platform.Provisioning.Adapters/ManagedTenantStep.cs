using Platform.Security;

namespace Platform.Provisioning.Adapters;

// Each phase is a separate durable checkpoint in the existing provisioning queue.
public sealed class ManagedTenantStep(string name, OnboardingInfrastructureOptions options, ITenantSecrets secrets) : IProvisioningStep
{
    public static readonly string[] Tasks = ["tenant-plugins", "tenant-migrations", "tenant-settings"];
    public string Name { get; } = Tasks.Contains(name) ? name : throw new ArgumentException("Unknown managed tenant phase.", nameof(name));

    public Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string,ProvisioningStepResult> completed, CancellationToken ct)
    {
        var index=Array.IndexOf(Tasks,Name);
        var prerequisite=index==0 ? "store" : Tasks[index-1];
        if (!completed.TryGetValue(prerequisite,out var previous) || !previous.Resources.TryGetValue("storeId",out var storeId) || string.IsNullOrWhiteSpace(storeId))
            throw new InvalidOperationException("Complete the preceding tenant phase before continuing.");
        if (!completed.TryGetValue("store",out var original) || !original.Resources.TryGetValue("storeId",out var owned) || owned!=storeId ||
            index>0 && (!previous.Resources.TryGetValue("profileVersion",out var version) || version!="1"))
            throw new InvalidOperationException("The preceding phase does not belong to this store profile.");
        return new StoreInstallerStep(options,secrets).RunAsync(request,completed,Name,ct);
    }
}
