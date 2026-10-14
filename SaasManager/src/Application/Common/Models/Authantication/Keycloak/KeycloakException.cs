namespace SaasManager.Application.Common.Models.Authantication.Keycloak;

public class KeycloakException : Exception
{
    public string Error { get; }
    public string ErrorDescription { get; }

    public KeycloakException(string message) : base(message)
    {
        Error = "unknown_error";
        ErrorDescription = message;
    }

    public KeycloakException(string error, string errorDescription) 
        : base($"{error}: {errorDescription}")
    {
        Error = error;
        ErrorDescription = errorDescription;
    }

    public KeycloakException(string message, Exception innerException) 
        : base(message, innerException)
    {
        Error = "unknown_error";
        ErrorDescription = message;
    }
}