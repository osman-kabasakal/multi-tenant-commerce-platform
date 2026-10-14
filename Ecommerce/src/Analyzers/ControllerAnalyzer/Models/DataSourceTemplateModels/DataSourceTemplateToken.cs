using DotLiquid;
using System;

namespace ControllerAnalyzer.Models.DataSourceTemplateModels;

public class DataSourceTemplateToken: Drop
{
    public DataSourceTemplateToken(
        DartFileInfoDrop dartFileInfo,
        List<EndpointDrop> endpoints)
    {
        DartFileInfo = dartFileInfo;
        Endpoints = endpoints;
    }
    
    public DartFileInfoDrop DartFileInfo { get; set; }

    public List<EndpointDrop> Endpoints { get; set; }
}
