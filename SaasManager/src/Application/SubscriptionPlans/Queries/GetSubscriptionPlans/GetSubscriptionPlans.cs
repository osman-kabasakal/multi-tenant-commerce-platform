using System.Text.Json;
using Core.Models.Responses;
using Microsoft.Extensions.Logging;
using SaasManager.Application.Common.Interfaces;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Models.SubscriptionPlans;
using SaasManager.Domain.Entities.Billing;

namespace SaasManager.Application.SubscriptionPlans.Queries.GetSubscriptionPlans;

public record GetSubscriptionPlansQuery : IRequest<ServiceResponse<List<SubscriptionPlanDto>>>
{
}

public class GetSubscriptionPlansQueryValidator : AbstractValidator<GetSubscriptionPlansQuery>
{
    public GetSubscriptionPlansQueryValidator()
    {
    }
}

public class GetSubscriptionPlansQueryHandler : IRequestHandler<GetSubscriptionPlansQuery, ServiceResponse<List<SubscriptionPlanDto>>>
{
    private readonly IApplicationDbContext _context;
    private readonly ILogger<GetSubscriptionPlansQueryHandler> _logger;
    private readonly IDateTime _dateTime;

    public GetSubscriptionPlansQueryHandler(
        IApplicationDbContext context,
        ILogger<GetSubscriptionPlansQueryHandler> logger,
        IDateTime dateTime)
    {
        _context = context;
        _logger = logger;
        _dateTime = dateTime;
    }

    public async Task<ServiceResponse<List<SubscriptionPlanDto>>> Handle(
        GetSubscriptionPlansQuery request,
        CancellationToken cancellationToken)
    {
        try
        {
            var plans = await _context.SubscriptionPlans
                .Where(p => p.IsActive && p.IsPublic)
                .OrderBy(p => p.Price)
                .ToListAsync(cancellationToken);

            // Eğer hiç plan yoksa default planları oluştur
            if (!plans.Any())
            {
                _logger.LogInformation("No subscription plans found. Creating default plans.");
                plans = await CreateDefaultPlans(cancellationToken);
            }

            var dtos = plans.Select(MapToDto).ToList();
            return ServiceResponse<List<SubscriptionPlanDto>>.Success(dtos);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving subscription plans");
            return ServiceResponse<List<SubscriptionPlanDto>>.Error(
                "SUBSCRIPTION_PLANS_ERROR",
                "Abonelik planları alınırken bir hata oluştu");
        }
    }
    
    private async Task<List<SubscriptionPlan>> CreateDefaultPlans(CancellationToken cancellationToken)
    {
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
        await _context.SaveChangesAsync(cancellationToken);
        
        _logger.LogInformation("Created {Count} default subscription plans", defaultPlans.Count);
        
        return defaultPlans;
    }

    private static JsonDocument CreateFeaturesDocument(string[] features)
    {
        return JsonDocument.Parse(JsonSerializer.Serialize(features));
    }

    private static SubscriptionPlanDto MapToDto(SubscriptionPlan plan)
    {
        return new SubscriptionPlanDto
        {
            Id = plan.Id,
            Name = plan.Name,
            Code = plan.Code,
            Price = plan.Price,
            Description = plan.Description,
            Features = ExtractFeatures(plan.Features),
            MaxProducts = plan.MaxProducts,
            MaxUsers = plan.MaxUsers,
            MaxMonthlyOrders = plan.MaxMonthlyOrders,
            HasPos = plan.HasPos,
            HasCourier = plan.HasCourier,
            IsPublic = plan.IsPublic,
            TrialDays = plan.TrialDays,
            SetupFee = plan.SetupFee,
            MaxCouriers = plan.MaxCouriers,
            MaxLocations = plan.MaxLocations,
            SupportPriority = plan.SupportPriority
        };
    }

    
    private static List<string> ExtractFeatures(JsonDocument? features)
    {
        if (features == null)
            return new List<string>();

        try
        {
            // Özellik listesini JsonDocument'tan çıkar
            return features.RootElement
                .EnumerateArray()
                .Select(e => e.GetString() ?? string.Empty)
                .Where(f => !string.IsNullOrEmpty(f))
                .ToList();
        }
        catch
        {
            return new List<string>();
        }
    }
}
