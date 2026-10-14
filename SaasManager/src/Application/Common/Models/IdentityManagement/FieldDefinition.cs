namespace SaasManager.Application.Common.Models.IdentityManagement;

public class FieldDefinition
{
    public string Type { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public bool Required { get; set; }
    public Dictionary<string, object>? Validations { get; set; }

    public Dictionary<string, string> ValidationMessages { get; set; } = new Dictionary<string, string>();
}
