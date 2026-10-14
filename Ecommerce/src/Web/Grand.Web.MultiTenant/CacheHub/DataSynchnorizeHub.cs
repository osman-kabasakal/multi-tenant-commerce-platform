using Microsoft.AspNetCore.SignalR;
using System;

namespace Grand.Web.MultiTenant.CacheHub;

public interface ICacheHub
{
    Task RemoveCacheKey(string cacheKey);
    Task RemoveByPrefix(string cacheKeyPrefix);
}

public class DataSynchnorizeHub : Hub
{

    public override Task OnConnectedAsync()
    {
        var httpCOntext = Context.GetHttpContext();
        if (httpCOntext != null &&
            httpCOntext.Items.TryGetValue("StoreId", out var storeId))
        {
            Groups.AddToGroupAsync(Context.ConnectionId, storeId.ToString());
        }
        else
        {
            Context.Abort();
        }
        return base.OnConnectedAsync();
    }

    public override Task OnDisconnectedAsync(Exception exception)
    {
        var httpCOntext = Context.GetHttpContext();
        if (httpCOntext != null &&
            httpCOntext.Items.TryGetValue("StoreId", out var storeId))
        {
            Groups.RemoveFromGroupAsync(Context.ConnectionId, storeId.ToString());
        }
        return base.OnDisconnectedAsync(exception);
    }


}
