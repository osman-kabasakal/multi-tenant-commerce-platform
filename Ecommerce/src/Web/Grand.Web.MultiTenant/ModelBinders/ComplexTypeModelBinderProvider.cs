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
            && context.BindingInfo?.BindingSource==null)
        {
            var fallback = overriddenModelBinderProvider.GetBinder(context);
            // Unsupported types (including nullable values) must continue through MVC's normal providers.
            return fallback == null ? null : new ComplexTypeModelBinder(fallback);
        }

        return null;
    }
}