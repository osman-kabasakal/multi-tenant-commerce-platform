using System.Text.RegularExpressions;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using StackExchange.Redis;

namespace Grand.Infrastructure.Extensions;

public static class SignalRServiceCollectionExtensions
{
    public static ISignalRServerBuilder AddPlatformSignalR(this IServiceCollection services, IConfiguration configuration)
    {
        var builder = services.AddSignalR();
        var provider = configuration["PlatformSignalR:Provider"] ?? "InProcess";
        if (provider == "InProcess") return builder;
        if (provider != "Redis") throw new InvalidOperationException("Select an implemented SignalR provider explicitly.");
        var deployment = configuration["PlatformSignalR:DeploymentId"] ?? "";
        var connection = configuration["Redis:RedisPubSubConnectionString"];
        if (!Regex.IsMatch(deployment, @"\A[a-z][a-z0-9-]{2,39}\z") || string.IsNullOrWhiteSpace(connection))
            throw new InvalidOperationException("Shared SignalR requires an owned deployment id and authenticated private Redis configuration.");
        var options = ConfigurationOptions.Parse(connection);
        if (string.IsNullOrWhiteSpace(options.Password) && !configuration.GetValue<bool>("LocalDemo:Enabled")) throw new InvalidOperationException("Shared SignalR requires authenticated Redis.");
        return builder.AddStackExchangeRedis(connection, redis =>
        {
            // The same prefix joins the admin web replicas and isolated task children of this deployment only.
            redis.Configuration.ChannelPrefix = RedisChannel.Literal("commerce:" + deployment + ":notifications");
        });
    }
}
