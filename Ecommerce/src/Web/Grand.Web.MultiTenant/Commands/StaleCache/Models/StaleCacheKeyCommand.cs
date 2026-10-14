using Grand.Infrastructure.Events;
using MediatR;
using System;

namespace Grand.Web.MultiTenant.Commands.StaleCache.Models;

public class StaleCacheKeyCommand: IRequest
{
    public string CacheKey { get; set; }
    public string StaleReason { get; set; }
    public CacheEvent StaleType { get; set; }
}
