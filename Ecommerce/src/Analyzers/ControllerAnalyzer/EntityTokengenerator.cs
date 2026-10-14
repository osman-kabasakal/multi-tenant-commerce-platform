using ControllerAnalyzer.Models.EntitiesTemplateModels;
using DotLiquid;
using Grand.SharedKernel.Extensions;
using System;
using System.Collections;
using System.Reflection;

namespace ControllerAnalyzer;

public class EntityTokengenerator
{
    private readonly string _outputDirectory;
    private readonly Dictionary<Type, string> _typeMap;
    private readonly HashSet<string> _generatedTypes;
    private readonly string _classTemplate;
    private readonly string _freezedClassTemplate;
    private readonly string _enumTemplate;

    public EntityTokengenerator(string outputDirectory)
    {
        _outputDirectory = outputDirectory;
        _typeMap = InitializeTypeMap();
        _generatedTypes = new HashSet<string>();

        // Load templates
        _classTemplate = File.ReadAllText(Path.Combine(CommonPath.BaseDirectory, "templates/dart_class.liquid"));
        _freezedClassTemplate = File.ReadAllText(Path.Combine(CommonPath.BaseDirectory, "templates/dart_freezed_class.liquid"));
        _enumTemplate = File.ReadAllText(Path.Combine(CommonPath.BaseDirectory, "templates/dart_enum.liquid"));
    }

    private Dictionary<Type, string> InitializeTypeMap()
    {
        return new Dictionary<Type, string> {
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
    }

    public List<IDartModel> GenerateModelsWithFreezed(params Type[] generateModels)
    {
        var rt = new List<IDartModel>();
        foreach (var generateModel in generateModels)
        {
            if (generateModel == null)
                continue;
            // Check if the type is defined in the .NET Core and C# base classes or in the Grand.Web assembly
            if (generateModel.Assembly.GetName().Name != "Grand.Web" &&
                !generateModel.Assembly.GetName().Name.StartsWith("DynamicAssembly_") &&
                (generateModel.Module.ScopeName.Equals("CommonLanguageRuntimeLibrary") ||
                 generateModel.Assembly.GetName().Name.StartsWith("System") ||
                 generateModel.Assembly.GetName().Name.Equals("mscorlib"))
                 )
            {
                if (generateModel.IsGenericType && generateModel.IsAssignableTo(typeof(IEnumerable)))
                {
                    var genericType = generateModel.GetGenericArguments().FirstOrDefault();
                    if (genericType != null)
                    {
                        rt.AddRange(GenerateModelsWithFreezed(genericType));
                        
                    }
                }
                continue;
            }

            if (generateModel.IsEnum)
            {
                rt.Add(GenerateDartEnum(generateModel));
            }
            else
            {
                rt.Add(GenerateDartClass(generateModel, true));
            }
        }

        return rt;
    }
    private DartEnumModel GenerateDartEnum(Type enumType)
    {
        var filePath = GetFilePathWithFileCreate(enumType);
        var enumModel = new DartEnumModel {
            ClassName = enumType.Name,
            RelativePath = filePath,
            FileName = Path.GetFileNameWithoutExtension(filePath),
            EnumName = enumType.Name,
            Values = Enum.GetValues(enumType)
                .Cast<object>()
                .Select(value => new DartEnumValue {
                    Name = Enum.GetName(enumType, value).ToCamelCase(),
                    Value = Convert.ToInt32(value)
                })
                .ToList()
        };

        if (_generatedTypes.Contains(enumType.FullName))
            return enumModel;



        var result = Template.Parse(_enumTemplate).Render(Hash.FromAnonymousObject(enumModel));
        File.WriteAllText(filePath, result, Encoding.UTF8);
        _generatedTypes.Add(enumType.FullName);

        return enumModel;
    }

    private DartClassModel GenerateDartClass(Type type, bool isFreezed = false)
    {

        var filePath = GetFilePathWithFileCreate(type);
        var fileName = Path.GetFileNameWithoutExtension(filePath);
        var nestedTypes = GetNestedTypes(type);

        var properties= GetProperties(type);

        if(properties.Any(x=>string.IsNullOrEmpty(x.OriginalName))){
            var debug= true;
        }

        var classModel = new DartClassModel {
            RelativePath = filePath,
            ClassName = type.Name+"",
            Properties = properties,
            Imports = GetImports(type, nestedTypes),
            IsFreezed = isFreezed,
            FileName = fileName
        };

        if (_generatedTypes.Contains(type.FullName))
            return classModel;



        var template = isFreezed ? _freezedClassTemplate : _classTemplate;
        var result = Template.Parse(template).Render(Hash.FromAnonymousObject(classModel,includeBaseClassProperties:false));
        File.WriteAllText(filePath, result, Encoding.UTF8);
        _generatedTypes.Add(type.FullName);

        return classModel;
    }

    private List<string> GetImports(Type type, HashSet<Type> nestedTypes)
    {
        var imports = new List<string>();

        foreach (var nestedType in nestedTypes)
        {
            var importPath = GetFilePathWithFileCreate(nestedType, type, true);
            imports.Add(importPath);
        }

        return imports;
    }

    private List<DartProperty> GetProperties(Type type)
    {
        return type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Select(p => new DartProperty {
                Name = ToCamelCase((p.Name+"")),
                DartType = GetDartType(p.PropertyType),
                OriginalName = p.Name+"",
                IsNullable = true,//IsNullableType(p.PropertyType),
                DefaultValue = GetDartDefaultValue(p.PropertyType)
            })
            .ToList();
    }

    private string GetFilePathWithFileCreate(Type type, Type? relativeType = null, bool isFreezed = false)
    {
        var fileName = GetFilePath(type,false);
        // if (File.Exists(fileName))
        // {
        //     File.Delete(fileName);
        // }

        if (relativeType != null && relativeType != type)
        {
            if (!File.Exists(fileName))
            {
                if (type.IsEnum)
                {
                    GenerateDartEnum(type);
                }
                else
                {
                    GenerateDartClass(type, isFreezed: isFreezed);
                }
            }
            return Path.GetRelativePath(Path.GetDirectoryName(Path.GetFullPath(GetFilePathWithFileCreate(relativeType, isFreezed: isFreezed))), Path.GetFullPath(fileName));
        }

        return fileName;
    }

    public string GetFilePath(Type type, bool onlyPath)
    {
        var isNested = type.DeclaringType != null;
        var namespaceName = isNested ? type.DeclaringType.Namespace : type.Namespace;
        var fullTypeName = isNested
            ? $"{namespaceName}.{type.DeclaringType.Name}.{type.Name}"
            : $"{namespaceName}.{type.Name}";
        var name = fullTypeName.Replace(type.Assembly.GetName().Name, "");
        var split = name.Split('.').Select(x => x.Trim().ToSnakeCase());
        var rootDirectory = Path.Combine(_outputDirectory, "");
        foreach (var directoryName in split)
        {
            if (string.IsNullOrEmpty(directoryName))
                continue;
            if (Directory.Exists(Path.Combine(rootDirectory, directoryName)) || onlyPath)
            {
                rootDirectory = Path.Combine(rootDirectory, directoryName);
                continue;
            }

            rootDirectory = Path.Combine(rootDirectory, directoryName);
            Directory.CreateDirectory(rootDirectory);
        }

        var fileName = Path.Combine(rootDirectory, $"{(type.Name+"").ToSnakeCase()}.dart");
        return fileName;
    }

    private HashSet<Type> GetNestedTypes(Type type)
    {
        var nestedTypes = new HashSet<Type>();
        foreach (var property in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (property.PropertyType != type)
                AddTypeAndDependencies(property.PropertyType, nestedTypes);
        }

        return nestedTypes;
    }

    private void AddTypeAndDependencies(Type type, HashSet<Type> types)
    {
        bool isSystemType = (type.Module.ScopeName.Equals("CommonLanguageRuntimeLibrary") ||
                             type.Assembly.GetName().Name.Equals("System.Private.CoreLib") ||
                             type.Assembly.GetName().Name.Equals("mscorlib")) && (!type.IsGenericType);

        if (type == null || types.Contains(type) || isSystemType)
            return;

        if (!type.IsGenericType)
        {
            types.Add(type);
        }

        if (type.IsGenericType)
        {
            foreach (var argType in type.GetGenericArguments())
            {
                AddTypeAndDependencies(argType, types);
            }
        }

        if (type.HasElementType)
        {
            AddTypeAndDependencies(type.GetElementType(), types);
        }
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

        // Default fallback
        Console.WriteLine($"Warning: Unknown type '{type.FullName}' defaulting to 'dynamic'");
        return "dynamic";
    }

    private bool IsNullableType(Type type)
    {
        return type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>);
    }

    private string GetDartDefaultValue(Type type)
    {
        if (IsNullableType(type))
        {
            return "@Default(null)";
        }
        var dartType = GetDartType(type);
        if (dartType.StartsWith("List"))
        {
            return "@Default([])";
        }

        if (dartType.StartsWith("Map"))
        {
            return "@Default({})";
        }

        if (dartType.StartsWith("Set"))
        {
            var genericArgs = type.GetGenericArguments();
            return $"@Default(<{GetDartType(genericArgs[0])}>{{}})";
        }

        if (type == typeof(bool))
        {
            return "@Default(false)";
        }

        if (type.IsEnum)
        {
            var values = Enum.GetValues(type);
            var name = Enum.GetName(type, values.GetValue(0));
            return $"@Default({type.Name}.{ToCamelCase(name)})";
        }

        return string.Empty;
    }

    private string ToCamelCase(string input)
    {
        if (string.IsNullOrEmpty(input))
            return input;

        if (input.Length == 1)
            return input.ToLowerInvariant();

        return char.ToLowerInvariant(input[0]) + input.Substring(1);
    }
}
