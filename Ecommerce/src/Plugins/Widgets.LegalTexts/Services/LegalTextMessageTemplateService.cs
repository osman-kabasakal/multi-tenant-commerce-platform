using DotLiquid;
using DotLiquid.NamingConventions;
using Grand.Data;
using Grand.Domain;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using MongoDB.Driver.Linq;
using System;
using Widgets.LegalTexts.Models;

namespace Widgets.LegalTexts.Services;

public class LegalTextMessageTemplateService : ILegalTextMessageTemplateService
{
    private readonly IWorkContext _workContext;
    private readonly IRepository<LegalTextMessageTemplate> _messageTemplateRepository;
    private readonly ICacheBase _cacheBase;

    public LegalTextMessageTemplateService(
        IWorkContext workContext,
        IRepository<LegalTextMessageTemplate> messageTemplateRepository,
        ICacheBase cacheBase)
    {
        _workContext = workContext;
        _messageTemplateRepository = messageTemplateRepository;
        _cacheBase = cacheBase;
    }

    public async Task DeleteMessageTemplate(LegalTextMessageTemplate messageTemplate)
    {
        if (messageTemplate == null)
            throw new ArgumentNullException(nameof(messageTemplate));

        await _messageTemplateRepository.DeleteAsync(messageTemplate);
        await _cacheBase.RemoveByPrefix(LegalTextDefaults.MessageTemplatesPrefixCacheKey);
    }

    public async Task<IPagedList<LegalTextMessageTemplate>> GetAllMessageTemplates(LegalTextMessageTemplateListModel model,int pageIndex = 0, int pageSize = int.MaxValue)
    {
        var query = from mt in _messageTemplateRepository.Table
                    where (string.IsNullOrEmpty(model.SearchName) || mt.Name.Contains(model.SearchName)) &&
                          (string.IsNullOrEmpty(model.SelectedCategoryName) || mt.Category == model.SelectedCategoryName) &&
                          mt.IsActive==model.IsActive
                          orderby mt.Order
                    select mt;
        return await _cacheBase.GetAsync(LegalTextDefaults.MessageTemplatesPrefixCacheKey+$"List.{pageIndex}.{pageSize}.{model.SearchName}.{model.SelectedCategoryName}.{model.IsActive}", async () =>
        {
            return await Task.FromResult(new PagedList<LegalTextMessageTemplate>(query, pageIndex, pageSize));
        });
    }

    public async Task<List<LegalTextMessageTemplate>> GetMessageTemplateByCategory(string category)
    {
        if (string.IsNullOrWhiteSpace(category))
            return null;

        var query = from mt in _messageTemplateRepository.Table
                    where mt.Category == category && mt.IsActive
                    select mt;

        return await query.ToListAsync();
    }

    public async Task<LegalTextMessageTemplate> GetMessageTemplateById(string id)
    {
        if (string.IsNullOrWhiteSpace(id))
            return null;

        return await _messageTemplateRepository.GetByIdAsync(id);
    }

    public async Task InsertMessageTemplate(LegalTextMessageTemplate messageTemplate)
    {
        if (messageTemplate == null)
            throw new ArgumentNullException(nameof(messageTemplate));

        await _messageTemplateRepository.InsertAsync(messageTemplate);
        await _cacheBase.RemoveByPrefix(LegalTextDefaults.MessageTemplatesPrefixCacheKey);
    }

    public string RenderTemplate(LegalTextMessageTemplate template, LegalTextMessageTemplateToken tokens)
    {
        if (template == null)
            throw new ArgumentNullException(nameof(template));

        if (tokens == null)
            throw new ArgumentNullException(nameof(tokens));

       var hash = Hash.FromAnonymousObject(tokens);
        Template.NamingConvention = new CSharpNamingConvention();
        var liquidTemplate = Template.Parse(template.Body);
        var replaced = liquidTemplate.Render(hash);

        return replaced;
    }

    public async Task UpdateMessageTemplate(LegalTextMessageTemplate messageTemplate)
    {
        if (messageTemplate == null)
            throw new ArgumentNullException(nameof(messageTemplate));

        await _messageTemplateRepository.UpdateAsync(messageTemplate);
        await _cacheBase.RemoveByPrefix(LegalTextDefaults.MessageTemplatesPrefixCacheKey);
    }
}
