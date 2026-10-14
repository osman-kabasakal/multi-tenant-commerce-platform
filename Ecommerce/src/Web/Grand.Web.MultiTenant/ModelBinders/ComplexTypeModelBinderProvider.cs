using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace Grand.Web.MultiTenant.ModelBinders;

public class ComplexTypeModelBinderProvider(IModelBinderProvider overriddenModelBinderProvider) : IModelBinderProvider
{
    public IModelBinder GetBinder(ModelBinderProviderContext context)
    {
        if (context == null)
        {
            throw new ArgumentNullException(nameof(context));
        }

        if (!context.Metadata.ModelType.IsPrimitive
            && context.Metadata.ModelType != typeof(string)
            && context.Metadata.ModelType != typeof(decimal)
            && !context.Metadata.ModelType.IsEnum
            && context.BindingInfo.BindingSource==null)
        {
            return new ComplexTypeModelBinder(overriddenModelBinderProvider.GetBinder(context));
        }

        return null;
    }
}