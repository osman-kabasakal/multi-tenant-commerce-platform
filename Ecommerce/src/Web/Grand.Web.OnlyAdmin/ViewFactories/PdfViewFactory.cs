using Grand.Web.Common.View;
using Microsoft.AspNetCore.Mvc.Razor;

namespace Grand.Web.OnlyAdmin.ViewFactories;

public class PdfViewFactory: IViewLocationExpander, IAreaViewFactory
{
    public void PopulateValues(ViewLocationExpanderContext context)
    {
        var debug = true;
    }

    public IEnumerable<string> ExpandViewLocations(ViewLocationExpanderContext context, IEnumerable<string> viewLocations)
    {
     var locations = viewLocations.ToList();
     if(context.ViewName.Contains("OrderPdfTemplate"))
     {
         locations.AddRange(new[]
         {
             $"/Areas/Admin/Views/PdfTemplates/OrderPdfTemplate.cshtml",
         });
     }

     if (context.ViewName.Contains("ShipmentPdfTemplate"))
     {
         locations.AddRange(new[]
         {
             $"/Areas/Admin/Views/PdfTemplates/ShipmentPdfTemplate.cshtml"
         });
     }
    
    return locations; 
    }

    public string AreaName => "Admin";
    public IEnumerable<string> GetViewLocations(IEnumerable<string> viewLocations)
    {
        return new[] {
            "/Views/{1}/{0}.cshtml"
        };
    }
}