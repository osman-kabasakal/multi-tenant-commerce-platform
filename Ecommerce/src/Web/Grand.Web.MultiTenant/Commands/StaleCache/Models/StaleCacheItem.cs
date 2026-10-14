using System;

namespace Grand.Web.MultiTenant.Commands.StaleCache.Models;

public class StaleCacheItem
{
    public String CorrelationId { get; set; }
    public DateTime AsOf { get; set; }
}
