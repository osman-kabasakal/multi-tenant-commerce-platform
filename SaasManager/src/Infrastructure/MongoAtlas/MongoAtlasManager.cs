using Core.Utilities;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using SaasManager.Application.Common.Interfaces.Mongo;
using SaasManager.Application.Common.Models;
using SaasManager.Application.Common.Models.MongoAtlasModels;
using SaasManager.Application.Stores.Commands.RegisterStore;
using StackExchange.Redis;
using Role = SaasManager.Application.Common.Models.MongoAtlasModels.Role;

namespace SaasManager.Infrastructure.MongoAtlas;

public class MongoAtlasManager: IMongoAtlasManager
{
    private readonly IMongoAtlasClientService _mongoAtlasClientService;
    private readonly IConfiguration _configuration;
    private readonly ISubscriber _subscriber;
    private readonly IWebHostEnvironment _webHostEnvironment;

    private readonly string _culustureName;

    public MongoAtlasManager(
        IMongoAtlasClientService mongoAtlasClientService,
        IConfiguration  configuration,
        ISubscriber subscriber,
        IWebHostEnvironment webHostEnvironment
        )
    {
        _mongoAtlasClientService = mongoAtlasClientService;
        _configuration = configuration;
        _subscriber = subscriber;
        _webHostEnvironment = webHostEnvironment;
        _culustureName = configuration[webHostEnvironment.IsDevelopment() ? "Dev:MongoAtlas:ClusterName" : "MongoAtlas:ClusterName"];
    }
    
    public async Task<TenantStatusMessage> CreateDatabaseUserByStoreAsync(RegisterStoreCommand storeCommand, CancellationToken cancellationToken = default)
    {
        var userPassword = PasswordGenerator.GenerateRandomPassword(includeSpecial:false);
        var mongoUserName = MongoUsernameHelper.SanitizeMongoUsername(storeCommand.OwnerEmail.Split("@").First());
        var databaseName = MongoDatabaseHelper.SanitizeDatabaseName(storeCommand.StoreSubDomain);
        try
        {
            var userExist = await _mongoAtlasClientService.DeleteAsync<MongoDatabaseUser>($"databaseUsers/admin/{mongoUserName}",cancellationToken);
        }
        catch (Exception)
        {
            // ignored
        }

        var response =
            await _mongoAtlasClientService.PostAsync<CreateMongoDatabaseUserRequest, MongoDatabaseUser>("databaseUsers",
                new CreateMongoDatabaseUserRequest
                {
                    AwsIAMType ="NONE",
                    DatabaseName = "admin",
                    GroupId = _configuration["MongoAtlas:ProjectId"],
                    Password = userPassword,
                    Roles = new List<Role>()
                    {
                        new Role()
                        {
                            DatabaseName = databaseName,
                            RoleName = "readWrite"
                        }
                    },
                    Scopes = new List<Scope>()
                    {
                        new Scope()
                        {
                            Name = _culustureName,
                            Type = "CLUSTER"
                        }
                    },
                    Username = mongoUserName
                }, cancellationToken);

        var cluster =
            await _mongoAtlasClientService.GetAsync<MongoAtlasClusterDetail>($"clusters/{_culustureName}", cancellationToken);
        
        var tenantStatusMessage = new TenantStatusMessage
        {
            StatusEventType = TenantStatusEvent.Registered,
            StoreName = storeCommand.StoreName,
            StoreSubDomain = storeCommand.StoreSubDomain,
            LogoUrl = storeCommand.LogoUrl,
            OwnerEmail = storeCommand.OwnerEmail,
            Password = storeCommand.Password,
            FirstName = storeCommand.FirstName,
            Lastname = storeCommand.Lastname,
            Role = storeCommand.Role,
            CompanyName = storeCommand.CompanyName,
            CompanyAddress = storeCommand.CompanyAddress,
            CompanyEmail = storeCommand.CompanyEmail,
            CompanyPhoneNumber = storeCommand.CompanyPhoneNumber,
            MongoConnectionString = GetConnectionString(cluster!,mongoUserName, userPassword,databaseName, _culustureName!),
        };

        return tenantStatusMessage;
    }

    private string GetConnectionString(MongoAtlasClusterDetail mongoAtlasClusterDetail, string userName,
        string password,
        string databaseName,
        string clusterName)
    {
        var connectionStringFormat = "mongodb+srv://{0}:{1}@{2}/{3}?retryWrites=true&w=majority&appName={4}";

        return string.Format(connectionStringFormat, userName, password,
            mongoAtlasClusterDetail.ConnectionStrings?.StandardSrv!.Replace("mongodb+srv://", String.Empty),
            databaseName,
            clusterName
            );
    }
}
