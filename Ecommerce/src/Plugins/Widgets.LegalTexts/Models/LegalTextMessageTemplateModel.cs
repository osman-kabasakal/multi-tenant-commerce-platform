using Grand.Infrastructure.ModelBinding;
using Grand.Infrastructure.Models;
using Grand.Web.Common.Models;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;

namespace Widgets.LegalTexts.Models;

public class LegalTextMessageTemplateModel : BaseEntityModel, ILocalizedModel<LegalTextMessageTemplateLocalizedModel>
{

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Name")]
    public string Name { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Body")]
    public string Body { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Category")]
    public string Category { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Order")]
    public int Order { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.IsRequired")]
    public bool IsRequired { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.IsActive")]
    public bool IsActive { get; set; }
    
    public IList<LegalTextMessageTemplateLocalizedModel> Locales { get; set; } = new List<LegalTextMessageTemplateLocalizedModel>();

    public List<SelectListItem> AvailableCategories { get; set; } = new List<SelectListItem>();

    [GrandResourceDisplayName("Admin.Content.MessageTemplates.Fields.AllowedTokens")]
    public List<string> AllowedTokens { get; set; }
}

public class LegalTextMessageTemplateLocalizedModel: ILocalizedModelLocal
{
    public string LanguageId { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Name")]
    public string Name { get; set; }

    [GrandResourceDisplayName("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Body")]
    public string Body { get; set; }
}
