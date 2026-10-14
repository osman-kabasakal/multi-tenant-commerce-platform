using Grand.Business.Core.Interfaces.Common.Seo;
using Grand.Domain.Seo;
using Grand.Web.Common.Controllers;
using Microsoft.AspNetCore.Mvc;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Routing;
using System.Reflection;
using System.Linq;
using Grand.Infrastructure.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System.Net;

namespace Misc.MobileApp.Controllers;

public class SeoSlugUrlResolverController: BasePublicController
{
    private readonly ISlugService _slugService;
    private readonly IServiceProvider _serviceProvider;
    private readonly LinkGenerator _linkGenerator;
    private static readonly Dictionary<string, RouteInfo> _routeCache = new();

    public SeoSlugUrlResolverController(
        ISlugService slugService,
        IServiceProvider serviceProvider,
        LinkGenerator linkGenerator)
    {
        _slugService = slugService;
        _serviceProvider = serviceProvider;
        _linkGenerator = linkGenerator;
    }

    private class RouteInfo
    {
        public string Controller { get; set; }
        public string Action { get; set; }
        public Dictionary<string, string> RouteParams { get; set; }
    }

    [HttpGet]
    [Route("/resolveseoslug")]
    public async Task<IActionResult> ResolveSeoSlug(string slug)
    {
        if (string.IsNullOrEmpty(slug))
            return BadRequest("Slug cannot be empty");

        // Normalize the slug (remove leading/trailing slashes)
        slug = WebUtility.HtmlDecode(slug).Trim('/');

        // Step 1: First try to resolve using the slug service (for SEO friendly URLs)
        var entityUrl = await _slugService.GetBySlugCached(slug);
        
        if (entityUrl != null)
        {
            // If URL Entity is not active find the latest one
            if (!entityUrl.IsActive)
            {
                var activeSlug = await _slugService.GetActiveSlug(entityUrl.EntityId, entityUrl.EntityName, entityUrl.LanguageId);
                if (string.IsNullOrEmpty(activeSlug))
                    return NotFound();
                    
                return Ok(new { 
                    redirect = true,
                    slug = activeSlug
                });
            }
            
            var controller = "";
            var action = "";
            
            switch (entityUrl.EntityName)
            {
                case EntityTypes.Product:
                    controller = "Product";
                    action = "ProductDetails";
                    break;
                case EntityTypes.Category:
                    controller = "Catalog";
                    action = "Category";
                    break;
                case EntityTypes.Brand:
                    controller = "Catalog";
                    action = "Brand";
                    break;
                case EntityTypes.Collection:
                    controller = "Catalog";
                    action = "Collection";
                    break;
                case EntityTypes.Vendor:
                    controller = "Catalog";
                    action = "Vendor";
                    break;
                case EntityTypes.NewsItem:
                    controller = "News";
                    action = "NewsItem";
                    break;
                case EntityTypes.BlogPost:
                    controller = "Blog";
                    action = "BlogPost";
                    break;
                case EntityTypes.Page:
                    controller = "Page";
                    action = "PageDetails";
                    break;
                case EntityTypes.KnowledgeBaseArticle:
                    controller = "Knowledgebase";
                    action = "KnowledgebaseArticle";
                    break;
                case EntityTypes.KnowledgeBaseCategory:
                    controller = "Knowledgebase";
                    action = "ArticlesByCategory";
                    break;
                case EntityTypes.Course:
                    controller = "Course";
                    action = "Details";
                    break;
                default:
                    if (!string.IsNullOrEmpty(entityUrl.Controller) && !string.IsNullOrEmpty(entityUrl.Action))
                    {
                        controller = entityUrl.Controller;
                        action = entityUrl.Action;
                    }
                    break;
            }
            
            return Ok(new {
                entityId = entityUrl.EntityId,
                entityType = entityUrl.EntityName,
                controller = controller,
                action = action,
                slug = entityUrl.Slug
            });
        }
        
        // Step 2: If not found in SlugService, try to match it against defined routes
        var routeInfo = await ResolveRouteFromEndpointProvider(slug);
        
        if (routeInfo != null)
        {
            var result = new
            {
                controller = routeInfo.Controller,
                action = routeInfo.Action,
                routeParams = routeInfo.RouteParams,
                slug = slug
            };
            
            return Ok(result);
        }
        
        return NotFound();
    }
    
    private async Task<RouteInfo> ResolveRouteFromEndpointProvider(string slug)
    {
        // Check if we have this route in cache
        if (_routeCache.TryGetValue(slug, out var cachedRoute))
        {
            return cachedRoute;
        }
        
        try
        {
            // Try to match the slug against standard routes defined in EndpointProvider
            // Example: "orderdetails/123" should match to OrderController's Details action
            
            // Common route patterns from EndpointProvider
            var routePatterns = new Dictionary<string, RouteInfo>
            {
                // Order related routes
                { @"^orderdetails/(?<orderId>[^/]+)$", new RouteInfo { Controller = "Order", Action = "Details", RouteParams = new Dictionary<string, string>() } },
                { @"^orderdetails/shipment/(?<shipmentId>[^/]+)$", new RouteInfo { Controller = "Order", Action = "ShipmentDetails", RouteParams = new Dictionary<string, string>() } },
                { @"^orderdetails/pdf/(?<orderId>[^/]+)$", new RouteInfo { Controller = "Order", Action = "GetPdfInvoice", RouteParams = new Dictionary<string, string>() } },
                { @"^orderdetails/cancel/(?<orderId>[^/]+)$", new RouteInfo { Controller = "Order", Action = "CancelOrder", RouteParams = new Dictionary<string, string>() } },
                { @"^reorder/(?<orderId>[^/]+)$", new RouteInfo { Controller = "Order", Action = "ReOrder", RouteParams = new Dictionary<string, string>() } },
                
                // Cart related routes
                { @"^cart/?$", new RouteInfo { Controller = "ShoppingCart", Action = "Cart", RouteParams = new Dictionary<string, string>() } },
                { @"^cart/summary/?$", new RouteInfo { Controller = "ShoppingCart", Action = "CartSummary", RouteParams = new Dictionary<string, string>() } },
                { @"^cart/total/?$", new RouteInfo { Controller = "ShoppingCart", Action = "CartTotal", RouteParams = new Dictionary<string, string>() } },
                
                // Account related routes
                { @"^login/?$", new RouteInfo { Controller = "Account", Action = "Login", RouteParams = new Dictionary<string, string>() } },
                { @"^register/?$", new RouteInfo { Controller = "Account", Action = "Register", RouteParams = new Dictionary<string, string>() } },
                { @"^logout/?$", new RouteInfo { Controller = "Account", Action = "Logout", RouteParams = new Dictionary<string, string>() } },
                { @"^account/info$", new RouteInfo { Controller = "Account", Action = "Info", RouteParams = new Dictionary<string, string>() } },
                { @"^account/addresses$", new RouteInfo { Controller = "Account", Action = "Addresses", RouteParams = new Dictionary<string, string>() } },
                { @"^account/orders$", new RouteInfo { Controller = "Order", Action = "CustomerOrders", RouteParams = new Dictionary<string, string>() } },
                { @"^registerresult/(?<resultId>[^/]+)$", new RouteInfo { Controller = "Account", Action = "registerresult", RouteParams = new Dictionary<string, string>() } },
                { @"^account/activation\?token=(?<token>[^&]+)&email=(?<email>[^&]+)$", new RouteInfo { Controller = "Account", Action = "AccountActivation", RouteParams = new Dictionary<string, string>() } },
                { @"^account/activation$", new RouteInfo { Controller = "Account", Action = "AccountActivation", RouteParams = new Dictionary<string, string>() } },
                
                // Product related routes
                { @"^product/(?<productId>[^/]+)$", new RouteInfo { Controller = "Product", Action = "ProductDetails", RouteParams = new Dictionary<string, string>() } },
                { @"^category/(?<categoryId>[^/]+)$", new RouteInfo { Controller = "Catalog", Action = "Category", RouteParams = new Dictionary<string, string>() } },
                { @"^brand/(?<brandId>[^/]+)$", new RouteInfo { Controller = "Catalog", Action = "Brand", RouteParams = new Dictionary<string, string>() } },
                
                // Search
                { @"^search/?$", new RouteInfo { Controller = "Catalog", Action = "Search", RouteParams = new Dictionary<string, string>() } },
                
                // Checkout
                { @"^checkout/?$", new RouteInfo { Controller = "Checkout", Action = "Start", RouteParams = new Dictionary<string, string>() } },
                { @"^checkout/completed/?$", new RouteInfo { Controller = "Checkout", Action = "Completed", RouteParams = new Dictionary<string, string>() } },
                { @"^checkout/completed/(?<orderId>[^/]+)$", new RouteInfo { Controller = "Checkout", Action = "Completed", RouteParams = new Dictionary<string, string>() } },
            };
            
            foreach (var pattern in routePatterns)
            {
                var regex = new Regex(pattern.Key, RegexOptions.IgnoreCase);
                var match = regex.Match(slug);
                
                if (match.Success)
                {
                    var routeInfo = new RouteInfo
                    {
                        Controller = pattern.Value.Controller,
                        Action = pattern.Value.Action,
                        RouteParams = new Dictionary<string, string>()
                    };
                    
                    // Extract named capture groups as route parameters
                    for (int i = 1; i < match.Groups.Count; i++)
                    {
                        var groupName = regex.GroupNameFromNumber(i);
                        if (!string.IsNullOrEmpty(groupName) && groupName != i.ToString())
                        {
                            routeInfo.RouteParams[groupName] = match.Groups[i].Value;
                        }
                    }
                    
                    // Cache the result
                    _routeCache[slug] = routeInfo;
                    
                    return routeInfo;
                }
            }
            
            return null;
        }
        catch (Exception ex)
        {
            // Log the exception if needed
            return null;
        }
    }
}