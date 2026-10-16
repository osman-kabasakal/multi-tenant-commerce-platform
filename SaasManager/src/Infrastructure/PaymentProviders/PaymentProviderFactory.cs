using System.Text.Json;
using Core.Models.Configs;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using SaasManager.Domain.Entities.Financial;

namespace SaasManager.Infrastructure.PaymentProviders;

public class PaymentProviderFactory : IPaymentProviderFactory
{
    private readonly IApplicationDbContext _context;
    private readonly IDictionary<string, IPaymentProvider> _providers;
    private readonly ILogger<PaymentProviderFactory> _logger;
    private readonly IyzicoConfiguration _iyzicoConf;

    public PaymentProviderFactory(
        IApplicationDbContext context,
        IOptions<IyzicoConfiguration> defaultPaymentProviderOptions,
        IEnumerable<IPaymentProvider> providers,
        ILogger<PaymentProviderFactory> logger)
    {
        _context = context;
        _logger = logger;
        _providers = providers.ToDictionary(p => p.Code, p => p);
        _iyzicoConf = defaultPaymentProviderOptions.Value;
    }

    public IPaymentProvider GetProvider(string providerCode)
    {
        if (string.IsNullOrEmpty(providerCode))
            throw new ArgumentNullException(nameof(providerCode));

        if (!_providers.TryGetValue(providerCode, out var provider))
        {
            _logger.LogError("Payment provider not found: {ProviderCode}", providerCode);
            throw new InvalidOperationException($"Payment provider not found: {providerCode}");
        }

        if (!provider.IsActive)
        {
            _logger.LogError("Payment provider is not active: {ProviderCode}", providerCode);
            throw new InvalidOperationException($"Payment provider is not active: {providerCode}");
        }

        return provider;
    }

    public IPaymentProvider GetDefaultProvider()
    {
        if (string.IsNullOrWhiteSpace(_iyzicoConf.ApiKey) || string.IsNullOrWhiteSpace(_iyzicoConf.SecretKey))
            throw new InvalidOperationException("Configure the selected payment merchant before paid enrollment.");
        Guid? selectedId = null;
        if (!string.IsNullOrEmpty(_iyzicoConf.ProviderId))
            selectedId = Guid.TryParse(_iyzicoConf.ProviderId, out var id) && id != Guid.Empty
                ? id : throw new InvalidOperationException("The configured payment provider id is invalid.");
        var defaultProvider = _context.PaymentProviders.FirstOrDefault(p => p.IsActive && !p.IsDeleted &&
            (selectedId == null ? p.Code == "IYZICO" : p.Id == selectedId.Value));
        if (defaultProvider == null)
        {
            if (selectedId != null) throw new InvalidOperationException("The configured payment provider is unavailable.");
            var provider = GetProvider("IYZICO");
            // Merchant secrets live in private runtime configuration, never another plaintext database copy.
            defaultProvider = new PaymentProvider(provider.Name, provider.Code, provider.Type,
                JsonDocument.Parse("{\"credentialSource\":\"runtime-configuration\"}"), string.Empty, string.Empty,
                _iyzicoConf.IsSandbox ? "https://sandbox-api.iyzipay.com" : "https://api.iyzipay.com", _iyzicoConf.IsSandbox,
                0m, 0m, ["TRY"], 30);
            _context.PaymentProviders.Add(defaultProvider);
            _context.SaveChangesAsync(default).GetAwaiter().GetResult();
        }

        return GetProvider(defaultProvider.Code);
    }

    public IEnumerable<IPaymentProvider> GetAllProviders()
    {
        return _providers.Values.Where(p => p.IsActive);
    }
}
