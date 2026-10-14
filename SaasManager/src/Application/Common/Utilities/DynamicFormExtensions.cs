using System.ComponentModel.DataAnnotations;
using System.Reflection;
using System.Text.Json;
using Core.Utilities;
using SaasManager.Application.Common.Models.IdentityManagement;

namespace SaasManager.Application.Common.Utilities;

public static class DynamicFormExtensions
{
    public static Dictionary<string, FieldDefinition> ToDynamicFormParameters<T>() where T : class, new()
{
    var parameters = new Dictionary<string, FieldDefinition>();
    var modelType = typeof(T);
    var properties = modelType.GetProperties(BindingFlags.Public | BindingFlags.Instance);

    foreach (var property in properties)
    {
        var fieldNameAttr = property.GetCustomAttribute<DynamicFormFieldNameAttribute>();
        var fieldName = fieldNameAttr?.Name ?? property.Name;

        var displayAttribute = property.GetCustomAttribute<DisplayAttribute>();
        var label = displayAttribute?.Name ?? property.Name;

        var requiredAttr = property.GetCustomAttribute<RequiredAttribute>();
        var isRequired = requiredAttr != null;
        
        var fieldDef = new FieldDefinition
        {
            Type = DetermineFieldType(property),
            Label = label,
            Required = isRequired,
            Validations = new Dictionary<string, object>(),
            ValidationMessages = new Dictionary<string, string>()
        };

        var validations = fieldDef.Validations!;
        var validationMessages = fieldDef.ValidationMessages!;

        // RegularExpression kontrolü
        var regexAttr = property.GetCustomAttribute<RegularExpressionAttribute>();
        if (regexAttr != null)
        {
            validations.Add("pattern", regexAttr.Pattern);
            validationMessages.Add("pattern", !string.IsNullOrEmpty(regexAttr.ErrorMessage)
                ? regexAttr.ErrorMessage
                : $"{label} alanı geçerli bir format ile girilmelidir.");
        }
        
        // StringLength kontrolü
        var stringLengthAttribute = property.GetCustomAttribute<StringLengthAttribute>();
        if (stringLengthAttribute != null)
        {
            if(stringLengthAttribute.MinimumLength > 0)
            {
                validations.Add("minLength", stringLengthAttribute.MinimumLength);
                // Key'i 'minlength' olarak değiştirdik
                validationMessages.Add("minlength", !string.IsNullOrEmpty(stringLengthAttribute.ErrorMessage)
                    ? stringLengthAttribute.ErrorMessage
                    : $"{label} alanı en az {stringLengthAttribute.MinimumLength} karakter olmalıdır.");
            }

            var maxlength = stringLengthAttribute.MinimumLength < stringLengthAttribute.MaximumLength
                ? stringLengthAttribute.MaximumLength
                : 1500;
            validations.Add("maxLength", maxlength);
            // Key'i 'maxlength' olarak değiştirdik
            validationMessages.Add("maxlength", !string.IsNullOrEmpty(stringLengthAttribute.ErrorMessage)
                ? stringLengthAttribute.ErrorMessage
                : $"{label} alanı en fazla {maxlength} karakter olmalıdır.");
        }
        
        // Range kontrolü
        var rangeAttribute = property.GetCustomAttribute<RangeAttribute>();
        if (rangeAttribute != null)
        {
            var min = Convert.ToDouble(rangeAttribute.Minimum);
            var max = Convert.ToDouble(rangeAttribute.Maximum);
            
            validations.Add("min", rangeAttribute.Minimum);
            validationMessages.Add("min", !string.IsNullOrEmpty(rangeAttribute.ErrorMessage)
                ? rangeAttribute.ErrorMessage
                : $"{label} alanı en az {rangeAttribute.Minimum} olmalıdır.");
            
            var maxValue = min < max ? max : double.MaxValue;
            validations.Add("max", maxValue);
            validationMessages.Add("max", !string.IsNullOrEmpty(rangeAttribute.ErrorMessage)
                ? rangeAttribute.ErrorMessage
                : $"{label} alanı en fazla {maxValue} olmalıdır.");
        }

        // Required kontrolü için ValidationMessage
        if (isRequired)
        {
            validationMessages.Add("required", !string.IsNullOrEmpty(requiredAttr?.ErrorMessage)
                ? requiredAttr!.ErrorMessage
                : $"{label} alanı zorunludur.");
        }

        parameters.Add(fieldName, fieldDef);
    }
    return parameters;
}

    private static string DetermineFieldType(PropertyInfo property)
    {
        // DataType attribute kontrolü
        var dataTypeAttr = property.GetCustomAttribute<DataTypeAttribute>();
        if (dataTypeAttr != null)
        {
            switch (dataTypeAttr.DataType)
            {
                case DataType.Password:
                    return "password";
                case DataType.EmailAddress:
                    return "email";
                case DataType.PhoneNumber:
                    return "tel";
                case DataType.MultilineText:
                    return "textarea";
                case DataType.Date:
                    return "date";
                case DataType.Time:
                    return "time";
                case DataType.Upload:
                    return "file";
                case DataType.Currency:
                    return "number";
            }
        }

        // Property tipine göre kontrol
        var propertyType = Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType;

        if (propertyType == typeof(bool))
            return "checkbox";

        if (propertyType == typeof(DateTime))
            return "date";

        if (propertyType.IsEnum)
            return "select";

        if (propertyType == typeof(int) || propertyType == typeof(decimal) || propertyType == typeof(double))
            return "number";

        // Field isminde belirli anahtar kelimeleri kontrol et
        var fieldNameLower = property.Name.ToLowerInvariant();
        if (fieldNameLower.Contains("password"))
            return "password";
        if (fieldNameLower.Contains("email"))
            return "email";
        if (fieldNameLower.Contains("phone"))
            return "tel";
        if (fieldNameLower.Contains("cardnumber"))
            return "tel"; // Kredi kartı numarası için tel input daha uygun
        if (fieldNameLower.Contains("cvc") || fieldNameLower.Contains("cvv"))
            return "tel"; // Güvenlik kodu için tel input

        // Varsayılan tip
        return "text";
    }

    public static T ToDynamicFormModel<T>(this Dictionary<string, object> data) where T : class, new()
    {
        var model = new T();
        var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

        foreach (var property in properties)
        {
            var fieldNameAttr = property.GetCustomAttribute<DynamicFormFieldNameAttribute>();

            var fieldName = fieldNameAttr?.Name??property.Name;
            if (!data.TryGetValue(fieldName, out var value) || value == null)
                continue;

            try
            {
                object? convertedValue;
                // JsonElement kontrolü
                if (value is JsonElement jsonElement)
                {
                    convertedValue = ConvertJsonElementToType(jsonElement, property.PropertyType);
                }
                else
                {
                    convertedValue = ConvertValueToType(value, property.PropertyType);
                }

                if (convertedValue != null)
                {
                    property.SetValue(model, convertedValue);
                }
            }
            catch (Exception ex)
            {
                throw new ArgumentException(
                    $"'{fieldName}' alanının değeri '{property.PropertyType.Name}' tipine dönüştürülemedi.",
                    ex);
            }
        }

        return model;
    }

    private static object? ConvertJsonElementToType(JsonElement element, Type targetType)
    {
        targetType = Nullable.GetUnderlyingType(targetType) ?? targetType;

        return element.ValueKind switch
        {
            JsonValueKind.String => ConvertValueToType(element.GetString(), targetType),
            JsonValueKind.Number when targetType == typeof(int) => element.GetInt32(),
            JsonValueKind.Number when targetType == typeof(long) => element.GetInt64(),
            JsonValueKind.Number when targetType == typeof(decimal) => element.GetDecimal(),
            JsonValueKind.Number when targetType == typeof(double) => element.GetDouble(),
            JsonValueKind.True => true,
            JsonValueKind.False => false,
            JsonValueKind.Null => null,
            JsonValueKind.Array when targetType.IsArray => ConvertJsonArrayToArray(element, targetType),
            _ => throw new ArgumentException($"JsonElement türü {element.ValueKind} desteklenmiyor.")
        };
    }

    private static object? ConvertValueToType(object? value, Type targetType)
    {
        if (value == null)
            return null;

        var nullableType = Nullable.GetUnderlyingType(targetType);
        targetType = nullableType ?? targetType;

        // String'e özel kontrol
        if (value is string stringValue)
        {
            if (string.IsNullOrWhiteSpace(stringValue) && nullableType != null)
                return null;

            // Enum kontrolü
            if (targetType.IsEnum)
                return Enum.Parse(targetType, stringValue, true);

            // DateTime kontrolü
            if (targetType == typeof(DateTime) && DateTime.TryParse(stringValue, out var dateValue))
                return dateValue;
        }

        // Sayısal tip dönüşümleri
        if (targetType == typeof(int) && int.TryParse(value.ToString(), out var intValue))
            return intValue;

        if (targetType == typeof(decimal) && decimal.TryParse(value.ToString(), out var decimalValue))
            return decimalValue;

        if (targetType == typeof(double) && double.TryParse(value.ToString(), out var doubleValue))
            return doubleValue;

        // Boolean dönüşümü
        if (targetType == typeof(bool) && bool.TryParse(value.ToString(), out var boolValue))
            return boolValue;

        if (targetType == typeof(Guid) && Guid.TryParse(value.ToString(), out var guidValue))
        {
            return guidValue;
        }

        // Direkt dönüşüm dene
        if (targetType.IsAssignableFrom(value.GetType()))
            return value;

        // Convert.ChangeType ile son deneme
        return Convert.ChangeType(value, targetType);
    }

    private static object? ConvertJsonArrayToArray(JsonElement element, Type targetType)
    {
        var elementType = targetType.GetElementType();
        if (elementType == null)
            throw new ArgumentException("Hedef tip bir dizi tipi değil.");

        var list = element.EnumerateArray()
            .Select(item => ConvertJsonElementToType(item, elementType))
            .Where(item => item != null)
            .ToArray();

        var array = Array.CreateInstance(elementType, list.Length);
        Array.Copy(list, array, list.Length);
        return array;
    }
}
