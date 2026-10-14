using Microsoft.Extensions.Configuration;
using System.Text;
using System.Text.Json;

namespace Grand.Installer.Cli.Services.CaludeAi;

public class ClaudeAIService : IClaudeAIService
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IConfiguration _configuration;
        
    public ClaudeAIService(IHttpClientFactory httpClientFactory, IConfiguration configuration)
    {
        _httpClientFactory = httpClientFactory;
        _configuration = configuration;
    }
        
    public async Task<string> GetCompletionAsync(string prompt)
    {
        // var claudePrompt = await GetClaudePrompt(prompt);
        var apiKey = _configuration["ClaudeAI:ApiKey"];
        var apiUrl = "https://api.anthropic.com/v1/messages";
            
        var httpClient = new HttpClient(new SocketsHttpHandler
        {
            PooledConnectionLifetime = TimeSpan.FromMinutes(15),
            PooledConnectionIdleTimeout = TimeSpan.FromMinutes(15),
        });
        httpClient.DefaultRequestHeaders.Add("x-api-key", apiKey);
        httpClient.DefaultRequestHeaders.Add("anthropic-version", "2023-06-01");
        httpClient.Timeout = TimeSpan.FromSeconds(120);
            
        var requestData = new
        {
            model = "claude-3-7-sonnet-20250219",
            max_tokens = 4000,
            messages = new[]
            {
                new { role = "user", content = prompt }
            }
        };
        var requestString = JsonSerializer.Serialize(requestData);
        var content = new StringContent(
            requestString,
            Encoding.UTF8,
            "application/json");
            
        try
        {
            var response = await httpClient.PostAsync(apiUrl, content);
            response.EnsureSuccessStatusCode();
                
            var responseBody = await response.Content.ReadAsStringAsync();
            var responseObject = JsonSerializer.Deserialize<ClaudeAIResponse>(responseBody);
                
            return responseObject.content[0].text;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Claude AI API ile iletişim hatası: {ex.Message}");
            throw;
        }
    }
    
    public async Task<string> GetClaudePrompt(string prompt)
    {
        var apiKey = _configuration["ClaudeAI:ApiKey"];
        var apiUrl = "https://api.anthropic.com/v1/experimental/generate_prompt";
            
        var httpClient = new HttpClient(new SocketsHttpHandler
        {
            PooledConnectionLifetime = TimeSpan.FromMinutes(15),
            PooledConnectionIdleTimeout = TimeSpan.FromMinutes(15),
        });
        httpClient.DefaultRequestHeaders.Add("x-api-key", apiKey);
        httpClient.DefaultRequestHeaders.Add("anthropic-version", "2023-06-01");
        httpClient.DefaultRequestHeaders.Add("anthropic-beta","prompt-tools-2025-04-02");
        httpClient.Timeout = TimeSpan.FromSeconds(120);
            
        var requestData = new
        {
            target_model = "claude-3-7-sonnet-20250219",
            task=prompt,
        };
        var requestString = JsonSerializer.Serialize(requestData);
        var content = new StringContent(
            requestString,
            Encoding.UTF8,
            "application/json");
            
        try
        {
            var response = await httpClient.PostAsync(apiUrl, content);
            response.EnsureSuccessStatusCode();
                
            var responseBody = await response.Content.ReadAsStringAsync();
            var responseObject = JsonSerializer.Deserialize<ClaudeAIResponse>(responseBody);
                
            return responseObject.content[0].text;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Claude AI API ile iletişim hatası: {ex.Message}");
            throw;
        }
    }
        
    private class ClaudeAIResponse
    {
        public Content[] content { get; set; }
            
        public class Content
        {
            public string type { get; set; }
            public string text { get; set; }
        }
    }
}