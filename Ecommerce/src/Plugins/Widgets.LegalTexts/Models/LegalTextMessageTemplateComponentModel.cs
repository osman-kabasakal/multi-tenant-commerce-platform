using Grand.Infrastructure.Models;
using System;

namespace Widgets.LegalTexts.Models;

public class LegalTextMessageTemplateComponentModel: BaseModel
{
    public string Name { get; set; }

    public string TemplateText { get; set; }


    public int Order { get; set; }

    public string Category { get; set; }

    public bool IsRequired { get; set; }

    public bool IsActive { get; set; }
}
