using DotLiquid;

public class ParamDrop : ILiquidizable
{
    public Type ReflectionType { get; set; }
    public string Decorator { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public bool IsOptional { get; set; }

    public ParamDrop(string decorator, string name, string type, Type reflectionType, bool isOptional)
    {
        Decorator = decorator;
        Name = name;
        Type = type;
        ReflectionType = reflectionType;
        IsOptional = isOptional;
    }

    public object ToLiquid()
    {
        return new
        {
            Decorator,
            Name,
            Type,
            IsOptional
        };
    }
}
