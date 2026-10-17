using Npgsql;
using Platform.Provisioning;

internal static class TenantDomainRegistryFixture
{
    public static async Task RunAsync(string connection)
    {
        static void Check(bool value,string message) { if(!value)throw new Exception("FAILED: "+message);Console.WriteLine("PASS: "+message); }
        static async Task Reject<T>(Func<Task> action,string message) where T:Exception {try{await action();}catch(T){Console.WriteLine("PASS: "+message);return;}throw new Exception("FAILED: "+message);}
        await using var registry=new TenantDomainRegistry(connection);
        var owner=Guid.NewGuid(); var id=Guid.NewGuid();var tenant=Guid.NewGuid().ToString("N");
        var request=new TenantDomainRequest(id,tenant,owner,"domain-integration","shop.business.example.net","manage.shop.business.example.net");
        var copies=await Task.WhenAll(Enumerable.Range(0,24).Select(_=>registry.CreateAsync(request)));
        Check(copies.All(x=>x.Challenge==copies[0].Challenge),"Concurrent domain requests keep one immutable ownership challenge");
        Check(await registry.GetAsync(id,Guid.NewGuid())==null,"Another portal owner cannot read a domain challenge");
        await Reject<ProvisioningConflictException>(()=>registry.CreateAsync(request with{OwnerSubject=Guid.NewGuid()}),"Another owner cannot reuse the domain request id");
        await Reject<ProvisioningConflictException>(()=>registry.CreateAsync(request with{StoreHost="other.business.example.net",AdminHost="manage.other.business.example.net"}),"A replay cannot change either requested hostname");
        await Reject<TenantDomainException>(()=>registry.RequireVerifiedAsync(id,owner,tenant,request.DeploymentId),"Pending API access does not authorize enrollment");
        var claims=await Task.WhenAll(Enumerable.Range(0,8).Select(_=>registry.ClaimAsync(request.DeploymentId,default)));
        Check(claims.Count(x=>x!=null)==1,"Concurrent domain check workers obtain one fenced claim");var lease=claims.Single(x=>x!=null)!;
        var access=new TenantDomainAccess(new string('a',32),"business.example.net");
        await Reject<ProvisioningLeaseLostException>(()=>registry.CompleteCheckAsync(lease with{Token=Guid.NewGuid()},access,default),"A foreign domain worker cannot record verification");
        await registry.CompleteCheckAsync(lease,access,default);
        Check((await registry.GetAsync(id,owner))!.State=="AwaitingOwnership","API-access check waits for separate DNS ownership proof");
        await Reject<TenantDomainException>(()=>registry.RequireVerifiedAsync(id,owner,tenant,request.DeploymentId),"Cloudflare API access alone cannot authorize enrollment");
        Check(!await registry.RequestVerificationAsync(id,Guid.NewGuid()),"Another owner cannot trigger DNS proof verification");
        Check(await registry.RequestVerificationAsync(id,owner),"The authenticated owner can request DNS proof verification");
        var proof=(await registry.ClaimAsync(request.DeploymentId,default))!;
        await registry.CompleteCheckAsync(proof,access,default);
        Check((await registry.RequireVerifiedAsync(id,owner,tenant,request.DeploymentId)).State=="Verified","Successful proof reserves the Cloudflare zone for the exact tenant");
        await Reject<TenantDomainException>(()=>registry.RequireVerifiedAsync(id,owner,Guid.NewGuid().ToString("N"),request.DeploymentId),"A verified domain cannot be attached to a different business");
        var other=request with{Id=Guid.NewGuid(),TenantId=Guid.NewGuid().ToString("N"),OwnerSubject=Guid.NewGuid(),StoreHost="second.business.example.net",AdminHost="manage.second.business.example.net"};
        await registry.CreateAsync(other);var initial=(await registry.ClaimAsync(other.DeploymentId,default))!;await registry.CompleteCheckAsync(initial,access,default);
        await registry.RequestVerificationAsync(other.Id,other.OwnerSubject);var another=(await registry.ClaimAsync(other.DeploymentId,default))!;
        await Reject<TenantDomainException>(()=>registry.CompleteCheckAsync(another,access,default),"A second business cannot claim another hostname in the same Cloudflare zone");
        await registry.FailCheckAsync(another,"DomainAlreadyAssigned",true,default);
        Check((await registry.GetAsync(other.Id,other.OwnerSubject))!.State=="Failed","Rejected domain ownership is durable and exposes a safe error code");
        await using var db=new NpgsqlConnection(connection);await db.OpenAsync();
        await using(var count=new NpgsqlCommand("SELECT count(*) FROM platform_provisioning.domain_zone_claims",db)) Check((long)(await count.ExecuteScalarAsync())! ==1,"Only one tenant holds the verified zone claim");
        await using var change=new NpgsqlCommand("UPDATE platform_provisioning.domain_requests SET owner_subject=$1 WHERE id=$2",db);change.Parameters.AddWithValue(Guid.NewGuid());change.Parameters.AddWithValue(id);
        await Reject<PostgresException>(async()=>await change.ExecuteNonQueryAsync(),"Database trigger prevents changing the owner after a domain request exists");
    }
}
