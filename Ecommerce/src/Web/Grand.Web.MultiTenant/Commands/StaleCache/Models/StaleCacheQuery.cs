using Grand.Web.MultiTenant.Commands.Queries.StaleCache.Models;
using MediatR;
using System;

namespace Grand.Web.MultiTenant.Commands.StaleCache.Models;

public class StaleCacheQuery: IRequest<StaleCacheResponse>
{
    public List<StaleCacheItem> StaleCacheItems { get; set; } = [];
}
