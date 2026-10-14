using System.ComponentModel.DataAnnotations;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Authentication;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using SaasManager.Application.Common.Interfaces.Mongo;
using HttpRequestException = System.Net.Http.HttpRequestException;

namespace SaasManager.Infrastructure.MongoAtlas;

public class MongoAtlasClientService: IMongoAtlasClientService
{
    private readonly IMongoDigestAuthenticationHandler _authenticationHandler;

    public MongoAtlasClientService(
        IMongoDigestAuthenticationHandler authenticationHandler
        )
    {
        _authenticationHandler = authenticationHandler;
    }
    
    public async Task<TResponse?> GetAsync<TResponse>(string uri, CancellationToken cancellationToken)
    {
        var requestMessage= new HttpRequestMessage(HttpMethod.Get, uri);
        requestMessage.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/vnd.atlas.2024-08-05+json"));
        
        using var response = await _authenticationHandler.SendRequestAsync(requestMessage);
    
        if (response.IsSuccessStatusCode) // 2xx kodları için
        {
            if (response.Content.Headers.ContentLength > 0)
            {
                return await response.Content.ReadFromJsonAsync<TResponse>(cancellationToken: cancellationToken);
            }
            return default;
        }
    
        var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
        throw new HttpRequestException(
            $"API yanıtı başarısız: {response.StatusCode} - {errorContent}",
            null,
            response.StatusCode);
    }

    public async Task<TResponse?> PostAsync<TRequest, TResponse>(string uri, TRequest request, CancellationToken cancellationToken)
    {
        var requestMessage= new HttpRequestMessage(HttpMethod.Post, uri);
        requestMessage.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/vnd.atlas.2024-08-05+json"));
        requestMessage.Content = new StringContent(JsonSerializer.Serialize(request), Encoding.UTF8, "application/json");
        using var response = await _authenticationHandler.SendRequestAsync(requestMessage);
    
        switch (response.StatusCode)
        {
            case HttpStatusCode.OK:
            case HttpStatusCode.Created:
            case HttpStatusCode.Accepted:
                if (response.Content.Headers.ContentLength > 0)
                {
                    return await response.Content.ReadFromJsonAsync<TResponse>(cancellationToken: cancellationToken);
                }
                return default;
            
            case HttpStatusCode.NotFound:
                throw new HttpRequestException($"Kaynak bulunamadı: {uri}");
            
            case HttpStatusCode.BadRequest:
                var validationErrors = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>(cancellationToken);
                throw new ValidationException($"İstek geçersiz:\n{validationErrors?.Detail}");
            
            case HttpStatusCode.Unauthorized:
            case HttpStatusCode.Forbidden:
                throw new AuthenticationException("Yetkisiz erişim");
            
            default:
                var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                throw new HttpRequestException(
                    $"API yanıtı başarısız: {response.StatusCode} - {errorContent}",
                    null,
                    response.StatusCode);
        }
    }

    public async Task<TResponse?> DeleteAsync<TResponse>(string uri, CancellationToken cancellationToken)
    {
        var requestMessage= new HttpRequestMessage(HttpMethod.Delete, uri);
        requestMessage.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/vnd.atlas.2024-08-05+json"));
        
        using var response = await _authenticationHandler.SendRequestAsync(requestMessage);
    
        if (response.IsSuccessStatusCode) // 2xx kodları için
        {
            if (response.Content.Headers.ContentLength > 0)
            {
                return await response.Content.ReadFromJsonAsync<TResponse>(cancellationToken: cancellationToken);
            }
            return default;
        }
    
        var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
        throw new HttpRequestException(
            $"API yanıtı başarısız: {response.StatusCode} - {errorContent}",
            null,
            response.StatusCode);
    }

    public Task<TResponse?> PutAsync<TRequest, TResponse>(string uri, TRequest request, CancellationToken cancellationToken)
    {
        throw new NotImplementedException();
    }
}
