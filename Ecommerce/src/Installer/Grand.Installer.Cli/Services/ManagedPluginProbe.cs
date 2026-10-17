using System.Text.RegularExpressions;
using System.Xml.Linq;
using Grand.Infrastructure.Plugins;
using Grand.SharedKernel.Extensions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Grand.Installer.Cli.Services;

public static class ManagedPluginProbe
{
    // Offline: execute the real loader against a published target, without starting its host or opening a database.
    public static void Verify(string directory,string buildType)
    {
        if(buildType is not ("Frontend" or "Backend" or "Installer" or "Background" or "Uploader"))
            throw new ArgumentException("Choose an explicit plugin BuildType.");
        CommonPath.BaseDirectory=Path.GetFullPath(directory);
        var manifest=XDocument.Load(Path.Combine(AppContext.BaseDirectory,"App_Data","ManagedTenantPlugins.xml"));
        var expected=manifest.Descendants("ManagedTenantPlugin")
            .Where(x=>x.Element("Category")!.Value=="Plugins" || buildType!="Frontend").ToArray();
        var values=new Dictionary<string,string?> {
            ["Extensions:InstalledPlugins"]=string.Join(',',expected.Select(x=>x.Element("SystemName")!.Value)),
            ["Extensions:PluginSkipLoadingPattern"]="^(?!(?:"+string.Join('|',expected.Select(x=>Regex.Escape(x.Attribute("Include")!.Value)))+")\\.dll$).*",
            ["Extensions:PluginShadowCopy"]="false"
        };
        var services=new ServiceCollection();services.AddLogging();
        PluginManager.Load(services.AddMvcCore(),new ConfigurationBuilder().AddInMemoryCollection(values).Build());
        var loaded=PluginManager.ReferencedPlugins.ToArray();
        var actual=loaded.Select(x=>x.SystemName).OrderBy(x=>x,StringComparer.Ordinal).ToArray();
        var names=expected.Select(x=>x.Element("SystemName")!.Value).OrderBy(x=>x,StringComparer.Ordinal).ToArray();
        if(!actual.SequenceEqual(names) || loaded.Any(x=>!x.Installed || x.PluginType==null))
            throw new InvalidOperationException("The published target did not load its complete required plugin set.");
        Console.WriteLine("PASS: "+buildType+" loaded "+actual.Length+" committed plugins and their runtime types without network access.");
    }
}
