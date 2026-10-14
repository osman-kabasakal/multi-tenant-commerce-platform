using Grand.Infrastructure.ModelBinding;
using Grand.Infrastructure.Models;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;

namespace Widgets.LegalTexts.Models;

public class LegalTextMessageTemplateListModel: BaseModel
{
    public LegalTextMessageTemplateListModel()
    {
        AvailableCategories= new List<SelectListItem>();
    }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Category")]
    public string SelectedCategoryName { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Name")]
    public string SearchName { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.IsActive")]
    public bool IsActive { get; set; }= true;
    public List<SelectListItem> AvailableCategories { get; set; }

}
