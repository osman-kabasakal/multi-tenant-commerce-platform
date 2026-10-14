namespace Payments.Iyzico.Utilities;

public class FieldDefinition
{
    public string Type { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public object? Value { get;  set; }
    public bool Required { get; set; }
    public Dictionary<string, object> Validations { get; set; }= new();

    public Dictionary<string, string> ValidationMessages { get; set; } = new Dictionary<string, string>();
    
}
