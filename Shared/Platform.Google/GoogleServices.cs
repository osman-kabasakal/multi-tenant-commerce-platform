using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace Platform.Google;

public static class GoogleServices
{
    public static IServiceCollection AddGoogleCloud(this IServiceCollection services, IConfiguration configuration)
    {
        var options = configuration.GetSection("Provisioning:Google").Get<GoogleCloudOptions>()
            ?? throw new InvalidOperationException("Configure Provisioning:Google.");
        options.Validate();
        services.AddSingleton(options);
        services.AddGoogleTransport();
        services.AddTransient<GoogleTenantProvisioner>();
        services.AddTransient<FirebaseAppDistribution>();
        return services;
    }
    public static IServiceCollection AddGoogleTransport(this IServiceCollection services)
    {
        // Runtime senders need ADC and FCM permission only, never provisioning/IAM write options.
        services.TryAddSingleton<IGoogleAccessTokenSource, ApplicationDefaultTokenSource>();
        services.AddHttpClient<GoogleRestClient>(client => client.Timeout = TimeSpan.FromSeconds(120))
            .ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler { AllowAutoRedirect = false });
        services.AddTransient<FirebaseCloudMessaging>();
        return services;
    }
}
