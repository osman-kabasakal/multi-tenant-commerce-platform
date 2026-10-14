using System.Text.Json.Serialization;

namespace Grand.Data.Uploader.Models;

public class MongoDatabaseUserRM
{
}

public class Label
{
    [JsonPropertyName("key")] public string? Key { get; set; }

    [JsonPropertyName("value")] public string? Value { get; set; }
}

public class Link
{
    [JsonPropertyName("href")] public string? Href { get; set; }

    [JsonPropertyName("rel")] public string? Rel { get; set; }
}

public class MongoDatabaseUser
{
    public MongoDatabaseUser()
    {
        Labels = new List<Label>();
        Links = new List<Link>();
        Roles = new List<Role>();
        Scopes = new List<Scope>();
    }

    [JsonPropertyName("awsIAMType")] public string? AwsIAMType { get; set; }

    [JsonPropertyName("databaseName")] public string? DatabaseName { get; set; }

    [JsonPropertyName("deleteAfterDate")] public DateTime? DeleteAfterDate { get; set; }

    [JsonPropertyName("description")] public string? Description { get; set; }

    [JsonPropertyName("labels")] public List<Label> Labels { get; set; }

    [JsonPropertyName("ldapAuthType")] public string? LdapAuthType { get; set; }

    [JsonPropertyName("links")] public List<Link> Links { get; set; }

    [JsonPropertyName("oidcAuthType")] public string? OidcAuthType { get; set; }

    [JsonPropertyName("roles")] public List<Role> Roles { get; set; }

    [JsonPropertyName("scopes")] public List<Scope> Scopes { get; set; }

    [JsonPropertyName("username")] public string? Username { get; set; }

    [JsonPropertyName("x509Type")] public string? X509Type { get; set; }
}

public class Role
{
    [JsonPropertyName("collectionName")] public string? CollectionName { get; set; }

    [JsonPropertyName("databaseName")] public string? DatabaseName { get; set; }

    [JsonPropertyName("roleName")] public string? RoleName { get; set; }
}

public class MongoAtlasListResponseBase<TResult>
{
    public MongoAtlasListResponseBase()
    {
        Links = new List<Link>();
        Results = new List<TResult>();
    }

    [JsonPropertyName("links")] public List<Link> Links { get; set; }

    [JsonPropertyName("results")] public List<TResult> Results { get; set; }

    [JsonPropertyName("totalCount")] public int TotalCount { get; set; }
}

public class Scope
{
    [JsonPropertyName("name")] public string? Name { get; set; }

    [JsonPropertyName("type")] public string? Type { get; set; }
}


public class CreateMongoDatabaseUserRequest
{
    public CreateMongoDatabaseUserRequest()
    {
        Roles = new List<Role>();
        Scopes = new List<Scope>();
    }
    [JsonPropertyName("awsIAMType")] public string? AwsIAMType { get; set; }

    [JsonPropertyName("databaseName")] public string? DatabaseName { get; set; }

    [JsonPropertyName("groupId")] public string? GroupId { get; set; }
    
    [JsonPropertyName("password")]
    public string? Password { get; set; }

    [JsonPropertyName("roles")] public List<Role> Roles { get; set; }

    [JsonPropertyName("scopes")] public List<Scope> Scopes { get; set; }

    [JsonPropertyName("username")] public string? Username { get; set; }
}


// Root myDeserializedClass = JsonSerializer.Deserialize<Root>(myJsonResponse);
    public class AnalyticsAutoScaling
    {
        [JsonPropertyName("compute")]
        public Compute? Compute { get; set; }

        [JsonPropertyName("diskGB")]
        public DiskGB? DiskGB { get; set; }
    }

    public class AnalyticsSpecs
    {
        [JsonPropertyName("diskSizeGB")]
        public double? DiskSizeGB { get; set; }

        [JsonPropertyName("nodeCount")]
        public int? NodeCount { get; set; }

        [JsonPropertyName("diskIOPS")]
        public int? DiskIOPS { get; set; }

        [JsonPropertyName("ebsVolumeType")]
        public string? EbsVolumeType { get; set; }

        [JsonPropertyName("instanceSize")]
        public string? InstanceSize { get; set; }
    }

    public class AutoScaling
    {
        [JsonPropertyName("compute")]
        public Compute? Compute { get; set; }

        [JsonPropertyName("diskGB")]
        public DiskGB? DiskGB { get; set; }
    }

    public class AwsPrivateLink
    {
        [JsonPropertyName("property1")]
        public string? Property1 { get; set; }

        [JsonPropertyName("property2")]
        public string? Property2 { get; set; }
    }

    public class AwsPrivateLinkSrv
    {
        [JsonPropertyName("property1")]
        public string? Property1 { get; set; }

        [JsonPropertyName("property2")]
        public string? Property2 { get; set; }
    }

    public class BiConnector
    {
        [JsonPropertyName("enabled")]
        public bool? Enabled { get; set; }

        [JsonPropertyName("readPreference")]
        public string? ReadPreference { get; set; }
    }

    public class Compute
    {
        [JsonPropertyName("enabled")]
        public bool? Enabled { get; set; }

        [JsonPropertyName("maxInstanceSize")]
        public string? MaxInstanceSize { get; set; }

        [JsonPropertyName("minInstanceSize")]
        public string? MinInstanceSize { get; set; }

        [JsonPropertyName("scaleDownEnabled")]
        public bool? ScaleDownEnabled { get; set; }
    }

    public class ConnectionStrings
    {
        public ConnectionStrings()
        {
            PrivateEndpoint = new List<PrivateEndpoint>();
        }

        [JsonPropertyName("awsPrivateLink")]
        public AwsPrivateLink? AwsPrivateLink { get; set; }

        [JsonPropertyName("awsPrivateLinkSrv")]
        public AwsPrivateLinkSrv? AwsPrivateLinkSrv { get; set; }

        [JsonPropertyName("private")]
        public string? Private { get; set; }

        [JsonPropertyName("privateEndpoint")]
        public List<PrivateEndpoint> PrivateEndpoint { get; set; }

        [JsonPropertyName("privateSrv")]
        public string? PrivateSrv { get; set; }

        [JsonPropertyName("standard")]
        public string? Standard { get; set; }

        [JsonPropertyName("standardSrv")]
        public string? StandardSrv { get; set; }
    }

    public class DiskGB
    {
        [JsonPropertyName("enabled")]
        public bool? Enabled { get; set; }
    }

    public class ElectableSpecs
    {
        [JsonPropertyName("diskSizeGB")]
        public double? DiskSizeGB { get; set; }

        [JsonPropertyName("diskIOPS")]
        public int? DiskIOPS { get; set; }

        [JsonPropertyName("ebsVolumeType")]
        public string? EbsVolumeType { get; set; }

        [JsonPropertyName("instanceSize")]
        public string? InstanceSize { get; set; }

        [JsonPropertyName("nodeCount")]
        public int? NodeCount { get; set; }
    }

    public class Endpoint
    {
        [JsonPropertyName("endpointId")]
        public string? EndpointId { get; set; }

        [JsonPropertyName("providerName")]
        public string? ProviderName { get; set; }

        [JsonPropertyName("region")]
        public string? Region { get; set; }
    }


    public class MongoDBEmployeeAccessGrant
    {
        public MongoDBEmployeeAccessGrant()
        {
            Links = new List<Link>();
        }
        [JsonPropertyName("expirationTime")]
        public DateTime? ExpirationTime { get; set; }

        [JsonPropertyName("grantType")]
        public string? GrantType { get; set; }

        [JsonPropertyName("links")]
        public List<Link> Links { get; set; }
    }

    public class PrivateEndpoint
    {
        public PrivateEndpoint()
        {
            Endpoints = new List<Endpoint>();
        }
        [JsonPropertyName("connectionString")]
        public string? ConnectionString { get; set; }

        [JsonPropertyName("endpoints")]
        public List<Endpoint> Endpoints { get; set; }

        [JsonPropertyName("srvConnectionString")]
        public string? SrvConnectionString { get; set; }

        [JsonPropertyName("srvShardOptimizedConnectionString")]
        public string? SrvShardOptimizedConnectionString { get; set; }

        [JsonPropertyName("type")]
        public string? Type { get; set; }
    }

    public class ReadOnlySpecs
    {
        [JsonPropertyName("diskSizeGB")]
        public double? DiskSizeGB { get; set; }

        [JsonPropertyName("nodeCount")]
        public int? NodeCount { get; set; }

        [JsonPropertyName("diskIOPS")]
        public int? DiskIOPS { get; set; }

        [JsonPropertyName("ebsVolumeType")]
        public string? EbsVolumeType { get; set; }

        [JsonPropertyName("instanceSize")]
        public string? InstanceSize { get; set; }
    }

    public class RegionConfig
    {
        [JsonPropertyName("electableSpecs")]
        public ElectableSpecs? ElectableSpecs { get; set; }

        [JsonPropertyName("priority")]
        public int? Priority { get; set; }

        [JsonPropertyName("providerName")]
        public string? ProviderName { get; set; }

        [JsonPropertyName("regionName")]
        public string? RegionName { get; set; }

        [JsonPropertyName("analyticsAutoScaling")]
        public AnalyticsAutoScaling? AnalyticsAutoScaling { get; set; }

        [JsonPropertyName("analyticsSpecs")]
        public AnalyticsSpecs? AnalyticsSpecs { get; set; }

        [JsonPropertyName("autoScaling")]
        public AutoScaling? AutoScaling { get; set; }

        [JsonPropertyName("readOnlySpecs")]
        public ReadOnlySpecs? ReadOnlySpecs { get; set; }
    }

    public class ReplicationSpec
    {
        public ReplicationSpec()
        {
            RegionConfigs = new List<RegionConfig>();
        }
        [JsonPropertyName("id")]
        public string? Id { get; set; }

        [JsonPropertyName("regionConfigs")]
        public List<RegionConfig> RegionConfigs { get; set; }

        [JsonPropertyName("zoneId")]
        public string? ZoneId { get; set; }

        [JsonPropertyName("zoneName")]
        public string? ZoneName { get; set; }
    }

    public class MongoAtlasClusterDetail
    {
        public MongoAtlasClusterDetail()
        {
            Labels = new List<Label>();
            Links = new List<Link>();
            ReplicationSpecs = new List<ReplicationSpec>();
            Tags = new List<Tag>();
        }
        
        [JsonPropertyName("acceptDataRisksAndForceReplicaSetReconfig")]
        public DateTime? AcceptDataRisksAndForceReplicaSetReconfig { get; set; }

        [JsonPropertyName("backupEnabled")]
        public bool? BackupEnabled { get; set; }

        [JsonPropertyName("biConnector")]
        public BiConnector? BiConnector { get; set; }

        [JsonPropertyName("clusterType")]
        public string? ClusterType { get; set; }

        [JsonPropertyName("configServerManagementMode")]
        public string? ConfigServerManagementMode { get; set; }

        [JsonPropertyName("configServerType")]
        public string? ConfigServerType { get; set; }

        [JsonPropertyName("connectionStrings")]
        public ConnectionStrings? ConnectionStrings { get; set; }

        [JsonPropertyName("createDate")]
        public DateTime? CreateDate { get; set; }

        [JsonPropertyName("diskWarmingMode")]
        public string? DiskWarmingMode { get; set; }

        [JsonPropertyName("encryptionAtRestProvider")]
        public string? EncryptionAtRestProvider { get; set; }

        [JsonPropertyName("featureCompatibilityVersion")]
        public string? FeatureCompatibilityVersion { get; set; }

        [JsonPropertyName("featureCompatibilityVersionExpirationDate")]
        public DateTime? FeatureCompatibilityVersionExpirationDate { get; set; }

        [JsonPropertyName("globalClusterSelfManagedSharding")]
        public bool? GlobalClusterSelfManagedSharding { get; set; }

        [JsonPropertyName("groupId")]
        public string? GroupId { get; set; }

        [JsonPropertyName("id")]
        public string? Id { get; set; }

        [JsonPropertyName("labels")]
        public List<Label> Labels { get; set; }

        [JsonPropertyName("links")]
        public List<Link> Links { get; set; }

        [JsonPropertyName("mongoDBEmployeeAccessGrant")]
        public MongoDBEmployeeAccessGrant? MongoDBEmployeeAccessGrant { get; set; }

        [JsonPropertyName("mongoDBMajorVersion")]
        public string? MongoDBMajorVersion { get; set; }

        [JsonPropertyName("mongoDBVersion")]
        public string? MongoDBVersion { get; set; }

        [JsonPropertyName("name")]
        public string? Name { get; set; }

        [JsonPropertyName("paused")]
        public bool? Paused { get; set; }

        [JsonPropertyName("pitEnabled")]
        public bool? PitEnabled { get; set; }

        [JsonPropertyName("redactClientLogData")]
        public bool? RedactClientLogData { get; set; }

        [JsonPropertyName("replicaSetScalingStrategy")]
        public string? ReplicaSetScalingStrategy { get; set; }

        [JsonPropertyName("replicationSpecs")]
        public List<ReplicationSpec> ReplicationSpecs { get; set; }

        [JsonPropertyName("rootCertType")]
        public string? RootCertType { get; set; }

        [JsonPropertyName("stateName")]
        public string? StateName { get; set; }

        [JsonPropertyName("tags")]
        public List<Tag> Tags { get; set; }

        [JsonPropertyName("terminationProtectionEnabled")]
        public bool? TerminationProtectionEnabled { get; set; }

        [JsonPropertyName("versionReleaseSystem")]
        public string? VersionReleaseSystem { get; set; }
    }

    public class Tag
    {
        [JsonPropertyName("key")]
        public string? Key { get; set; }

        [JsonPropertyName("value")]
        public string? Value { get; set; }
    }

