using DotLiquid;
using System;

namespace ControllerAnalyzer.Models.RepositoryTemplateModels;

public class RepositoryTemplateDrop : Drop
{
    public string FeatureName { get; set; }
    public List<string> Imports { get; set; }
    public List<EndpointDrop> Endpoints { get; set; }
}

public class EndpointDrop : Drop
{
    public string EntityType { get; set; }
    public string ActionName { get; set; }
    public string Url { get; set; }
    public List<ParamDrop> Params { get; set; }
}

public class ParamDrop : Drop
{
    public string Type { get; set; }
    public string Name { get; set; }
    public bool IsOptional { get; set; }
}