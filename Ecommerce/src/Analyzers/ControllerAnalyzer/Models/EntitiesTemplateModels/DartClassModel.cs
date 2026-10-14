using DotLiquid;
using System;

namespace ControllerAnalyzer.Models.EntitiesTemplateModels;
public interface IDartModel
{
    public string RelativePath { get; set; }   
    public string ClassName { get; set; }
    public string FileName { get; set; }
}
public class DartClassModel:Drop, IDartModel
{
    public string ClassName { get; set; }
    public List<DartProperty> Properties { get; set; }
    public List<string> Imports { get; set; }
    public bool IsFreezed { get; set; }
    public string FileName { get; set; }
    public string RelativePath { get; set; }
}

public class DartProperty : ILiquidizable
{
    public string Name { get; set; }
    public string DartType { get; set; }
    public string OriginalName { get; set; }
    public bool IsNullable { get; set; }
    public string DefaultValue { get; set; }

    public object ToLiquid()
    {
        return new
        {
            Name,
            DartType,
            OriginalName,
            IsNullable,
            DefaultValue
        };
    }
}

public class DartEnumModel: Drop, IDartModel
{
    public string ClassName { get; set; }
    public string FileName { get; set; }
    public string EnumName { get; set; }
    public List<DartEnumValue> Values { get; set; }
    public string RelativePath { get; set; }
}

public class DartEnumValue: ILiquidizable
{
    public string Name { get; set; }
    public int Value { get; set; }

    public object ToLiquid()
    {
        return new { Name, Value };
    }
}

public class FromJsonTemplateModel: Drop
{
    public FromJsonTemplateModel()
    {
        ClassModels = new List<DartClassModel>();
    }
    public List<DartClassModel> ClassModels { get; set; }
}