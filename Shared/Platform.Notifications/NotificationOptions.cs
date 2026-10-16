using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Platform.Google;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace Platform.Notifications;

public sealed class NotificationOptions
{
    public string Provider { get; init; } = "Disabled";
    public string LocalDirectory { get; init; } = "";
    public void Validate(string environment, bool localDemo)
    {
        if (Provider is not ("Disabled" or "LocalSink" or "Fcm" or "FcmApns"))
            throw new InvalidOperationException("Choose a Disabled, LocalSink, Fcm or FcmApns notification provider.");
        if (Provider == "FcmApns" && (localDemo || environment != Environments.Production && environment != Environments.Staging))
            throw new InvalidOperationException("Direct APNs requires an explicit Production or Staging deployment without LocalDemo.");
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
            case "FcmApns":
                services.AddGoogleTransport();
                services.TryAddSingleton(TimeProvider.System);
                services.AddSingleton(sp => {
                    sp.GetRequiredService<NotificationOptions>();
                    var apple = configuration.GetSection("Notifications:Apns").Get<ApnsOptions>()
                        ?? throw new InvalidOperationException("Configure the APNs team key explicitly.");
                    apple.Validate(); return apple;
                });
                services.AddSingleton<ApnsProviderTokens>();
                services.AddHostedService<ApnsKeyStartupCheck>();
                services.AddSingleton<IApnsHttpClients,ApnsHttpClients>();
                services.AddScoped<FcmTenantPushSender>();
                services.AddScoped<ApnsTenantPushSender>();
                services.AddScoped<ITenantPushSender,FcmApnsTenantPushSender>();
                break;
            case "Disabled": services.AddScoped<ITenantPushSender, DisabledTenantPushSender>(); break;
            default: throw new InvalidOperationException("Unknown notification provider.");
        }
        return services;
    }
}


internal sealed class ApnsKeyStartupCheck(ApnsProviderTokens tokens) : IHostedService
{
    public Task StartAsync(CancellationToken ct) { ct.ThrowIfCancellationRequested(); tokens.Get(); return Task.CompletedTask; }
    public Task StopAsync(CancellationToken ct) => Task.CompletedTask;
}
