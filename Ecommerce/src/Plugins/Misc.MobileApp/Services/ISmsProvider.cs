namespace Misc.MobileApp.Services;

public interface ISmsProvider
{
    Task SendSmsAsync(string phoneNumber, string message);
}

public interface ISmsProviderFactory
{
    ISmsProvider? GetSmsProvider(SendCouponCodeNotificationSettings settings);
}