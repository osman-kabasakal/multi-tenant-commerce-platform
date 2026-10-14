using System.Reflection;
using Core.Models.Responses;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using SaasManager.Application.Common.Behaviours;
using SaasManager.Application.Common.Interfaces.Authentication;
using SaasManager.Application.Common.Interfaces.Cache;
using SaasManager.Application.Common.Models.SubscriptionPlans;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;
using SaasManager.Application.SubscriptionPlans.Queries.GetSubscriptionPlans;
using SaasManager.Domain.Entities.Registration;

namespace SaasManager.Application;

public static class DependencyInjection
{
    public static void AddApplicationServices(this IHostApplicationBuilder builder)
    {
        builder.Services.AddScoped<IRegistrationStep, EmailVerificationStep>();
        builder.Services.AddScoped<IRegistrationStep, BusinessRegistrationStep>();
        builder.Services.AddScoped<IRegistrationStep, SubscriptionSelectionStep>();
        builder.Services.AddScoped<IRegistrationStep, PaymentVerificationStep>();
        
        builder.Services.AddAutoMapper(Assembly.GetExecutingAssembly());

        builder.Services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());

        builder.Services.AddMediatR(cfg => {
            cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());
            cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(UnhandledExceptionBehaviour<,>));
            cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(AuthorizationBehaviour<,>));
            cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(ValidationBehaviour<,>));
            cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(PerformanceBehaviour<,>));
        });
        
        builder.Services.AddScoped<GetSubscriptionPlansQueryHandler>();
        builder.Services.AddScoped<IRequestHandler<GetSubscriptionPlansQuery, ServiceResponse<List<SubscriptionPlanDto>>>>(sp =>
        {
            var decorated = sp.GetRequiredService<GetSubscriptionPlansQueryHandler>();
            var cache = sp.GetRequiredService<ICacheBase>();
            return new CachedSubscriptionPlansQueryHandler(decorated, cache);
        });
    }
}
