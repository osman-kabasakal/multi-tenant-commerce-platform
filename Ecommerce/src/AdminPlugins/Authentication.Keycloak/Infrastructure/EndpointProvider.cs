using Grand.Infrastructure.Endpoints;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace Authentication.Keycloak.Infrastructure;

public class EndpointProvider: IEndpointProvider
{
    public int Priority => 10;
    public void RegisterEndpoint(IEndpointRouteBuilder endpointRouteBuilder)
    {
        endpointRouteBuilder.MapControllerRoute("SuperAdminLogin", "super-admin/login/",
            new { controller = "KeycloakAuthentication", action = "KeycloakLogin", area = "Admin" });
        
        endpointRouteBuilder.MapControllerRoute("AzCallbackPath", "super-admin/signin-oidc/",
            new { controller = "KeycloakAuthentication", action = "KeycloakLoginCallback", area = "Admin" });
        
        endpointRouteBuilder.MapControllerRoute("KeycloakPostLogout", "super-admin/KeycloakLogout/",
            new { controller = "KeycloakAuthentication", action = "KeycloakLogout", area = "Admin" });
        
        endpointRouteBuilder.MapControllerRoute("SuperAdminLogout", "super-admin/signout-oidc/",
            new { controller = "KeycloakAuthentication", action = "OpenIdSignOut", area = "Admin" });
        
    }
}