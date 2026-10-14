using System.Net.Http;
using System.Text;
using System.Text.Json;
using Famizyo.Integration.Adisyo.Models;
using Famizyo.Integration.Adisyo.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;

namespace Famizyo.Integration.Adisyo.Services;

public class AdisyoApiService : IAdisyoApiService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<AdisyoApiService> _logger;
    private readonly ISettingService _settingService;
    private readonly IConnectionMultiplexer _redis;
    private readonly JsonSerializerOptions _jsonOptions;

    public AdisyoApiService(
        HttpClient httpClient,
        ILogger<AdisyoApiService> logger,
        ISettingService settingService,
        IConnectionMultiplexer redis
        )
    {
        _httpClient = httpClient;
        _logger = logger;
        _settingService = settingService;
        _redis = redis;
        _jsonOptions = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true,
            DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull,
        };
    }

    private async Task<HttpRequestMessage> CreateRequestAsync(string endpoint, HttpMethod method, object content = null)
    {
        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
        
        if (string.IsNullOrEmpty(settings.ApiKey) || string.IsNullOrEmpty(settings.ApiSecret))
        {
            throw new InvalidOperationException("Adisyo API credentials are not configured");
        }

        var request = new HttpRequestMessage(method, $"{settings.BaseUrl}/{endpoint}");
        
        // Add required headers
        request.Headers.Add("x-api-key", settings.ApiKey!);
        request.Headers.Add("x-api-secret", settings.ApiSecret!);
        request.Headers.Add("x-api-consumer", settings.Consumer);

        if (content != null)
        {
            var json = JsonSerializer.Serialize(content, _jsonOptions);
            request.Content = new StringContent(json, Encoding.UTF8, "application/json");
        }

        return request;
    }

    private async Task<T> GetFromRedisAsync<T>(string key)
    {
        try
        {
            var db = _redis.GetDatabase();
            var value = await db.StringGetAsync(key);
            
            if (!value.HasValue)
                return default(T);
                
            return JsonSerializer.Deserialize<T>(value, _jsonOptions);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting value from Redis for key: {Key}", key);
            return default(T);
        }
    }

    private async Task SetToRedisAsync<T>(string key, T value, TimeSpan expiry)
    {
        try
        {
            var db = _redis.GetDatabase();
            var json = JsonSerializer.Serialize(value, _jsonOptions);
            await db.StringSetAsync(key, json, expiry);
            _logger.LogDebug("Successfully cached data to Redis with key: {Key}, expiry: {Expiry}", key, expiry);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error setting value to Redis for key: {Key}", key);
        }
    }

    private async Task<T> GetOrSetRedisAsync<T>(string key, Func<Task<T>> factory, TimeSpan expiry)
    {
        // Try to get from Redis first
        var cachedValue = await GetFromRedisAsync<T>(key);
        if (cachedValue != null)
        {
            _logger.LogDebug("Cache hit for key: {Key}", key);
            return cachedValue;
        }

        // If not in cache, call factory method
        _logger.LogDebug("Cache miss for key: {Key}, fetching from source", key);
        var value = await factory();
        
        // Cache the result
        if (value != null)
        {
            await SetToRedisAsync(key, value, expiry);
        }

        return value;
    }

    private async Task<T> SendRequestAsync<T>(string endpoint, HttpMethod method, object? content = null)
    {
        try
        {
            var request = await CreateRequestAsync(endpoint, method, content);
            var response = await _httpClient.SendAsync(request);
            
            var responseContent = await response.Content.ReadAsStringAsync();
            
            if (!response.IsSuccessStatusCode)
            {
                _logger.LogError("Adisyo API request failed. Status: {StatusCode}, Content: {Content}", 
                    response.StatusCode, responseContent);
                throw new HttpRequestException($"Adisyo API request failed with status {response.StatusCode}");
            }
            
            _logger.LogDebug("Adisyo API response received. Status: {StatusCode}, Content: {Content}", 
                response.StatusCode, responseContent);
            var result = JsonSerializer.Deserialize<T>(responseContent, _jsonOptions);
            if (result == null)
            {
                throw new InvalidOperationException("Failed to deserialize Adisyo API response");
            }

            return result;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error calling Adisyo API endpoint: {Endpoint}", endpoint);
            throw;
        }
    }

    public async Task<List<AdisyoProductCategory>> GetProductsAsync()
    {
        _logger.LogInformation("Fetching products from Adisyo API");
        
        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
        var cacheKey = $"adisyo:{settings.ApiKey}:products";
        var cacheExpiry = TimeSpan.FromMinutes(3);
        
        var response = await GetOrSetRedisAsync(cacheKey, 
            () => SendRequestAsync<AdisyoApiResponse<List<AdisyoProductCategory>>>("Products", HttpMethod.Get), 
            cacheExpiry);
        
        if (response.Status != 100)
        {
            throw new InvalidOperationException($"Adisyo API returned error: {response.Message}");
        }

        return response.Data ?? new List<AdisyoProductCategory>();
    }

    public async Task<List<AdisyoProductCategory>> GetProductCategoriesAsync()
    {
        return await GetProductsAsync();
    }

    public async Task<List<AdisyoFeatureGroupDetail>> GetFeaturesAsync()
    {
        _logger.LogInformation("Fetching features from Adisyo API (legacy endpoint)");
        
        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
        var cacheKey = $"adisyo:{settings.ApiKey}:features";
        var cacheExpiry = TimeSpan.FromMinutes(3);
        
        var response = await GetOrSetRedisAsync(cacheKey, 
            () => SendRequestAsync<AdisyoApiResponse<AdisyoFeaturesResponse>>("Features", HttpMethod.Get), 
            cacheExpiry);
        
        if (response.Status != 100)
        {
            throw new InvalidOperationException($"Adisyo API returned error: {response.Message}");
        }

        return response.Data.FeatureGroups ?? new List<AdisyoFeatureGroupDetail>();
    }

    public async Task<AdisyoFeaturesResponse> GetFeatureGroupsAsync()
    {
        _logger.LogInformation("Fetching sophisticated feature groups from Adisyo API");
        
        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
        var cacheKey = $"adisyo:{settings.ApiKey}:feature-groups";
        var cacheExpiry = TimeSpan.FromMinutes(3);
        
        var response = await GetOrSetRedisAsync(cacheKey, 
            () => SendRequestAsync<AdisyoApiResponse<AdisyoFeaturesResponse>>("Features", HttpMethod.Get), 
            cacheExpiry);
        
        if (response.Status != 100)
        {
            throw new InvalidOperationException($"Adisyo API returned error: {response.Message}");
        }

        return response.Data ?? new AdisyoFeaturesResponse();
    }

    public async Task<List<AdisyoPaymentType>> GetPaymentTypesAsync()
    {
        _logger.LogInformation("Fetching payment types from Adisyo API");
        
        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
        var cacheKey = $"adisyo:{settings.ApiKey}:payment-types";
        var cacheExpiry = TimeSpan.FromMinutes(3);
        
        var response = await GetOrSetRedisAsync(cacheKey, 
            () => SendRequestAsync<AdisyoPaymentTypesResponse>("PaymentTypes", HttpMethod.Get), 
            cacheExpiry);
        
        if (response.Status != 100)
        {
            throw new InvalidOperationException($"Adisyo API returned error: {response.Message}");
        }

        return response.PaymentTypes;
    }

    public async Task<AdisyoOrderResponse> SaveOrderAsync(AdisyoOrderRequest orderRequest)
    {
        _logger.LogInformation("Sending order to Adisyo API. WebOrderId: {WebOrderId}", orderRequest.WebOrderId);
        
        var response = await SendRequestAsync<AdisyoOrderResponse>(
            "SaveOrder", HttpMethod.Post, orderRequest);
        
        if (response.Status != 100)
        {
            throw new InvalidOperationException($"Adisyo API returned error: {response.Message}");
        }

        _logger.LogInformation("Order successfully sent to Adisyo. OrderId: {OrderId}", response.OrderId);
        return response;
    }

    public async Task<AdisyoApiResponse<object>> CancelOrderAsync(int orderId, string? cancelReason = null)
    {
        _logger.LogInformation("Cancelling order in Adisyo. OrderId: {OrderId}, Reason: {Reason}", 
            orderId, cancelReason);
        
        var cancelRequest = new AdisyoCancelOrderRequest
        {
            OrderId = orderId,
            CancelReason = cancelReason
        };

        var response = await SendRequestAsync<AdisyoApiResponse<object>>(
            "Cancel", HttpMethod.Post, cancelRequest);
        
        if (response.Status != 100)
        {
            throw new InvalidOperationException($"Adisyo API returned error: {response.Message}");
        }

        _logger.LogInformation("Order successfully cancelled in Adisyo. OrderId: {OrderId}", orderId);
        return response;
    }

    public async Task<AdisyoOrderQueryResponse> GetRecentOrdersAsync(AdisyoRecentOrdersRequest request)
    {
        _logger.LogInformation("Fetching recent orders from Adisyo API. Page: {Page}", request.Page);
        
        var queryString = BuildQueryString(new Dictionary<string, object?>
        {
            { "page", request.Page },
            { "minimumId", request.MinimumId },
            { "minimumUpdateDate", request.MinimumUpdateDate },
            { "status", request.Status }
        });

        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
        var cacheKey = $"adisyo:{settings.ApiKey}:recent-orders:{queryString}";
        var cacheExpiry = TimeSpan.FromMinutes(1);
        
        var response = await GetOrSetRedisAsync(cacheKey, 
            () => SendRequestAsync<AdisyoOrderQueryResponse>($"RecentOrders{queryString}", HttpMethod.Get), 
            cacheExpiry);
        
        if (response.Status != 100)
        {
            throw new InvalidOperationException($"Adisyo API returned error: {response.Message}");
        }

        return response;
    }

    public async Task<CompletedOrderRequestResponse> GetCompletedOrdersAsync(AdisyoCompletedOrdersRequest request)
    {
        _logger.LogInformation("Fetching completed orders from Adisyo API. Page: {Page}, StartDate: {StartDate}", 
            request.Page, request.StartDate);
        
        var queryString = BuildQueryString(new Dictionary<string, object?>
        {
            { "page", request.Page },
            { "startDate", request.StartDate },
            { "includeCancelled", request.IncludeCancelled },
            { "orderType", request.OrderType }
        });

        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
        var cacheKey = $"adisyo:{settings.ApiKey}:completed-orders:{queryString}";
        var cacheExpiry = TimeSpan.FromMinutes(1);
        
        var response = await GetOrSetRedisAsync(cacheKey, 
            () => SendRequestAsync<CompletedOrderRequestResponse>($"CompletedOrders{queryString}", HttpMethod.Get), 
            cacheExpiry);
        
        if (response.Status != 100)
        {
            throw new InvalidOperationException($"Adisyo API returned error: {response.Message}");
        }

        return response;
    }

    public async Task<byte[]> GetImageWithUrl(string imageUrl)
    {
        var settings = _settingService.LoadSetting<AdisyoIntegrationSettings>();
        var request = new HttpRequestMessage(HttpMethod.Get, imageUrl);
        
        // Add required headers
        request.Headers.Add("x-api-key", settings.ApiKey!);
        request.Headers.Add("x-api-secret", settings.ApiSecret!);
        request.Headers.Add("x-api-consumer", settings.Consumer);
        var imageDatta = await _httpClient.SendAsync(request).ConfigureAwait(false);
        if (!imageDatta.IsSuccessStatusCode)
        {
            _logger.LogError("Failed to fetch image from Adisyo. Status: {StatusCode}", imageDatta.StatusCode);
            return [];
        }
        
        var imageBytes = await imageDatta.Content.ReadAsByteArrayAsync().ConfigureAwait(false);
        
        if (imageBytes == null || imageBytes.Length == 0)
        {
            _logger.LogError("Received empty image data from Adisyo");
            return [];
        }
        _logger.LogInformation("Successfully fetched image from Adisyo. Size: {Size} bytes", imageBytes.Length);
        return imageBytes;
    }

    private static string BuildQueryString(Dictionary<string, object?> parameters)
    {
        var validParams = parameters
            .Where(p => p.Value != null)
            .Select(p => $"{p.Key}={Uri.EscapeDataString(p.Value!.ToString()!)}")
            .ToList();

        return validParams.Any() ? "?" + string.Join("&", validParams) : string.Empty;
    }
}