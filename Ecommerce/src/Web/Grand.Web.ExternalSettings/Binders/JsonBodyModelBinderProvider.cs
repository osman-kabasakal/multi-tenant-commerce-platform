// using Grand.Infrastructure.ModelBinding;
// using Microsoft.AspNetCore.Mvc;
// using Microsoft.AspNetCore.Mvc.ModelBinding;
// using System.Reflection;
//
// namespace Grand.Web.ExternalSettings.Binders;
//
// public class JsonBodyModelBinderProvider:IModelBinderProvider
// {
//     public IModelBinder GetBinder(ModelBinderProviderContext context)
//     {
//         ArgumentNullException.ThrowIfNull(context);
//
//         if (context == null)
//             throw new ArgumentNullException(nameof(context));
//
//         // Eğer model üzerinde özel bir Bind attribute varsa, bu provider'ı atla
//         if (context.Metadata.ModelType.GetCustomAttribute<BindAttribute>() != null)
//             return null;
//
//         // Complex type'lar için JSON binding yap
//         if (!context.Metadata.IsComplexType)
//             return null;
//
//         return new JsonBodyModelBinder();
//     }
// }