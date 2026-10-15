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
using SaasManager.Application.Stores.Commands.RegisterStore;
using SaasManager.Application.Stores.Provisioning;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.IdentityManagement;
using SaasManager.Infrastructure.Data;

namespace Registration.Security.Tests;

[TestClass]
public sealed class LocalEnrollmentTests
{
    [TestMethod]
    public async Task LocalTrialSurvivesQueueOutageWithoutDuplicatingOrChargingSubscription()
    {
        await using var db=new TestContext(new DbContextOptionsBuilder<ApplicationDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
        var userId=Guid.NewGuid();
        var guest=new GuestRegistration("trial@example.test","") {Id=Guid.NewGuid(),Firstname="Demo",Lastname="Owner"};
        guest.MarkAsConverted(userId.ToString());guest.MarkEmailAsVerified();db.GuestRegistrations.Add(guest);
        var plan=new SubscriptionPlan("Local plan","LOCAL",299,100,3,1000,false,false,JsonDocument.Parse("{}"),14,"Test",0,true,0,1,0);
        db.SubscriptionPlans.Add(plan);await db.SaveChangesAsync();
        var work=new Mock<IWorkContext>();work.SetupGet(x=>x.KeycloakId).Returns(userId);work.SetupProperty(x=>x.GuestRegistration,guest);
        var sender=new Mock<ISender>();
        sender.SetupSequence(x=>x.Send(It.IsAny<RegisterStoreCommand>(),It.IsAny<CancellationToken>()))
            .ThrowsAsync(new IOException("Queue unavailable"))
            .ReturnsAsync(ServiceResponse<TenantStatusMessage>.Success(new()));
        var environment=new Mock<IHostEnvironment>();environment.SetupGet(x=>x.EnvironmentName).Returns("Development");
        var config=new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
            ["LocalDemo:Enabled"]="true",["LocalDemo:SelfService"]="true",["Provisioning:Enabled"]="true"
        }).Build();
        var handler=new EnrollLocalBusinessHandler(db,work.Object,sender.Object,config,environment.Object);
        var request=new EnrollLocalBusiness(Guid.NewGuid(),"Trial Shop","synthetic-local-password");
        await Assert.ThrowsExceptionAsync<IOException>(()=>handler.Handle(request,default));
        var subscription=await db.BusinessSubscriptions.SingleAsync();var end=subscription.EndDate;
        Assert.AreEqual(1,await db.Businesses.CountAsync());Assert.IsTrue(subscription.IsTrial);Assert.AreEqual(0m,subscription.Amount);
        var result=await handler.Handle(request,default);
        Assert.AreEqual(request.RegistrationId,result.BusinessId);Assert.AreEqual("trial-shop",result.Slug);
        Assert.AreEqual(1,await db.BusinessSubscriptions.CountAsync());Assert.AreEqual(end,subscription.EndDate);
        Assert.AreEqual(1,await db.BusinessApps.CountAsync());
        Assert.AreEqual(0,await db.Payments.CountAsync());Assert.AreEqual(0,await db.PaymentMethods.CountAsync());
        environment.SetupGet(x=>x.EnvironmentName).Returns("Production");
        await Assert.ThrowsExceptionAsync<InvalidOperationException>(()=>handler.Handle(request,default));
        environment.SetupGet(x=>x.EnvironmentName).Returns("Development");
        work.SetupGet(x=>x.KeycloakId).Returns(Guid.NewGuid());
        await Assert.ThrowsExceptionAsync<UnauthorizedAccessException>(()=>handler.Handle(request,default));
    }
}
