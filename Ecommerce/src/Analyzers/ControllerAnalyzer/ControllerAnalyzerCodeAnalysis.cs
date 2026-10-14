using Grand.Web.Controllers;
using MediatR;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;
using System.Collections.Immutable;

namespace ControllerAnalyzer;

public class ControllerAnalyzerCodeAnalysis
{
    public static List<ActionAnalysisResult> AnalyzeControllerActions(string sourceCode, string controllerName, string actionName)
    {
        var rt = new List<ActionAnalysisResult>();
        var tree = CSharpSyntaxTree.ParseText(sourceCode);
        var compilation = CSharpCompilation.Create("Analysis")
            .AddReferences(
                MetadataReference.CreateFromFile(typeof(object).Assembly.Location),
                MetadataReference.CreateFromFile(typeof(Task<>).Assembly.Location),
                MetadataReference.CreateFromFile(typeof(IMediator).Assembly.Location),
                MetadataReference.CreateFromFile(typeof(AccountController).Assembly.Location)
            )
            .AddSyntaxTrees(tree);

        var semanticModel = compilation.GetSemanticModel(tree);
        var root = tree.GetRoot();

        var controllerClass = root.DescendantNodes()
            .OfType<ClassDeclarationSyntax>()
            .FirstOrDefault(c => c.Identifier.Text.EndsWith("Controller") && (string.IsNullOrEmpty(controllerName) || c.Identifier.Text.StartsWith(controllerName)));

        if (controllerClass == null) return rt;

        var methods = controllerClass.DescendantNodes()
            .OfType<MethodDeclarationSyntax>()
            .Where(m => m.Modifiers.Any(mod => mod.IsKind(SyntaxKind.PublicKeyword)));

        foreach (var method in methods)
        {
            if (!string.IsNullOrEmpty(actionName) && !method.Identifier.Text.Equals(actionName, StringComparison.OrdinalIgnoreCase)) continue;
            rt.Add(AnalyzeActionMethod(method, semanticModel));
        }

        return rt;
    }

    public class ActionAnalysisResult
    {
        public string ActionName { get; set; }
        public string HttpMethod { get; set; }
        public Dictionary<string, string> LocalVariables { get; set; } = new();
        public List<string> ReturnTypes { get; set; } = new();
    }

    private static ActionAnalysisResult AnalyzeActionMethod(MethodDeclarationSyntax method, SemanticModel semanticModel)
    {
        var result = new ActionAnalysisResult {
            ActionName = method.Identifier.Text
        };

        var httpMethod = method.AttributeLists
            .SelectMany(al => al.Attributes)
            .FirstOrDefault(a => a.Name.ToString().StartsWith("Http"))
            ?.Name.ToString() ?? "GET";

        result.HttpMethod = httpMethod;

        // Mediator kullanımını ve değişken tanımlamalarını analiz et
        var localVariables = method.DescendantNodes()
            .OfType<VariableDeclarationSyntax>();

        foreach (var variable in localVariables)
        {
            foreach (var declarator in variable.Variables)
            {
                if (declarator.Initializer?.Value != null)
                {
                    AnalyzeVariableInitialization(declarator, semanticModel, result.LocalVariables);
                }
            }
        }

        // Return statement analizi
        var returnStatements = method.DescendantNodes()
            .OfType<ReturnStatementSyntax>();

        foreach (var returnStatement in returnStatements)
        {
            if (returnStatement.Expression == null) continue;

            if (returnStatement.Expression is InvocationExpressionSyntax invocation)
            {
                AnalyzeReturnInvocation(invocation, semanticModel, result.LocalVariables, result.ReturnTypes);
            }
        }

        return result;
    }

    private static void AnalyzeVariableInitialization(VariableDeclaratorSyntax declarator, SemanticModel semanticModel, Dictionary<string, string> localVariableTypes)
    {
        var initialization = declarator.Initializer.Value;
        var variableName = declarator.Identifier.Text;

        // Mediator.Send() çağrısı analizi
        if (initialization is AwaitExpressionSyntax awaitExpr &&
            awaitExpr.Expression is InvocationExpressionSyntax invocation)
        {
            var symbolInfo = semanticModel.GetSymbolInfo(invocation);
            var symbol = symbolInfo.Symbol as IMethodSymbol;

            if (symbolInfo.CandidateReason == CandidateReason.OverloadResolutionFailure)
            {
                symbol = symbolInfo.CandidateSymbols.FirstOrDefault() as IMethodSymbol;
            }

            if (symbol?.Name == "Send" && symbol.ContainingType.Name == "ISender")
            {
                var argument = invocation.ArgumentList.Arguments.FirstOrDefault()?.Expression;
                if (argument != null)
                {
                    var typeInfo = semanticModel.GetTypeInfo(argument);
                    var requestType = typeInfo.Type;

                    // Request tipinden response tipini bul
                    if (requestType is INamedTypeSymbol requestSymbol)
                    {
                        var responseType = requestSymbol.AllInterfaces
                            .FirstOrDefault(i => i.Name == "IRequest")?
                            .TypeArguments.FirstOrDefault();

                        localVariableTypes[variableName] = GetTypeSignature(responseType);

                        Console.WriteLine($"Local Variable: {variableName} - Type: {responseType?.ToDisplayString() ?? "Unknown"} (from Mediator.Send)");
                        if (responseType != null)
                        {
                            AnalyzeType(responseType);
                        }
                    }
                }
            }
        }
        else
        {
            // Normal değişken tanımlaması
            var variableType = semanticModel.GetTypeInfo(initialization).Type;
            localVariableTypes[variableName] = GetTypeSignature(variableType);

            Console.WriteLine($"Local Variable: {variableName} - Type: {variableType?.ToDisplayString() ?? "Unknown"}");
            if (variableType != null)
            {
                AnalyzeType(variableType);
            }
        }
    }

    private static void AnalyzeReturnInvocation(InvocationExpressionSyntax invocation, SemanticModel semanticModel, Dictionary<string, string> localVariableTypes, List<string> returnTypes)
    {
        var methodSymbol = semanticModel.GetSymbolInfo(invocation).Symbol as IMethodSymbol;
        var methodName = methodSymbol?.Name ?? invocation.Expression.ToString();

        switch (methodName)
        {
            case "View":
                AnalyzeViewResult(invocation, semanticModel, localVariableTypes, returnTypes);
                break;
            case "Challenge":
                returnTypes.Add("Challenge:null");
                break;
            case "RedirectToRoute":
                returnTypes.Add($"RedirectToRoute:{invocation.ArgumentList.Arguments.FirstOrDefault()?.ToString() ?? "unknown"}");
                break;
            case "Json":
                AnalyzeJsonResult(invocation, semanticModel, localVariableTypes, returnTypes);
                break;
            default:
                returnTypes.Add($"Unknow:null");
                break;
        }
    }

    private static void AnalyzeJsonResult(InvocationExpressionSyntax jsonInvocation, SemanticModel semanticModel, Dictionary<string, string> localVariableTypes, List<string> returnTypes)
    {
        var arguments = jsonInvocation.ArgumentList.Arguments;
        if (arguments.Count > 0)
        {
            var arg = arguments[0].Expression;

            // Anonim tip analizi
            if (arg is AnonymousObjectCreationExpressionSyntax anonymousObject)
            {
                // Compile-time tip bilgisini al
                var typeInfo = semanticModel.GetTypeInfo(anonymousObject);
                var runtimeType = typeInfo.Type;

                if (runtimeType != null)
                {
                    var typeFullName = runtimeType.ToDisplayString(SymbolDisplayFormat.FullyQualifiedFormat);

                    // Property bilgilerini topla
                    var properties = anonymousObject.Initializers
                        .Select(init =>
                        {
                            var propertyName = init.NameEquals?.Name.Identifier.Text ?? init.Expression.ToString();
                            var propertyTypeInfo = semanticModel.GetTypeInfo(init.Expression);
                            var propertyType = propertyTypeInfo.Type != null ? GetTypeSignature(propertyTypeInfo.Type) : "unknown";
                            return new { Name = propertyName, Type = propertyType };
                        }).Select(x=> (x.Name,x.Type))
                        .ToList();

                    // Anonymous tip için benzersiz bir imza oluştur
                    var typeSignature = string.Join("~", properties.Select(p => $"{p.Name}:{p.Type}"));
                    returnTypes.Add($"Json:AnonymousType|Assembly->{Convert.ToBase64String(Encoding.UTF8.GetBytes(GenerateAssemblyName(properties)))}|Type->{Convert.ToBase64String(Encoding.UTF8.GetBytes(GenerateTypeSignature(properties)))}|Properties->{Convert.ToBase64String(Encoding.UTF8.GetBytes(typeSignature))}");
                }
                else
                {
                    returnTypes.Add("Json:AnonymousType|Unknown");
                }
            }
            else
            {
                // Değişken veya direkt değer analizi
                var typeInfo = semanticModel.GetTypeInfo(arg);
                var argType = typeInfo.Type;

                var argSymbol = semanticModel.GetSymbolInfo(arg).Symbol;

                if (argSymbol is ILocalSymbol)
                {
                    var localSymbol = argSymbol as ILocalSymbol;
                    if (localVariableTypes.TryGetValue(localSymbol.Name, out var localType))
                    {
                        returnTypes.Add($"Json:{localType}");
                    }
                }
                else if (arg is IdentifierNameSyntax identifier)
                {
                    returnTypes.Add($"Json:{GetTypeSignature(argType)}");
                }
                else
                {
                    returnTypes.Add($"Json:{GetTypeSignature(argType)}");
                }
            }
        }
    }
    private static string GenerateTypeSignature(List<(string Name, string Type)> properties)
    {
        var signature = string.Join(",", properties.Select(p => $"{p.Name}:{p.Type}"));
        return $"AnonymousType_{ComputeStableHash(signature)}";
    }

    private static string GenerateAssemblyName(List<(string Name, string Type)> properties)
    {
        // Property'lerin sıralı imzasını oluştur
        var orderedProperties = properties
            .OrderBy(p => p.Name)
            .ThenBy(p => p.Type)
            .Select(p => $"{p.Name}:{p.Type}");

        var signature = string.Join("|", orderedProperties);

        // Stable bir hash değeri oluştur
        var hash = ComputeStableHash(signature);

        // Assembly adını oluştur
        return $"DynamicAssembly_{hash}";
    }

    private static string ComputeStableHash(string input)
    {
        using (var sha256 = System.Security.Cryptography.SHA256.Create())
        {
            var bytes = System.Text.Encoding.UTF8.GetBytes(input);
            var hashBytes = sha256.ComputeHash(bytes);

            // Hash'in ilk 8 karakterini al (yeterince unique olması için)
            return BitConverter.ToString(hashBytes).Replace("-", "").Substring(0, 8);
        }
    }

    private static void AnalyzeViewResult(InvocationExpressionSyntax viewInvocation, SemanticModel semanticModel, Dictionary<string, string> localVariableTypes, List<string> returnTypes)
    {
        var arguments = viewInvocation.ArgumentList.Arguments;

        if (arguments.Count > 0)
        {
            var lastArg = arguments.Last().Expression;
            var modelType = semanticModel.GetTypeInfo(lastArg).Type;

            if (lastArg is IdentifierNameSyntax identifier)
            {
                var symbolInfo = semanticModel.GetSymbolInfo(lastArg);
                var declaredType = symbolInfo.Symbol?.ContainingSymbol as INamedTypeSymbol;

                if (declaredType != null)
                {
                    returnTypes.Add($"View:{GetTypeSignature(declaredType)}");
                }
                else if (symbolInfo.Symbol is ILocalSymbol localSymbol && localVariableTypes.TryGetValue(localSymbol.Name, out var localType))
                {
                    returnTypes.Add($"View:{localType}");
                }
                else
                {
                    returnTypes.Add($"View:{GetTypeSignature(modelType)}");
                }
            }
            else
            {
                returnTypes.Add($"View:{GetTypeSignature(modelType)}");
            }
        }
        else
        {
            returnTypes.Add("View:null");
        }
    }

    private static void AnalyzeType(ITypeSymbol type)
    {
        if (type == null) return;

        if (type is INamedTypeSymbol namedType)
        {
            var properties = namedType.GetMembers()
                .OfType<IPropertySymbol>()
                .Where(p => p.DeclaredAccessibility == Accessibility.Public);

            foreach (var property in properties)
            {
                Console.WriteLine($"    * {property.Name}: {property.Type}");
            }
        }
    }

    private static string GetTypeSignature(ITypeSymbol type)
    {
        if (type == null) return "Unknown";

        return CreateTypeGetTypeSignature(type);
    }

    public static string CreateTypeGetTypeSignature(ITypeSymbol typeSymbol)
    {
        if (typeSymbol == null)
            return string.Empty;

        var signature = new StringBuilder();

        if (typeSymbol is INamedTypeSymbol namedType)
        {
            // İç içe geçmiş tip hiyerarşisini oluştur
            var containingTypeChain = GetContainingTypeChain(namedType);

            // Namespace'i ekle
            if (!string.IsNullOrEmpty(namedType.ContainingNamespace?.ToString()))
            {
                signature.Append(namedType.ContainingNamespace).Append('.');
            }

            // İç içe geçmiş tipleri ekle
            for (int i = 0; i < containingTypeChain.Count; i++)
            {
                if (i > 0)
                    signature.Append('+');
                signature.Append(containingTypeChain[i].Name);
            }

            // Generic tip kontrolü
            if (namedType.IsGenericType)
            {
                signature.Append('`')
                        .Append(namedType.TypeArguments.Length);

                signature.Append("[[");

                for (int i = 0; i < namedType.TypeArguments.Length; i++)
                {
                    if (i > 0)
                        signature.Append("],[");

                    var typeArg = namedType.TypeArguments[i];
                    signature.Append(CreateTypeGetTypeSignature(typeArg));
                }

                signature.Append("]]");
            }

            // Assembly bilgilerini ekle
            signature.Append(", ")
                    .Append(GetAssemblyName(typeSymbol));
        }

        return signature.ToString();
    }

    private static List<INamedTypeSymbol> GetContainingTypeChain(INamedTypeSymbol type)
    {
        var chain = new List<INamedTypeSymbol>();
        var currentType = type;

        // En içteki tipten başlayarak dışa doğru zinciri oluştur
        while (currentType != null)
        {
            chain.Add(currentType);
            currentType = currentType.ContainingType;
        }

        // Dıştaki tipten içe doğru sıralamak için listeyi ters çevir
        chain.Reverse();
        return chain;
    }


    private static string GetAssemblyName(ITypeSymbol typeSymbol)
    {
        // Assembly adını ve özelliklerini oluştur
        var assembly = typeSymbol.ContainingAssembly;
        if (assembly == null)
            return string.Empty;

        var assemblyName = new StringBuilder(assembly.Name);

        // Assembly version
        if (!string.IsNullOrEmpty(assembly.Identity.Version.ToString()))
        {
            assemblyName.Append(", Version=")
                       .Append(assembly.Identity.Version.ToString());
        }

        // Culture bilgisi
        assemblyName.Append(", Culture=")
                   .Append(string.IsNullOrEmpty(assembly.Identity.CultureName) ? "neutral" : assembly.Identity.CultureName);

        var publicToken = GetPublicKeyTokenString(assembly.Identity.PublicKeyToken);
        // Public key token
        if (!string.IsNullOrEmpty(publicToken))
        {
            assemblyName.Append(", PublicKeyToken=")
                       .Append(publicToken);
        }

        return assemblyName.ToString();
    }

    private static string GetPublicKeyTokenString(ImmutableArray<byte> tokenBytes)
    {
        // Eğer token boşsa "null" değeri dönüyoruz
        if (tokenBytes.IsEmpty)
            return "";

        // StringBuilder kullanarak her byte'ı hexadecimal formata çeviriyoruz
        var tokenBuilder = new StringBuilder(tokenBytes.Length * 2);

        foreach (byte b in tokenBytes)
        {
            // "X2" format belirteci her byte'ı 2 karakterlik uppercase hex'e çevirir
            // Örneğin: 255 -> "FF", 15 -> "0F"
            tokenBuilder.Append(b.ToString("X2"));
        }

        return tokenBuilder.ToString().ToLowerInvariant(); // lowercase'e çeviriyoruz
    }
}
