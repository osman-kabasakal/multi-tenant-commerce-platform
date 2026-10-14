using Grand.Infrastructure.Endpoints;
using Grand.Web.MultiTenant.CacheHub;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.AspNetCore.Routing;
using System;

namespace Grand.Web.MultiTenant.Endpoints;

public class MultiTenantEndpointsProvider : IEndpointProvider
{
    public int Priority => -1000;

    public void RegisterEndpoint(IEndpointRouteBuilder endpointRouteBuilder)
    {
        // endpointRouteBuilder.MapHub<DataSynchnorizeHub>("/cachehub",(option)=>{
        //     option.WebSockets.SubProtocolSelector = (protocols) => {
        //         if (protocols.Contains("json"))
        //         {
        //             return "json";
        //         }
        //         return null;
        //     };
        // });

        endpointRouteBuilder.MapControllerRoute("StaleCache",
            "/StaleCache/stale-cache-keys",
            new { controller = "StaleCache", action = "GetStaleCorrelationIds" });
        
        endpointRouteBuilder.MapControllerRoute("ShoppingCartInfo",
            "/ShoppingCartInfo/info",
            new { controller = "ShoppingCartInfo", action = "GetShoppingCartInfo" });
    }
}
