using DotLiquid;
using System.Collections.Generic;

public class EndpointDrop: ILiquidizable
{
    public string Method { get; set; }
    public string Path { get; set; }
    public bool IsExtra { get; set; }
    public string ResponseType { get; set; }
    public Type? ReflectionResponseType { get; set; }
    public string Name { get; set; }
    public List<ParamDrop> Params { get; set; }

    public EndpointDrop(string method, string path, bool isExtra, string responseType, Type? reflectionResponseType, string name, List<ParamDrop> @params)
    {
        Method = method;
        Path = path;
        IsExtra = isExtra;
        ResponseType = responseType;
        ReflectionResponseType = reflectionResponseType;
        Name = name;
        Params = @params;
    }

    public object ToLiquid()
    {
        return new
        {
            Method,
            Path,
            IsExtra,
            ResponseType,
            Name,
            Params
        };
    }
}
