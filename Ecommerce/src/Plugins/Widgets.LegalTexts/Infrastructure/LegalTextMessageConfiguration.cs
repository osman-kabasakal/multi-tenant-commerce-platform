using AutoMapper;
using Grand.Infrastructure.Mapper;
using System;
using Grand.Web.Common.Extensions;
using Widgets.LegalTexts.Models;
using Grand.Business.Core.Extensions;

namespace Widgets.LegalTexts.Infrastructure;

public class LegalTextMessageConfiguration : Profile, IAutoMapperProfile
{
    public LegalTextMessageConfiguration()
    {
        CreateMap<Models.LegalTextMessageTemplateModel, LegalTextMessageTemplate>()
            .ForMember(dest => dest.Id, mo => mo.Ignore())
            .ForMember(dest => dest.Locales, mo => mo.MapFrom(x => x.Locales.ToTranslationProperty()));

        CreateMap<LegalTextMessageTemplate, Models.LegalTextMessageTemplateModel>()
            .ForMember(dest => dest.Locales, mo => mo.Ignore());

        CreateMap<LegalTextMessageTemplate, LegalTextMessageTemplateComponentModel>();
    }

    public int Order => 0;
}
