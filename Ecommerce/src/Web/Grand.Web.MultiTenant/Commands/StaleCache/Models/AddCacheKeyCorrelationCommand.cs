using MediatR;
using System;

namespace Grand.Web.MultiTenant.Commands.StaleCache.Models;

public class AddCacheKeyCorrelationCommand: IRequest
{
    public string CorrelationId { get; set; }
    public List<string> CacheKeys { get; set; } = [];
}
