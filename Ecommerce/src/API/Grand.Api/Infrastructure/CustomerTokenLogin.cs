using Grand.Api.Models.Common;
using Grand.Business.Core.Interfaces.Customers;
using Grand.Domain.Customers;

namespace Grand.Api.Infrastructure;

internal static class CustomerTokenLogin
{
    public static async Task<Customer> AuthenticateAsync(LoginWebModel model, ICustomerService customers,
        ICustomerManagerService manager, CustomerSettings settings)
    {
        if (model == null || string.IsNullOrWhiteSpace(model.Email) || string.IsNullOrEmpty(model.Password) ||
            model.Email.Length > 320 || !TryDecodePassword(model.Password, out var password)) return null;
        var customer = await customers.GetCustomerByEmail(model.Email.Trim());
        if (customer == null || !customer.Active || customer.Deleted || customer.IsSystemAccount() || string.IsNullOrEmpty(customer.Password) ||
            customer.CannotLoginUntilDateUtc > DateTime.UtcNow) return null;
        var identifier = settings.UsernamesEnabled ? customer.Username : customer.Email;
        if (string.IsNullOrWhiteSpace(identifier)) return null;
        // Use the ordinary password verifier, including its two-factor-required result.
        var result = await manager.LoginCustomer(identifier, password);
        return result == CustomerLoginResults.Successful ? customer : null;
    }
    internal static bool TryDecodePassword(string encoded, out string password)
    {
        password = "";
        if (string.IsNullOrEmpty(encoded) || encoded.Length > 4096) return false;
        try
        {
            password = new System.Text.UTF8Encoding(false, true).GetString(Convert.FromBase64String(encoded));
            return password.Length is > 0 and <= 1024;
        }
        catch (Exception error) when (error is FormatException or System.Text.DecoderFallbackException)
        { return false; }
    }
}
