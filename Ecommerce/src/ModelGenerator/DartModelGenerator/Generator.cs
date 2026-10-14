using Grand.Domain.Common;
using Grand.Infrastructure.Models;
using Grand.Web.Common.Page.Paging;
using Grand.Web.Models.Catalog;
using System.Reflection;
using System.Text;

namespace DartModelGenerator;

public class Generator
{
    private readonly string _outputDirectory;
    private readonly Dictionary<Type, string> _typeMap;
    private readonly HashSet<string> _generatedTypes;

    public Generator(string outputDirectory)
    {
        _outputDirectory = outputDirectory;
        _typeMap = InitializeTypeMap();
        _generatedTypes = new HashSet<string>();
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
    
    public void GenerateModels(Type generateModel)
    {
        if (generateModel.IsEnum)
        {
            GenerateDartEnum(generateModel);
        }
        else
        {
            GenerateDartClass(generateModel);
        }
    }
    
    public void GenerateModelsWithFreezed(params Type[] generateModels)
    {
        foreach (var generateModel in generateModels)
        {
            if (generateModel.IsEnum)
            {
                GenerateDartEnum(generateModel);
            }
            else
            {
                GenerateDartClassWithFreezed(generateModel);
            }
        }
    }

    public void GenerateModels()
    {
        var assembly = typeof(SearchModel).Assembly;
        var types = assembly.GetTypes().ToList();
        var modelTypes = types
            .Where(t => t.FullName == typeof(UserField).FullName || (t.Namespace?.StartsWith("Grand.Web.Models") == true
                                                                     ))
            .ToList();

        // First generate enums
        foreach (var type in modelTypes.Where(t => t.IsEnum))
        {
            GenerateDartEnum(type);
        }
        
        // Then generate classes
        foreach (var type in modelTypes.Where(t => !t.IsEnum && !t.IsInterface))
        {
            GenerateDartClass(type);
        }
        
    }
    
    public void GenerateModelsWithFreezed()
    {
        var assembly = typeof(SearchModel).Assembly;
        var types = assembly.GetTypes().ToList();
        var modelTypes = types
            .Where(t => t.FullName == typeof(UserField).FullName || (t.Namespace?.StartsWith("Grand.Web.Models") == true
                ))
            .ToList();

        // First generate enums
        foreach (var type in modelTypes.Where(t => t.IsEnum))
        {
            GenerateDartEnum(type);
        }
        
        // Then generate classes
        foreach (var type in modelTypes.Where(t => !t.IsEnum && !t.IsInterface))
        {
            GenerateDartClassWithFreezed(type);
        }
        
    }

    private string GetFilePath(Type type, Type? relativeType = null, bool isFreezed=false)
    {
        var isNested = type.DeclaringType != null;
        var namespaceName = isNested ? type.DeclaringType.Namespace : type.Namespace;
        var fullTypeName = isNested 
            ? $"{namespaceName}.{type.DeclaringType.Name}.{type.Name}"
            : $"{namespaceName}.{type.Name}";
        var name = fullTypeName.Replace("Grand.Web.Models", "");
        var split = name.Split('.').Select(x=>x.Trim().ToSnakeCase());
        var rootDirectory = Path.Combine(_outputDirectory,"");
        foreach (var directoryName in split)
        {
            if (string.IsNullOrEmpty(directoryName))
                continue;
            if (Directory.Exists(Path.Combine(rootDirectory, directoryName)))
            {
                rootDirectory = Path.Combine(rootDirectory, directoryName);
                continue;
            }

            rootDirectory = Path.Combine(rootDirectory, directoryName);
            Directory.CreateDirectory(rootDirectory);
        }

        var fileName = Path.Combine(rootDirectory, $"{type.Name.ToSnakeCase()}.dart");
        // if (File.Exists(fileName))
        // {
        //     File.Delete(fileName);
        // }

        if (relativeType != null)
        {
            if (!File.Exists(fileName))
            {
                if (type.IsEnum)
                {
                    GenerateDartEnum(type);
                }
                else
                {
                    if (isFreezed)
                    {
                        GenerateDartClassWithFreezed(type);
                    }
                    else
                    {
                        GenerateDartClass(type);
                    }
                }
            }
            return Path.GetRelativePath(Path.GetDirectoryName(Path.GetFullPath(GetFilePath(relativeType, isFreezed: isFreezed))), Path.GetFullPath(fileName));
        }

        return fileName;
    }

    private void GenerateDartEnum(Type enumType)
    {
        var filePath = GetFilePath(enumType);

        if (_generatedTypes.Contains(enumType.FullName))
            return;

        using (var writer = new StreamWriter(filePath, false, Encoding.UTF8))
        {
            writer.WriteLine("import 'package:json_annotation/json_annotation.dart';");
            writer.WriteLine();
            writer.WriteLine("@JsonEnum(valueField: 'value')");
            writer.WriteLine($"enum {enumType.Name} {{");

            var values = Enum.GetValues(enumType);
            var stringValues = new List<string>();
            foreach (var value in values)
            {
                var name = Enum.GetName(enumType, value);
                var numericValue = Convert.ToInt32(value);
                stringValues.Add($"  @JsonValue({numericValue}) \n   {ToCamelCase(name)}({numericValue})\n ");
            }
            writer.WriteLine(string.Join(",", stringValues)+";");
            writer.WriteLine();
            writer.WriteLine("  final int value;");
            writer.WriteLine($"  const {enumType.Name}(this.value);");
            writer.WriteLine("}");
        }

        _generatedTypes.Add(enumType.FullName);
    }

    private void GenerateDartClass(Type type)
    {
        if (_generatedTypes.Contains(type.FullName))
            return;

        var filePath = GetFilePath(type);
        var fileName = Path.GetFileName(filePath);

        using (var writer = new StreamWriter(filePath, false, Encoding.UTF8))
        {
            // Write imports
            writer.WriteLine("import 'package:json_annotation/json_annotation.dart';");

            // Add imports for nested types
            var nestedTypes = GetNestedTypes(type);
            foreach (var nestedType in nestedTypes)
            {
                if (nestedType != type)
                {
                    writer.WriteLine($"import '{GetFilePath(nestedType, type)}';");
                }
            }

            writer.WriteLine($"part '{fileName.Replace(".dart", ".g.dart")}';");
            writer.WriteLine();

            // Write class declaration
            writer.WriteLine("@JsonSerializable()");
            writer.WriteLine($"class {type.Name} {{");

            // Write constructor
            

            var propLines = new StringBuilder();
            var propertyNames = new List<string>();

            // Write properties
            foreach (var property in type.GetProperties(BindingFlags.Public | BindingFlags.Instance ))
            {
                var dartType = GetDartType(property.PropertyType);
                var dartName = ToCamelCase(property.Name);

                if (dartName != property.Name)
                {
                    propLines.AppendLine($"  @JsonKey(name: '{property.Name}')");
                }

                // Handle nullable types
                var isNullable = true;
                dartType = isNullable ? $"{dartType}?" : dartType;

                propLines.AppendLine($"  {dartType} {dartName};");
                propLines.AppendLine();
                propertyNames.Add(dartName);
            }
            
            writer.WriteLine($"  {type.Name}({{\n{string.Join(",\n",propertyNames.Select(x=>$"this.{x}"))}\n}});");
            writer.WriteLine();
            
            writer.Write(propLines);
            // Write fromJson and toJson methods
            writer.WriteLine($"  factory {type.Name}.fromJson(Map<String, dynamic> json) =>");
            writer.WriteLine($"      _${type.Name}FromJson(json);");
            writer.WriteLine();
            writer.WriteLine("  Map<String, dynamic> toJson() =>");
            writer.WriteLine($"      _${type.Name}ToJson(this);");

            writer.WriteLine("}");
        }

        _generatedTypes.Add(type.FullName);
    }
    
    private void GenerateDartClassWithFreezed(Type type)
    {
        if (_generatedTypes.Contains(type.FullName))
            return;

        var filePath = GetFilePath(type, isFreezed: true);
        var fileName = Path.GetFileName(filePath);

        using (var writer = new StreamWriter(filePath, false, Encoding.UTF8))
        {
            // Write imports
            writer.WriteLine("import 'package:freezed_annotation/freezed_annotation.dart';");
            // Add imports for nested types
            var nestedTypes = GetNestedTypes(type);
            foreach (var nestedType in nestedTypes)
            {
                if (nestedType != type)
                {
                    writer.WriteLine($"import '{GetFilePath(nestedType, type,isFreezed: true)}';");
                }
            }

            writer.WriteLine($"part '{fileName.Replace(".dart", ".freezed.dart")}';");
            writer.WriteLine();
            
            writer.WriteLine($"part '{fileName.Replace(".dart", ".g.dart")}';");
            writer.WriteLine();

            // Write class declaration
            writer.WriteLine("@freezed");
            writer.WriteLine($"class {type.Name} with _${type.Name} {{");

            // Write constructor
            

            var propertyNames = new List<string>();

            // Write properties
            foreach (var property in type.GetProperties(BindingFlags.Public | BindingFlags.Instance ))
            {
                var dartType = GetDartType(property.PropertyType);
                var dartName = ToCamelCase(property.Name);

                // Handle nullable types
                var isNullable = IsNullableType(property.PropertyType);
                dartType = isNullable ? $"@JsonKey(name: '{property.Name}', includeIfNull: false) @Default(null) {dartType}? {dartName}" : $"@JsonKey(name: '{property.Name}', includeIfNull: false) {GetDartDefaultValue(property.PropertyType)} {dartType}? {dartName}";

                propertyNames.Add(dartType);
            }
            
            writer.WriteLine($" const factory {type.Name}({{\n{string.Join(",\n",propertyNames.Select(x=>$"{x}"))}\n}}) = _{type.Name};");
            writer.WriteLine();
            
            writer.WriteLine($"  factory {type.Name}.fromJson(Map<String, dynamic> json) =>");
            writer.WriteLine($"      _${type.Name}FromJson(json);");
            writer.WriteLine();
            writer.WriteLine("  Map<String, dynamic> toJson() => super.toJson();");
            // writer.WriteLine($"      _${type.Name}ToJson(this);");
            writer.WriteLine("}");



        }

        _generatedTypes.Add(type.FullName);
    }

    private HashSet<Type> GetNestedTypes(Type type)
    {
        var nestedTypes = new HashSet<Type>();
        foreach (var property in type.GetProperties(BindingFlags.Public | BindingFlags.Instance ))
        {
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