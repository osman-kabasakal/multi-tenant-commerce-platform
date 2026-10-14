using Grand.Business.Core.Commands.System.Security;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.System.Installation;
using Grand.Data;
using Grand.Data.Mongo;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Migrations;
using Grand.Infrastructure.Plugins;
using Grand.Installer.Cli.Models;
using Grand.SharedKernel.Extensions;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;

namespace Grand.Installer.Cli.Services;

public class InstallerService
{
    private readonly IServiceProvider _serviceProvider;

    public InstallerService(
        IServiceProvider serviceProvider
        )
    {
        _serviceProvider = serviceProvider;
    }
    private string BuildConnectionString(IInstallationLocalizedService locService, InstallModel model)
    {
        var connectionString = "";

        if (model.ConnectionInfo && model.DataProvider != DbProvider.LiteDB)
        {
            if (string.IsNullOrEmpty(model.DatabaseConnectionString))
                throw new Exception("Connection string must be does not is empty!");
            else
                connectionString = model.DatabaseConnectionString;
        }
        else
        {
            if (model.DataProvider != DbProvider.LiteDB)
            {
                if (string.IsNullOrEmpty(model.MongoDBDatabaseName))
                    throw new Exception("Database name is required");
                if (string.IsNullOrEmpty(model.MongoDBServerName))
                    throw new Exception("server name is required");

                var builder = new MongoUrlBuilder {
                    Server = new MongoServerAddress(model.MongoDBServerName),
                    Username = model.MongoDBUsername,
                    Password = model.MongoDBPassword,
                    DatabaseName = model.MongoDBDatabaseName
                };
                connectionString = builder.ToString();
            }
            else
            {
                var _dbConfig= _serviceProvider.GetRequiredService<DatabaseConfig>();
                if (!_dbConfig.UseLiteDb)
                    throw new Exception(locService.GetResource(model.SelectedLanguage, "InfoLiteDb"));

                if (string.IsNullOrEmpty(_dbConfig.LiteDbConnectionString))
                    throw new Exception(locService.GetResource(model.SelectedLanguage, "InfoLiteDbConnectionString"));

                connectionString = _dbConfig.LiteDbConnectionString;
            }
        }

        return connectionString;
    }

    protected async Task CheckConnectionString(IInstallationLocalizedService locService, string connectionString,
        InstallModel model)
    {

        if (!string.IsNullOrEmpty(connectionString))
            try
            {
                if (model.DataProvider != DbProvider.LiteDB)
                {
                    var mdb = _serviceProvider.GetRequiredService<IDatabaseContext>();
                    mdb.SetConnection(connectionString);
                    if (await mdb.DatabaseExist())
                        return;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.InnerException != null ? ex.InnerException.Message : ex.Message);
            }
        else if (string.IsNullOrEmpty(connectionString))
            throw new Exception(locService.GetResource(model.SelectedLanguage, "ConnectionStringRequired"));
    }

    protected async Task<bool> DatabaseExist(string connectionString)
    {
        var mdb = new MongoDBContext();
        mdb.SetConnection(connectionString);
        return await mdb.DatabaseExist();
    }

    public virtual async Task Install(InstallModel model)
    {
        if (DataSettingsManager.DatabaseIsInstalled() && (await DatabaseExist(model.DatabaseConnectionString)))
            return;

        ICacheBase cacheBase= _serviceProvider!.GetRequiredService<ICacheBase>();
        var installed = await cacheBase.GetAsync("Installed", async () => await Task.FromResult(false));
        if (installed)
            return;

        var locService = _serviceProvider.GetRequiredService<IInstallationLocalizedService>();

        if (model.DatabaseConnectionString != null)
            model.DatabaseConnectionString = model.DatabaseConnectionString.Trim();

        var connectionString = BuildConnectionString(locService, model);

        await CheckConnectionString(locService, connectionString, model);

        var _logger=_serviceProvider.GetRequiredService<ILogger<InstallerService>>();
        try
        {
            //save settings
            var settings = new DataSettings {
                ConnectionString = connectionString,
                DbProvider = model.DataProvider
            };

            await DataSettingsManager.SaveSettings(settings);
            DataSettingsManager.LoadSettings(true);
            IConfigurationRoot configuration = (IConfigurationRoot)_serviceProvider.GetRequiredService<IConfiguration>();
            var installationService = _serviceProvider.GetRequiredService<IInstallationService>();
            await installationService.InstallData(
                model.StoreHostScheme, HostString.FromUriComponent(model.StoreHost),
                model.AdminEmail, model.AdminPassword, model.Collation,
                model.InstallSampleData, model.CompanyName, model.CompanyAddress, model.CompanyPhoneNumber,
                model.CompanyEmail);

            _logger.LogInformation("Database has been installed");

            //reset cache
            DataSettingsManager.ResetCache();

            PluginManager.ClearPlugins();

            //register default permissions
            var permissionProvider = _serviceProvider.GetRequiredService<IPermissionProvider>();
            var _mediator = _serviceProvider.GetRequiredService<IMediator>();
            await _mediator.Send(new InstallPermissionsCommand { PermissionProvider = permissionProvider });
            _logger.LogInformation("Permission has been installed");
            
            //restart application
            await cacheBase.SetAsync("Installed", async () => await Task.FromResult(true));
            DataSettingsManager.LoadSettings(true);
            
            var migrationProcess = _serviceProvider.GetRequiredService<IMigrationProcess>();
            migrationProcess.RunMigrationProcess();

            _logger.LogInformation("Migration process has been executed");
            
            
            
            return;
        }
        catch (Exception exception)
        {
            //reset cache
            DataSettingsManager.ResetCache();
            await cacheBase.Clear();

            System.IO.File.Delete(CommonPath.SettingsPath);
            
            _logger.LogError(exception, exception.InnerException?.Message);

            throw new Exception(string.Format(locService.GetResource(model.SelectedLanguage, "SetupFailed"),
                exception.Message + " " + exception.InnerException?.Message));
        }

        return;
    }

    public async Task<Customer> InsertSuperUser(string superUserEmail, string superUserPassword)
    {
        var _customerGroupRepository = _serviceProvider.GetRequiredService<IRepository<CustomerGroup>>();
        var crAdministrators = _customerGroupRepository.Table.FirstOrDefault(cg => cg.SystemName == SystemCustomerGroupNames.SuperAdministrators);
        var crRegistered = _customerGroupRepository.Table.FirstOrDefault(cg => cg.SystemName == SystemCustomerGroupNames.Registered);
        var _countryRepository = _serviceProvider.GetRequiredService<IRepository<Country>>();
        var _customerRepository = _serviceProvider.GetRequiredService<IRepository<Customer>>();
        var adminUser = new Customer {
            CustomerGuid = Guid.NewGuid(),
            Email = superUserEmail,
            Username = superUserEmail,
            Password = superUserPassword,
            PasswordFormatId = PasswordFormat.Clear,
            PasswordSalt = "",
            Active = true,
            LastActivityDateUtc = DateTime.UtcNow,
            PasswordChangeDateUtc = DateTime.UtcNow
        };
        
        var country = _countryRepository.Table.FirstOrDefault(c => c.ThreeLetterIsoCode == "USA");
        var defaultAdminUserAddress = new Address {
            FirstName = "John",
            LastName = "Smith",
            PhoneNumber = "12345678",
            Email = "admin@yourstore.com",
            FaxNumber = "",
            Company = "GrandNode LTD",
            Address1 = "21 West 52nd Street",
            Address2 = "",
            City = "New York",
            StateProvinceId = country?.StateProvinces.FirstOrDefault(sp => sp.Name == "New York")?.Id,
            CountryId = country?.Id,
            ZipPostalCode = "10021"
        };
        adminUser.Addresses.Add(defaultAdminUserAddress);
        adminUser.BillingAddress = defaultAdminUserAddress;
        adminUser.ShippingAddress = defaultAdminUserAddress;
        adminUser.Groups.Add(crAdministrators.Id);
        adminUser.Groups.Add(crRegistered.Id);
        adminUser.UserFields.Add(new UserField
            { Key = SystemCustomerFieldNames.FirstName, Value = "John", StoreId = "" });
        adminUser.UserFields.Add(new UserField
            { Key = SystemCustomerFieldNames.LastName, Value = "Smith", StoreId = "" });
        await _customerRepository.InsertAsync(adminUser);

        return adminUser;
    } 
}