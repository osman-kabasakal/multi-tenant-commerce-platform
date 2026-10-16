using System.Text.Json;
using Core.Models.Responses;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SaasManager.Application.Common.Interfaces.Identity;
using SaasManager.Application.Common.Models;
using SaasManager.Application.IdentityManagement.Commands.Registration.Steps;
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Application.Stores.Provisioning;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Infrastructure.Data;
using ValidationException=SaasManager.Application.Common.Exceptions.ValidationException;

namespace Registration.Security.Tests;

[TestClass]
public sealed class TrialEnrollmentTests
{
    [TestMethod]
    public async Task ProductionTrialSurvivesQueueFailureWithoutDuplicatingSubscriptionOrCharging()
    {
        await using var f=new Fixture();await f.Seed();
        f.Sender.SetupSequence(x=>x.Send(It.IsAny<RegisterStoreCommand>(),It.IsAny<CancellationToken>())).ThrowsAsync(new IOException("Queue unavailable")).ReturnsAsync(ServiceResponse<TenantStatusMessage>.Success(new()));
        await Assert.ThrowsExceptionAsync<IOException>(()=>f.Handle());var subscription=await f.Db.BusinessSubscriptions.SingleAsync();var end=subscription.EndDate;
        var result=await f.Handle();var business=await f.Db.Businesses.SingleAsync();
        Assert.AreEqual(f.Request.RegistrationId,result.BusinessId);Assert.AreEqual(f.Details.TaxNumber,business.TaxNumber);Assert.AreEqual(f.Details.Address,business.Address);Assert.AreEqual(f.Guest.Email,business.Email);
        Assert.AreEqual(f.Plan.Id,subscription.PlanId);Assert.IsTrue(subscription.IsTrial);Assert.AreEqual(0m,subscription.Amount);Assert.AreEqual(end,(await f.Db.BusinessSubscriptions.SingleAsync()).EndDate);
        Assert.AreEqual(1,await f.Db.BusinessApps.CountAsync());Assert.AreEqual(0,await f.Db.Payments.CountAsync());Assert.AreEqual(0,await f.Db.PaymentMethods.CountAsync());
        f.Sender.Verify(s=>s.Send(It.Is<RegisterStoreCommand>(c=>c.BusinessId==business.Id && c.OwnerEmail==f.Guest.Email && c.CompanyAddress==f.Details.Address),It.IsAny<CancellationToken>()),Times.Exactly(2));
    }
    [DataTestMethod]
    [DataRow("TenantOnboarding:Trial:Enabled","false")][DataRow("Provisioning:Enabled","false")][DataRow("Provisioning:Profile","Local")]
    [DataRow("Provisioning:DeploymentId","")][DataRow("LocalDemo:Enabled","true")][DataRow("PlatformSecurity:Provider","Local")]
    [DataRow("PlatformSecurity:ReadOnly","true")][DataRow("TenantOnboarding:Trial:PlanId","")]
    [DataRow("Provisioning:Mobile:Provider","Unknown")]
    public async Task ImplicitOrDemoConfigurationCannotCreateProductionBusinesses(string key,string value)
    {
        await using var f=new Fixture();await f.Seed();f.Config[key]=value;await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Handle());Assert.AreEqual(0,await f.Db.Businesses.CountAsync());
        f.Sender.Verify(s=>s.Send(It.IsAny<RegisterStoreCommand>(),It.IsAny<CancellationToken>()),Times.Never);
    }
    [DataTestMethod]
    [DataRow("identity-mismatch")][DataRow("unverified")][DataRow("development")]
    public async Task EnrollmentRequiresTheVerifiedOwnerAndDeploymentEnvironment(string scenario)
    {
        await using var f=new Fixture(scenario!="unverified");await f.Seed();
        if(scenario=="identity-mismatch")f.Work.SetupGet(w=>w.KeycloakId).Returns(Guid.NewGuid());
        if(scenario=="development"){f.Environment.SetupGet(e=>e.EnvironmentName).Returns("Development");await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>f.Handle());}
        else await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>f.Handle());
        Assert.AreEqual(0,await f.Db.Businesses.CountAsync());
    }
    [DataTestMethod]
    [DataRow("phone")][DataRow("tax")][DataRow("address")][DataRow("password")][DataRow("slug")]
    public async Task InvalidCompanyDataNeverCreatesAPlaceholderBusiness(string scenario)
    {
        await using var f=new Fixture();await f.Seed();if(scenario=="phone")f.Details.Phone="123";if(scenario=="tax")f.Details.TaxNumber="";if(scenario=="address")f.Details.Address="";if(scenario=="slug")f.Details.Name="www";
        var request=scenario=="password"?f.Request with{AdminPassword="short"}:f.Request;
        await Assert.ThrowsExceptionAsync<ValidationException>(()=>f.Handler().Handle(request,default));Assert.AreEqual(0,await f.Db.Businesses.CountAsync());
    }
    [TestMethod]
    public async Task ReplaysCannotChangeTheBusinessPlanOrCreateASecondOwnedBusiness()
    {
        await using var f=new Fixture();await f.Seed();await f.Handle();
        await Assert.ThrowsExceptionAsync<EnrollmentConflictException>(()=>f.Handler().Handle(f.Request with{RegistrationId=Guid.NewGuid()},default));
        f.Details.Address="A changed company address";await Assert.ThrowsExceptionAsync<EnrollmentConflictException>(()=>f.Handle());f.Details.Address="Verified Company Street 10";
        f.Config["TenantOnboarding:Trial:PlanId"]=Guid.NewGuid().ToString();await Assert.ThrowsExceptionAsync<EnrollmentConflictException>(()=>f.Handle());
        Assert.AreEqual(1,await f.Db.Businesses.CountAsync());Assert.AreEqual(1,await f.Db.BusinessSubscriptions.CountAsync());
    }
    [TestMethod]
    public async Task AnotherAuthenticatedOwnerCannotReplayTheExistingRegistration()
    {
        await using var f=new Fixture();await f.Seed();await f.Handle();var subject=Guid.NewGuid();var other=new GuestRegistration("other@example.test",""){Id=Guid.NewGuid()};other.MarkEmailAsVerified();other.MarkAsConverted(subject.ToString());
        f.Work.SetupGet(w=>w.KeycloakId).Returns(subject);f.Work.SetupProperty(w=>w.GuestRegistration,other);await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>f.Handle());Assert.AreEqual(1,await f.Db.Businesses.CountAsync());
    }
    [TestMethod]
    public async Task OnlyTheConfiguredPublicTrialPlanCanBeSelected()
    {
        await using var f=new Fixture();await f.Seed();f.Plan.UpdateAccessibility(false,14,0);await f.Db.SaveChangesAsync();await Assert.ThrowsExceptionAsync<EnrollmentConflictException>(()=>f.Handle());Assert.AreEqual(0,await f.Db.Businesses.CountAsync());
    }
    private sealed class Fixture : IAsyncDisposable
    {
        public TestContext Db {get;}=new(new DbContextOptionsBuilder<ApplicationDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
        public GuestRegistration Guest {get;}=new("verified@example.test",""){Id=Guid.NewGuid(),Firstname="Verified",Lastname="Owner"};
        public SubscriptionPlan Plan {get;}=new("Public trial","PORTABLE",299,100,3,1000,false,false,JsonDocument.Parse("{}"),14,"Configured trial",0,true,0,1,0){Id=Guid.NewGuid()};
        public BusinessRegistrationModel Details {get;}=new(){Name="Portable Trial",LegalCompanyName="Portable Trial Limited",OwnerName="Verified Owner",TaxNumber="9999999901",TaxOffice="Test Office",Phone="5551234567",Address="Verified Company Street 10",City="Test City",District="Test District",PostalCode="00000"};
        public Mock<IWorkContext> Work {get;}=new();public Mock<ISender> Sender {get;}=new();public Mock<IHostEnvironment> Environment {get;}=new();public IConfigurationRoot Config {get;}
        public EnrollTrialBusiness Request {get;}
        public Fixture(bool verified=true)
        {
            var subject=Guid.NewGuid();Guest.MarkAsConverted(subject.ToString());if(verified)Guest.MarkEmailAsVerified();Work.SetupGet(w=>w.KeycloakId).Returns(subject);Work.SetupProperty(w=>w.GuestRegistration,Guest);
            Sender.Setup(s=>s.Send(It.IsAny<RegisterStoreCommand>(),It.IsAny<CancellationToken>())).ReturnsAsync(ServiceResponse<TenantStatusMessage>.Success(new()));Environment.SetupGet(e=>e.EnvironmentName).Returns("Production");
            Config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?>{["TenantOnboarding:Trial:Enabled"]="true",["TenantOnboarding:Trial:PlanId"]=Plan.Id.ToString(),["Provisioning:Enabled"]="true",["Provisioning:Profile"]="Portable",["Provisioning:DeploymentId"]="production-test",["PlatformSecurity:Provider"]="AesGcm"}).Build();
            Request=new(Guid.NewGuid(),Details,"Üretim-parolası-12345");
        }
        public async Task Seed(){Db.GuestRegistrations.Add(Guest);Db.SubscriptionPlans.Add(Plan);await Db.SaveChangesAsync();}
        public EnrollTrialBusinessHandler Handler()=>new(Db,Work.Object,Sender.Object,Config,Environment.Object);
        public Task<TrialEnrollmentResult> Handle()=>Handler().Handle(Request,default);
        public ValueTask DisposeAsync()=>Db.DisposeAsync();
    }
}
