using Grand.Domain.Customers;

namespace Grand.Business.System.Services.Installation;

public partial class InstallationService
{
    // Explicit operator repair for an interrupted install after customer/message creation.
    // Earlier store, customer, currency and country identities are retained.
    public async Task CompleteInterruptedBaseInstallation(string ownerEmail, string initialPassword)
    {
        if (!_storeRepository.Table.Any() || !_customerRepository.Table.Any(x => x.Email == ownerEmail.ToLowerInvariant()) ||
            !_languageRepository.Table.Any() || !_countryRepository.Table.Any() || !_emailAccountRepository.Table.Any())
            throw new InvalidOperationException("This repair requires the owned store, owner, language, country and email seed phases.");
        await InstallSettings(false);
        await InstallPageLayouts();
        await InstallPages();
        await InstallLocaleResources();
        var owner = _customerRepository.Table.Single(x => x.Email == ownerEmail.ToLowerInvariant());
        if (owner.PasswordFormatId != PasswordFormat.Hashed)
            await HashDefaultCustomerPassword(ownerEmail, initialPassword);
        await InstallProductLayouts();
        await InstallCategoryLayouts();
        await InstallBrandLayouts();
        await InstallCollectionLayouts();
        await InstallScheduleTasks();
        if (!_merchandiseReturnReasonRepository.Table.Any()) await InstallMerchandiseReturnReasons();
        if (!_merchandiseReturnActionRepository.Table.Any()) await InstallMerchandiseReturnActions();
        if (!_orderStatusRepository.Table.Any()) await InstallOrderStatus();
    }
}
