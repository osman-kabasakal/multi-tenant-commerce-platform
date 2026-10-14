using Grand.Infrastructure.Endpoints;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace Widgets.Slider.Infrastructure;

public class EndpointProvider : IEndpointProvider
{
    public void RegisterEndpoint(IEndpointRouteBuilder endpointRouteBuilder)
    {
        // Admin area endpoints
        endpointRouteBuilder.MapControllerRoute(
            name: "Admin.Slider.LinkSelector.GetCategories",
            pattern: "Admin/WidgetsSlider/LinkSelector/GetCategories",
            defaults: new { controller = "LinkSelector", action = "GetCategories", area = "Admin" }
        );
        
        endpointRouteBuilder.MapControllerRoute(
            name: "Admin.Slider.LinkSelector.GetProducts",
            pattern: "Admin/WidgetsSlider/LinkSelector/GetProducts",
            defaults: new { controller = "LinkSelector", action = "GetProducts", area = "Admin" }
        );
        
        endpointRouteBuilder.MapControllerRoute(
            name: "Admin.Slider.LinkSelector.GetBrands",
            pattern: "Admin/WidgetsSlider/LinkSelector/GetBrands",
            defaults: new { controller = "LinkSelector", action = "GetBrands", area = "Admin" }
        );
        
        endpointRouteBuilder.MapControllerRoute(
            name: "Admin.Slider.LinkSelector.GetCollections",
            pattern: "Admin/WidgetsSlider/LinkSelector/GetCollections",
            defaults: new { controller = "LinkSelector", action = "GetCollections", area = "Admin" }
        );
        
        endpointRouteBuilder.MapControllerRoute(
            name: "Admin.Slider.LinkSelector.GetBlogPosts",
            pattern: "Admin/WidgetsSlider/LinkSelector/GetBlogPosts",
            defaults: new { controller = "LinkSelector", action = "GetBlogPosts", area = "Admin" }
        );
    }
    
    public int Priority => 0;
}