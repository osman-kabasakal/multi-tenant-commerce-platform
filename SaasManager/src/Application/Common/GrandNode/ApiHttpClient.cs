using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

namespace SaasManager.Application.Common.GrandNode;

public class AuthTokens
    {
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
        public DateTime ExpiresAt { get; set; }
        public string BearerToken { get; set; }
        public string BearerRefreshToken { get; set; }
        public DateTime BearerExpiresAt { get; set; }
        public string CsrfToken { get; set; }
        public bool IsGuest { get; set; }
    }

    public class ApiHttpClient
    {
        private readonly HttpClient _httpClient;
        private readonly string _apiBaseUrl;
        private readonly string _keyCloakAuthUrl;
        private readonly string _authRealm;
        private AuthTokens _currentTokens;
        private readonly string _authClientId;
        private readonly string _clientSecret;
        private readonly string _username;
        private readonly string _password;
        
        public ApiHttpClient(string apiBaseUrl,
            string keyCloakAuthUrl,
            string authRealm, string authClientId, string clientSecret, string username, string password)
        {
            _httpClient = new HttpClient();
            _apiBaseUrl = apiBaseUrl;
            _keyCloakAuthUrl = keyCloakAuthUrl;
            _authRealm = authRealm;
            _authClientId = authClientId;
            _clientSecret = clientSecret;
            _username = username;
            _password = password;
        }

        public async Task<AuthTokens> Login()
        {
            try
            {
                // Get Keycloak client token
                var keycloakClientToken = await GetClientToken();

                // Get antiforgery token
                var requestAntiforgery = new HttpRequestMessage(HttpMethod.Get, $"{_apiBaseUrl}/tokenweb/Antiforgery");
                requestAntiforgery.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                requestAntiforgery.Headers.Add("x-store-token", keycloakClientToken.AccessToken);
                requestAntiforgery.Headers.Add("X-Response-View", "Json");

                var responseAntiforgery = await _httpClient.SendAsync(requestAntiforgery);
                responseAntiforgery.EnsureSuccessStatusCode();
                var antiforgeryToken = await responseAntiforgery.Content.ReadAsStringAsync();

                // Get grand token
                var loginData = new
                {
                    Email = _username,
                    Password = Convert.ToBase64String(Encoding.UTF8.GetBytes(_password))
                };

                var jsonLoginData = JsonSerializer.Serialize(loginData);
                var requestGrandToken = new HttpRequestMessage(HttpMethod.Post, $"{_apiBaseUrl}/token/login");
                requestGrandToken.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                requestGrandToken.Headers.Add("x-store-token", keycloakClientToken.AccessToken);
                requestGrandToken.Headers.Add("X-CSRF-TOKEN", antiforgeryToken);
                requestGrandToken.Headers.Add("X-Response-View", "Json");
                requestGrandToken.Content = new StringContent(jsonLoginData, Encoding.UTF8, "application/json");

                var responseGrandToken = await _httpClient.SendAsync(requestGrandToken);
                responseGrandToken.EnsureSuccessStatusCode();
                var grandTokenContent = await responseGrandToken.Content.ReadAsStringAsync();

               // Create auth tokens
                var expiresAt = DateTime.Now.AddMinutes(1440);

                var tokens = new AuthTokens
                {
                    AccessToken = keycloakClientToken.AccessToken,
                    RefreshToken = keycloakClientToken.RefreshToken,
                    ExpiresAt = keycloakClientToken.ExpiresAt,
                    BearerToken = grandTokenContent,
                    BearerRefreshToken = "",
                    BearerExpiresAt = expiresAt,
                    CsrfToken = antiforgeryToken,
                    IsGuest = false
                };

                _currentTokens = tokens;
                SetupRefreshTimer();

                return tokens;
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Login error: {ex.Message}");
                Console.Error.WriteLine(ex.StackTrace);
            }

            return null;
        }

        private async Task<dynamic> GetClientToken()
        {
            // Implement the client token acquisition logic here
            // This is a placeholder - you need to implement the actual Keycloak authentication
            
            var tokenEndpoint = $"{_keyCloakAuthUrl}/realms/{_authRealm}/protocol/openid-connect/token";
            var content = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_id", _authClientId),
                new KeyValuePair<string, string>("client_secret", _clientSecret)
            });

            var response = await _httpClient.PostAsync(tokenEndpoint, content);
            response.EnsureSuccessStatusCode();
            var responseContent = await response.Content.ReadAsStringAsync();
            var tokenResponse = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(responseContent);

            return new
            {
                AccessToken = tokenResponse["access_token"].GetString(),
                ExpiresAt = DateTime.Now.AddSeconds(Convert.ToDouble(tokenResponse["expires_in"].GetInt32()))
            };
        }

        private void SetupRefreshTimer()
        {
            // Setup a timer to refresh the token before it expires
            // This is a placeholder - implement the actual refresh logic
            // You might want to use a Timer or background Task
        }

        private async Task RefreshTokens()
        {
            var loginData = new
            {
                Email = _username,
                Password = Convert.ToBase64String(Encoding.UTF8.GetBytes(_password))
            };
            var jsonLoginData = JsonSerializer.Serialize(loginData);
            var requestGrandToken = new HttpRequestMessage(HttpMethod.Post, $"{_apiBaseUrl}/token/login");
            requestGrandToken.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            requestGrandToken.Headers.Add("x-store-token", _currentTokens.AccessToken);
            requestGrandToken.Headers.Add("X-CSRF-TOKEN", _currentTokens.CsrfToken);
            requestGrandToken.Headers.Add("X-Response-View", "Json");
            requestGrandToken.Content = new StringContent(jsonLoginData, Encoding.UTF8, "application/json");

            var responseGrandToken = await _httpClient.SendAsync(requestGrandToken);
            responseGrandToken.EnsureSuccessStatusCode();
            var grandTokenContent = await responseGrandToken.Content.ReadAsStringAsync();
            _currentTokens.BearerToken = grandTokenContent;
        }

        private async Task EnsureAuthenticated()
        {
            if (_currentTokens == null)
            {
                await Login();
                return;
            }

            if (DateTime.Now >= _currentTokens.ExpiresAt.AddMinutes(-5))
            {
                await RefreshTokens();
            }
        }

        // Generic HTTP request method
        private async Task<T> SendRequestAsync<T>(HttpMethod method, string endpoint, object data = null)
        {
            await EnsureAuthenticated();

            var requestUrl = $"{_apiBaseUrl}/{endpoint.TrimStart('/')}";
            var request = new HttpRequestMessage(method, requestUrl);

            // Add headers
            request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            request.Headers.Add("x-store-token", _currentTokens.AccessToken);
            request.Headers.Add("X-CSRF-TOKEN", _currentTokens.CsrfToken);
            request.Headers.Add("Authorization", $"Bearer {_currentTokens.BearerToken}");
            request.Headers.Add("X-Response-View", "Json");

            // Add content for POST, PUT methods
            if (data != null && (method == HttpMethod.Post || method == HttpMethod.Put))
            {
                var jsonData = JsonSerializer.Serialize(data);
                request.Content = new StringContent(jsonData, Encoding.UTF8, "application/json");
            }

            // Send request
            var response = await _httpClient.SendAsync(request);
            response.EnsureSuccessStatusCode();

            // Parse response
            var responseContent = await response.Content.ReadAsStringAsync();
            if (string.IsNullOrEmpty(responseContent))
            {
                return default;
            }

            return JsonSerializer.Deserialize<T>(responseContent);
        }

        // Generic GET method
        public async Task<T> GetAsync<T>(string endpoint)
        {
            return await SendRequestAsync<T>(HttpMethod.Get, endpoint);
        }

        // Generic POST method
        public async Task<T> PostAsync<T>(string endpoint, object data)
        {
            return await SendRequestAsync<T>(HttpMethod.Post, endpoint, data);
        }

        // Generic PUT method
        public async Task<T> PutAsync<T>(string endpoint, object data)
        {
            return await SendRequestAsync<T>(HttpMethod.Put, endpoint, data);
        }

        // Generic DELETE method
        public async Task<T> DeleteAsync<T>(string endpoint)
        {
            return await SendRequestAsync<T>(HttpMethod.Delete, endpoint);
        }
    }
