using System.Security.Cryptography;
using System.Text;
using System.Text.Json.Serialization;
using Npgsql;

namespace Platform.Provisioning;

/// <summary>Immutable content hashes, never storage paths or remote image URLs.</summary>
public sealed record MobileBrandingImages(string Logo,string Icon,string Splash)
{
    public void Validate()
    {
        if(new[]{Logo,Icon,Splash}.Any(x=>!IosReleasePlan.Digest(x)))throw new ArgumentException("Invalid branding image digest.");
    }
}
public sealed record MobileBranding(MobileBrandingImages Android,MobileBrandingImages Ios)
{
    public void Validate(){Android.Validate();Ios.Validate();}
    [JsonIgnore]
    public string Sha256=>Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(
        $"branding-v1\n{Android.Logo}\n{Android.Icon}\n{Android.Splash}\n{Ios.Logo}\n{Ios.Icon}\n{Ios.Splash}\n"))).ToLowerInvariant();
}

/// <summary>Small owner-uploaded public branding images shared by Linux and Mac builders.</summary>
public sealed class MobileBrandingStore(string connectionString):IAsyncDisposable
{
    private readonly NpgsqlDataSource db=NpgsqlDataSource.Create(connectionString);
    public const int MaximumBytes=5*1024*1024;
    internal static async Task InitializeAsync(NpgsqlConnection connection,NpgsqlTransaction transaction,CancellationToken ct)
    {
        await using var command=new NpgsqlCommand("""
            CREATE TABLE IF NOT EXISTS platform_provisioning.mobile_brand_images (
                tenant_id text NOT NULL REFERENCES platform_provisioning.jobs(tenant_id),
                sha256 text NOT NULL CHECK(sha256 ~ '^[a-f0-9]{64}$'),
                content bytea NOT NULL CHECK(octet_length(content) BETWEEN 24 AND 5242880),
                created_at timestamptz NOT NULL DEFAULT now(),
                PRIMARY KEY(tenant_id,sha256)
            );
            CREATE OR REPLACE FUNCTION platform_provisioning.immutable_mobile_brand_image_v1()
            RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $$
            BEGIN RAISE EXCEPTION 'Frozen branding content is immutable' USING ERRCODE='23514'; END;
            $$;
            DROP TRIGGER IF EXISTS immutable_mobile_brand_image_v1 ON platform_provisioning.mobile_brand_images;
            CREATE TRIGGER immutable_mobile_brand_image_v1 BEFORE UPDATE OR DELETE ON platform_provisioning.mobile_brand_images
                FOR EACH ROW EXECUTE FUNCTION platform_provisioning.immutable_mobile_brand_image_v1();
            """,connection,transaction);
        await command.ExecuteNonQueryAsync(ct);
    }
    public static (string Extension,int Width,int Height) Inspect(byte[] content)
    {
        if(content.Length is <24 or >MaximumBytes)throw new ArgumentException("Use a PNG or JPEG up to 5 MiB.");
        int width=0,height=0;string extension;
        if(content.AsSpan(0,8).SequenceEqual(new byte[]{137,80,78,71,13,10,26,10}) &&
            content.AsSpan(8,8).SequenceEqual(new byte[]{0,0,0,13,73,72,68,82}))
        {
            extension="png";width=System.Buffers.Binary.BinaryPrimitives.ReadInt32BigEndian(content.AsSpan(16,4));
            height=System.Buffers.Binary.BinaryPrimitives.ReadInt32BigEndian(content.AsSpan(20,4));
        }
        else if(content[0]==255 && content[1]==216)
        {
            extension="jpg";var index=2;
            while(index+3<content.Length)
            {
                if(content[index++]!=255)break;
                while(index<content.Length && content[index]==255)index++;
                if(index>=content.Length)break;var marker=content[index++];
                if(marker is 0xd9 or 0xda)break;
                if(marker is 0x01 or >=0xd0 and <=0xd8)continue;
                if(index+2>content.Length)break;
                var length=(content[index]<<8)|content[index+1];
                if(length<2 || index+length>content.Length)break;
                if(marker is 0xc0 or 0xc1 or 0xc2 && length>=8)
                {height=(content[index+3]<<8)|content[index+4];width=(content[index+5]<<8)|content[index+6];break;}
                index+=length;
            }
        }
        else throw new ArgumentException("Use a PNG or JPEG image.");
        if(width is <1 or >4096 || height is <1 or >4096)throw new ArgumentException("Image dimensions must be within 1–4096 pixels.");
        return(extension,width,height);
    }
    public async Task<string> PutAsync(string tenant,byte[] content,bool icon,CancellationToken ct)
    {
        IosReleasePlan.Tenant(tenant);var dimensions=Inspect(content);
        if(icon && (dimensions.Width!=dimensions.Height || dimensions.Width<512))throw new ArgumentException("Use a square app icon of at least 512 pixels; 1024 is recommended.");
        var digest=Convert.ToHexString(SHA256.HashData(content)).ToLowerInvariant();
        await using var command=db.CreateCommand("INSERT INTO platform_provisioning.mobile_brand_images(tenant_id,sha256,content) VALUES($1,$2,$3) ON CONFLICT DO NOTHING");
        command.Parameters.AddWithValue(tenant);command.Parameters.AddWithValue(digest);command.Parameters.AddWithValue(content);
        await command.ExecuteNonQueryAsync(ct);
        if(!(await ReadAsync(tenant,digest,ct)).SequenceEqual(content))throw new InvalidOperationException("Frozen branding bytes differ from their digest.");
        return digest;
    }
    public async Task<byte[]> ReadAsync(string tenant,string digest,CancellationToken ct)
    {
        IosReleasePlan.Tenant(tenant);if(!IosReleasePlan.Digest(digest))throw new ArgumentException("Invalid branding digest.");
        await using var command=db.CreateCommand("SELECT content FROM platform_provisioning.mobile_brand_images WHERE tenant_id=$1 AND sha256=$2");
        command.Parameters.AddWithValue(tenant);command.Parameters.AddWithValue(digest);
        var bytes=await command.ExecuteScalarAsync(ct) as byte[]??throw new KeyNotFoundException("Restore the selected tenant branding image.");
        Inspect(bytes);
        if(Convert.ToHexString(SHA256.HashData(bytes)).ToLowerInvariant()!=digest)throw new InvalidOperationException("Frozen branding content changed.");
        return bytes;
    }
    public ValueTask DisposeAsync()=>db.DisposeAsync();
}
