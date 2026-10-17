using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SaasManager.Application.AppBuilds;
using SaasManager.Application.AppBuilds.Commands.NewBuild;
using SaasManager.Application.AppBuilds.Queries.GetNewBuildVm;
using SaasManager.Application.Common.Models.AppBuilds;
using SaasManager.Domain.Entities.Billing;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Enums;
using SaasManager.Infrastructure.Data;

namespace Portable.Services.Tests;

[TestClass]
public sealed class AppBuildEligibilityTests
{
    private static TestContext Database()=>new(new DbContextOptionsBuilder<ApplicationDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
    [DataTestMethod]
    [DataRow(BusinessStatus.Trial, true, true)]
    [DataRow(BusinessStatus.Active, false, true)]
    [DataRow(BusinessStatus.Trial, false, false)]
    [DataRow(BusinessStatus.UnderSetup, true, false)]
    [DataRow(BusinessStatus.Suspended, true, false)]
    [DataRow(BusinessStatus.Cancelled, true, false)]
    [DataRow(BusinessStatus.Banned, true, false)]
    public async Task OnlyReadyBusinessesWithMatchingCurrentSubscriptionsCanBuild(BusinessStatus status,bool trial,bool allowed)
    {
        await using var db=Database();var owner=Owners.Create();owner.Business.UpdateStatus(status);
        db.Businesses.Add(owner.Business);db.GuestRegistrations.Add(owner.Guest);
        var app=new BusinessApp(owner.Business.Id,AppType.CustomerMobile,"App","com.example.app"){Id=Guid.NewGuid()};db.BusinessApps.Add(app);
        db.BusinessSubscriptions.Add(new BusinessSubscription(owner.Business.Id,Guid.NewGuid(),DateTime.UtcNow.AddDays(-1),DateTime.UtcNow.AddDays(5),0,PaymentPeriod.Monthly,trial,trial?DateTime.UtcNow.AddDays(5):null));
        await db.SaveChangesAsync();
        var vm=(await new GetNewBuildVmQueryHandler(db,owner.Context.Object).Handle(new(),default)).Data!;
        Assert.AreEqual(allowed,vm.CanBuild);Assert.IsFalse(vm.HasActiveBuild);Assert.AreEqual(app.Id,vm.BusinessAppId);
        if(!allowed)Assert.IsFalse(string.IsNullOrWhiteSpace(vm.BlockReason));
    }
    [DataTestMethod]
    [DataRow("expired-trial")][DataRow("expired-subscription")][DataRow("future")][DataRow("cancelled")][DataRow("missing")]
    public async Task BrowserFlagsCannotBypassExpiredOrMissingSubscription(string scenario)
    {
        await using var db=Database();var owner=Owners.Create();owner.Business.UpdateStatus(BusinessStatus.Trial);
        db.Businesses.Add(owner.Business);db.GuestRegistrations.Add(owner.Guest);
        var app=new BusinessApp(owner.Business.Id,AppType.CustomerMobile,"App","com.example.app"){Id=Guid.NewGuid()};db.BusinessApps.Add(app);
        var now=DateTime.UtcNow;
        if(scenario!="missing")
        {
            var subscription=new BusinessSubscription(owner.Business.Id,Guid.NewGuid(),scenario=="future"?now.AddDays(1):now.AddDays(-2),
                scenario=="expired-subscription"?now.AddDays(-1):now.AddDays(5),0,PaymentPeriod.Monthly,true,scenario=="expired-trial"?now.AddDays(-1):now.AddDays(5));
            if(scenario=="cancelled")subscription.UpdateStatus(SubscriptionStatus.Cancelled);db.BusinessSubscriptions.Add(subscription);
        }
        await db.SaveChangesAsync();var adapter=new Mock<IPortableAppBuilds>(MockBehavior.Strict);
        var command=new NewBuildCommand{NewBuild=new(){BusinessAppId=app.Id,CanBuild=true,BuildNumber=2,RequestId=Guid.NewGuid(),Version="1.0.0"}};
        var response=await new NewBuildCommandHandler(db,owner.Context.Object,new Mock<IMediator>().Object,adapter.Object).Handle(command,default);
        Assert.IsFalse(response.IsSuccess);Assert.AreEqual(0,adapter.Invocations.Count);Assert.AreEqual(0,await db.AppBuilds.CountAsync());
        Assert.IsFalse((await new GetNewBuildVmQueryHandler(db,owner.Context.Object).Handle(new(),default)).Data!.CanBuild);
    }
    [TestMethod]
    public async Task ReadyTrialUsesPortableQueueAndKeepsBusinessStatusAndVersion()
    {
        await using var db=Database();var owner=Owners.Create();owner.Business.UpdateStatus(BusinessStatus.Trial);
        db.Businesses.Add(owner.Business);db.GuestRegistrations.Add(owner.Guest);
        var app=new BusinessApp(owner.Business.Id,AppType.CustomerMobile,"App","com.example.app"){Id=Guid.NewGuid()};db.BusinessApps.Add(app);
        db.BusinessSubscriptions.Add(new BusinessSubscription(owner.Business.Id,Guid.NewGuid(),DateTime.UtcNow.AddDays(-1),DateTime.UtcNow.AddDays(5),0,PaymentPeriod.Monthly,true,DateTime.UtcNow.AddDays(5)));await db.SaveChangesAsync();
        var adapter=new Mock<IPortableAppBuilds>();adapter.Setup(p=>p.StateAsync(app,default)).ReturnsAsync(new PortableBuildState(true,false,2,null));
        var vm=(await new GetNewBuildVmQueryHandler(db,owner.Context.Object,adapter.Object).Handle(new(),default)).Data!;
        Assert.IsTrue(vm.CanBuild);Assert.IsTrue(vm.UsesExistingBranding);Assert.AreEqual(2,vm.BuildNumber);Assert.AreNotEqual(Guid.Empty,vm.RequestId);
        adapter.Setup(p=>p.EnqueueAsync(app,vm,default)).ReturnsAsync(new NewBuildDto{BuildNumber=2,BuildStatus="Queued"});
        var response=await new NewBuildCommandHandler(db,owner.Context.Object,new Mock<IMediator>().Object,adapter.Object).Handle(new(){NewBuild=vm},default);
        Assert.IsTrue(response.IsSuccess);Assert.AreEqual(2,response.Data!.BuildNumber);Assert.AreEqual(BusinessStatus.Trial,owner.Business.Status);
        Assert.AreEqual(1,app.BuildNumber);Assert.AreEqual(0,await db.AppBuilds.CountAsync());
        var foreign=vm;foreign.BusinessAppId=Guid.NewGuid();
        Assert.IsFalse((await new NewBuildCommandHandler(db,owner.Context.Object,new Mock<IMediator>().Object,adapter.Object).Handle(new(){NewBuild=foreign},default)).IsSuccess);
        adapter.Verify(p=>p.EnqueueAsync(app,It.IsAny<NewBuildDto>(),default),Times.Once);
        adapter.Setup(p=>p.StateAsync(app,default)).ReturnsAsync(new PortableBuildState(true,true,3,null));
        var busy=(await new GetNewBuildVmQueryHandler(db,owner.Context.Object,adapter.Object).Handle(new(),default)).Data!;
        Assert.IsFalse(busy.CanBuild);Assert.IsTrue(busy.HasActiveBuild);Assert.AreEqual(app.Id,busy.BusinessAppId);Assert.IsNull(busy.BlockReason);
    }
}
