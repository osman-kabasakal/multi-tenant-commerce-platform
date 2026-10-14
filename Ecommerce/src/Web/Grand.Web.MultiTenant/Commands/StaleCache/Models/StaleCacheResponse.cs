using System;

namespace Grand.Web.MultiTenant.Commands.Queries.StaleCache.Models;

public class StaleCacheResponse
{
    public List<string> StaleCorrelationIds { get; set; }
    public DateTime AsOf { get; set; }
}
