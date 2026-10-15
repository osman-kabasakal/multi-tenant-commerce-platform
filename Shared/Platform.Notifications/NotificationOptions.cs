using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Platform.Google;

namespace Platform.Notifications;

public sealed class NotificationOptions
{
    public string Provider { get; init; } = "Disabled";
    public string LocalDirectory { get; init; } = "";
    public void Validate(string environment, bool localDemo)
    {
        if (Provider is not ("Disabled" or "LocalSink" or "Fcm"))
            throw new InvalidOperationException("Choose a Disabled, LocalSink or Fcm notification provider.");
        if (Provider == "LocalSink" && (environment != Environments.Development || !localDemo || !Path.IsPathFullyQualified(LocalDirectory)))
            throw new InvalidOperationException("Local notification capture requires Development, LocalDemo and an absolute local directory.");
    }
}

public static class TenantNotifications
{
    public static IServiceCollection AddTenantNotifications(this IServiceCollection services, IConfiguration configuration)
    {
        var options = configuration.GetSection("Notifications").Get<NotificationOptions>() ?? new();
        services.AddSingleton(sp => {
            options.Validate(sp.GetRequiredService<IHostEnvironment>().EnvironmentName, configuration.GetValue<bool>("LocalDemo:Enabled"));
            return options;
        });
        switch (options.Provider)
        {
            case "LocalSink": services.AddScoped<ITenantPushSender, LocalSinkTenantPushSender>(); break;
            case "Fcm":
                services.AddGoogleTransport();
                services.AddScoped<ITenantPushSender, FcmTenantPushSender>();
                break;
            case "Disabled": services.AddScoped<ITenantPushSender, DisabledTenantPushSender>(); break;
            default: throw new InvalidOperationException("Unknown notification provider.");
        }
        return services;
    }
}
