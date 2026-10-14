using Microsoft.Extensions.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace Grand.Data.Uploader.mongo;

public class DigestAuthenticationHandler: IMongoDigestAuthenticationHandler
{
    private readonly string _username;
    private readonly string _password;
    private readonly IConfiguration _configuration;
    private readonly HttpClient _httpClient;

    public DigestAuthenticationHandler(IHttpClientFactory httpClientFactory,IConfiguration configuration)
    {
        _username = configuration["MongoAtlas:ClientPublicKey"]!;
        _password = configuration["MongoAtlas:ClientSecret"]!;
        _configuration = configuration;
        _httpClient = httpClientFactory.CreateClient("MongoAtlasClient");
    }

    public async Task<HttpResponseMessage> SendRequestAsync(HttpRequestMessage request)
    {
        // İlk isteği gönder - 401 yanıtı ve digest bilgilerini al
        var response = await _httpClient.SendAsync(request);

        if (response.StatusCode != System.Net.HttpStatusCode.Unauthorized)
        {
            return response;
        }

        // WWW-Authenticate header'ını parse et
        var authHeader = response.Headers.WwwAuthenticate.First();
        var digestParams = ParseDigestHeader(authHeader!.Parameter!);

        // Digest parametrelerini hazırla
        var nonce = digestParams["nonce"];
        var realm = digestParams["realm"];
        var qop = digestParams["qop"];
        var nc = "00000001";
        var cnonce = GenerateCnonce();

        // HA1 = MD5(username:realm:password)
        var ha1 = CreateMD5($"{_username}:{realm}:{_password}");

        // HA2 = MD5(method:uri)
        var ha2 = CreateMD5($"{request.Method}:{request.RequestUri!.PathAndQuery}");

        // response = MD5(HA1:nonce:nc:cnonce:qop:HA2)
        var response_digest = CreateMD5($"{ha1}:{nonce}:{nc}:{cnonce}:{qop}:{ha2}");

        // Authorization header'ını oluştur
        var authorizationHeader = $"Digest username=\"{_username}\", " +
            $"realm=\"{realm}\", " +
            $"nonce=\"{nonce}\", " +
            $"uri=\"{request.RequestUri.PathAndQuery}\", " +
            $"algorithm=MD5, " +
            $"qop={qop}, " +
            $"nc={nc}, " +
            $"cnonce=\"{cnonce}\", " +
            $"response=\"{response_digest}\"";

        // Yeni bir istek oluştur
        var newRequest = new HttpRequestMessage(request.Method, request.RequestUri);
        newRequest.Headers.Add("Authorization", authorizationHeader);
        
        // Önceki header'ları kopyala
        foreach (var header in request.Headers)
        {
            newRequest.Headers.Add(header.Key, header.Value);
        }

        // İçeriği kopyala (eğer varsa)
        if (request.Content != null)
        {
            newRequest.Content = request.Content;
        }

        // Yeni isteği gönder
        return await _httpClient.SendAsync(newRequest);
    }

    private Dictionary<string, string> ParseDigestHeader(string header)
    {
        return header.Split(',')
            .Select(part => part.Trim().Split(new[] { '=' }, 2))
            .Where(parts => parts.Length == 2)
            .ToDictionary(
                parts => parts[0].Trim(),
                parts => parts[1].Trim('"', ' ')
            );
    }

    private string GenerateCnonce()
    {
        var random = new byte[16];
        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(random);
        }
        return BitConverter.ToString(random).Replace("-", "").ToLower();
    }

    private string CreateMD5(string input)
    {
        using (var md5 = MD5.Create())
        {
            var inputBytes = Encoding.ASCII.GetBytes(input);
            var hashBytes = md5.ComputeHash(inputBytes);
            return BitConverter.ToString(hashBytes).Replace("-", "").ToLower();
        }
    }
}

public interface IMongoDigestAuthenticationHandler
{
    Task<HttpResponseMessage> SendRequestAsync(HttpRequestMessage request);
}
