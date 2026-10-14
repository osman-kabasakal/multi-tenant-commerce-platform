namespace Payments.Iyzico.Utilities;

[AttributeUsage(AttributeTargets.Property | AttributeTargets.Parameter)]
public class DynamicFormFieldNameAttribute : Attribute
{
    public string Name { get; }

    public DynamicFormFieldNameAttribute(string name)
    {
        Name = name;
    }
}
