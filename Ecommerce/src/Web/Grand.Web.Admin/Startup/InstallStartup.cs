using Azure.Security.KeyVault.Secrets;
using Grand.Business.Core.Commands.System.Security;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.System.Installation;
using Grand.Business.System.Services.Installation;
using Grand.Data;
using Grand.Data.Mongo;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Migrations;
using Grand.Infrastructure.Plugins;
using Grand.SharedKernel.Extensions;
using Grand.Web.Admin.Models.Install;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using MongoDB.Driver;

namespace Grand.Web.Admin.Startup;

public class InstallStartup: IStartupApplication
{
    public IServiceProvider ServiceProvider { get; set; }
    
    public void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        services.AddScoped<IInstallationLocalizedService, InstallationLocalizedService>();
        services.AddScoped<IInstallationService, InstallationService>();
    }

    public void Configure(IApplicationBuilder application, IWebHostEnvironment webHostEnvironment)
    {
        using var serviceScope= application.ApplicationServices.CreateScope();
        ServiceProvider = serviceScope.ServiceProvider;
        Install(new InstallModel {
            UserFields = null,
            SelectedLanguage = "tr-TR",
            AdminEmail = "admin@store.com",
            AdminPassword = "CHANGE_ME",
            ConfirmPassword = "CHANGE_ME",
            DatabaseConnectionString = ServiceProvider.GetRequiredService<SecretClient>().GetSecret("applicationdb").Value.Value,
            DataProvider = DbProvider.MongoDB,
            ConnectionInfo = true,
            MongoDBServerName = null,
            MongoDBDatabaseName = null,
            MongoDBUsername = null,
            MongoDBPassword = null,
            DisableSampleDataOption = false,
            InstallSampleData = true,
            Installed = false,
            Collation = "tr",
            AvailableLanguages = null,
            AvailableCollation = null,
            AvailableProviders = null,
            CompanyName = "Contoso",
            CompanyAddress = "İzmir",
            CompanyPhoneNumber = "0000000000",
            CompanyEmail = "info@contoso.com"
        }).Wait();
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
                var _dbConfig= ServiceProvider.GetRequiredService<DatabaseConfig>();
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
                    var mdb = ServiceProvider.GetRequiredService<IDatabaseContext>();
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

        ICacheBase cacheBase= ServiceProvider!.GetRequiredService<ICacheBase>();
        var installed = await cacheBase.GetAsync("Installed", async () => await Task.FromResult(false));
        if (installed)
            return;

        var locService = ServiceProvider.GetRequiredService<IInstallationLocalizedService>();

        if (model.DatabaseConnectionString != null)
            model.DatabaseConnectionString = model.DatabaseConnectionString.Trim();

        var connectionString = BuildConnectionString(locService, model);

        await CheckConnectionString(locService, connectionString, model);

        var _logger=ServiceProvider.GetRequiredService<ILogger<StartupApplication>>();
        try
        {
            //save settings
            var settings = new DataSettings {
                ConnectionString = connectionString,
                DbProvider = model.DataProvider
            };

            await DataSettingsManager.SaveSettings(settings);
            DataSettingsManager.LoadSettings(true);
            IConfigurationRoot configuration = (IConfigurationRoot)ServiceProvider.GetRequiredService<IConfiguration>();
            var installationService = ServiceProvider.GetRequiredService<IInstallationService>();
            await installationService.InstallData(
                configuration["Web:Scheme"], HostString.FromUriComponent(configuration["Web:Host"]),
                model.AdminEmail, model.AdminPassword, model.Collation,
                model.InstallSampleData, model.CompanyName, model.CompanyAddress, model.CompanyPhoneNumber,
                model.CompanyEmail);

            _logger.LogInformation("Database has been installed");

            //reset cache
            DataSettingsManager.ResetCache();

            PluginManager.ClearPlugins();

            var pluginsInfo = PluginManager.ReferencedPlugins.ToList();

            foreach (var pluginInfo in pluginsInfo)
                try
                {
                    var plugin = pluginInfo.Instance<IPlugin>(ServiceProvider);
                    await plugin.Install();
                    _logger.LogInformation($"Plugin {plugin.PluginInfo.FriendlyName} has been installed");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error during installing plugin " + pluginInfo.SystemName,
                        ex.Message + " " + ex.InnerException?.Message);
                }

            //register default permissions
            var permissionProvider = ServiceProvider.GetRequiredService<IPermissionProvider>();
            var _mediator = ServiceProvider.GetRequiredService<IMediator>();
            await _mediator.Send(new InstallPermissionsCommand { PermissionProvider = permissionProvider });
            _logger.LogInformation("Permission has been installed");

            //install migration process - install only header
            var migrationProcess = ServiceProvider.GetRequiredService<IMigrationProcess>();
            migrationProcess.InstallApplication();

            _logger.LogInformation("Migration process has been executed");

            //restart application
            await cacheBase.SetAsync("Installed", async () => await Task.FromResult(true));
            DataSettingsManager.LoadSettings(true);
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
    
    public int Priority => 101;
    public bool BeforeConfigure => false;
}