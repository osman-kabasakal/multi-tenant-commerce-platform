using System.Security.Cryptography;
using System.Text;
using Npgsql;
using Platform.Provisioning;

internal static class MobileIdentityRegistryFixture
{
    public static async Task RunAsync(PostgresProvisioningQueue queue,string connection)
    {
        static void Check(bool value,string message){if(!value)throw new Exception("FAILED: "+message);Console.WriteLine("PASS: "+message);}
        static async Task Reject<T>(Func<Task> action,string message) where T:Exception{try{await action();}catch(T){Console.WriteLine("PASS: "+message);return;}throw new Exception("FAILED: "+message);}
        var tenant=Guid.NewGuid().ToString("N");var owner=Guid.NewGuid();var app=Guid.NewGuid();var deployment="identity-integration";
        var package="com.publisher.original"+tenant;var url="https://identity-"+tenant[..8]+".shops.example.test";
        var originalRequest=new TenantProvisioningRequest(tenant,"identity-"+tenant[..8],"Versioned store","owner@example.net","Owner","Test","Address","123","owner@example.net",
            package,package,deployment,"AndroidAppDistribution");
        await queue.EnqueueAsync(originalRequest);var parent=(await queue.ClaimAsync(TimeSpan.FromMinutes(2)))!;
        Check(parent.Job.Request.TenantId==tenant,"The identity fixture owns its isolated onboarding job");
        await queue.CheckpointAsync(parent,"publication",new("Portable",new Dictionary<string,string>{{"storeUrl",url},{"readiness","Verified"}}));
        await queue.CheckpointAsync(parent,"google-firebase",new("Google",new Dictionary<string,string>{{"projectId","version-contract"},{"projectNumber","1234567"},{"androidAppId","1:1234567:android:abcdef1"},{"iosAppId","1:1234567:ios:abcdef1"}}));
        var initialReceipt=new ProvisioningStepResult("AndroidAppDistribution",new Dictionary<string,string>{{"androidApplicationId",package},{"androidAppId","1:1234567:android:abcdef1"},
            {"sourceHash",new string('a',64)},{"sha256",new string('b',64)},{"signingCertificateSha256",new string('c',64)},{"buildNumber","1"},{"release","projects/1234567/apps/1:1234567:android:abcdef1/releases/initial"}});
        await queue.CheckpointAsync(parent,"mobile-android-release",initialReceipt);await queue.CompleteAsync(parent);var original=(await queue.GetAsync(tenant))!;
        await using var versions=new MobileIdentityRegistry(connection);await using var domains=new TenantDomainRegistry(connection);
        var reservedPackage="com.publisher.reserved"+tenant;
        var contenders=Enumerable.Range(0,8).Select(_=>Guid.NewGuid().ToString("N")).ToArray();
        var reservations=await Task.WhenAll(contenders.Select(candidate=>versions.TryReservePackageAsync(reservedPackage,candidate,default)));
        Check(reservations.Count(x=>x)==1,"First enrollment and later identity changes share one atomic global package reservation");
        var winner=contenders[Array.FindIndex(reservations,x=>x)];
        Check(await versions.TryReservePackageAsync(reservedPackage,winner,default) && !await versions.TryReservePackageAsync(reservedPackage,tenant,default),"Package reservation replays retain their original tenant and cannot be transferred");
        var initial=new MobileIdentityRequest(MobileIdentityRegistry.InitialId(tenant,deployment),tenant,app,owner,deployment,package,package,url,null,null,DomainActivationPlan.Digest(original.Request),0);
        var legacy=await versions.ImportInitialAsync(initial,original);
        Check(legacy.State=="Active" && legacy.Legacy,"The existing signed application is imported without changing its package or certificate");
        Check((await versions.ImportInitialAsync(initial,original)).Request.Id==legacy.Request.Id,"Initial identity import is idempotent");
        var domainRequest=new TenantDomainRequest(Guid.NewGuid(),tenant,owner,deployment,"shop-"+tenant[..8]+".version.example.org","manage.shop-"+tenant[..8]+".version.example.org");
        await domains.CreateAsync(domainRequest);var access=new TenantDomainAccess(new string('b',32),"version.example.org");
        await domains.CompleteCheckAsync((await domains.ClaimAsync(deployment,default))!,access,default);await domains.RequestVerificationAsync(domainRequest.Id,owner);
        await domains.CompleteCheckAsync((await domains.ClaimAsync(deployment,default))!,access,default);await domains.MarkActiveAsync(domainRequest.Id,owner,tenant,deployment,default);
        var domain=TenantDomainSelection.From((await domains.GetAsync(domainRequest.Id,owner))!);var nextPackage="org.example.version.brand"+tenant;
        var request=new MobileIdentityRequest(Guid.NewGuid(),tenant,app,owner,deployment,nextPackage,nextPackage,"https://"+domain.StoreHost,domain,legacy.Request.Id,initial.OriginalRequestSha256,1);
        var copies=await Task.WhenAll(Enumerable.Range(0,12).Select(_=>versions.EnqueueAsync(request)));
        Check(copies.All(x=>x.Request==request && x.Generation==1),"Concurrent version requests create one immutable package identity");
        Check(await versions.GetAsync(request.Id,Guid.NewGuid())==null && await versions.GetForWorkerAsync(Guid.NewGuid().ToString("N"),request.Id)==null,"Another owner or tenant cannot read the identity version");
        await Reject<ProvisioningConflictException>(()=>versions.EnqueueAsync(request with{Id=Guid.NewGuid(),AndroidPackageName=nextPackage+"other",IosBundleId=nextPackage+"other"}),"Only one pending package transition is allowed per tenant");
        var claims=await Task.WhenAll(Enumerable.Range(0,8).Select(_=>versions.ClaimLinuxAsync(deployment,default)));Check(claims.Count(x=>x!=null)==1,"Only one Linux worker claims the new package");var linux=claims.Single(x=>x!=null)!;
        var iosPlan=new IosReleasePlan(tenant,deployment,nextPackage,"ABC123DEFG",new string('d',64),new string('e',64),1,"version-contract","1234567","1:1234567:ios:abcdef2",new string('f',64),request.StoreUrl){MobileIdentityId=request.Id};
        var prepared=new PreparedMobileIdentity("version-contract","1234567","1:1234567:android:abcdef2",iosPlan.IosAppId,request.FirebaseSecretName,
            "android-package-signing-v1-"+Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(nextPackage))).ToLowerInvariant(),new string('c',64),new string('a',64),1,iosPlan);
        await Reject<ProvisioningConflictException>(()=>versions.PrepareAsync(linux,prepared with{ProjectId="foreign-project",IosPlan=iosPlan with{ProjectId="foreign-project"}},default),"Preparation cannot move the identity to a different Firebase project");
        await versions.PrepareAsync(linux,prepared,default);
        await Reject<PostgresException>(()=>versions.PrepareAsync(linux,prepared with{AndroidCertificateSha256=new string('d',64)},default),"The saved package signing binding cannot change after preparation");
        Check(await versions.ClaimIosAsync(new(deployment,"ABC123DEFG",new string('d',64),new string('0',64)),default)==null,"An incompatible Mac source cannot claim this iOS package");
        var ios=(await versions.ClaimIosAsync(new(deployment,"ABC123DEFG",new string('d',64),new string('e',64)),default))!;
        var android=new ProvisioningStepResult("AndroidAppDistribution",new Dictionary<string,string>{{"androidApplicationId",nextPackage},{"androidAppId",prepared.AndroidAppId},
            {"sourceHash",prepared.AndroidSourceHash},{"sha256",new string('b',64)},{"signingCertificateSha256",prepared.AndroidCertificateSha256},{"buildNumber","1"},{"storeUrl",request.StoreUrl},
            {"release","projects/1234567/apps/"+prepared.AndroidAppId+"/releases/new-package"}});
        await versions.CompleteAndroidAsync(linux,android,default);
        Check((await versions.GetAsync(legacy.Request.Id,owner))!.State=="Active" && (await versions.GetAsync(request.Id,owner))!.State=="WaitingBuilds","Android alone never activates the new package; the existing identity stays active");
        var iosReceipt=new IosReleaseReceipt(new string('1',64),iosPlan.SourceHash,iosPlan.SigningCertificateSha256,iosPlan.FirebaseSdkSha256,1,
            Guid.NewGuid().ToString("D"),Guid.NewGuid().ToString("D"),"projects/1234567/apps/"+iosPlan.IosAppId+"/releases/new-ios",true);
        await Reject<ArgumentException>(()=>versions.CompleteIosAsync(ios,iosReceipt with{SigningCertificateSha256=new string('0',64)},default),"A different iOS signing certificate cannot satisfy the activation gate");
        await Reject<ProvisioningLeaseLostException>(()=>versions.CompleteIosAsync(ios with{Token=Guid.NewGuid()},iosReceipt,default),"A foreign Mac lease cannot record the signed iOS result");
        await versions.CompleteIosAsync(ios,iosReceipt,default);
        var list=await versions.ListAsync(tenant,owner);Check(list.Count(x=>x.State=="Active")==1 && list.Single(x=>x.State=="Active").Request.Id==request.Id,"Both matching signed platform receipts atomically activate one new identity");
        Check(list.Single(x=>x.Legacy).State=="Retired" && list.Single(x=>x.Legacy).AndroidReceipt!.Resources["signingCertificateSha256"]==initialReceipt.Resources["signingCertificateSha256"],"The previous package and signing receipt remain available for history and old installations");
        Check(await versions.TryPromoteAsync(request.Id,tenant,default),"Activation replay is idempotent");

        await using var builds=new AndroidBuildQueue(connection);
        var binding=MobileIdentityBuildScopes.Android(list.Single(x=>x.State=="Active"),original,request.StoreUrl);
        var manual=await builds.EnqueueAsync(Guid.NewGuid(),tenant,app,deployment,2,default,binding);
        Check(manual.Scope==binding,"A manual build durably freezes the active package, Firebase app, endpoint and signing reference");
        await Reject<ProvisioningConflictException>(()=>builds.EnqueueAsync(Guid.NewGuid(),tenant,app,deployment,2,default,null),"A manual build cannot bypass the active identity with the legacy implicit target");
        var buildLease=(await builds.ClaimAsync(deployment,default))!;
        await Reject<InvalidOperationException>(()=>builds.CompleteAsync(buildLease,android with{Resources=new Dictionary<string,string>(android.Resources){["buildNumber"]="2",["signingCertificateSha256"]=new string('0',64)}},default),"A rebuild cannot complete with another package's signing certificate");
        await builds.CompleteAsync(buildLease,android with{Resources=new Dictionary<string,string>(android.Resources){["buildNumber"]="2"}},default);
        Check((await builds.ListAsync(tenant)).Single().Scope==binding,"The selected package reference remains in completed build history");

        // A later domain change has a separate fenced queue; its initial installation checkpoints stay unchanged.
        var nextDomainRequest=domainRequest with {Id=Guid.NewGuid(),StoreHost="next-"+tenant[..8]+".version.example.org",AdminHost="manage.next-"+tenant[..8]+".version.example.org"};
        await domains.CreateAsync(nextDomainRequest);
        await domains.CompleteCheckAsync((await domains.ClaimAsync(deployment,default))!,access,default);await domains.RequestVerificationAsync(nextDomainRequest.Id,owner);
        await domains.CompleteCheckAsync((await domains.ClaimAsync(deployment,default))!,access,default);
        var selected=TenantDomainSelection.From((await domains.GetAsync(nextDomainRequest.Id,owner))!);
        await using var changes=new DomainActivationQueue(connection);
        var migration=new DomainActivationPlan(selected.Id,tenant,owner,deployment,selected,domain.Id,initial.OriginalRequestSha256,app,false,null);
        var migrations=await Task.WhenAll(Enumerable.Range(0,8).Select(_=>changes.EnqueueAsync(migration)));
        Check(migrations.All(x=>x.Plan==migration),"Repeated activation requests preserve one immutable domain migration plan");
        Check(await changes.GetAsync(migration.Id,Guid.NewGuid())==null,"Another owner cannot inspect the domain migration");
        var domainLease=(await changes.ClaimAsync(deployment,default))!;
        await Reject<PostgresException>(()=>changes.CompleteAsync(domainLease,default),"A domain migration cannot complete before DNS, HTTPS, store update and primary-address checkpoints");
        await Reject<ProvisioningLeaseLostException>(()=>changes.CheckpointAsync(domainLease with{Token=Guid.NewGuid()},"dns",new("Cloudflare",new Dictionary<string,string>()),default),"An old or foreign activation worker cannot record progress");
        await changes.DeferAsync(domainLease,new("DomainDnsPropagationPending",TimeSpan.FromSeconds(30)),default);
        Check((await changes.GetAsync(migration.Id,owner))!.Attempts==0,"Waiting for public DNS propagation does not exhaust migration retry attempts");
        await Reject<TenantDomainException>(()=>domains.MarkActiveAsync(selected.Id,owner,tenant,deployment,default,Guid.NewGuid(),true),"A stale migration cannot replace an unrelated primary domain");
        Check((await domains.ListAsync(tenant,owner)).Single(x=>x.IsPrimary).Request.Id==domain.Id,"The active store domain is preserved after a stale migration attempt");
    }
}
