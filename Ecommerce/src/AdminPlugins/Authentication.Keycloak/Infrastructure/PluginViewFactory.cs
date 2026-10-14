using Grand.Web.Common.View;
using Microsoft.AspNetCore.Mvc.Razor;

namespace Authentication.Keycloak.Infrastructure;

public class PluginViewFactory: IViewLocationExpander, IAreaViewFactory
{
    public string AreaName => "Admin";
    public IEnumerable<string> GetViewLocations(IEnumerable<string> viewLocations)
    {
        var pluginViewLocation = new[] {
            $"/Plugins/{KeycloakAuthenticationDefaults.ProviderSystemName}/Areas/{AreaName}/Views/{{1}}/{{0}}.cshtml",
            $"/Plugins/{KeycloakAuthenticationDefaults.ProviderSystemName}/Areas/{AreaName}/Views/Shared/{{0}}.cshtml"
        };

        return pluginViewLocation;
    }

    public void PopulateValues(ViewLocationExpanderContext context)
    {
        
    }

    public IEnumerable<string> ExpandViewLocations(ViewLocationExpanderContext context, IEnumerable<string> viewLocations)
    {
        var locations = viewLocations.ToList();
        locations.AddRange(GetViewLocations(locations));
        return locations;
    }
}