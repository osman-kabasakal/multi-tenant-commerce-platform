using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Core.Models.Configs;
using Microsoft.IdentityModel.Tokens;
using SaasManager.Application.Common.Interfaces.Security;

namespace SaasManager.Infrastructure.Security;

public class SecurityService : ISecurityService
{
    private readonly GuestAuthConfiguration _guestAuthConfiguration;
    private readonly RandomNumberGenerator _rng;

    public SecurityService(
        GuestAuthConfiguration guestAuthConfiguration
        )
    {
        _guestAuthConfiguration = guestAuthConfiguration;
        _rng = RandomNumberGenerator.Create();
    }

    public string GenerateVerificationCode()
    {
        var bytes = new byte[4];
        _rng.GetBytes(bytes);
        var code = BitConverter.ToUInt32(bytes, 0) % 1000000;
        return code.ToString("D6");
    }

    public string GenerateTempToken()
    {
        var bytes = new byte[24]; // 24 byte, Base64'e çevrildiğinde 32 karakter oluşturur
        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(bytes);
        }
    
        return Convert.ToBase64String(bytes)
            .Replace("/", "_")
            .Replace("+", "-")
            .Replace("=", "");
    }

    public string HashString(string input)
    {
        if (string.IsNullOrEmpty(input))
            throw new ArgumentNullException(nameof(input));

        using var sha256 = SHA256.Create();
        var bytes = Encoding.UTF8.GetBytes(input);
        var hash = sha256.ComputeHash(bytes);
        return Convert.ToBase64String(hash);
    }

    public bool ValidateHash(string input, string hash)
    {
        if (string.IsNullOrEmpty(input) || string.IsNullOrEmpty(hash))
            return false;

        var inputHash = HashString(input);
        return inputHash.Equals(hash, StringComparison.OrdinalIgnoreCase);
    }

    public string GenerateRandomString(int length, bool useSpecialChars = false)
    {
        if (length <= 0)
            throw new ArgumentException("Length must be positive", nameof(length));

        const string letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const string numbers = "0123456789";
        const string special = "!@#$%^&*()_+-=[]{}|;:,.<>?";

        var chars = letters + numbers;
        if (useSpecialChars)
            chars += special;

        var bytes = new byte[length * 4];
        _rng.GetBytes(bytes);

        var result = new char[length];
        for (int i = 0; i < length; i++)
        {
            var randomInt = BitConverter.ToUInt32(bytes, i * 4);
            result[i] = chars[(int)(randomInt % chars.Length)];
        }

        return new string(result);
    }

    public string GenerateValidationToken(DateTime validTo)
    {
        return GenerateGuestToken(_guestAuthConfiguration, Guid.NewGuid(), validTo);
    }
    
    public bool ValidateValidationToken(string token)
    {
        try
        {
            ValidateGuestToken(_guestAuthConfiguration, token);
        }
        catch (Exception)
        {
            return false;
        }

        return true;
    }

    public string GenerateGuestToken(GuestAuthConfiguration authConfiguration, Guid guestId, DateTime? validTo=null)
    {
        // JWT için security key
        var securityKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(authConfiguration.SecurityKey!));
        
        var credentials = new SigningCredentials(
            securityKey, 
            SecurityAlgorithms.HmacSha256);

        // Token claims
        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, guestId.ToString()),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim("type", "guest"),
            new Claim(JwtRegisteredClaimNames.Iat, 
                DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString())
        };

        // Token oluştur
        var token = new JwtSecurityToken(
            issuer: authConfiguration.Issuer,
            audience: authConfiguration.Audience,
            claims: claims,
            expires: validTo??DateTime.UtcNow.AddDays(authConfiguration.TokenExpirationInDays), // Guest token 7 gün geçerli
            signingCredentials: credentials);

        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);
        return tokenString;
    }

    public ClaimsPrincipal ValidateGuestToken(GuestAuthConfiguration authConfiguration, string token)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var securityKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(authConfiguration.SecurityKey!));

        // Token'ı doğrula
        var validationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = authConfiguration.Issuer,
            ValidAudience = authConfiguration.Audience,
            IssuerSigningKey = securityKey,
            ClockSkew = TimeSpan.Zero,
            
        };

        var principal = tokenHandler.ValidateToken(
            token, 
            validationParameters, 
            out var validatedToken);

        return principal;
    }
}
