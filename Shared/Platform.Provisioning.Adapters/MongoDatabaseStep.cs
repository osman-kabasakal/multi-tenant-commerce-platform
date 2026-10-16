using System.Security.Cryptography;
using MongoDB.Bson;
using MongoDB.Driver;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class TenantSecretsStep(ITenantSecrets secrets) : IProvisioningStep
{
    public string Name => "tenant-secrets";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string,ProvisioningStepResult> completed, CancellationToken ct)
    {
        request.Validate();
        await secrets.ProvisionAsync(request.TenantId,request.Slug,ct);
        await secrets.GetAsync(request.TenantId,TenantSecretNames.InitialPassword,ct);
        return new("Shared",new Dictionary<string,string> { ["tenantId"]=request.TenantId });
    }
}

public sealed class MongoDatabaseStep(OnboardingInfrastructureOptions options, ITenantSecrets secrets) : IProvisioningStep
{
    public string Name => "database";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string,ProvisioningStepResult> completed, CancellationToken ct)
    {
        var name = "tenant_" + request.TenantId;
        var username = name;
        string password;
        var adminSettings = MongoClientSettings.FromConnectionString(options.MongoAdminConnection);
        adminSettings.ServerSelectionTimeout=TimeSpan.FromSeconds(15);
        var database = new MongoClient(adminSettings).GetDatabase(name);
        var users = await database.RunCommandAsync<BsonDocument>(new BsonDocument("usersInfo",username),cancellationToken:ct);
        var existing = users["users"].AsBsonArray;
        if (existing.Count != 0)
        {
            var user = existing[0].AsBsonDocument;
            if (!user.TryGetValue("customData",out var metadata) || metadata.AsBsonDocument.GetValue("platformTenantId","") != request.TenantId)
                throw new InvalidOperationException("An existing database user is not owned by this tenant.");
            var roles=user["roles"].AsBsonArray;
            if (roles.Count!=1 || roles[0]["role"]!="readWrite" || roles[0]["db"]!=name)
                throw new InvalidOperationException("The tenant database user has unexpected roles.");
            password=await secrets.GetAsync(request.TenantId,"database-password",ct);
        }
        else
        {
            var collections=await (await database.ListCollectionNamesAsync(cancellationToken:ct)).ToListAsync(ct);
            if (collections.Count!=0) throw new InvalidOperationException("Refusing to adopt an unowned database.");
            password=await secrets.GetOrCreateAsync(request.TenantId,"database-password",()=>Convert.ToBase64String(RandomNumberGenerator.GetBytes(36)),ct);
            await database.RunCommandAsync<BsonDocument>(new BsonDocument {
                ["createUser"]=username,["pwd"]=password,
                ["customData"]=new BsonDocument("platformTenantId",request.TenantId),
                ["roles"]=new BsonArray {new BsonDocument { ["role"]="readWrite",["db"]=name }}
            },cancellationToken:ct);
        }
        var builder=new MongoUrlBuilder(options.MongoAdminConnection) {
            DatabaseName=name,Username=username,Password=password,AuthenticationSource=name
        };
        var candidate=builder.ToMongoUrl().ToString();
        var connection=await secrets.GetOrCreateAsync(request.TenantId,TenantSecretNames.DatabaseConnection,()=>candidate,ct);
        if (connection!=candidate) throw new InvalidOperationException("Database configuration changed; migrate explicitly.");
        var tenantSettings=MongoClientSettings.FromConnectionString(connection);
        tenantSettings.ServerSelectionTimeout=TimeSpan.FromSeconds(15);
        await new MongoClient(tenantSettings).GetDatabase(name).RunCommandAsync<BsonDocument>(new BsonDocument("ping",1),cancellationToken:ct);
        return new("Mongo",new Dictionary<string,string> { ["databaseName"]=name,["username"]=username });
    }
}
