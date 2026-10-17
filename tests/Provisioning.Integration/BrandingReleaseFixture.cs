using Npgsql;
using Platform.Provisioning;

internal static class BrandingReleaseFixture
{
    static void Check(bool value,string message){if(!value)throw new Exception("FAILED: "+message);Console.WriteLine("PASS: "+message);}
    static async Task Reject<T>(Func<Task> action,string message)where T:Exception{try{await action();}catch(T){Check(true,message);return;}throw new Exception("FAILED: "+message);}
    public static async Task RunAsync(string ownerConnection,string saasConnection,string workerConnection,ProvisioningJob original,IosReleasePlan initial)
    {
        var tenant=original.Request.TenantId;var app=Guid.NewGuid();var owner=Guid.NewGuid();
        await using var identities=new MobileIdentityRegistry(saasConnection);
        var active=await identities.EnsureInitialAsync(original,app,owner,default);
        await using var uploads=new MobileBrandingStore(saasConnection);await using var downloads=new MobileBrandingStore(workerConnection);
        // Queue/storage fixture bytes only. Actual raster decoding and native build checks are separate.
        var png=new byte[32];new byte[]{137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82}.CopyTo(png,0);png[18]=2;png[22]=2;
        var digest=await uploads.PutAsync(tenant,png,true,default);
        var brand=new MobileBranding(new(digest,digest,digest),new(digest,digest,digest));
        Check((await downloads.ReadAsync(tenant,digest,default)).SequenceEqual(png),"The restricted Mac role reads the exact branding bytes frozen by the portal role");
        await Reject<KeyNotFoundException>(()=>downloads.ReadAsync(Guid.NewGuid().ToString("N"),digest,default),"A different tenant cannot resolve an image by guessing its known digest");
        await using var ownerDb=new NpgsqlConnection(ownerConnection);await ownerDb.OpenAsync();
        async Task Sql(string sql,params object[] values){await using var c=new NpgsqlCommand(sql,ownerDb);foreach(var value in values)c.Parameters.Add(new NpgsqlParameter{Value=value});await c.ExecuteNonQueryAsync();}
        await Reject<PostgresException>(()=>Sql("UPDATE platform_provisioning.mobile_brand_images SET content=content WHERE tenant_id=$1",tenant),"Even an owner cannot rewrite frozen branding content");
        await Reject<PostgresException>(()=>Sql("DELETE FROM platform_provisioning.mobile_brand_images WHERE tenant_id=$1",tenant),"Frozen branding cannot be deleted underneath retained release plans");
        var scope=MobileIdentityBuildScopes.Android(active,original,initial.StoreUrl) with {Branding=brand};
        var id=Guid.NewGuid();var number=initial.BuildNumber+1;
        var plan=initial with {ReleaseId=id,MobileIdentityId=active.Request.Id,BuildNumber=number,Branding=brand};
        await using var android=new AndroidBuildQueue(saasConnection);await using var androidWorker=new AndroidBuildQueue(workerConnection);
        await using var ios=new IosBuildQueue(workerConnection);
        var rows=await Task.WhenAll(Enumerable.Range(0,8).Select(_=>android.EnqueueAsync(id,tenant,app,initial.DeploymentId,number,default,scope,plan)));
        Check(rows.All(x=>x.Id==id) && (await ios.ListAsync(tenant)).Count==1,"Concurrent portal retries create one atomic Android and iOS release pair");
        var identity=new IosWorkerIdentity(plan.DeploymentId,plan.DevelopmentTeam,plan.SigningCertificateSha256,plan.SourceHash);
        Check(await ios.ClaimAsync(identity,TimeSpan.FromMinutes(1),default)==null,"The Mac does not build a paired release before its Android artifact succeeds");
        await Reject<ProvisioningConflictException>(()=>android.EnqueueAsync(id,tenant,app,plan.DeploymentId,number,default,scope,plan with {SourceHash=new string('d',64)}),"A repeated request cannot change its frozen iOS source");
        var lease=(await androidWorker.ClaimAsync(plan.DeploymentId,default))!;
        var receipt=new ProvisioningStepResult("AndroidAppDistribution",new Dictionary<string,string>{["buildNumber"]=number.ToString(),["androidApplicationId"]=scope.AndroidPackageName,
            ["androidAppId"]=scope.AndroidAppId,["signingCertificateSha256"]=scope.CertificateSha256,["storeUrl"]=scope.StoreUrl,["brandingSha256"]=brand.Sha256});
        await androidWorker.CompleteAsync(lease,receipt,default);
        await Reject<ProvisioningConflictException>(()=>android.EnqueueAsync(Guid.NewGuid(),tenant,app,plan.DeploymentId,number+1,default,scope),"A pending iOS release blocks a competing subsequent version in the database");
        Check(await ios.ClaimAsync(identity with {SourceHash=new string('e',64)},TimeSpan.FromMinutes(1),default)==null,"A Mac with another source revision cannot claim the branded iOS release");
        var first=(await ios.ClaimAsync(identity,TimeSpan.FromMinutes(1),default))!;
        Check(first.Job.Plan==plan,"The Mac receives the frozen package, Firebase, certificate, version and branding snapshot");
        await Sql("UPDATE platform_provisioning.ios_build_jobs SET lease_until=now()-interval '1 second' WHERE id=$1",id);
        var winner=(await ios.ClaimAsync(identity,TimeSpan.FromMinutes(1),default))!;
        var built=new IosReleaseReceipt(new string('f',64),plan.SourceHash,plan.SigningCertificateSha256,plan.FirebaseSdkSha256,number,
            "11111111-1111-1111-1111-111111111111","22222222-2222-2222-2222-222222222222",$"projects/{plan.ProjectNumber}/apps/{plan.IosAppId}/releases/manual",true){BrandingSha256=brand.Sha256};
        await Reject<ProvisioningLeaseLostException>(()=>ios.CompleteAsync(first,built,default),"An expired Mac cannot commit a subsequent iOS receipt");
        await Reject<ArgumentException>(()=>ios.CompleteAsync(winner,built with {BrandingSha256=null},default),"A native receipt missing the selected branding is rejected");
        await Reject<ProvisioningLeaseLostException>(()=>ios.CompleteAsync(winner with {Job=winner.Job with {Plan=plan with {BuildNumber=number+1}}},built with {BuildNumber=number+1},default),"A valid claim cannot commit a receipt against a substituted immutable build plan");
        await ios.CompleteAsync(winner,built,default);
        await Reject<PostgresException>(()=>Sql("UPDATE platform_provisioning.ios_build_jobs SET receipt='{}'::jsonb WHERE id=$1",id),"Completed branded iOS receipts remain immutable");
        await using var initialQueue=new PostgresIosReleaseQueue(workerConnection);
        Check((await initialQueue.GetAsync(tenant))?.Plan==initial && (await initialQueue.GetAsync(tenant))?.State=="Succeeded","A subsequent version preserves the initial signed iOS release and its original plan");
        Check((await identities.GetAsync(active.Request.Id,owner))?.State=="Active","A branding refresh preserves the active application identity");
    }
}
