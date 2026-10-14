namespace Core.Models.Responses;

public class ServiceResponse<T>: IServiceResponse
{
    public bool IsSuccess { get; }
    public T? Data { get; }
    public string? ErrorCode { get; }
    public string? ErrorMessage { get; }

    private ServiceResponse(bool isSuccess, T? data = default, string? errorCode = null, string? errorMessage = null)
    {
        IsSuccess = isSuccess;
        Data = data;
        ErrorCode = errorCode;
        ErrorMessage = errorMessage;
    }

    public static ServiceResponse<T> Success(T data) => new(true, data);

    public static ServiceResponse<T> Error(string code, string message) 
        => new(false, default, code, message);
}

public interface IServiceResponse
{
    public bool IsSuccess { get; }
    public string? ErrorCode { get; }
    public string? ErrorMessage { get; }
}
