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
        // Varsayılan provider'ı veritabanından al
        var defaultProvider = _context.PaymentProviders
            .FirstOrDefault(p => p.IsActive);

        if (defaultProvider == null)
        {
            _logger.LogError("No default payment provider configured");
            var defaultP=_providers.First();
            var paymentProvider = new PaymentProvider(
                defaultP.Value.Name,
                defaultP.Key,
                defaultP.Value.Type,
                JsonDocument.Parse(JsonSerializer.Serialize(_iyzicoConf)),
                apiKey: _iyzicoConf.ApiKey,
                apiSecret: _iyzicoConf.SecretKey,
                baseUrl: "https://api.iyzipay.com",
                isSandbox: true,
                0m,
                0m,
                ["TRY", "USD"],
                30
            );
            paymentProvider.UpdateHealthStatus(true);
            _context.PaymentProviders.Add(paymentProvider);
            _context.SaveChangesAsync(default).ConfigureAwait(true).GetAwaiter().GetResult();
            throw new InvalidOperationException("No default payment provider configured");
        }

        return GetProvider(defaultProvider.Code);
    }

    public IEnumerable<IPaymentProvider> GetAllProviders()
    {
        return _providers.Values.Where(p => p.IsActive);
    }
}
