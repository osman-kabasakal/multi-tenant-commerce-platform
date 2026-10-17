using Grand.Infrastructure.Caching.Message;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Events;
using MediatR;
using Microsoft.Extensions.DependencyInjection;
using StackExchange.Redis;
using System.Diagnostics;
using System.Text.Json;

namespace Grand.Infrastructure.Caching.Redis;

public sealed class RedisMessageBus : IMessageBus
{
    private static readonly string ClientId = Guid.NewGuid().ToString("N");
    private readonly RedisConfig _redisConfig;
    private readonly IServiceProvider _serviceProvider;
    private readonly ISubscriber _subscriber;
    private readonly object _subscriptionLock = new();
    private Task _subscription;

    public RedisMessageBus(ISubscriber subscriber, IServiceProvider serviceProvider, RedisConfig redisConfig)
    {
        _subscriber = subscriber;
        _serviceProvider = serviceProvider;
        _redisConfig = redisConfig;
        SubscribeAsync();
    }

    public async Task PublishAsync<TMessage>(TMessage msg) where TMessage : IMessageEvent
    {
        try
        {
            var client = new MessageEventClient {
                ClientId = ClientId,
                Key = msg.Key,
                MessageType = msg.MessageType
            };
            var message = JsonSerializer.Serialize(client);
            await _subscriber.PublishAsync(RedisChannel.Literal(_redisConfig.RedisPubSubChannel), message);
        }
        catch (Exception ex)
        {
            Debug.WriteLine(ex.Message);
        }
    }

    public Task SubscribeAsync()
    {
        lock (_subscriptionLock)
            return _subscription ??= _subscriber.SubscribeAsync(RedisChannel.Literal(_redisConfig.RedisPubSubChannel), (_, value) =>
            {
                try
                {
                    var message = JsonSerializer.Deserialize<MessageEventClient>(value);
                    if (message != null && message.ClientId != ClientId) OnSubscriptionChanged(message);
                }
                catch (Exception ex) { Debug.WriteLine(ex.Message); }
            });
    }

    public void OnSubscriptionChanged(IMessageEvent message) => _ = ApplySubscriptionAsync(message);

    private async Task ApplySubscriptionAsync(IMessageEvent message)
    {
        // Old unqualified ClearCache messages must not affect all tenants in this process.
        if (string.IsNullOrWhiteSpace(message.Key)) return;
        try
        {
            using var scope = _serviceProvider.CreateScope();
            var cache = scope.ServiceProvider.GetRequiredService<ICacheBase>();
            var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
            switch (message.MessageType)
            {
                case (int)MessageEventType.RemoveKey:
                    await cache.RemoveAsync(message.Key, false);
                    await mediator.Publish(new EntityCacheEvent(message.Key, CacheEvent.RemoveKey));
                    break;
                case (int)MessageEventType.RemoveByPrefix:
                case (int)MessageEventType.ClearCache:
                    await cache.RemoveByPrefix(message.Key, false);
                    await mediator.Publish(new EntityCacheEvent(message.Key, CacheEvent.RemovePrefix));
                    break;
            }
        }
        catch (Exception ex) { Debug.WriteLine(ex.Message); }
    }
}
