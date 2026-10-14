namespace SaasManager.Application.Common.Models.IdentityManagement;

public class RegistrationStepResponse
{
    public string CurrentStep { get; set; } = string.Empty;
    public Dictionary<string, FieldDefinition>? ExpectedParams { get; set; }
    public string? ValidationUrl { get; set; }
    public string? ValidationToken { get; set; }
    public int? TimeoutSeconds { get; set; }
    public bool IsCompleted { get; set; }
    public string? RedirectUrl { get; set; }

    public bool HasValidationError => OperationErrorMessage != null || Errors.Count > 0;

    public string? OperationErrorMessage { get; set; }

    public Dictionary<string, List<string>> Errors { get; set; } = new Dictionary<string, List<string>>();
}
