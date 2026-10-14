using DotLiquid;
using System.Collections.Generic;

public class DartFileInfoDrop: Drop
{
    public string FeatureName { get; set; }
    public string Name { get; set; }
    public string InstanceName { get; set; }
    public List<string> Imports { get; set; }

    public DartFileInfoDrop(string featureName,string name, string instanceName, List<string> imports)
    {
        FeatureName = featureName;
        Name = name;
        InstanceName = instanceName;
        Imports = imports;
    }
}
