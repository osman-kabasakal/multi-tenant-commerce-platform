namespace SaasManager.Application.Common.Interfaces.Mongo;

public interface IMongoAtlasClientService
{
    Task<TResponse?> GetAsync<TResponse>(string uri, CancellationToken cancellationToken);
    
    Task<TResponse?> PostAsync<TRequest, TResponse>(string uri, TRequest request, CancellationToken cancellationToken);
    Task<TResponse?> DeleteAsync<TResponse>(string uri, CancellationToken cancellationToken);
    
    Task<TResponse?> PutAsync<TRequest, TResponse>(string uri, TRequest request, CancellationToken cancellationToken);
}
