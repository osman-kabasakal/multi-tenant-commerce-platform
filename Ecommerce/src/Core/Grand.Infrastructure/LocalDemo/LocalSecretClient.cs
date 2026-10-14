using Azure;
using Azure.Core;
using Azure.Security.KeyVault.Secrets;
using Microsoft.Extensions.Configuration;
using System.Security.Cryptography;
using System.Text.RegularExpressions;

namespace Grand.Infrastructure.LocalDemo;

/// <summary>File-backed vault adapter for the explicitly enabled local demo only.</summary>
public sealed class LocalSecretClient : SecretClient
{
    private readonly string _directory;
    private readonly IConfiguration _configuration;
    public LocalSecretClient(IConfiguration configuration)
    {
        _configuration = configuration;
        _directory = configuration["LocalDemo:SecretsPath"]
            ?? throw new InvalidOperationException("LocalDemo:SecretsPath is required.");
        Directory.CreateDirectory(_directory);
    }

    public override Response<KeyVaultSecret> GetSecret(string name, string version = null,
        CancellationToken cancellationToken = default)
    {
        if (!Regex.IsMatch(name, "^[a-zA-Z0-9-]{1,127}$"))
            throw new ArgumentException("Invalid local secret name.", nameof(name));
        var value = name switch
        {
            "applicationdb" or "defaultdb" => _configuration["Database:ConnectionString"],
            "redispublisher" => _configuration["Redis:RedisPubSubConnectionString"],
            _ => null
        };
        if (value == null)
        {
            var path = Path.Combine(_directory, name);
            value = System.Text.Encoding.UTF8.GetString(LocalSecretFile.GetOrCreate(path,
                () => System.Text.Encoding.UTF8.GetBytes(Convert.ToHexString(RandomNumberGenerator.GetBytes(32)))));
        }
        return Response.FromValue(new KeyVaultSecret(name, value), new LocalResponse());
    }

    public override Task<Response<KeyVaultSecret>> GetSecretAsync(string name, string version = null,
        CancellationToken cancellationToken = default) => Task.FromResult(GetSecret(name, version, cancellationToken));

    private sealed class LocalResponse : Response
    {
        public override int Status => 200;
        public override string ReasonPhrase => "Local demo";
        public override Stream ContentStream { get; set; }
        public override string ClientRequestId { get; set; } = "local-demo";
        public override void Dispose() { }
        protected override bool ContainsHeader(string name) => false;
        protected override IEnumerable<HttpHeader> EnumerateHeaders() => Array.Empty<HttpHeader>();
        protected override bool TryGetHeader(string name, out string value) { value = null; return false; }
        protected override bool TryGetHeaderValues(string name, out IEnumerable<string> values) { values = null; return false; }
    }
}
