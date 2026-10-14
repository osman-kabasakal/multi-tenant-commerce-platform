using Grand.Infrastructure.TypeSearch;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Abstractions;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Routing.Patterns;
using Microsoft.CodeAnalysis.Diagnostics;
using System;
using System.Reflection;

namespace ControllerAnalyzer;

public class EndpointAnalyzer
{
    private readonly IReadOnlyList<ActionDescriptor> _endpointSources;
    private readonly LinkGenerator linkGenerator;
    private readonly ITypeSearcher typeSearcher;

    public EndpointAnalyzer(IReadOnlyList<ActionDescriptor> endpointSources,
    LinkGenerator linkGenerator,
    ITypeSearcher typeSearcher)
    {
        _endpointSources = endpointSources;
        this.linkGenerator = linkGenerator;
        this.typeSearcher = typeSearcher;
    }

    private readonly Dictionary<Type, string> _typeMap = new Dictionary<Type, string> {
            { typeof(string), "String" },
            { typeof(int), "int" },
            { typeof(double), "double" },
            { typeof(decimal), "double" },
            { typeof(float), "double" },
            { typeof(bool), "bool" },
            { typeof(DateTime), "DateTime" },
            { typeof(DateTimeOffset), "DateTime" },
            { typeof(TimeSpan), "Duration" },
            { typeof(Guid), "String" },
            { typeof(Uri), "String" },
            { typeof(byte), "int" },
            { typeof(sbyte), "int" },
            { typeof(short), "int" },
            { typeof(ushort), "int" },
            { typeof(uint), "int" },
            { typeof(long), "int" },
            { typeof(ulong), "int" },
            { typeof(char), "String" }
        };


    public string GenerateDartEndpoints(string controllerName, string methodName)
    {
        var stringBuilder = new StringBuilder();
        var endpoints = _endpointSources.OfType<ControllerActionDescriptor>().GroupBy(x => x.ControllerName);

        foreach (var controllerEndpoint in endpoints)
        {
            foreach (var endpoint in controllerEndpoint)
            {
                var methodInfo = endpoint.MethodInfo;
                if (methodInfo == null) continue;

                if ((!string.IsNullOrEmpty(controllerName) && methodInfo.DeclaringType.Name != controllerName) ||
                (!string.IsNullOrEmpty(methodName) && methodInfo.Name != methodName))
                {
                    continue;
                }

                var httpMethod = GetHttpMethod(endpoint);
                var route = endpoint.AttributeRouteInfo?.Template ?? $"/{endpoint.RouteValues["area"]}/{endpoint.RouteValues["controller"]}/{endpoint.RouteValues["action"]}".Replace("//", "/");
                var parameters = GetParameters(httpMethod, route, methodInfo, endpoint.Parameters);
                var returnType = GetReturnType(methodInfo);

                stringBuilder.AppendLine(GenerateDartEndpoint(httpMethod, route, parameters, returnType));
                stringBuilder.AppendLine();
            }

            stringBuilder.AppendLine("--------------------end_of_feature-------------------");
        }

        return stringBuilder.ToString();
    }

    private MethodInfo GetMethodInfo(RouteEndpoint endpoint)
    {
        return endpoint.Metadata
            .OfType<ControllerActionDescriptor>()
            .FirstOrDefault()
            ?.MethodInfo;
    }

    private string GetHttpMethod(ControllerActionDescriptor endpoint)
    {
        return endpoint.EndpointMetadata
            .OfType<HttpMethodMetadata>()
            .FirstOrDefault()
            ?.HttpMethods
            .FirstOrDefault() ?? "GET";
    }

    private List<(string name, string type, string source, bool isOptional)> GetParameters(
        string httpMethod,
        string route,
        MethodInfo methodInfo,
        IList<ParameterDescriptor> routePattern)
    {
        var parameters = new List<(string name, string type, string source, bool isOptional)>();
        var routeParameters = routePattern.Select(p => p.Name).ToList();

        foreach (var param in methodInfo.GetParameters())
        {
            var paramType = GetDartType(param.ParameterType);
            var paramName = param.Name ?? "";

            if (param.GetCustomAttribute<FromServicesAttribute>() != null)
                continue;


            if (param.GetCustomAttribute<FromBodyAttribute>() != null)
            {
                parameters.Add((paramName, paramType, "Body", param.IsOptional));
            }
            else if (param.GetCustomAttribute<FromQueryAttribute>() != null)
            {
                parameters.Add((paramName, paramType, "Query", param.IsOptional));
            }
            else if ((httpMethod == "GET" || httpMethod == "DELETE")
             && routeParameters.Contains(paramName))
            {
                if (route.Contains("{" + paramName + "}"))
                    parameters.Add((paramName, paramType, "Path", param.IsOptional));
                else
                    parameters.Add((paramName, paramType, "Query", param.IsOptional));
            }
            else
            {
                if (!param.ParameterType.IsPrimitive && param.ParameterType != typeof(string))
                    parameters.Add((paramName, paramType, "Body", param.IsOptional));
                else
                    parameters.Add((paramName, paramType, "Query", param.IsOptional));
            }
        }

        return parameters;
    }

    private string GetReturnType(MethodInfo methodInfo)
    {
        var returnType = methodInfo.ReturnType;

        if (returnType.IsGenericType)
        {
            if (returnType.GetGenericTypeDefinition() == typeof(Task<>))
            {
                returnType = returnType.GetGenericArguments()[0];
            }
            else if (returnType.GetGenericTypeDefinition() == typeof(ActionResult<>))
            {
                returnType = returnType.GetGenericArguments()[0];
            }

        }

        var controllerFileFormat = "/workspace/Repos/LocalBusinessEcommerce/BusinessEcommerce/Ecommerce/src/Web/Grand.Web/Controllers/{0}.cs";

        if (returnType == typeof(IActionResult) || returnType == typeof(Task<IActionResult>))
        {
            var anlyzerResult = ControllerAnalyzerCodeAnalysis.AnalyzeControllerActions(File.ReadAllText(string.Format(controllerFileFormat, methodInfo.DeclaringType.Name)), methodInfo.DeclaringType.Name, methodInfo.Name);
            if (anlyzerResult != null && anlyzerResult.Count > 0)
            {
                var analysis = anlyzerResult.FirstOrDefault();
                if (analysis.ReturnTypes.Count > 0 && analysis.ReturnTypes.Any(x => x.Split(":")[0].Trim() == "Json" || x.Split(":")[0].Trim() == "RedirectToRoute"))
                {
                    var viewreturnType = analysis.ReturnTypes.FirstOrDefault(x => x.Split(":")[0].Trim() == "View");
                    if (viewreturnType != null)
                    {
                        var returnModelType = viewreturnType.Split(":")[1].Trim();
                        if (returnModelType.StartsWith("null") || returnModelType.StartsWith("Anonymous") || returnModelType.StartsWith("Unknown"))
                        {
                            if (returnModelType.StartsWith("Anonymous"))
                                return "ApiResponse<Map<String,dynamic>>";
                            else if (returnModelType.StartsWith("null"))
                                return "dynamic";
                            else
                                return "ApiResponse<dynamic>";
                        }
                        var type = Type.GetType(returnModelType);
                        if (type != null)
                        {
                            return $"ApiResponse<{GetDartType(type)}>";
                        }

                        return "ApiResponse<dynamic>";
                    }
                    else
                    {
                        var jsonreturnType = analysis.ReturnTypes.FirstOrDefault(x => x.Split(":")[0].Trim() == "Json");
                        if (jsonreturnType != null)
                        {
                            var returnModelType = jsonreturnType.Split(":")[1].Trim();
                            if (returnModelType.StartsWith("null") || returnModelType.StartsWith("Anonymous") || returnModelType.StartsWith("Unknown"))
                            {
                                if (returnModelType.StartsWith("Anonymous"))
                                    return "ApiResponse<Map<String,dynamic>>";
                                else if (returnModelType.StartsWith("null"))
                                    return "dynamic";
                                else
                                    return "ApiResponse<dynamic>";
                            }
                            var type = Type.GetType(returnModelType);
                            if (type != null)
                            {
                                return $"ApiResponse<{GetDartType(type)}>";
                            }

                            return "ApiResponse<dynamic>";
                        }
                    }
                }
                else
                {
                    var viewreturnType = analysis.ReturnTypes.FirstOrDefault(x => x.Split(":")[0].Trim() == "View" || x.Split(":")[0].Trim() == "Json");
                    if (viewreturnType != null)
                    {
                        var returnModelType = viewreturnType.Split(":")[1].Trim();
                        if (returnModelType.StartsWith("null") || returnModelType.StartsWith("Anonymous") || returnModelType.StartsWith("Unknown"))
                        {
                            return "dynamic";
                        }
                        var reflectionReturnType = Type.GetType(returnModelType);
                        if (reflectionReturnType != null)
                        {
                            return GetDartType(reflectionReturnType);
                        }
                        return "dynamic";
                    }
                }
                return "dynamic";
            }
        }

        return GetDartType(returnType);
    }


    private bool IsNullableType(Type type)
    {
        return type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>);
    }

    private string GetDartType(Type type)
    {
        if (type == null)
            return "dynamic";

        // Handle nullable types
        if (IsNullableType(type))
        {
            var underlyingType = Nullable.GetUnderlyingType(type);
            return GetDartType(underlyingType);
        }

        // Handle enums
        if (type.IsEnum)
        {
            return type.Name;
        }

        // Handle arrays
        if (type.IsArray)
        {
            var elementType = type.GetElementType();
            return $"List<{GetDartType(elementType)}>";
        }

        // Handle generic collections
        if (type.IsGenericType)
        {
            var genericTypeDef = type.GetGenericTypeDefinition();
            var genericArgs = type.GetGenericArguments();

            // Handle Dictionary
            if (genericTypeDef == typeof(Dictionary<,>) ||
                genericTypeDef == typeof(IDictionary<,>))
            {
                var keyType = GetDartType(genericArgs[0]);
                var valueType = GetDartType(genericArgs[1]);
                return $"Map<{keyType}, {valueType}>";
            }

            // Handle List-like types
            if (genericTypeDef == typeof(List<>) ||
                genericTypeDef == typeof(IList<>) ||
                genericTypeDef == typeof(ICollection<>) ||
                genericTypeDef == typeof(IEnumerable<>))
            {
                return $"List<{GetDartType(genericArgs[0])}>";
            }

            // Handle HashSet
            if (genericTypeDef == typeof(HashSet<>) ||
                genericTypeDef == typeof(ISet<>))
            {
                return $"Set<{GetDartType(genericArgs[0])}>";
            }
        }

        // Handle known types
        if (_typeMap.ContainsKey(type))
        {
            return _typeMap[type];
        }

        return type.Name;
    }

    private string GenerateDartEndpoint(
        string httpMethod,
        string route,
        List<(string name, string type, string source, bool isOptional)> parameters,
        string returnType)
    {
        var parameterList = string.Join(", ", parameters.Select(p =>
            p.source switch
            {
                "Path" => $"@Path('{p.name}') {p.type}{(p.isOptional ? "?" : "")} {p.name}",
                "Body" => $"@Body() {p.type}{(p.isOptional ? "?" : "")} {p.name}",
                "Query" => $"@Query('{p.name}') {p.type}{(p.isOptional ? "?" : "")} {p.name}",
                _ => $"{p.type}{(p.isOptional ? "?" : "")} {p.name}"
            }));

        var methodName = GetMethodName(httpMethod, route);

        return $@"@{httpMethod}('{route}')
  Future<{returnType}> {methodName}({parameterList});";
    }

    private string GetMethodName(string httpMethod, string route)
    {
        var parts = route.Split('/')
            .Where(p => !string.IsNullOrEmpty(p))
            .Select(part =>
            {
                if (part.StartsWith("{") && part.EndsWith("}"))
                {
                    return "By" + char.ToUpper(part[1]) + part.Substring(2, part.Length - 3);
                }
                return char.ToUpper(part[0]) + part.Substring(1);
            });

        return $"{httpMethod.ToLowerInvariant()}{string.Join("", parts)}";
    }
}