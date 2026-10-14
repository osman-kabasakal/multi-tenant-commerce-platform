namespace SaasManager.Application.Common.Models.Authantication;

public record GuestValidationResult
{
    public bool IsValid { get; }
    public string? FailedAtStep { get; }
    public string? ErrorMessage { get; }

    public Dictionary<string, List<string>> Errors { get; set; } = new Dictionary<string, List<string>>();

    private GuestValidationResult(bool isValid, string? failedAtStep = null, string? errorMessage = null,Dictionary<string, List<string>>? errors= null)
    {
        IsValid = isValid;
        FailedAtStep = failedAtStep;
        ErrorMessage = errorMessage;
        Errors = errors ?? new Dictionary<string, List<string>>();
    }

    public static GuestValidationResult Success() => new(true);

    public static GuestValidationResult Failure(string step, string message,Dictionary<string, List<string>>? errors= null) 
        => new(false, step, message,errors);
}
