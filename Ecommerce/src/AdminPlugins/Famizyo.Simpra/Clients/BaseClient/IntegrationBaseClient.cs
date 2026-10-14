using Famizyo.Simpra.Settings;
using System.Diagnostics;
using System.Net.Http;
using System.Text.Json;

namespace Famizyo.Simpra.Clients.BaseClient;

public abstract class IntegrationBaseClient<T> : IIntegrationClient
    where T:class,new()
{
    private readonly SimpraSettings _settings;

    public HttpClient RequestClient { get; set; }

    public bool IsReady { get; set; }
    
    public string BaseUrl => _settings.SimpraEnvironment switch
    {
        SimpraEnvironment.Production => "https://api.simpra.app/",
        SimpraEnvironment.Uat => "https://api-uat.simpra.app/",
        SimpraEnvironment.Qa => "https://api-qa.simpra.app/",
        _ => throw new ArgumentOutOfRangeException(nameof(SimpraSettings.SimpraEnvironment), "Invalid environment setting")
    };
    
    public abstract string Url { get; }
    
    public abstract HttpMethod Method { get; }
    
    public abstract Dictionary<string, object> QueryData { get; set; }

    public IntegrationBaseClient(
        IHttpClientFactory httpClientFactory,
        SimpraSettings settings
        )
    {
        RequestClient = httpClientFactory.CreateClient();
        _settings = settings;
        SetIsReady();
    }

    private void SetIsReady()
    {
        IsReady = !string.IsNullOrEmpty(_settings.AccessToken);
    }
    
    public virtual void SetQueryData(Dictionary<string, object> queryData)
        {
            QueryData = queryData;
        }

        public virtual string ToStringQueryData()
        {
            if (QueryData is null)
                return string.Empty;
            var keys = QueryData.Keys.ToList();
            var rt = keys.Count
                     > 0
                ? "?"
                : "";
            foreach (var key in keys)
            {
                
                rt += $"{key}={QueryData[key]}"+ (keys.IndexOf(key) == keys.Count - 1 ? "" : "&");
            }

            return rt;
        }

        protected HttpRequestMessage GetRequest()
        {
            var request = new HttpRequestMessage(Method,
                $"{BaseUrl}{Url}" + ToStringQueryData());

            request.Headers.Add(SimpraDefaults.SimpraApiAuthHeaderKeyName, $"{_settings.AccessToken}");
            return request;
        }
        
        public virtual async Task<T?> Process(Dictionary<string, object> queryData)
        {
            T? rt;
            if (IsReady)
            {
                if (queryData != null)  SetQueryData(queryData);
                var message=GetRequest();
                var response = await RequestClient.SendAsync(message);
                if (response.IsSuccessStatusCode)
                {
                    await using var responseStream = await response.Content.ReadAsStreamAsync();
                    rt =  await JsonSerializer.DeserializeAsync<T>(responseStream);
                }
                else
                {
                    rt = new T();
                    Console.WriteLine($"Trendyol ürün filtreleme hatası. \n{(new Exception(await response.Content.ReadAsStringAsync().ConfigureAwait(false)))}");
                }
            }
            else
            {
                rt = new T();
            }
            return rt;
        }
}