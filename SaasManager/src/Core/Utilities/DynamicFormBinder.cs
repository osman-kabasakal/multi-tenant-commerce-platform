using System.Reflection;
using System.Text.Json;

namespace Core.Utilities;

public static class DynamicFormBinder
{
    public static T BindToModel<T>(this Dictionary<string, object> formData)
    {
        var modelType = typeof(T);

        // Check if the type has a constructor
        var constructor = modelType.GetConstructors().FirstOrDefault();
        if (constructor != null)
        {
            var constructorParams = constructor.GetParameters();
            var constructorArgs = new object?[constructorParams.Length];

            for (int i = 0; i < constructorParams.Length; i++)
            {
                var param = constructorParams[i];
                var dynamicFormFieldNameAttribute = param.GetCustomAttribute<DynamicFormFieldNameAttribute>();
                var fieldName = dynamicFormFieldNameAttribute?.Name ?? param.Name;

                if (fieldName != null && formData.TryGetValue(fieldName, out var value))
                {
                    constructorArgs[i] = ConvertToType(value, param.ParameterType);
                }
                else
                {
                    constructorArgs[i] = param.ParameterType.IsValueType ? Activator.CreateInstance(param.ParameterType) : null;
                }
            }

            var model = (T)constructor.Invoke(constructorArgs);

            // Set remaining writable properties
            foreach (var property in modelType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                if (property.CanWrite && property.SetMethod?.IsPublic == true)
                {
                    var dynamicFormFieldNameAttribute = property.GetCustomAttribute<DynamicFormFieldNameAttribute>();
                    var fieldName = dynamicFormFieldNameAttribute?.Name ?? property.Name;

                    if (formData.TryGetValue(fieldName, out var value))
                    {
                        property.SetValue(model, ConvertToType(value, property.PropertyType));
                    }
                }
            }

            return model;
        }

        // Fallback for class types with default constructor
        var fallbackModel = Activator.CreateInstance<T>();
        foreach (var property in modelType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            var dynamicFormFieldNameAttribute = property.GetCustomAttribute<DynamicFormFieldNameAttribute>();
            var fieldName = dynamicFormFieldNameAttribute?.Name ?? property.Name;

            if (formData.TryGetValue(fieldName, out var value))
            {
                property.SetValue(fallbackModel, ConvertToType(value, property.PropertyType));
            }
        }

        return fallbackModel;
    }
    
    private static object? ConvertToType(object value, Type targetType)
    {
        try
        {
            if (value == null)
            {
                return targetType.IsValueType && Nullable.GetUnderlyingType(targetType) == null
                    ? Activator.CreateInstance(targetType)
                    : null;
            }

            // Handle JsonElement case
            if (value is JsonElement jsonElement)
            {
                return ConvertJsonElementToType(jsonElement, targetType);
            }

            // Handle nullable types
            var underlyingType = Nullable.GetUnderlyingType(targetType) ?? targetType;

            // Handle enums
            if (underlyingType.IsEnum && value is string stringValue)
            {
                return Enum.Parse(underlyingType, stringValue, ignoreCase: true);
            }

            // Handle standard conversions
            return Convert.ChangeType(value, underlyingType);
        }
        catch
        {
            // Log or handle conversion failure
            return null;
        }
    }

    private static object? ConvertJsonElementToType(JsonElement element, Type targetType)
    {
        try
        {
            // Handle nullable types
            var underlyingType = Nullable.GetUnderlyingType(targetType) ?? targetType;

            // Handle enums
            if (underlyingType.IsEnum)
            {
                var stringValue = element.GetString();
                return stringValue != null ? Enum.Parse(underlyingType, stringValue, ignoreCase: true) : null;
            }

            switch (element.ValueKind)
            {
                case JsonValueKind.Null:
                    return targetType.IsValueType && Nullable.GetUnderlyingType(targetType) == null
                        ? Activator.CreateInstance(targetType)
                        : null;

                case JsonValueKind.String:
                    var stringVal = element.GetString();
                    if (underlyingType == typeof(Guid) && stringVal != null)
                    {
                        return Guid.Parse(stringVal);
                    }
                    if (underlyingType == typeof(DateTime))
                    {
                        return DateTime.Parse(stringVal ?? string.Empty);
                    }
                    return Convert.ChangeType(stringVal, underlyingType);

                case JsonValueKind.Number:
                    if (underlyingType == typeof(int)) return element.GetInt32();
                    if (underlyingType == typeof(long)) return element.GetInt64();
                    if (underlyingType == typeof(double)) return element.GetDouble();
                    if (underlyingType == typeof(decimal)) return element.GetDecimal();
                    if (underlyingType == typeof(float)) return element.GetSingle();
                    break;

                case JsonValueKind.True:
                case JsonValueKind.False:
                    return element.GetBoolean();

                case JsonValueKind.Array:
                    // return element.EnumerateArray().Select(x=>)
                    break;

                case JsonValueKind.Object:
                    // Object handling could be implemented here if needed
                    break;
            }

            // Fallback: try general conversion
            return Convert.ChangeType(element.GetRawText(), underlyingType);
        }
        catch
        {
            // Log or handle conversion failure
            return null;
        }
    }
}

[AttributeUsage(AttributeTargets.Property | AttributeTargets.Parameter)]
public class DynamicFormFieldNameAttribute : Attribute
{
    public string Name { get; }

    public DynamicFormFieldNameAttribute(string name)
    {
        Name = name;
    }
}
