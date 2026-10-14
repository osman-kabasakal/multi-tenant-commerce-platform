using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace Grand.Web.Common.Components;

public abstract class BaseViewComponent : ViewComponent
{
    public new IViewComponentResult View<TModel>(string viewName, TModel model)
    {
        return base.View(viewName, model);
    }

    public new IViewComponentResult View<TModel>(TModel model)
    {
        ViewData.Model = model;
        if (Request?.ContentType?.Contains("application/json")??false)
            return new JsonContentViewComponentResult(JsonSerializer.Serialize(model));
        return base.View(model);
    }

    public new IViewComponentResult View(string viewName)
    {
        return base.View(viewName);
    }
}