using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using System.Text;
using System.Text.Json;

namespace Grand.Web.MultiTenant.ModelBinders;

public class ComplexTypeModelBinder : IModelBinder
{
    private readonly IModelBinder _overriddenModelBinder;

    public ComplexTypeModelBinder(IModelBinder overriddenModelBinder)
    {
        ArgumentNullException.ThrowIfNull(overriddenModelBinder);
        _overriddenModelBinder = overriddenModelBinder;
    }

    public async Task BindModelAsync(ModelBindingContext bindingContext)
    {
        var httpContext = bindingContext.HttpContext;
        var hasJsonContentType = httpContext.Request.ContentType?.Contains("application/json") ?? false;
        if (hasJsonContentType)
        {
            try
            {
                var request = bindingContext.HttpContext.Request;
                request.EnableBuffering();

                string requestBody;
                using (var reader = new StreamReader(
                           request.Body,
                           encoding: Encoding.UTF8,
                           detectEncodingFromByteOrderMarks: false,
                           leaveOpen: true))
                {
                    requestBody = await reader.ReadToEndAsync();
                    request.Body.Position = 0;
                }

                if (string.IsNullOrEmpty(requestBody))
                {
                    bindingContext.Result = ModelBindingResult.Failed();
                    return;
                }

                using var jsonDoc = JsonDocument.Parse(requestBody);
                var rootElement = jsonDoc.RootElement;

                // Action'daki complex type parameter sayısını kontrol et
                var complexParameters = bindingContext.ActionContext.ActionDescriptor.Parameters
                    .Where(p => !p.ParameterType.IsPrimitive
                                && p.ParameterType != typeof(string)
                                && p.ParameterType != typeof(decimal)
                                && !p.ParameterType.IsEnum
                                && p.BindingInfo?.BindingSource==null)
                    .ToList();

                object model;
                if (complexParameters.Count > 1)
                {
                    // Birden fazla complex type varsa, parameter ismine göre deserialize et
                    if (rootElement.TryGetProperty(bindingContext.FieldName, out var modelProperty))
                    {
                        model = JsonSerializer.Deserialize(
                            modelProperty.GetRawText(),
                            bindingContext.ModelType,
                            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                        );
                    }
                    else
                    {
                        bindingContext.Result = ModelBindingResult.Failed();
                        return;
                    }
                }
                else
                {
                    // Tek complex type varsa
                    try
                    {
                        // Önce parameter ismiyle match eden property'i kontrol et
                        if (rootElement.TryGetProperty(bindingContext.FieldName, out var modelProperty))
                        {
                            model = JsonSerializer.Deserialize(
                                modelProperty.GetRawText(),
                                bindingContext.ModelType,
                                new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                            );
                        }
                        else
                        {
                            // Yoksa direkt body'yi deserialize et
                            model = JsonSerializer.Deserialize(
                                requestBody,
                                bindingContext.ModelType,
                                new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                            );
                        }
                    }
                    catch
                    {
                        // Deserialize başarısız olursa failed dön
                        bindingContext.Result = ModelBindingResult.Failed();
                        return;
                    }
                }

                bindingContext.Result = ModelBindingResult.Success(model);
            }
            catch (Exception)
            {
                bindingContext.ModelState.AddModelError(
                    bindingContext.ModelName,
                    "The request body could not be read."
                );
                bindingContext.Result = ModelBindingResult.Failed();
            }
        }
        else

        {
            await _overriddenModelBinder.BindModelAsync(bindingContext);
        }
    }
}