using Grand.Infrastructure.Mapper;
using Widgets.LegalTexts;
using Widgets.LegalTexts.Models;

public static class LegalMessageTemplateMapperExtensions{
    public static LegalTextMessageTemplate ToEntity(this LegalTextMessageTemplateModel model){

        if(model == null)
            return null;

        return model.MapTo<LegalTextMessageTemplateModel,LegalTextMessageTemplate>();
    }

     public static LegalTextMessageTemplate ToEntity(this LegalTextMessageTemplateModel model, LegalTextMessageTemplate destination){

        if(model == null)
            return null;

        return model.MapTo(destination);
    }


    public static LegalTextMessageTemplateModel ToModel(this LegalTextMessageTemplate entity){

        if(entity == null)
            return null;

        return entity.MapTo<LegalTextMessageTemplate,LegalTextMessageTemplateModel>();
    }
}