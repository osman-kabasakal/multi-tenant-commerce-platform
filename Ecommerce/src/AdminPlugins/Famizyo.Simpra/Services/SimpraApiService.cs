using Famizyo.Simpra.Models;
using Famizyo.Simpra.Settings;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Famizyo.Simpra.Services;

public class SimpraApiService : ISimpraApiService
{
    private readonly HttpClient _httpClient;
    private readonly ISettingService _settingService;
    private readonly ILogger<SimpraApiService> _logger;
    private SimpraSettings _settings;

    public SimpraApiService(
        HttpClient httpClient,
        ISettingService settingService,
        ILogger<SimpraApiService> logger)
    {
        _httpClient = httpClient;
        _settingService = settingService;
        _logger = logger;
        _settings = _settingService.LoadSetting<SimpraSettings>();
        ConfigureHttpClient();
    }

    private void ConfigureHttpClient()
    {
        var baseUrl = _settings.SimpraEnvironment switch
        {
            SimpraEnvironment.Production => "https://api.simpra.app/",
            SimpraEnvironment.Uat => "https://api-uat.simpra.app/",
            SimpraEnvironment.Qa => "https://api-qa.simpra.app/",
            _ => throw new ArgumentOutOfRangeException(nameof(_settings.SimpraEnvironment), "Invalid environment setting")
        };

        _httpClient.BaseAddress = new Uri(baseUrl);
        _httpClient.DefaultRequestHeaders.Clear();
        _httpClient.DefaultRequestHeaders.Add("Simpra-Access-Token", _settings.AccessToken);
        _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
    }

    private async Task<T> SendRequestAsync<T>(string endpoint, HttpMethod method, object? requestBody = null)
    {
        try
        {
            var request = new HttpRequestMessage(method, endpoint);

            if (requestBody != null)
            {
                var json = JsonSerializer.Serialize(requestBody, new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                    DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
                });
                request.Content = new StringContent(json, Encoding.UTF8, "application/json");
            }

            var response = await _httpClient.SendAsync(request);
            var responseContent = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
            {
                _logger.LogError("Simpra API request failed. Status: {StatusCode}, Content: {Content}", 
                    response.StatusCode, responseContent);
                throw new HttpRequestException($"Simpra API request failed: {response.StatusCode}");
            }

            if (string.IsNullOrEmpty(responseContent))
            {
                 return JsonSerializer.Deserialize<T>("{}",new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                });;
            }

            return JsonSerializer.Deserialize<T>(responseContent, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error sending request to Simpra API endpoint: {Endpoint}", endpoint);
            throw;
        }
    }

    public async Task<SimpraBaseResponse<SimpraMenuItemResponse>> CreateMenuItemAsync(SimpraMenuItemRequest request)
    {
        var crudResponse= await SendRequestAsync<SimpraMenuItemCrudResponse>(
            "apps/api/v1/menu_items", HttpMethod.Post, request);

        if (crudResponse.Errors != null && crudResponse.Errors.Any())
        {
            return new SimpraBaseResponse<SimpraMenuItemResponse>() {
                Success = false,
                Message = string.Join(", ", crudResponse.Errors.Select(e => e.Message)),
            };
        }

        return await GetMenuItemAsync(crudResponse.MenuItem.Id);

    }

    public async Task<SimpraBaseResponse<SimpraMenuItemResponse>> UpdateMenuItemAsync(string menuItemId, SimpraMenuItemRequest request)
    {
        var crudResponse= await SendRequestAsync<SimpraMenuItemCrudResponse>(
            $"apps/api/v1/menu_items/{menuItemId}", HttpMethod.Patch, request);
        
        if (crudResponse.Errors != null && crudResponse.Errors.Any())
        {
            return new SimpraBaseResponse<SimpraMenuItemResponse>() {
                Success = false,
                Message = string.Join(", ", crudResponse.Errors.Select(e => e.Message)),
            };
        }

        return await GetMenuItemAsync(crudResponse.MenuItem.Id);
    }

    public async Task<SimpraBaseResponse<List<SimpraMenuItemResponse>>> GetMenuItemsAsync(
        int page = 1, 
        int perPage = 50, 
        long? updatedAt = null, 
        string? status = null, 
        string? propertyIds = null, 
        string? sku = null)
    {
        try
        {
            var queryParams = new List<string>();
            
            queryParams.Add($"page={page}");
            queryParams.Add($"per_page={perPage}");
            
            if (updatedAt.HasValue)
                queryParams.Add($"updated_at={updatedAt.Value}");
            
            if (!string.IsNullOrEmpty(status))
                queryParams.Add($"status={status}");
            
            if (!string.IsNullOrEmpty(propertyIds))
                queryParams.Add($"property_ids={propertyIds}");
            
            if (!string.IsNullOrEmpty(sku))
                queryParams.Add($"sku={sku}");
            
            var endpoint = "v2/menu_items";
            if (queryParams.Any())
            {
                endpoint += "?" + string.Join("&", queryParams);
            }
            
            var response = await SendRequestAsync<SimpraMenuItemsResponse>(endpoint, HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraMenuItemResponse>>
            {
                Data = response.MenuItems,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get menu items");
            return new SimpraBaseResponse<List<SimpraMenuItemResponse>>
            {
                Data = new List<SimpraMenuItemResponse>(),
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<SimpraMenuItemResponse>> GetMenuItemAsync(string menuItemId)
    {
        var response= await SendRequestAsync<SimpraMenuItemResponse>(
            $"v2/menu_items/{menuItemId}", HttpMethod.Get);
        return new SimpraBaseResponse<SimpraMenuItemResponse>
        {
            Data = response,
            Success = true,
            Message = null
        };
    }

    public async Task<SimpraBaseResponse<List<SimpraMenuItemGroup>>> GetMenuItemGroupsAsync()
    {
        try
        {
            var response = await SendRequestAsync<SimpraMenuItemGroupsResponse>("menu_item_groups", HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraMenuItemGroup>>
            {
                Data = response.MenuItemGroups,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get menu item groups");
            return new SimpraBaseResponse<List<SimpraMenuItemGroup>>
            {
                Data = new List<SimpraMenuItemGroup>(),
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<SimpraCrudCheckResponse>> CreateCheckAsync(SimpraCheckRequest request)
    {
        try
        {
            var crudCheckResponse = await SendRequestAsync<SimpraCrudCheckResponse>(
                "apps/api/v1/checks", HttpMethod.Post, request);

            return new SimpraBaseResponse<SimpraCrudCheckResponse> {
                Data = crudCheckResponse,
                Success = true,
                Message = null
            };

        }
        catch (Exception e)
        {
            return new SimpraBaseResponse<SimpraCrudCheckResponse> {
                Data = null,
                Success = false,
                Message = e.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<SimpraChecksResponse>> GetChecksAsync(
        int page = 1, 
        int perPage = 50, 
        string? businessDate = null,
        string? businessDateSince = null,
        string? businessDateUntil = null,
        string? status = null,
        string? sortBy = "desc",
        long? updatedAt = null,
        long? closedAtSince = null,
        long? closedAtUntil = null,
        string? revenueCenterId = null,
        string? tableId = null)
    {
        try
        {
            var queryParams = new Dictionary<string, string>
            {
                ["page"] = page.ToString(),
                ["per_page"] = perPage.ToString()
            };

            if (!string.IsNullOrEmpty(businessDate))
                queryParams["business_date"] = businessDate;
                
            if (!string.IsNullOrEmpty(businessDateSince))
                queryParams["business_date_since"] = businessDateSince;
                
            if (!string.IsNullOrEmpty(businessDateUntil))
                queryParams["business_date_until"] = businessDateUntil;
                
            if (!string.IsNullOrEmpty(status))
                queryParams["status"] = status;
                
            if (!string.IsNullOrEmpty(sortBy))
                queryParams["sort_by"] = sortBy;
                
            if (updatedAt.HasValue && updatedAt.Value > 0)
                queryParams["updated_at"] = updatedAt.Value.ToString();
                
            if (closedAtSince.HasValue && closedAtSince.Value > 0)
                queryParams["closed_at_since"] = closedAtSince.Value.ToString();
                
            if (closedAtUntil.HasValue && closedAtUntil.Value > 0)
                queryParams["closed_at_until"] = closedAtUntil.Value.ToString();
                
            if (!string.IsNullOrEmpty(revenueCenterId))
                queryParams["revenue_center_id"] = revenueCenterId;
                
            if (!string.IsNullOrEmpty(tableId))
                queryParams["table_id"] = tableId;

            var queryString = string.Join("&", queryParams.Select(kvp => $"{kvp.Key}={Uri.EscapeDataString(kvp.Value)}"));
            var endpoint = $"checks?{queryString}";

            var response = await SendRequestAsync<SimpraChecksResponse>(endpoint, HttpMethod.Get);
            
            return new SimpraBaseResponse<SimpraChecksResponse>
            {
                Data = response,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get checks from Simpra");
            return new SimpraBaseResponse<SimpraChecksResponse>
            {
                Data = null,
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<SimpraCheckResponse>> GetCheckAsync(int checkId)
    {
        try
        {
            var check=  await SendRequestAsync<SimpraCheckResponse>(
                $"checks/{checkId}", HttpMethod.Get);
            return new SimpraBaseResponse<SimpraCheckResponse>
            {
                Data = check,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get checks from Simpra");
            return new SimpraBaseResponse<SimpraCheckResponse>
            {
                Data = null,
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<object?>?> CreateCheckPaymentAsync(string checkId, SimpraCheckPaymentRequest? request)
    {
        return await SendRequestAsync<SimpraBaseResponse<object?>>(
            $"apps/api/v1/checks/{checkId}/check_payments", HttpMethod.Post, request);
    }

    public async Task<SimpraBaseResponse<object>> UpdateDeliveryStatusAsync(int checkId, SimpraDeliveryStatusRequest request)
    {
        return await SendRequestAsync<SimpraBaseResponse<object>>(
            $"apps/api/v1/checks/{checkId}/change_delivery_status", HttpMethod.Post, request);
    }

    public async Task<SimpraBaseResponse<object>> CancelCheckItemAsync(int checkId, int checkItemId, SimpraCheckItemCancelRequest request)
    {
        return await SendRequestAsync<SimpraBaseResponse<object>>(
            $"apps/api/v1/checks/{checkId}/check_items/{checkItemId}/cancel", HttpMethod.Post, request);
    }

    public async Task<SimpraBaseResponse<List<SimpraPaymentType>>> GetPaymentTypesAsync()
    {
        try
        {
            var response = await SendRequestAsync<SimpraPaymentTypesResponse>("payment_types", HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraPaymentType>>
            {
                Data = response.PaymentTypes,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get payment types");
            return new SimpraBaseResponse<List<SimpraPaymentType>>
            {
                Data = new List<SimpraPaymentType>(),
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<List<SimpraCondimentGroup>>> GetCondimentGroupsAsync()
    {
        try
        {
            var response = await SendRequestAsync<SimpraCondimentGroupsResponse>("condiment_groups", HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraCondimentGroup>>
            {
                Data = response.CondimentGroups,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get condiment groups");
            return new SimpraBaseResponse<List<SimpraCondimentGroup>>
            {
                Data = new List<SimpraCondimentGroup>(),
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<bool> TestConnectionAsync()
    {
        try
        {
            var response = await GetMenuItemGroupsAsync();
            return response.Success;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to test Simpra API connection");
            return false;
        }
    }

    public async Task<SimpraBaseResponse<List<SimpraRevenueCenter>>> GetRevenueCentersAsync()
    {
        try
        {
            var response = await SendRequestAsync<SimpraRevenueCentersResponse>("revenue_centers", HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraRevenueCenter>>
            {
                Data = response.RevenueCenters,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get revenue centers");
            return new SimpraBaseResponse<List<SimpraRevenueCenter>>
            {
                Data = new List<SimpraRevenueCenter>(),
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<List<SimpraSalesChannel>>> GetSalesChannelsAsync()
    {
        try
        {
            var response = await SendRequestAsync<SimpraSalesChannelsResponse>("sales_channels", HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraSalesChannel>>
            {
                Data = response.SalesChannels,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get sales channels");
            return new SimpraBaseResponse<List<SimpraSalesChannel>>
            {
                Data = new List<SimpraSalesChannel>(),
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<List<SimpraEmployee>>> GetEmployeesAsync()
    {
        try
        {
            var response = await SendRequestAsync<SimpraEmployeesResponse>("employees", HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraEmployee>>
            {
                Data = response.Employees,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get employees");
            return new SimpraBaseResponse<List<SimpraEmployee>>
            {
                Data = new List<SimpraEmployee>(),
                Success = false,
                Message = ex.Message
            };
        }
    }

    public async Task<SimpraBaseResponse<List<SimpraItemDefinition>>> GetItemDefinitionsAsync(
        int page = 1,
        int perPage = 50,
        long updatedAt = 0,
        string? status = null,
        string? sourceType = null,
        string? sourceId = null,
        string? targetId = null,
        string? propertyIds = null)
    {
        try
        {
            var queryParams = new List<string>();
            
            queryParams.Add($"page={page}");
            queryParams.Add($"per_page={perPage}");
            queryParams.Add($"updated_at={updatedAt}");
            
            if (!string.IsNullOrEmpty(status))
                queryParams.Add($"status={status}");
            
            if (!string.IsNullOrEmpty(sourceType))
                queryParams.Add($"source_type={sourceType}");
            
            if (!string.IsNullOrEmpty(sourceId))
                queryParams.Add($"source_id={sourceId}");
            
            if (!string.IsNullOrEmpty(targetId))
                queryParams.Add($"target_id={targetId}");
            
            if (!string.IsNullOrEmpty(propertyIds))
                queryParams.Add($"property_ids={propertyIds}");
            
            var endpoint = "item_definitions";
            if (queryParams.Any())
            {
                endpoint += "?" + string.Join("&", queryParams);
            }
            
            var response = await SendRequestAsync<SimpraItemDefinitionsResponse>(endpoint, HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraItemDefinition>>
            {
                Data = response.ItemDefinitions,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get item definitions");
            return new SimpraBaseResponse<List<SimpraItemDefinition>>
            {
                Data = new List<SimpraItemDefinition>(),
                Success = false,
                Message = ex.Message
            };
        }
    }

    /// <summary>
    /// Gets tax categories from Simpra
    /// </summary>
    public async Task<SimpraBaseResponse<List<SimpraTax>>> GetTaxesAsync()
    {
        try
        {
            var response = await SendRequestAsync<SimpraTaxesResponse>("taxes", HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraTax>>
            {
                Data = response.Taxes,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get taxes");
            return new SimpraBaseResponse<List<SimpraTax>>
            {
                Data = new List<SimpraTax>(),
                Success = false,
                Message = ex.Message
            };
        }
    }
    
    /// <summary>
    /// Gets condiments from Simpra
    /// </summary>
    public async Task<SimpraBaseResponse<List<SimpraCondiment>>> GetCondimentsAsync(
        int page = 1,
        int perPage = 50,
        string? status = null,
        long updatedAt = 0)
    {
        try
        {
            var queryParams = new List<string>();
            
            queryParams.Add($"page={page}");
            queryParams.Add($"per_page={perPage}");
            queryParams.Add($"updated_at={updatedAt}");
            
            if (!string.IsNullOrEmpty(status))
                queryParams.Add($"status={status}");
            
            var endpoint = "condiments";
            if (queryParams.Any())
            {
                endpoint += "?" + string.Join("&", queryParams);
            }
            
            var response = await SendRequestAsync<SimpraCondimentsResponse>(endpoint, HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraCondiment>>
            {
                Data = response.Condiments,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get condiments");
            return new SimpraBaseResponse<List<SimpraCondiment>>
            {
                Data = new List<SimpraCondiment>(),
                Success = false,
                Message = ex.Message
            };
        }
    }
    
    /// <summary>
    /// Gets service charges from Simpra
    /// </summary>
    public async Task<SimpraBaseResponse<List<SimpraServiceCharge>>> GetServiceChargesAsync()
    {
        try
        {
            var response = await SendRequestAsync<SimpraServiceChargesResponse>("service_charges", HttpMethod.Get);
            return new SimpraBaseResponse<List<SimpraServiceCharge>>
            {
                Data = response.ServiceCharges,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to get service charges");
            return new SimpraBaseResponse<List<SimpraServiceCharge>>
            {
                Data = new List<SimpraServiceCharge>(),
                Success = false,
                Message = ex.Message
            };
        }
    }
    
    /// <summary>
    /// Creates a service charge on a check
    /// </summary>
    public async Task<SimpraBaseResponse<SimpraCheckServiceChargeResponse>> CreateCheckServiceChargeAsync(string checkId, SimpraCheckServiceChargeRequest request)
    {
        try
        {
            var endpoint = $"apps/api/v1/checks/{checkId}/check_service_charges";
            var response = await SendRequestAsync<SimpraCheckServiceChargeResponse>(endpoint, HttpMethod.Post, request);
            return new SimpraBaseResponse<SimpraCheckServiceChargeResponse>
            {
                Data = response,
                Success = true,
                Message = null
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to create check service charge for check {CheckId}", checkId);
            return new SimpraBaseResponse<SimpraCheckServiceChargeResponse>
            {
                Data = null,
                Success = false,
                Message = ex.Message
            };
        }
    }
}