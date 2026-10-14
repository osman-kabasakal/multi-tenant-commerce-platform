using Grand.Infrastructure.Endpoints;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace Misc.MobileApp
{
    public class EndpointProvider : IEndpointProvider
    {
        public void RegisterEndpoint(IEndpointRouteBuilder endpointRouteBuilder)
        {
            endpointRouteBuilder.MapControllerRoute(
                "MobileAppResolveSeoSlug",
                "resolveseoslug",
                new { controller = "SeoSlugUrlResolver", action = "ResolveSeoSlug" });
        }

        public int Priority => 0;
    }
}