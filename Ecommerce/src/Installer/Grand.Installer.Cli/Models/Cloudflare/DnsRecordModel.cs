using System.Text.Json.Serialization;

namespace Grand.Installer.Cli.Models.Cloudflare;

public class DnsRecordModel
{
    [JsonPropertyName("comment")]
    public string Comment { get; set; }

    [JsonPropertyName("content")]
    public string Content { get; set; }

    [JsonPropertyName("name")]
    public string Name { get; set; }

    [JsonPropertyName("proxied")]
    public bool Proxied { get; set; }

    [JsonPropertyName("settings")]
    public Settings Settings { get; set; }

    [JsonPropertyName("tags")]
    public List<string> Tags { get; set; }

    [JsonPropertyName("ttl")]
    public int Ttl { get; set; }

    [JsonPropertyName("type")]
    public string Type { get; set; }
}

public class Settings
{
    [JsonPropertyName("ipv4_only")]
    public bool Ipv4Only { get; set; }

    [JsonPropertyName("ipv6_only")]
    public bool Ipv6Only { get; set; }
}


public class Account
    {
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }
    }

    public class Meta
    {
        [JsonPropertyName("cdn_only")]
        public bool CdnOnly { get; set; }

        [JsonPropertyName("custom_certificate_quota")]
        public int CustomCertificateQuota { get; set; }

        [JsonPropertyName("dns_only")]
        public bool DnsOnly { get; set; }

        [JsonPropertyName("foundation_dns")]
        public bool FoundationDns { get; set; }

        [JsonPropertyName("page_rule_quota")]
        public int PageRuleQuota { get; set; }

        [JsonPropertyName("phishing_detected")]
        public bool PhishingDetected { get; set; }

        [JsonPropertyName("step")]
        public int Step { get; set; }
    }

    public class Owner
    {
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("type")]
        public string Type { get; set; }
    }

    public class DnsZoneModel
    {
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("account")]
        public Account Account { get; set; }

        [JsonPropertyName("activated_on")]
        public DateTime ActivatedOn { get; set; }

        [JsonPropertyName("created_on")]
        public DateTime CreatedOn { get; set; }

        [JsonPropertyName("development_mode")]
        public int DevelopmentMode { get; set; }

        [JsonPropertyName("meta")]
        public Meta Meta { get; set; }

        [JsonPropertyName("modified_on")]
        public DateTime ModifiedOn { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("name_servers")]
        public List<string> NameServers { get; set; }

        [JsonPropertyName("original_dnshost")]
        public string OriginalDnshost { get; set; }

        [JsonPropertyName("original_name_servers")]
        public List<string> OriginalNameServers { get; set; }

        [JsonPropertyName("original_registrar")]
        public string OriginalRegistrar { get; set; }

        [JsonPropertyName("owner")]
        public Owner Owner { get; set; }

        [JsonPropertyName("paused")]
        public bool Paused { get; set; }

        [JsonPropertyName("status")]
        public string Status { get; set; }

        [JsonPropertyName("type")]
        public string Type { get; set; }

        [JsonPropertyName("vanity_name_servers")]
        public List<string> VanityNameServers { get; set; }
    }