using System;
using System.Buffers.Text;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Grand.Infrastructure.Caching;
using Microsoft.Extensions.Configuration;
using StackExchange.Redis;

namespace Grand.Web.ExternalSettings.TenantToken
{
    public class TenantTokenHandler : ITenantTokenHandler
    {
        private readonly IDatabase _redis;
        private readonly string _secretKey;

        public TenantTokenHandler(IDatabase redisConnection, IConfiguration configuration)
        {
            _redis = redisConnection;
            _secretKey = configuration["TenantToken:SecretKey"];
        }

        public async Task<string> CreateTemporaryToken(string tenantId, bool isOtt = true, int expirationMinutes = 15)
        {
            // Generate a unique token
            var randomToken = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));

            // Prepare token data
            var tokenData = new TokenBodyModel(tenantId,
                                               DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() + (expirationMinutes * 60 * 1000),
                                               isOtt);

            // Save to Redis
            var key = $"temp_token:{randomToken}";
            await _redis.StringSetAsync(key, Newtonsoft.Json.JsonConvert.SerializeObject(tokenData), TimeSpan.FromMinutes(expirationMinutes));

            // Sign the token
            var signature = SignToken(randomToken);
            var base64String = Convert.ToBase64String(Encoding.UTF8.GetBytes($"{randomToken}.{signature}"));
            base64String = base64String.TrimEnd('=')
            .Replace('+', '-')
            .Replace('/', '_');
            return base64String;
        }

        public async Task<string> ValidateAndGetTenant(string httpToken)
        {
            if (string.IsNullOrEmpty(httpToken))
            {
                return null;
            }

            var token = httpToken.Replace('_', '/').Replace('-', '+');
            token = token.PadRight(token.Length + (4 - token.Length % 4) % 4, '=');

            if (!Base64.IsValid(token))
            {
                return null;
            }

            var parts = Encoding.UTF8.GetString(Convert.FromBase64String(token)).Split('.');
            if (parts.Length != 2)
            {
                return null;
            }

            var tokenPart = parts[0];
            var signature = parts[1];

            // Verify signature
            if (!VerifySignature(tokenPart, signature))
            {
                return null;
            }

            // Get data from Redis
            var key = $"temp_token:{tokenPart}";
            var data = await _redis.StringGetAsync(key);

            if (string.IsNullOrEmpty(data))
            {
                return null;
            }

            var tokenData = Newtonsoft.Json.JsonConvert.DeserializeObject<TokenBodyModel>(data);

            // Check expiration
            if (tokenData.ExpiresAt < DateTimeOffset.UtcNow.ToUnixTimeMilliseconds())
            {
                await _redis.KeyDeleteAsync(key);
                return null;
            }

            // Delete token after use (one-time use)
            if (tokenData.IsOtt)
                await _redis.KeyDeleteAsync(key);

            return tokenData.Tenant;
        }

        private string SignToken(string token)
        {
            using (var sha256 = SHA256.Create())
            {
                var bytes = Encoding.UTF8.GetBytes(token + _secretKey);
                var hash = sha256.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }

        private bool VerifySignature(string token, string signature)
        {
            var expectedSignature = SignToken(token);
            return expectedSignature == signature;
        }
    }

    internal class TokenBodyModel
    {
        public string Tenant { get; }
        public long ExpiresAt { get; }
        public bool IsOtt { get; }

        public TokenBodyModel(string tenant, long expiresAt, bool isOtt)
        {
            Tenant = tenant;
            ExpiresAt = expiresAt;
            IsOtt = isOtt;
        }

        public override bool Equals(object obj)
        {
            return obj is TokenBodyModel other &&
                   Tenant == other.Tenant &&
                   ExpiresAt == other.ExpiresAt &&
                   IsOtt == other.IsOtt;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(Tenant, ExpiresAt, IsOtt);
        }
    }
}
