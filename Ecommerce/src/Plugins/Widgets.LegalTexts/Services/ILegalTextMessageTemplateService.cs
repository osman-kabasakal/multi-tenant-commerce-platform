using Grand.Domain;
using System;
using Widgets.LegalTexts.Models;

namespace Widgets.LegalTexts.Services;

public interface ILegalTextMessageTemplateService
{
    Task<LegalTextMessageTemplate> GetMessageTemplateById(string id);
    Task<IPagedList<LegalTextMessageTemplate>> GetAllMessageTemplates(LegalTextMessageTemplateListModel model,int pageIndex = 0, int pageSize = int.MaxValue);
    Task<List<LegalTextMessageTemplate>> GetMessageTemplateByCategory(string category);
    Task InsertMessageTemplate(LegalTextMessageTemplate messageTemplate);
    Task UpdateMessageTemplate(LegalTextMessageTemplate messageTemplate);
    Task DeleteMessageTemplate(LegalTextMessageTemplate messageTemplate);
    string RenderTemplate(LegalTextMessageTemplate template, LegalTextMessageTemplateToken tokens);
}
