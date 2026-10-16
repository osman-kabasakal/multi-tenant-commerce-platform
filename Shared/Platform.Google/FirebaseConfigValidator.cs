using System.Text.Json.Nodes;
using System.Xml;
using System.Xml.Linq;

namespace Platform.Google;

public static class FirebaseConfigValidator
{
    public static void Validate(TenantFirebaseConfiguration config)
    {
        if (config.IosPushTransport is not ("Fcm" or "Apns") || config.IosPushTransport == "Apns" &&
            (config.IosDevelopmentTeam == null || !System.Text.RegularExpressions.Regex.IsMatch(config.IosDevelopmentTeam, "^[A-Z0-9]{10}\\z")))
            throw new InvalidOperationException("Invalid tenant iOS push transport or Apple team.");
        var android = JsonNode.Parse(config.AndroidConfigJson) as JsonObject
            ?? throw new InvalidOperationException("Invalid Android Firebase configuration.");
        var clients = android["client"] as JsonArray;
        if (android["project_info"]?["project_id"]?.GetValue<string>() != config.ProjectId ||
            android["project_info"]?["project_number"]?.GetValue<string>() != config.ProjectNumber ||
            clients == null || !clients.OfType<JsonObject>().Any(c =>
                c["client_info"]?["mobilesdk_app_id"]?.GetValue<string>() == config.AndroidAppId &&
                c["client_info"]?["android_client_info"]?["package_name"]?.GetValue<string>() == config.AndroidPackageName))
            throw new InvalidOperationException("Android Firebase configuration belongs to a different app or project.");
        using var input = new StringReader(config.IosConfigPlist);
        using var reader = XmlReader.Create(input, new XmlReaderSettings { DtdProcessing = DtdProcessing.Ignore, XmlResolver = null, MaxCharactersInDocument = 2 * 1024 * 1024 });
        var entries = XDocument.Load(reader).Root?.Element("dict")?.Elements().ToArray()
            ?? throw new InvalidOperationException("Invalid iOS Firebase configuration.");
        Dictionary<string, string> plist = [];
        for (var i = 0; i < entries.Length - 1; i++)
            if (entries[i].Name.LocalName == "key") plist.Add(entries[i].Value, entries[++i].Value);
        if (plist.GetValueOrDefault("PROJECT_ID") != config.ProjectId || plist.GetValueOrDefault("GCM_SENDER_ID") != config.ProjectNumber ||
            plist.GetValueOrDefault("GOOGLE_APP_ID") != config.IosAppId || plist.GetValueOrDefault("BUNDLE_ID") != config.IosBundleId)
            throw new InvalidOperationException("iOS Firebase configuration belongs to a different app or project.");
    }
}
