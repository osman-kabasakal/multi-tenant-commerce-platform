using Npgsql;
using Platform.Provisioning;

internal static class AndroidBuildQueueFixture
{
    private static void Check(bool ok,string message){if(!ok)throw new Exception(message);Console.WriteLine("PASS: "+message);}
    private static async Task Reject<T>(Func<Task> action)where T:Exception
    {try{await action();}catch(T){return;}throw new Exception("A forbidden Android queue operation succeeded.");}
    internal static async Task RunAsync(PostgresProvisioningQueue parents,string connection,TenantProvisioningRequest template)
    {
        var tenant=Guid.NewGuid().ToString("N");
        var request=template with{TenantId=tenant,Slug="android-rebuild-"+tenant[..8],DeploymentId="android-build-fixture",MobileReleaseProfile="AndroidAppDistribution"};
        await parents.EnqueueAsync(request);
        await using var db=new NpgsqlConnection(connection);await db.OpenAsync();
        // Only this uniquely created test tenant is seeded. No native build or provider success is claimed by this queue fixture.
        var receipt=new ProvisioningStepResult("AndroidAppDistribution",new Dictionary<string,string>{["buildNumber"]="1",["androidApplicationId"]="com.example.tenant"+tenant,
            ["sourceHash"]=new('a',64),["sha256"]=new('b',64),["signingCertificateSha256"]=new('c',64),["release"]="projects/123456789/apps/1:123456789:android:abcdef/releases/fixture"});
        var steps=System.Text.Json.JsonSerializer.Serialize(new Dictionary<string,ProvisioningStepResult>{{"mobile-android-release",receipt}});
        await using(var prepare=new NpgsqlCommand("UPDATE platform_provisioning.jobs SET state='Succeeded',steps=$2::jsonb WHERE tenant_id=$1",db))
        {prepare.Parameters.AddWithValue(tenant);prepare.Parameters.AddWithValue(steps);await prepare.ExecuteNonQueryAsync();}
        await using var queue=new AndroidBuildQueue(connection);await using var replica=new AndroidBuildQueue(connection);
        var id=Guid.NewGuid();var app=Guid.NewGuid();
        var jobs=await Task.WhenAll(Enumerable.Range(0,12).Select(i=>(i%2==0?queue:replica).EnqueueAsync(id,tenant,app,request.DeploymentId!,2)));
        Check(jobs.All(j=>j.Id==id && j.BuildNumber==2) && (await queue.ListAsync(tenant)).Count==1,"Concurrent retries across replicas enqueue one Android version");
        await Reject<ProvisioningConflictException>(()=>queue.EnqueueAsync(Guid.NewGuid(),tenant,app,request.DeploymentId!,2));
        await Reject<ProvisioningConflictException>(()=>queue.EnqueueAsync(Guid.NewGuid(),tenant,app,"foreign",3));
        Check(await queue.ClaimAsync("foreign",default)==null,"A worker from another deployment cannot claim a manual Android release");
        var claims=await Task.WhenAll(Enumerable.Range(0,12).Select(i=>(i%2==0?queue:replica).ClaimAsync(request.DeploymentId!,default)));
        var lease=claims.Single(c=>c!=null)!;Check(claims.Count(c=>c!=null)==1,"Concurrent Android workers obtain only one fenced claim");
        await using(var expire=new NpgsqlCommand("UPDATE platform_provisioning.android_build_jobs SET lease_until=now()-interval '1 second' WHERE id=$1",db))
        {expire.Parameters.AddWithValue(id);await expire.ExecuteNonQueryAsync();}
        var renewed=(await replica.ClaimAsync(request.DeploymentId!,default))!;
        await Reject<ProvisioningLeaseLostException>(()=>queue.CompleteAsync(lease,receipt with{Resources=new Dictionary<string,string>{{"buildNumber","2"}}},default));
        await replica.CompleteAsync(renewed,receipt with{Resources=new Dictionary<string,string>(receipt.Resources){{"fileSize","12"}}.Select(p=>new KeyValuePair<string,string>(p.Key,p.Key=="buildNumber"?"2":p.Value)).ToDictionary(p=>p.Key,p=>p.Value)},default);
        await Reject<PostgresException>(async()=>{await using var mutate=new NpgsqlCommand("UPDATE platform_provisioning.android_build_jobs SET receipt='{}'::jsonb WHERE id=$1",db);mutate.Parameters.AddWithValue(id);await mutate.ExecuteNonQueryAsync();});
        Check((await replica.ListAsync(tenant)).Single().State=="Succeeded","A recovered Android worker persists an immutable completed receipt");
        await Reject<ProvisioningConflictException>(()=>queue.EnqueueAsync(Guid.NewGuid(),tenant,app,request.DeploymentId!,2));
        var next=await queue.EnqueueAsync(Guid.NewGuid(),tenant,app,request.DeploymentId!,3);
        Check(next.BuildNumber==3,"The next Android release increments the original version monotonically");
    }
}
