using Microsoft.AspNetCore.SignalR;
using System;

namespace Grand.Web.MultiTenant.CacheHub;

public class TenantHubPipeline: IHubFilter
{
    public ValueTask<object> InvokeMethodAsync(HubInvocationContext invocationContext, Func<HubInvocationContext, ValueTask<object>> next)
    {
        // Block all client-to-server method calls
        throw new HubException("Direct hub method invocation is not allowed.");
    }
}
