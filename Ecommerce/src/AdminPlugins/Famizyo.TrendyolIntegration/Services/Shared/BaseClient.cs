using Famizyo.TrendyolIntegration.Settings;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text.Json;

namespace Famizyo.TrendyolIntegration.Services.Shared;

public abstract class BaseClient<T>: IBaseClient
where T: class,new()
{
    private readonly TrendyolIntegrationSettings _settings;
        private readonly HttpClient _client;

        protected BaseClient(
            TrendyolIntegrationSettings settings
        )
        {
            _settings = settings;
            
            if (string.IsNullOrEmpty(settings.ApiKey) ||
                string.IsNullOrEmpty(settings.ApiSecret) ||
                string.IsNullOrEmpty(settings.SaticiId))
            {
                IsReady = false;
            }
            else
            {
                IsReady = true;
                RequestClient = new HttpClient();
            }

            _client = new HttpClient();
        }

        public HttpRequestMessage RequestMessage { get; set; }

        public HttpClient RequestClient { get; set; }

        public bool IsReady { get; set; }

        public string BaseUrl => "https://api.tgoapis.com/integrator/";

        public abstract string Url { get; }

        public abstract HttpMethod Method { get; }

        public abstract Dictionary<string, object> QueryData { get; set; }

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

            var authString = $"{_settings.ApiKey}:{_settings.ApiSecret}";
            var str = System.Text.Encoding.UTF8.GetBytes(authString);
            var basicValue = Convert.ToBase64String(str);
            var val = Convert.FromBase64String(basicValue);

            request.Headers.Authorization = new AuthenticationHeaderValue("Basic", basicValue);

            request.Headers.Add("User-Agent", $"{_settings.SaticiId} - SelfIntegration");
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