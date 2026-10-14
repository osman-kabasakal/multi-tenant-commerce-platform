using System.Text.Json.Serialization;

namespace Authentication.Keycloak.Models;


public class Appclips
{
    [JsonPropertyName("apps")] public List<string> Apps { get; set; } = new List<string>();
}

public class Applinks
{
    [JsonPropertyName("details")] public List<Detail> Details { get; set; } = new List<Detail>();
}


public class Detail
{
    [JsonPropertyName("appIDs")]
    public List<string> AppIDs { get; set; } = new List<string>();

    [JsonPropertyName("components")]
    public List<KeyValuePair<string,object>> Components { get; set; } = new List<KeyValuePair<string,object>>();
    
    [JsonPropertyName("paths")]
    public List<string> Paths { get; set; } = new List<string>();
}

public class IosUniversalLinkJsonModel
{
    [JsonPropertyName("applinks")]
    public Applinks? Applinks { get; set; }

    [JsonPropertyName("webcredentials")]
    public Webcredentials? Webcredentials { get; set; }

    [JsonPropertyName("appclips")]
    public Appclips? Appclips { get; set; }
}

public class Webcredentials
{
    [JsonPropertyName("apps")]
    public List<string> Apps { get; set; }
}