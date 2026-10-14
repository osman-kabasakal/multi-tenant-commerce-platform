using ControllerAnalyzer.Models.DataSourceTemplateModels;
using Grand.Infrastructure.TypeSearch;
using Grand.SharedKernel.Attributes;
using MathNet.Numerics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Abstractions;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Routing;
using System;
using System.Reflection;
using System.Reflection.Emit;
using static ControllerAnalyzer.ControllerAnalyzerCodeAnalysis;

namespace ControllerAnalyzer;

public class EndpointDatasourceTokenManager
{
    private readonly IReadOnlyList<ActionDescriptor> _endpointSources;
    private readonly LinkGenerator _linkGenerator;
    // private readonly ITypeSearcher _typeSearcher;

    public EndpointDatasourceTokenManager(
        IReadOnlyList<ActionDescriptor> endpointSources,
        LinkGenerator linkGenerator
        // ITypeSearcher typeSearcher
        )
    {
        _endpointSources = endpointSources;
        _linkGenerator = linkGenerator;
        // _typeSearcher = typeSearcher;
    }

    // Type mapping dictionary remains the same as in original code
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

    public DataSourceTemplateToken GenerateDartTemplate(string controllerName, string methodName)
    {
        var endpoints = _endpointSources
            .OfType<ControllerActionDescriptor>()
            .GroupBy(x => x.ControllerName);

        var endpointDrops = new List<EndpointDrop>();

        foreach (var controllerEndpoint in endpoints)
        {
            foreach (var endpoint in controllerEndpoint)
            {
                var methodInfo = endpoint.MethodInfo;
                if (methodInfo == null) continue;

                if (methodInfo.GetCustomAttribute<IgnoreApiAttribute>() != null)
                    continue;

                // Skip if not matching controller or method name filters
                if ((!string.IsNullOrEmpty(controllerName) && methodInfo.DeclaringType.Name != controllerName) ||
                    (!string.IsNullOrEmpty(methodName) && methodInfo.Name != methodName) ||
                    methodInfo.DeclaringType.Assembly.GetName().Name != "Grand.Web")
                {
                    continue;
                }

                var httpMethod = GetHttpMethod(endpoint);
                var route = endpoint.AttributeRouteInfo?.Template ??
                    $"/{endpoint.RouteValues["area"]}/{endpoint.RouteValues["controller"]}/{endpoint.RouteValues["action"]}".Replace("//", "/");

                var parameters = GetParameters(httpMethod, route, methodInfo, endpoint.Parameters);
                var returnType = GetReturnType(methodInfo);
                var templateMethodName = GetMethodName(httpMethod, route);

                var paramDrops = parameters.Select(p => new ParamDrop(
                    GetDecoratorForSource(p.source),
                    p.name,
                    p.type,
                    p.reflectionType,
                    p.isOptional
                )).ToList();

                endpointDrops.Add(new EndpointDrop(
                    httpMethod,
                    route,
                    returnType.dartType.StartsWith("ApiResponse"), // IsExtra can be determined based on your requirements
                    returnType.dartType,
                    returnType.reflectionType,
                    templateMethodName,
                    paramDrops
                ));
            }
        }

        // Create DartFileInfo
        var dartFileInfo = new DartFileInfoDrop(
            featureName: controllerName.Replace("Controller", "").ToSnakeCase(),
            $"{controllerName.Replace("Controller", "").ToSnakeCase()}_data_source",
            $"{controllerName.Replace("Controller", "")}",
            new List<string> {
                "package:store_user_app/core/models/network/api_response.dart",
            }
        );

        return new DataSourceTemplateToken(dartFileInfo, endpointDrops);
    }

    private string GetDecoratorForSource(string source)
    {
        return source switch {
            "Path" => "Path",
            "Query" => "Query",
            "Body" => "Body",
            "Field" => "Field",
            _ => "Query" // Default to Query if unknown
        };
    }

    private (string dartType, Type? reflectionType) GetReturnType(MethodInfo methodInfo)
    {
        var returnType = methodInfo.ReturnType;

        if (returnType.IsGenericType)
        {
            var genericTypeDef = returnType.GetGenericTypeDefinition();
            if (genericTypeDef == typeof(Task<>) || genericTypeDef == typeof(ActionResult<>))
            {
                returnType = returnType.GetGenericArguments()[0];
            }
        }

        var controllerFileFormat = "/workspace/Repos/LocalBusinessEcommerce/BusinessEcommerce/Ecommerce/src/Web/Grand.Web/Controllers/{0}.cs";

        if (returnType == typeof(IActionResult) || returnType == typeof(Task<IActionResult>))
        {
            var analyzerResult = ControllerAnalyzerCodeAnalysis.AnalyzeControllerActions(
                File.ReadAllText(string.Format(controllerFileFormat, methodInfo.DeclaringType.Name)),
                methodInfo.DeclaringType.Name, methodInfo.Name);

            if (analyzerResult != null && analyzerResult.Count > 0)
            {
                var analysis = analyzerResult.FirstOrDefault();
                if (analysis != null)
                {
                    return ProcessAnalyzerResult(analysis);
                }
            }
        }

        return (GetDartType(returnType), returnType);
    }

    private (string dartType, Type? reflectionType) ProcessAnalyzerResult(ActionAnalysisResult analysis)
    {
        var viewReturnType = analysis.ReturnTypes.FirstOrDefault(x => x.Split(":")[0].Trim() == "View");
        if (viewReturnType != null)
        {
            return ProcessReturnType(viewReturnType);
        }

        var jsonReturnType = analysis.ReturnTypes.FirstOrDefault(x => x.Split(":")[0].Trim() == "Json");
        if (jsonReturnType != null)
        {
            return ProcessReturnType(jsonReturnType);
        }

        return ("dynamic", null);
    }

    private (string dartType, Type? reflectionType) ProcessReturnType(string returnTypeString)
    {
        var returnModelType = returnTypeString.Split(":")[1].Trim();
        if (returnModelType.StartsWith("null") || returnModelType.StartsWith("Anonymous") || returnModelType.StartsWith("Unknown"))
        {
            if (returnModelType.StartsWith("Anonymous"))
            {
                var spllitAnonymous = returnModelType.Split("|");
                if (spllitAnonymous.Length > 1 && spllitAnonymous[1] != "Unknown")
                {
                    Type anonymousType = GenerateAnonymousType(spllitAnonymous);
                    if (anonymousType != null)
                    {
                        return ($"ApiResponse<{anonymousType.Name}>", anonymousType);
                    }
                }
                return ("ApiResponse<Map<String,dynamic>>", null);
            }
            else if (returnModelType.StartsWith("null"))
                return ("dynamic", null);
            else
                return ("ApiResponse<dynamic>", null);
        }

        var type = Type.GetType(returnModelType);
        if (type != null)
        {
            return ($"ApiResponse<{GetDartType(type)}>", type);
        }

        return ("ApiResponse<dynamic>", null);
    }

    private Type GenerateAnonymousType(string[] spllitAnonymous)
    {
        var uniqAssemblyName= spllitAnonymous.FirstOrDefault(x=>x.StartsWith("Assembly->"))?.Split("->")[1];
        if(string.IsNullOrEmpty(uniqAssemblyName))
            return null;
        uniqAssemblyName= Encoding.UTF8.GetString(Convert.FromBase64String(uniqAssemblyName));
        AssemblyName assemblyName = new AssemblyName(uniqAssemblyName);
        AssemblyBuilder assemblyBuilder = AssemblyBuilder.DefineDynamicAssembly(assemblyName, AssemblyBuilderAccess.Run);
        ModuleBuilder moduleBuilder = assemblyBuilder.DefineDynamicModule($"{uniqAssemblyName}_DynamicModule");

        var typeName= spllitAnonymous.FirstOrDefault(x=>x.StartsWith("Type->"))?.Split("->")[1];
        if(typeName==null)
            return null;

         typeName = Encoding.UTF8.GetString(Convert.FromBase64String(typeName));   
        TypeBuilder typeBuilder = moduleBuilder.DefineType(typeName,
            TypeAttributes.Public | TypeAttributes.Class | TypeAttributes.Sealed);

        void AddProperty(string propertyName, Type propertyType)
        {
            FieldBuilder fieldBuilder = typeBuilder.DefineField("_" + propertyName.ToLower(),
                propertyType, FieldAttributes.Private);

            PropertyBuilder propertyBuilder = typeBuilder.DefineProperty(propertyName,
                PropertyAttributes.None, propertyType, null);

            // Getter method
            MethodBuilder getMethodBuilder = typeBuilder.DefineMethod("get_" + propertyName,
                MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.HideBySig,
                propertyType, Type.EmptyTypes);

            ILGenerator getIL = getMethodBuilder.GetILGenerator();
            getIL.Emit(OpCodes.Ldarg_0);
            getIL.Emit(OpCodes.Ldfld, fieldBuilder);
            getIL.Emit(OpCodes.Ret);

            // Setter method
            MethodBuilder setMethodBuilder = typeBuilder.DefineMethod("set_" + propertyName,
                MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.HideBySig,
                null, new Type[] { propertyType });

            ILGenerator setIL = setMethodBuilder.GetILGenerator();
            setIL.Emit(OpCodes.Ldarg_0);
            setIL.Emit(OpCodes.Ldarg_1);
            setIL.Emit(OpCodes.Stfld, fieldBuilder);
            setIL.Emit(OpCodes.Ret);

            propertyBuilder.SetGetMethod(getMethodBuilder);
            propertyBuilder.SetSetMethod(setMethodBuilder);
        }

        var properties= spllitAnonymous.FirstOrDefault(x=>x.StartsWith("Properties->"))?.Split("->");
        if(properties==null)
            return typeBuilder.CreateType();
        properties= Encoding.UTF8.GetString(Convert.FromBase64String(properties[1])).Split("~");

        foreach (var property in properties){
            var propType= property.Split(":")[1];
            var propName= property.Split(":")[0];
            AddProperty(propName, Type.GetType(propType)??typeof(object));
        }

        return typeBuilder.CreateType();
    }

    private string GetHttpMethod(ControllerActionDescriptor endpoint)
    {
        return endpoint.EndpointMetadata
            .OfType<HttpMethodMetadata>()
            .FirstOrDefault()
            ?.HttpMethods
            .FirstOrDefault() ?? "GET";
    }

    private List<(string name, string type, Type reflectionType, string source, bool isOptional)> GetParameters(
        string httpMethod,
        string route,
        MethodInfo methodInfo,
        IList<ParameterDescriptor> routePattern)
    {
        // Implementation remains the same as original
        var parameters = new List<(string name, string type, Type reflectionType, string source, bool isOptional)>();
        var routeParameters = routePattern.Select(p => p.Name).ToList();

        foreach (var param in methodInfo.GetParameters())
        {
            var paramType = GetDartType(param.ParameterType);
            var paramName = param.Name ?? "";

            if (param.GetCustomAttribute<FromServicesAttribute>() != null)
                continue;

            if (param.GetCustomAttribute<FromBodyAttribute>() != null)
            {
                parameters.Add((paramName, paramType, param.ParameterType, "Body", param.IsOptional));
            }
            else if (param.GetCustomAttribute<FromQueryAttribute>() != null)
            {
                parameters.Add((paramName, paramType, param.ParameterType, "Query", param.IsOptional));
            }
            else if ((httpMethod == "GET" || httpMethod == "DELETE") && routeParameters.Contains(paramName))
            {
                if (route.Contains("{" + paramName + "}"))
                    parameters.Add((paramName, paramType, param.ParameterType, "Path", param.IsOptional));
                else if (param.ParameterType.Assembly.GetName().Name == "Grand.Web")
                {
                    parameters.Add((paramName, paramType, param.ParameterType, "Field", param.IsOptional));
                }
                else
                    parameters.Add((paramName, paramType, param.ParameterType, "Query", param.IsOptional));
            }
            else
            {
                if (!param.ParameterType.IsPrimitive && param.ParameterType != typeof(string))
                    parameters.Add((paramName, paramType, param.ParameterType, "Body", param.IsOptional));
                else
                    parameters.Add((paramName, paramType, param.ParameterType, "Query", param.IsOptional));
            }
        }

        if (parameters.Count(x => x.source == "Body") > 1)
        {
            var bodyParams = parameters.Where(x => x.source == "Body").ToList();
            foreach (var bodyParam in bodyParams)
            {
                var index = parameters.IndexOf(bodyParam);
                parameters.Remove(bodyParam);
                parameters.Insert(index, (bodyParam.name, bodyParam.type, bodyParam.reflectionType, "Field", bodyParam.isOptional));
            }
        }

        return parameters;
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
