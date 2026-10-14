using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Core.Models.Configs;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Financial;

namespace SaasManager.Infrastructure.Data;

public static class InitialiserExtensions
{
    public static async Task InitialiseDatabaseAsync(this WebApplication app)
    {
        using var scope = app.Services.CreateScope();

        var initialiser = scope.ServiceProvider.GetRequiredService<ApplicationDbContextInitialiser>();

        await initialiser.InitialiseAsync();

        await initialiser.SeedAsync();
    }
}

public class ApplicationDbContextInitialiser
{
    private readonly ILogger<ApplicationDbContextInitialiser> _logger;
    private readonly ApplicationDbContext _context;
    private readonly IDateTime _dateTime;
    private readonly IyzicoConfiguration _iyzicoConf;
    private readonly IDictionary<string, IPaymentProvider> _providers;
    private readonly bool _localDemo;

    public ApplicationDbContextInitialiser(ILogger<ApplicationDbContextInitialiser> logger, 
        ApplicationDbContext context,
        IDateTime dateTime,
        IOptions<IyzicoConfiguration> defaultPaymentProviderOptions,
        IEnumerable<IPaymentProvider> providers, IConfiguration configuration)
    {
        _logger = logger;
        _localDemo = configuration.GetValue<bool>("LocalDemo:Enabled");
        _context = context;
        _dateTime = dateTime;
        _iyzicoConf = defaultPaymentProviderOptions.Value;
        _providers = providers.ToDictionary(p => p.Code, p => p);
    }

    public async Task InitialiseAsync()
    {
        try
        {
            await _context.Database.MigrateAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while initialising the database.");
            throw;
        }
    }

    public async Task SeedAsync()
    {
        try
        {
            await TrySeedAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while seeding the database.");
            throw;
        }
    }

    public async Task TrySeedAsync()
    {
        if (_context.SubscriptionPlans.Any())
            return;
        var defaultPlans = new List<SubscriptionPlan>
        {
            new(
                name: "Başlangıç",
                code: "STARTER",
                price: 299m,
                maxProducts: 100,
                maxUsers: 3,
                maxMonthlyOrders: 1000,
                hasPos: false,
                hasCourier: false,
                features: CreateFeaturesDocument(new[]
                {
                    "100 ürün limiti",
                    "3 kullanıcı",
                    "Mobil uygulama",
                    "Temel raporlama",
                    "Email destek"
                }),
                trialDays: 15,
                description: "Yeni başlayan işletmeler için ideal paket",
                setupFee: 0m,
                isPublic: true,
                maxCouriers: 0,
                maxLocations: 1,
                supportPriority: 3)
            {
                CreatedAt = _dateTime.Now
            },

            new(
                name: "Profesyonel",
                code: "PRO",
                price: 499m,
                maxProducts: -1, // Sınırsız
                maxUsers: 10,
                maxMonthlyOrders: -1, // Sınırsız
                hasPos: true,
                hasCourier: true,
                features: CreateFeaturesDocument(new[]
                {
                    "Sınırsız ürün",
                    "10 kullanıcı",
                    "Mobil uygulama",
                    "POS entegrasyonu",
                    "Kurye yönetimi",
                    "Gelişmiş raporlama",
                    "Öncelikli email destek",
                    "Telefon desteği"
                }),
                trialDays: 15,
                description: "Büyüyen işletmeler için tam donanımlı çözüm",
                setupFee: 0m,
                isPublic: true,
                maxCouriers: 10,
                maxLocations: 3,
                supportPriority: 2)
            {
                CreatedAt = _dateTime.Now
            },

            new(
                name: "Kurumsal",
                code: "ENTERPRISE",
                price: 999m,
                maxProducts: -1,
                maxUsers: -1,
                maxMonthlyOrders: -1,
                hasPos: true,
                hasCourier: true,
                features: CreateFeaturesDocument(new[]
                {
                    "Sınırsız herşey",
                    "Sınırsız kullanıcı",
                    "Mobil uygulama",
                    "POS entegrasyonu",
                    "Kurye yönetimi",
                    "Özel raporlama",
                    "API erişimi",
                    "7/24 öncelikli destek",
                    "Özel entegrasyonlar",
                    "Dedicated müşteri temsilcisi"
                }),
                trialDays: 15,
                description: "Büyük işletmeler için özel çözümler",
                setupFee: 0m,
                isPublic: true,
                maxCouriers: -1,
                maxLocations: -1,
                supportPriority: 1)
            {
                CreatedAt = _dateTime.Now
            }
        };

        _context.SubscriptionPlans.AddRange(defaultPlans);
        await _context.SaveChangesAsync(default);
        
        _logger.LogInformation("Created {Count} default subscription plans", defaultPlans.Count);
        
        
        if (_localDemo) return;
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
    }
    
    private static JsonDocument CreateFeaturesDocument(string[] features)
    {
        return JsonDocument.Parse(JsonSerializer.Serialize(features));
    }

}
