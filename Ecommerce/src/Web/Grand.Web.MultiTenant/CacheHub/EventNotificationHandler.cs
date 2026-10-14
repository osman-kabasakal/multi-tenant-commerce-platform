using DotLiquid.Util;
using Grand.Infrastructure.Events;
using Grand.Web.MultiTenant.Commands.StaleCache.Models;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using System;

namespace Grand.Web.MultiTenant.CacheHub;

public class EventNotificationHandler : INotificationHandler<EntityCacheEvent>
{
    private readonly IMediator _mediator;
    private readonly ILogger<EventNotificationHandler> _logger;

    public EventNotificationHandler(IMediator mediator, ILogger<EventNotificationHandler> logger)
    {
        _mediator = mediator;
        this._logger = logger;
    }

    public async Task Handle(EntityCacheEvent notification, CancellationToken cancellationToken)
    {

        // var reason = $"{notification.Event} - {notification.Entity}";

        // await _mediator.Send(new StaleCacheKeyCommand() {
        //     CacheKey = notification.Entity,
        //     StaleReason = reason,
        //     StaleType = notification.Event
        // });
    }
}
