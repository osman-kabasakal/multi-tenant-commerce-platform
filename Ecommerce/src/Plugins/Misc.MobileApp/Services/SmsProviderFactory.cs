using Microsoft.Extensions.DependencyInjection;

namespace Misc.MobileApp.Services;

public class SmsProviderFactory(
    IServiceProvider serviceProvider
    ): ISmsProviderFactory
{
    public ISmsProvider? GetSmsProvider(SendCouponCodeNotificationSettings settings)
    {
        return serviceProvider.GetKeyedService<ISmsProvider>(settings.SmsProvider);
    }
}