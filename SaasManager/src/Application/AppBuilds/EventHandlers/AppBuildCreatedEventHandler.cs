using System.Text.Json;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Enums;
using SaasManager.Domain.Events;
using StackExchange.Redis;

namespace SaasManager.Application.AppBuilds.EventHandlers;

public class AppBuildCreatedEventHandler: INotificationHandler<EntityCreatedEvent<AppBuild>>
{
    private readonly ISubscriber _subscriber;

    public AppBuildCreatedEventHandler(
        ISubscriber subscriber
        )
    {
        _subscriber = subscriber;
    }
    
    private const string CHANNEL_NAME = "NEW_BUILD";
    public async Task Handle(EntityCreatedEvent<AppBuild> notification, CancellationToken cancellationToken)
    {
        if(notification.Entity.BuildStatus != BuildStatus.Queued.ToString())
            return;
        
        await _subscriber.PublishAsync(RedisChannel.Literal(CHANNEL_NAME), JsonSerializer.Serialize(notification.Entity.Configuration));
    }
}
