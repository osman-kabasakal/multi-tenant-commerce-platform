using System.Text.Json;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Security;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Mongo;
using SaasManager.Application.Common.Models;
using SaasManager.Application.IdentityManagement.Commands.Registration;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Infrastructure.Data;
using StackExchange.Redis;

namespace Registration.Security.Tests;

[TestClass]
public class RegistrationSecurityTests
{
    private static ApplicationDbContext Context() => new TestContext(new DbContextOptionsBuilder<ApplicationDbContext>()
        .UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
    private static Mock<IWorkContext> Work(GuestRegistration guest)
    {
        var work=new Mock<IWorkContext>();
        work.SetupGet(x=>x.GuestId).Returns(guest.Id);
        work.SetupGet(x=>x.UserEmail).Returns(guest.Email);
        work.SetupProperty(x=>x.GuestRegistration,guest);
        return work;
    }
    [TestMethod]
    public void TenantAndBuildMessagesNeverSerializeCredentialValues()
    {
        var message=new TenantStatusMessage {TenantId="business-a",Password="private-password",MongoConnectionString="private-connection"};
        var json=JsonSerializer.Serialize(message);
        Assert.IsFalse(json.Contains("private-"));Assert.IsTrue(json.Contains("business-a"));
        var build=new SaasManager.Domain.Entities.RegisteredApps.AppBuildsConfig {KeycloakClientSecret="private-client-secret"};
        Assert.IsFalse(JsonSerializer.Serialize(build).Contains("private-client-secret"));
    }
    [TestMethod]
    public async Task RegistrationResumesSameBusinessAfterSecretStoreFailure()
    {
        await using var db=Context();
        var guest=new GuestRegistration("owner@example.test", "synthetic-token") {Id=Guid.NewGuid()};
        db.GuestRegistrations.Add(guest);
        var state=new BusinessRegistrationState(guest);db.BusinessRegistrationStates.Add(state);
        await db.SaveChangesAsync();
        var secrets=new Mock<ITenantSecrets>();
        secrets.SetupSequence(x=>x.ProvisionAsync(It.IsAny<string>(),It.IsAny<string>(),It.IsAny<CancellationToken>()))
            .ThrowsAsync(new IOException("Simulated secret store outage")).Returns(Task.CompletedTask);
        var step=new BusinessRegistrationStep(db,Work(guest).Object,NullLogger<BusinessRegistrationStep>.Instance,new Mock<IMediator>().Object,secrets.Object);
        var command=new RegistrationCommand {Data=new Dictionary<string,object> {
            ["name"]="Test Shop",["ownerName"]="Demo Owner",["legalCompanyName"]="Test Shop Ltd",
            ["taxNumber"]="1234567890",["taxOffice"]="Test Office",["phone"]="5321234567",
            ["address"]="Test Street 10",["city"]="Istanbul",["district"]="Kadikoy",["postalCode"]="34000"
        }};
        await Assert.ThrowsExceptionAsync<IOException>(()=>step.ValidateAsync(command));
        var business=await db.Businesses.SingleAsync();
        Assert.IsFalse(state.IsCompleted);
        Assert.AreEqual(business.Id,state.BusinessId);
        await step.ValidateAsync(command);
        Assert.IsTrue(state.IsCompleted);
        Assert.AreEqual(1,await db.Businesses.CountAsync());
        secrets.Verify(x=>x.ProvisionAsync(business.Id.ToString("N"),"test-shop",It.IsAny<CancellationToken>()),Times.Exactly(2));
    }
    [TestMethod]
    public async Task ProvisioningChecksOwnershipAndPublishesOnlySecretReferences()
    {
        await using var db=Context();
        var guest=new GuestRegistration("owner@example.test","synthetic-token") {Id=Guid.NewGuid()};
        var business=new Business("Test Shop","Owner",guest.Email!,"000","123","Test","Street","City","District","00000","Test Ltd",guest.Id);
        db.GuestRegistrations.Add(guest);db.Businesses.Add(business);await db.SaveChangesAsync();
        var work=Work(guest);var secrets=new Mock<ITenantSecrets>();var mongo=new Mock<IMongoAtlasManager>();var redis=new Mock<ISubscriber>();
        mongo.Setup(x=>x.CreateDatabaseUserByStoreAsync(It.IsAny<RegisterStoreCommand>(),It.IsAny<CancellationToken>()))
            .ReturnsAsync(new TenantStatusMessage {StoreSubDomain="test-shop",MongoConnectionString="synthetic-private-connection",Password="synthetic-private-password"});
        string? published=null;
        redis.Setup(x=>x.PublishAsync(It.IsAny<RedisChannel>(),It.IsAny<RedisValue>(),It.IsAny<CommandFlags>()))
            .Callback<RedisChannel,RedisValue,CommandFlags>((_,body,_)=>published=body.ToString()).ReturnsAsync(1);
        var handler=new RegisterStoreCommandHandler(db,mongo.Object,redis.Object,new ConfigurationBuilder().Build(),secrets.Object,work.Object);
        var request=new RegisterStoreCommand {BusinessId=business.Id,StoreSubDomain="test-shop"};
        var response=await handler.Handle(request,default);
        Assert.IsNotNull(published);
        Assert.IsFalse(published.Contains("synthetic-private"));
        Assert.IsNull(response.Data!.MongoConnectionString);Assert.IsNull(response.Data.Password);
        Assert.AreEqual(business.Id.ToString("N"),response.Data.TenantId);
        secrets.Verify(x=>x.SetAsync(business.Id.ToString("N"),TenantSecretNames.DatabaseConnection,"synthetic-private-connection",It.IsAny<CancellationToken>()),Times.Once);
        request.StoreSubDomain="another-shop";
        await Assert.ThrowsExceptionAsync<ArgumentException>(()=>handler.Handle(request,default));
        request.StoreSubDomain="test-shop";
        work.SetupProperty(x=>x.GuestRegistration,new GuestRegistration("other@example.test","other") {Id=Guid.NewGuid()});
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>handler.Handle(request,default));
        mongo.Verify(x=>x.CreateDatabaseUserByStoreAsync(It.IsAny<RegisterStoreCommand>(),It.IsAny<CancellationToken>()),Times.Once);
    }
}

// The tests exercise application handlers; JSON columns are converted only for the in-memory provider.
internal sealed class TestContext(DbContextOptions<ApplicationDbContext> options) : ApplicationDbContext(options)
{
    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        foreach(var type in builder.Model.GetEntityTypes())
            foreach(var property in type.GetProperties().Where(p=>p.ClrType==typeof(JsonDocument)).ToArray())
                builder.Entity(type.ClrType).Property<JsonDocument>(property.Name).HasConversion(
                    value=>value.RootElement.GetRawText(),value=>JsonDocument.Parse(value,new JsonDocumentOptions()));
    }
}
