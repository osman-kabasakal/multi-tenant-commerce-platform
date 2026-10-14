using System.ComponentModel.DataAnnotations;
using System.Reflection;
using System.Text.RegularExpressions;
using Core.Utilities;

namespace SaasManager.Application.IdentityManagement.Commands.Registration
{
    public class DynamicFormValidator<T> : AbstractValidator<T> where T : class
    {
        public DynamicFormValidator()
        {
            var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

            foreach (var property in properties)
            {
                // Property için Rule oluştur
                CreateRuleForProperty(property);
            }
        }

        private IValidationRule? CreateRuleForProperty(PropertyInfo property)
        {
            // Property için lambda expression oluştur
            var lambdaExpression = ExpressionHelper.GetPropertyExpression<T>(property);
            var fieldNameAttr = property.GetCustomAttribute<DynamicFormFieldNameAttribute>();
            var propName= fieldNameAttr?.Name??property.Name;

            // RuleFor metodunu çağır
            var ruleFor = typeof(AbstractValidator<T>)
                .GetMethods()
                .First(x => x.Name == "RuleFor")
                .MakeGenericMethod(property.PropertyType);

            var ruleBuilder = ruleFor.Invoke(this, new[] { lambdaExpression });
            if (ruleBuilder == null) return null;

            // Required kontrolü
            var requiredAttr = property.GetCustomAttribute<RequiredAttribute>();
            if (requiredAttr != null)
            {
                var typeMethods = typeof(DynamicFormValidator<T>)
                    .GetMethods(
                                BindingFlags.NonPublic | // Protected ve private methodlar için
                                BindingFlags.Instance | // Instance methodları için  
                                BindingFlags.Static | // Static methodlar için
                                BindingFlags.FlattenHierarchy);
                var applyRequiredMethod = typeMethods
                    .First(x=>x.Name == nameof(ApplyRequiredRule));
                    // .GetMethod(nameof(ApplyRequiredRule),
                    //     new[] { ruleBuilder.GetType(), typeof(string) });
                var applyRequired = applyRequiredMethod!
                    .MakeGenericMethod(property.PropertyType);

                ruleBuilder = applyRequired.Invoke(this,
                    new[] { ruleBuilder, requiredAttr.ErrorMessage ?? $"{property.Name} alanı zorunludur.",propName });
            }

            // Regex kontrolü
            var regexAttr = property.GetCustomAttribute<RegularExpressionAttribute>();
            if (regexAttr != null)
            {
                var applyRegex = GetType()
                    .GetMethod(nameof(ApplyRegexRule),BindingFlags.Public | 
                                                      BindingFlags.NonPublic | // Protected ve private methodlar için
                                                      BindingFlags.Instance | // Instance methodları için  
                                                      BindingFlags.Static | // Static methodlar için
                                                      BindingFlags.FlattenHierarchy)!
                    .MakeGenericMethod(property.PropertyType);

                ruleBuilder = applyRegex.Invoke(this,
                    new[]
                    {
                        ruleBuilder, regexAttr.Pattern,
                        regexAttr.ErrorMessage ?? $"{property.Name} geçerli bir formatta değil.",
                        propName
                    });
            }

            // StringLength kontrolü
            var stringLengthAttr = property.GetCustomAttribute<StringLengthAttribute>();
            if (stringLengthAttr != null)
            {
                var applyStringLength = GetType()
                    .GetMethod(nameof(ApplyStringLengthRule),BindingFlags.Public | 
                                                             BindingFlags.NonPublic | // Protected ve private methodlar için
                                                             BindingFlags.Instance | // Instance methodları için  
                                                             BindingFlags.Static | // Static methodlar için
                                                             BindingFlags.FlattenHierarchy)!
                    .MakeGenericMethod(property.PropertyType);

                ruleBuilder = applyStringLength.Invoke(this,
                    new[]
                    {
                        ruleBuilder, stringLengthAttr.MinimumLength, stringLengthAttr.MaximumLength,
                        stringLengthAttr.ErrorMessage ??
                        $"{property.Name} uzunluğu {stringLengthAttr.MinimumLength} ile {stringLengthAttr.MaximumLength} arasında olmalıdır.",
                        propName
                    });
            }

            // Range kontrolü
            var rangeAttr = property.GetCustomAttribute<RangeAttribute>();
            if (rangeAttr != null)
            {
                var applyRange = GetType()
                    .GetMethod(nameof(ApplyRangeRule),BindingFlags.Public | 
                                                      BindingFlags.NonPublic | // Protected ve private methodlar için
                                                      BindingFlags.Instance | // Instance methodları için  
                                                      BindingFlags.Static | // Static methodlar için
                                                      BindingFlags.FlattenHierarchy)!
                    .MakeGenericMethod(property.PropertyType);

                ruleBuilder = applyRange.Invoke(this,
                    new[]
                    {
                        ruleBuilder, rangeAttr.Minimum, rangeAttr.Maximum,
                        rangeAttr.ErrorMessage ??
                        $"{property.Name} değeri {rangeAttr.Minimum} ile {rangeAttr.Maximum} arasında olmalıdır.",
                        propName
                    });
            }

            return ruleBuilder as IValidationRule;
        }

        protected IRuleBuilder<T, TProperty> ApplyRequiredRule<TProperty>(
            IRuleBuilder<T, TProperty> ruleBuilder,
            string errorMessage,
            string propName)
        {
            return ruleBuilder
                .NotNull()
                .NotEmpty()
                .WithMessage(errorMessage)
                .OverridePropertyName(propName);
        }

        protected IRuleBuilder<T, TProperty> ApplyRegexRule<TProperty>(
            IRuleBuilder<T, TProperty> ruleBuilder,
            string pattern,
            string errorMessage,
            string propName)
        {
            return ruleBuilder
                .Must(value => value == null || Regex.IsMatch(value.ToString()!, pattern))
                .WithMessage(errorMessage)
                .OverridePropertyName(propName);
        }

        protected IRuleBuilder<T, TProperty> ApplyStringLengthRule<TProperty>(
            IRuleBuilder<T, TProperty> ruleBuilder,
            int minLength,
            int maxLength,
            string errorMessage,
            string propName)
        {
            if (typeof(TProperty) == typeof(string))
            {
                var stringRuleBuilder = ruleBuilder as IRuleBuilder<T, string>;
                return (IRuleBuilder<T, TProperty>)stringRuleBuilder!
                    .Length(minLength, maxLength)
                    .WithMessage(errorMessage)
                    .OverridePropertyName(propName);
            }

            return ruleBuilder;
        }

        protected IRuleBuilder<T, TProperty> ApplyRangeRule<TProperty>(
            IRuleBuilder<T, TProperty> ruleBuilder,
            object minimum,
            object maximum,
            string errorMessage,
            string propName)
        {
            if (typeof(TProperty).IsNumeric())
            {
                return ruleBuilder
                    .Must(value => value == null ||
                                   (Convert.ToDouble(value) >= Convert.ToDouble(minimum) &&
                                    Convert.ToDouble(value) <= Convert.ToDouble(maximum)))
                    .WithMessage(errorMessage)
                    .OverridePropertyName(propName);
            }

            return ruleBuilder;
        }
    }

    // Yardımcı sınıflar
    internal static class ExpressionHelper
    {
        public static System.Linq.Expressions.LambdaExpression GetPropertyExpression<T>(PropertyInfo property)
        {
            var parameter = System.Linq.Expressions.Expression.Parameter(typeof(T), "x");
            var memberExpression = System.Linq.Expressions.Expression.Property(parameter, property);
            var delegateType = typeof(Func<,>).MakeGenericType(typeof(T), property.PropertyType);
            return System.Linq.Expressions.Expression.Lambda(delegateType, memberExpression, parameter);
        }
    }

    internal static class TypeExtensions
    {
        public static bool IsNumeric(this Type type)
        {
            switch (Type.GetTypeCode(type))
            {
                case TypeCode.Byte:
                case TypeCode.SByte:
                case TypeCode.UInt16:
                case TypeCode.UInt32:
                case TypeCode.UInt64:
                case TypeCode.Int16:
                case TypeCode.Int32:
                case TypeCode.Int64:
                case TypeCode.Decimal:
                case TypeCode.Double:
                case TypeCode.Single:
                    return true;
                default:
                    return false;
            }
        }
    }
}
