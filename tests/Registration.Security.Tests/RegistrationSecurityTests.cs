using System.Text.Json;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Platform.Security;
using Platform.Provisioning;
using SaasManager.Application.Stores.Provisioning;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Interfaces.Security;
using SaasManager.Application.Common.Interfaces.PaymentProviders;
using Core.Models.Responses;
using SaasManager.Application.Common.Interfaces.Mongo;
using SaasManager.Application.Common.Models;
using SaasManager.Application.IdentityManagement.Commands.Registration;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.Registration;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Enums;
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
    private static void GrantPaidEntitlement(ApplicationDbContext db, GuestRegistration guest, Business business)
    {
        guest.ConvertToBusiness(business);
        var plan = new SubscriptionPlan("Paid fixture", "fixture-plan", 10, 10, 2, 100, false, false,
            JsonDocument.Parse("{}"), 0, "Contract fixture", 0, true, 0, 1, 0);
        db.SubscriptionPlans.Add(plan);
        db.BusinessSubscriptions.Add(new BusinessSubscription(business.Id, plan.Id, DateTime.UtcNow.AddDays(-1),
            DateTime.UtcNow.AddDays(30), 10, PaymentPeriod.Monthly));
        var payment = new PaymentSetupState(guest); payment.SetPreAuthDetails(1, "fixture-provider-reference"); payment.Complete();
        db.PaymentSetupStates.Add(payment);
    }
    [DataTestMethod]
    [DataRow("Disabled")][DataRow("AndroidAppDistribution")][DataRow("AndroidIosAppDistribution")]
    public async Task SaasQueuesTheSelectedMobilePolicyWithTheDeploymentAndCanonicalBusiness(string mobile)
    {
        await using var db=Context();var guest=new GuestRegistration("owner@example.test","synthetic-token"){Id=Guid.NewGuid()};
        var business=new Business("Test Shop","Owner",guest.Email!,"000","123","Test","Street","City","District","00000","Test Ltd",guest.Id);
        db.GuestRegistrations.Add(guest);db.Businesses.Add(business);GrantPaidEntitlement(db, guest, business);await db.SaveChangesAsync();
        TenantProvisioningRequest? captured=null;var queue=new Mock<IProvisioningQueue>();
        queue.Setup(x=>x.EnqueueAsync(It.IsAny<TenantProvisioningRequest>(),It.IsAny<CancellationToken>()))
            .Callback<TenantProvisioningRequest,CancellationToken>((request,_)=>captured=request)
            .ReturnsAsync((TenantProvisioningRequest request,CancellationToken _)=>new ProvisioningJob(request,"Pending",0,new Dictionary<string,ProvisioningStepResult>(),null,DateTimeOffset.UtcNow,DateTimeOffset.UtcNow));
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{{"Provisioning:Enabled","true"},{"Provisioning:Profile","Portable"},{"Provisioning:DeploymentId","production-a"},{"Provisioning:Mobile:Provider",mobile}}).Build();
        var handler=new RegisterStoreCommandHandler(db,new Mock<IMongoAtlasManager>(MockBehavior.Strict).Object,new Mock<ISubscriber>(MockBehavior.Strict).Object,config,new Mock<ITenantSecrets>().Object,Work(guest).Object,queue.Object);
        await handler.Handle(new RegisterStoreCommand{BusinessId=business.Id,StoreSubDomain="test-shop",StoreName="Test Shop",OwnerEmail=guest.Email!,Password="synthetic-private-password"},default);
        Assert.IsNotNull(captured);captured.Validate();Assert.AreEqual(mobile,captured.MobileReleaseProfile);Assert.AreEqual("production-a",captured.DeploymentId);Assert.AreEqual(business.Id.ToString("N"),captured.TenantId);
    }
    [DataTestMethod]
    [DataRow("NotQueued")][DataRow("Pending")][DataRow("Running")][DataRow("Failed")][DataRow("Succeeded")]
    public async Task OnlyTheOwnedIosStatusIsExposedAndRetryKeepsTheParentAuthorization(string state)
    {
        await using var db = Context(); var guest = new GuestRegistration("owner@example.test", "synthetic-token") { Id = Guid.NewGuid() };
        var business = new Business("Test Shop", "Owner", guest.Email!, "000", "123", "Test", "Street", "City", "District", "00000", "Test Ltd", guest.Id);
        db.GuestRegistrations.Add(guest); db.Businesses.Add(business); GrantPaidEntitlement(db, guest, business); await db.SaveChangesAsync();
        var work = Work(guest); var tenant = business.Id.ToString("N");
        var request = new TenantProvisioningRequest(tenant, "test-shop", "Test Shop", guest.Email!, "Owner", "Fixture", "Street", "000", guest.Email!,
            DeploymentId: "production-a", MobileReleaseProfile: "AndroidIosAppDistribution");
        var parent = new ProvisioningJob(request, "Failed", 1, new Dictionary<string, ProvisioningStepResult>(), null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow);
        var plan = new IosReleasePlan(tenant, "production-a", "com.example.tenant" + tenant, "ABCDE12345", new string('a', 64), new string('b', 64), 7,
            "status-fixture-demo", "123456789", "1:123456789:ios:bbbbbbbb", new string('c', 64), "https://test-shop.shops.example.test");
        var receipt = state == "Succeeded" ? new IosReleaseReceipt(new string('f', 64), plan.SourceHash, plan.SigningCertificateSha256, plan.FirebaseSdkSha256,
            plan.BuildNumber, "11111111-1111-1111-1111-111111111111", "22222222-2222-2222-2222-222222222222", "projects/123456789/apps/1:123456789:ios:bbbbbbbb/releases/fixture", true) : null;
        var queue = new Mock<IProvisioningQueue>(MockBehavior.Strict); var ios = new Mock<IIosReleaseQueue>(MockBehavior.Strict);
        queue.Setup(x => x.GetAsync(tenant, It.IsAny<CancellationToken>())).ReturnsAsync(parent);
        queue.Setup(x => x.RetryAsync(tenant, It.IsAny<CancellationToken>())).ReturnsAsync(true);
        ios.Setup(x => x.GetAsync(tenant, It.IsAny<CancellationToken>())).ReturnsAsync(state == "NotQueued" ? null :
            new IosReleaseJob(plan, state, 1, receipt, state == "Failed" ? "ios-release:InvalidOperationException" : null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow));
        var handler = new ProvisioningStatusHandler(db, work.Object, queue.Object, new ConfigurationBuilder().Build(), ios.Object);
        var result = (await handler.Handle(new GetProvisioningStatus(business.Id), default))!;
        Assert.AreEqual(state, result.IosRelease!.State);
        var json = JsonSerializer.Serialize(result);
        Assert.IsFalse(json.Contains("ABCDE12345")); Assert.IsFalse(json.Contains("DeviceUdids")); Assert.IsFalse(json.Contains("SourceHash"));
        Assert.IsTrue(await handler.Handle(new RetryProvisioning(business.Id), default));
        work.SetupProperty(x => x.GuestRegistration, new GuestRegistration("other@example.test", "synthetic-other") { Id = Guid.NewGuid() });
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(() => handler.Handle(new GetProvisioningStatus(business.Id), default));
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(() => handler.Handle(new RetryProvisioning(business.Id), default));
        queue.Verify(x => x.GetAsync(tenant, It.IsAny<CancellationToken>()), Times.Once);
        ios.Verify(x => x.GetAsync(tenant, It.IsAny<CancellationToken>()), Times.Once);
        queue.Verify(x => x.RetryAsync(tenant, It.IsAny<CancellationToken>()), Times.Once);
        ios.Verify(x => x.RetryAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }
    [TestMethod]
    public async Task AForeignIosPlanCannotBeReturnedAsTheOwnersProgress()
    {
        await using var db = Context(); var guest = new GuestRegistration("owner@example.test", "synthetic-token") { Id = Guid.NewGuid() };
        var business = new Business("Test Shop", "Owner", guest.Email!, "000", "123", "Test", "Street", "City", "District", "00000", "Test Ltd", guest.Id);
        db.Businesses.Add(business); await db.SaveChangesAsync(); var tenant = business.Id.ToString("N");
        var request = new TenantProvisioningRequest(tenant, "test-shop", "Test Shop", guest.Email!, "Owner", "Fixture", "Street", "000", guest.Email!, DeploymentId: "production-a", MobileReleaseProfile: "AndroidIosAppDistribution");
        var parent = new ProvisioningJob(request, "Pending", 0, new Dictionary<string, ProvisioningStepResult>(), null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow);
        var queue = new Mock<IProvisioningQueue>(); queue.Setup(x => x.GetAsync(tenant, It.IsAny<CancellationToken>())).ReturnsAsync(parent);
        var ios = new Mock<IIosReleaseQueue>();
        var foreign = new IosReleasePlan(Guid.NewGuid().ToString("N"), "production-a", "dev.commerce.foreign", "ABCDE12345", new string('a', 64), new string('b', 64), 7,
            "status-fixture-demo", "123456789", "1:123456789:ios:bbbbbbbb", new string('c', 64), "https://foreign.shops.example.test");
        ios.Setup(x => x.GetAsync(tenant, It.IsAny<CancellationToken>())).ReturnsAsync(new IosReleaseJob(foreign, "Pending", 0, null, null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow));
        var handler = new ProvisioningStatusHandler(db, Work(guest).Object, queue.Object, new ConfigurationBuilder().Build(), ios.Object);
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => handler.Handle(new GetProvisioningStatus(business.Id), default));
        queue.Setup(x => x.GetAsync(tenant, It.IsAny<CancellationToken>())).ReturnsAsync(parent with { Request = request with { TenantId = foreign.TenantId } });
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(() => handler.Handle(new GetProvisioningStatus(business.Id), default));
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
    public async Task CompletedPaymentReconcilesQueueFailureWithoutChargingAgain()
    {
        await using var db=Context();
        var guest=new GuestRegistration("owner@example.test","synthetic-token") {Id=Guid.NewGuid(),Firstname="Demo",Lastname="Owner"};
        var business=new Business("Test Shop","Owner",guest.Email!,"000","123","Test","Street","City","District","00000","Test Ltd",guest.Id);
        guest.ConvertToBusiness(business);
        var paymentState=new PaymentSetupState(guest);paymentState.Complete();
        db.GuestRegistrations.Add(guest);db.Businesses.Add(business);db.PaymentSetupStates.Add(paymentState);await db.SaveChangesAsync();
        var sender=new Mock<ISender>();
        sender.SetupSequence(x=>x.Send(It.IsAny<RegisterStoreCommand>(),It.IsAny<CancellationToken>()))
            .ThrowsAsync(new IOException("Simulated queue outage"))
            .ReturnsAsync(ServiceResponse<TenantStatusMessage>.Success(new() {TenantId=business.Id.ToString("N")}));
        var payment=new Mock<IPaymentProviderFactory>(MockBehavior.Strict);
        var protector=new Mock<ICardDataProtector>(MockBehavior.Strict);
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> { ["Provisioning:Enabled"]="true" }).Build();
        var step=new PaymentVerificationStep(db,Work(guest).Object,new Mock<IDateTime>().Object,
            NullLogger<PaymentVerificationStep>.Instance,protector.Object,payment.Object,
            sender.Object,new Mock<IMediator>().Object,new Mock<ITenantSecrets>().Object,config,new PaymentTestLock());
        Assert.IsFalse((await step.ValidateAsync(new RegistrationCommand(),default)).IsValid);
        await step.ValidateAsync(new RegistrationCommand(),default);
        Assert.IsTrue(paymentState.IsCompleted);
        sender.Verify(x=>x.Send(It.Is<RegisterStoreCommand>(c=>c.BusinessId==business.Id),It.IsAny<CancellationToken>()),Times.Exactly(2));
        payment.VerifyNoOtherCalls();protector.VerifyNoOtherCalls();
    }

    [TestMethod]
    public async Task DurableProvisioningDoesNotRequireAtlasOrRedisAndChecksJobOwnership()
    {
        await using var db=Context();
        var guest=new GuestRegistration("owner@example.test","synthetic-token") {Id=Guid.NewGuid()};
        var business=new Business("Test Shop","Owner",guest.Email!,"000","123","Test","Street","City","District","00000","Test Ltd",guest.Id);
        db.GuestRegistrations.Add(guest);db.Businesses.Add(business);GrantPaidEntitlement(db, guest, business);await db.SaveChangesAsync();
        var work=Work(guest);
        var secrets=new Mock<ITenantSecrets>();
        var mongo=new Mock<IMongoAtlasManager>(MockBehavior.Strict);
        var redis=new Mock<ISubscriber>(MockBehavior.Strict);
        var queue=new Mock<IProvisioningQueue>();
        TenantProvisioningRequest? queued=null;
        queue.Setup(x=>x.EnqueueAsync(It.IsAny<TenantProvisioningRequest>(),It.IsAny<CancellationToken>()))
            .Callback<TenantProvisioningRequest,CancellationToken>((request,_)=>queued=request)
            .ReturnsAsync((TenantProvisioningRequest request,CancellationToken _) => new ProvisioningJob(request,"Pending",0,new Dictionary<string,ProvisioningStepResult>(),null,DateTimeOffset.UtcNow,DateTimeOffset.UtcNow));
        queue.Setup(x=>x.RetryAsync(business.Id.ToString("N"),It.IsAny<CancellationToken>())).ReturnsAsync(true);
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> { ["Provisioning:Enabled"]="true" }).Build();
        var handler=new RegisterStoreCommandHandler(db,mongo.Object,redis.Object,config,secrets.Object,work.Object,queue.Object);
        var request=new RegisterStoreCommand { BusinessId=business.Id,StoreSubDomain="test-shop",StoreName="Test Shop",OwnerEmail=guest.Email!,Password="synthetic-private-password" };
        var response=await handler.Handle(request,default);
        Assert.IsNotNull(queued);queued.Validate();
        Assert.IsFalse(JsonSerializer.Serialize(queued).Contains("synthetic-private-password"));
        Assert.IsNull(response.Data!.MongoConnectionString);Assert.IsNull(response.Data.Password);
        secrets.Verify(x=>x.GetOrCreateAsync(business.Id.ToString("N"),TenantSecretNames.InitialPassword,It.IsAny<Func<string>>(),It.IsAny<CancellationToken>()),Times.Once);
        mongo.VerifyNoOtherCalls();redis.VerifyNoOtherCalls();
        var status=new ProvisioningStatusHandler(db,work.Object,queue.Object,config);
        Assert.IsTrue(await status.Handle(new RetryProvisioning(business.Id),default));
        request.OwnerEmail="different@example.test";
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>handler.Handle(request,default));
        work.SetupProperty(x=>x.GuestRegistration,new GuestRegistration("other@example.test","other") {Id=Guid.NewGuid()});
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>status.Handle(new GetProvisioningStatus(business.Id),default));
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>status.Handle(new RetryProvisioning(business.Id),default));
        queue.Verify(x=>x.RetryAsync(It.IsAny<string>(),It.IsAny<CancellationToken>()),Times.Once);
    }

    [TestMethod]
    public async Task ProvisioningChecksOwnershipAndPublishesOnlySecretReferences()
    {
        await using var db=Context();
        var guest=new GuestRegistration("owner@example.test","synthetic-token") {Id=Guid.NewGuid()};
        var business=new Business("Test Shop","Owner",guest.Email!,"000","123","Test","Street","City","District","00000","Test Ltd",guest.Id);
        db.GuestRegistrations.Add(guest);db.Businesses.Add(business);GrantPaidEntitlement(db, guest, business);await db.SaveChangesAsync();
        var work=Work(guest);var secrets=new Mock<ITenantSecrets>();var mongo=new Mock<IMongoAtlasManager>();var redis=new Mock<ISubscriber>();
        mongo.Setup(x=>x.CreateDatabaseUserByStoreAsync(It.IsAny<RegisterStoreCommand>(),It.IsAny<CancellationToken>()))
            .ReturnsAsync(new TenantStatusMessage {StoreSubDomain="test-shop",MongoConnectionString="synthetic-private-connection",Password="synthetic-private-password"});
        string? published=null;
        redis.Setup(x=>x.PublishAsync(It.IsAny<RedisChannel>(),It.IsAny<RedisValue>(),It.IsAny<CommandFlags>()))
            .Callback<RedisChannel,RedisValue,CommandFlags>((_,body,_)=>published=body.ToString()).ReturnsAsync(1);
        var handler=new RegisterStoreCommandHandler(db,mongo.Object,redis.Object,new ConfigurationBuilder().Build(),secrets.Object,work.Object);
        var request=new RegisterStoreCommand {BusinessId=business.Id,StoreSubDomain="test-shop",OwnerEmail=guest.Email!};
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
