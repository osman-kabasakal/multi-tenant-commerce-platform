using Grand.Domain;
using Grand.Domain.Localization;
using System;

namespace Widgets.LegalTexts;

public class LegalTextMessageTemplate : BaseEntity, ITranslationEntity
{
    public LegalTextMessageTemplate()
    {
           
    }

    public string Name { get; set; }
    public bool IsRequired { get; set; }
    public string Body { get; set; }
    public int Order { get; set; }
    public string Category { get; set; }
    public bool IsActive { get; set; }
    public IList<TranslationEntity> Locales { get; set; } = new List<TranslationEntity>();
}
