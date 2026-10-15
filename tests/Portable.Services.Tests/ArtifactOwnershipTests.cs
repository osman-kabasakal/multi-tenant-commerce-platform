using System.Text;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SaasManager.Application.AppBuilds.Commands.AppAssetUpload;
using SaasManager.Application.AppBuilds.Queries.DownloadAsset;
using SaasManager.Application.AppBuilds.Queries.DownloadBuild;
using NotFoundException = Ardalis.GuardClauses.NotFoundException;
using SaasManager.Application.Common.Interfaces.FileStorage;
using SaasManager.Domain.Entities.Organization;
using SaasManager.Domain.Entities.RegisteredApps;
using SaasManager.Domain.Enums;
using SaasManager.Infrastructure.Data;
using SaasManager.Infrastructure.FileStorage;

namespace Portable.Services.Tests;

[TestClass]
public sealed class ArtifactOwnershipTests
{
    internal static readonly byte[] Png=Convert.FromBase64String("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/l9sAAAAASUVORK5CYII=");

    [TestMethod]
    public async Task ActualUploadAndDownloadHandlersKeepFilesPrivateAndTenantOwned()
    {
        var directory=Path.Combine(Path.GetTempPath(),"owned-files-"+Guid.NewGuid().ToString("N"));
        try
        {
            await using var db=new TestContext(new DbContextOptionsBuilder<ApplicationDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
            var a=Owners.Create();var b=Owners.Create();
            db.Businesses.AddRange(a.Business,b.Business);db.GuestRegistrations.AddRange(a.Guest,b.Guest);
            var appA=new BusinessApp(a.Business.Id,AppType.CustomerMobile,"A","com.example.a"){Id=Guid.NewGuid()};
            var appB=new BusinessApp(b.Business.Id,AppType.CustomerMobile,"B","com.example.b"){Id=Guid.NewGuid()};
            db.BusinessApps.AddRange(appA,appB);await db.SaveChangesAsync();
            var storage=new FileSystemBlobStorageService(new(){RootDirectory=directory});
            var upload=new AppAssetUploadCommandHandler(db,storage,a.Context.Object,NullLogger<AppAssetUploadCommandHandler>.Instance,new Mock<IMediator>().Object);
            AppAssetUploadCommand Request(Guid app)=>new(){BusinessAppId=app,AssetType="Logo",Platform="android",File=new FormFile(new MemoryStream(Png),0,Png.Length,"file","logo.png")};
            var denied=await upload.Handle(Request(appB.Id),default);Assert.IsFalse(denied.IsSuccess);Assert.AreEqual(0,Directory.GetFiles(directory,"*",SearchOption.AllDirectories).Length);
            var saved=await upload.Handle(Request(appA.Id),default);Assert.IsTrue(saved.IsSuccess);
            var asset=await db.AppMediaAssets.SingleAsync();Assert.IsTrue(asset.FilePath.StartsWith("pfile:v1:"));Assert.IsFalse(saved.Data!.Url.Contains(asset.FilePath));
            var output=await new DownloadAssetHandler(db,storage,a.Context.Object).Handle(new(asset.Id),default);
            await using(output.FileStream){using var bytes=new MemoryStream();await output.FileStream.CopyToAsync(bytes);CollectionAssert.AreEqual(Png,bytes.ToArray());}
            await Assert.ThrowsExceptionAsync<NotFoundException>(()=>new DownloadAssetHandler(db,storage,b.Context.Object).Handle(new(asset.Id),default));
            var buildReference=await storage.UploadFileAsync(new MemoryStream([1,2,3]),"app.apk","app-builds",appA.Id.ToString("N"));
            var build=new AppBuild{Id=Guid.NewGuid(),BusinessAppId=appA.Id,FilePath=buildReference,Platform=BuildPlatform.Android};db.AppBuilds.Add(build);await db.SaveChangesAsync();
            var download=await new DownloadBuildQueryHandler(db,storage,a.Context.Object).Handle(new(){AppBuildId=build.Id},default);
            await download.FileStream.DisposeAsync();
            await Assert.ThrowsExceptionAsync<NotFoundException>(()=>new DownloadBuildQueryHandler(db,storage,b.Context.Object).Handle(new(){AppBuildId=build.Id},default));
        }
        finally{if(Directory.Exists(directory))Directory.Delete(directory,true);}
    }

    [TestMethod]
    public async Task InvalidAssetMetadataAndImageBytesCreateNoStoredObjects()
    {
        var directory=Path.Combine(Path.GetTempPath(),"invalid-files-"+Guid.NewGuid().ToString("N"));
        try
        {
            await using var db=new TestContext(new DbContextOptionsBuilder<ApplicationDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
            var owner=Owners.Create();db.GuestRegistrations.Add(owner.Guest);db.Businesses.Add(owner.Business);
            var app=new BusinessApp(owner.Business.Id,AppType.CustomerMobile,"App","com.example.app"){Id=Guid.NewGuid()};db.BusinessApps.Add(app);await db.SaveChangesAsync();
            var storage=new FileSystemBlobStorageService(new(){RootDirectory=directory});
            var handler=new AppAssetUploadCommandHandler(db,storage,owner.Context.Object,NullLogger<AppAssetUploadCommandHandler>.Instance,new Mock<IMediator>().Object);
            var request=new AppAssetUploadCommand{BusinessAppId=app.Id,AssetType="../../invalid",Platform="android",File=new FormFile(new MemoryStream(Png),0,Png.Length,"file","logo.png")};
            Assert.IsFalse((await handler.Handle(request,default)).IsSuccess);
            Assert.IsFalse((await handler.Handle(request with{AssetType="Logo",Platform="../outside"},default)).IsSuccess);
            var invalid=Encoding.UTF8.GetBytes("This is not an image.");
            Assert.IsFalse((await handler.Handle(request with{AssetType="Logo",File=new FormFile(new MemoryStream(invalid),0,invalid.Length,"file","logo.png")},default)).IsSuccess);
            Assert.AreEqual(0,await db.AppMediaAssets.CountAsync());Assert.AreEqual(0,Directory.GetFiles(directory,"*",SearchOption.AllDirectories).Length);
        }
        finally{if(Directory.Exists(directory))Directory.Delete(directory,true);}
    }
}
