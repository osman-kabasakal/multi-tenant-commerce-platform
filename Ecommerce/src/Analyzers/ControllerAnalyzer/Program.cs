using ControllerAnalyzer;
using Grand.Infrastructure;
using Grand.SharedKernel.Extensions;
using Grand.Web.ExternalSettings.Extensions;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using System.Reflection;
using Grand.Web.Common.Extensions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using ControllerAnalyzer.Models.EntitiesTemplateModels;
using DotLiquid;
using DotLiquid.NamingConventions;
using ControllerAnalyzer.Models.RepositoryTemplateModels;
using Grand.Domain.Messages;
using Grand.Web.Models.Common;
using Grand.Web.Models.Checkout;
using Grand.Web.MultiTenant.Controllers;
using Payments.Iyzico.Models;
using Widgets.LegalTexts.Models;

var loadedAssemblies = AppDomain.CurrentDomain.GetAssemblies().ToList();
var loadedPath = loadedAssemblies.Where(a => !a.IsDynamic).Select(x => x.Location);

var referencedAssemblyPath = Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll");
var deltaLoad = referencedAssemblyPath.Where(r => !loadedPath.Contains(r, StringComparer.InvariantCultureIgnoreCase));

foreach (var referencePath in deltaLoad)
{
    if (referencePath.StartsWith(AppDomain.CurrentDomain.BaseDirectory + "Grand.Business")
        || referencePath.StartsWith(AppDomain.CurrentDomain.BaseDirectory + "Grand.Api"))
    {
        loadedAssemblies.Add(AppDomain.CurrentDomain.Load(AssemblyName.GetAssemblyName(referencePath.ToString())));
    }
}




var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddEnvironmentVariables();

if (builder.Environment.IsDevelopment())
{
    CommonPath.WebHostEnvironment =
        Path.Combine(Directory.GetParent(builder.Environment.ContentRootPath).Parent.Parent.FullName, "wwwroot");
    CommonPath.BaseDirectory = Directory.GetParent(builder.Environment.ContentRootPath).Parent.Parent.FullName;
    builder.Environment.ContentRootPath = CommonPath.BaseDirectory;
    builder.Environment.WebRootPath = CommonPath.WebHostEnvironment;
}
else
{
    CommonPath.WebHostEnvironment =
        Path.Combine(builder.Environment.ContentRootPath, "wwwroot");
    CommonPath.BaseDirectory = builder.Environment.ContentRootPath;
    builder.Environment.ContentRootPath = CommonPath.BaseDirectory;
    builder.Environment.WebRootPath = CommonPath.WebHostEnvironment;
}



var outputFolder = Path.Combine(CommonPath.BaseDirectory, "output_2");
if (!Directory.Exists(outputFolder))
{
    Directory.CreateDirectory(outputFolder);
}

var entitiesFolder = Path.Combine(outputFolder, "entities");

if (!Directory.Exists(entitiesFolder))
{
    Directory.CreateDirectory(entitiesFolder);
}

var customEntityTokenGenerator = new EntityTokengenerator(entitiesFolder);
var generatedModels =  customEntityTokenGenerator.GenerateModelsWithFreezed([
    typeof(ShoppingCartInfoResponse)
]);

return;

builder.AddServiceDefaults();
builder.Host.UseDefaultServiceProvider((_, options) =>
{
    options.ValidateScopes = false;
    options.ValidateOnBuild = false;
});


//add services
StartupBase.ConfigureServices(builder.Services, builder.Configuration);

// var sa = new Grand.Business.Common.Startup.StartupApplication();

// sa.ConfigureServices(builder.Services, builder.Configuration);

builder.ConfigureApplicationSettings();


//build app
var app = builder.Build();

// var analyzer = new ControllerAnalyzerImp();
// var results = analyzer.AnalyzeControllers(typeof(HomeController).Assembly);

// foreach (var result in results)
// {
//     Console.WriteLine($"Controller: {result.ControllerName}");
//     Console.WriteLine($"Action: {result.ActionName}");
//     Console.WriteLine($"Is Async: {result.IsAsync}");
//     Console.WriteLine($"Declared Return Type: {result.DeclaredReturnType?.Name}");
//     Console.WriteLine($"Result Type: {result.ResultType}");
//     Console.WriteLine($"Actual Model Type: {result.ActualModelType?.Name ?? "None"}");

//     if (result.UnderlyingGenericType != null)
//     {
//         Console.WriteLine("Generic Type Arguments:");
//         foreach (var arg in result.GenericTypeArguments!)
//         {
//             Console.WriteLine($"  {arg.Key}: {arg.Value?.Name}");
//         }
//     }

//     Console.WriteLine("-------------------");
// }

// ControllerAnalyzerCodeAnalysis.AnalyzeControllerActions(File.ReadAllText("/workspace/Repos/LocalBusinessEcommerce/BusinessEcommerce/Ecommerce/src/Web/Grand.Web/Controllers/CheckoutController.cs"));
var actionDescriptor = app.Services.GetRequiredService<IActionDescriptorCollectionProvider>().ActionDescriptors.Items;
var endpointSources = app.Services.GetServices<EndpointDataSource>();


var allControllerFiles = Directory.GetFiles("/workspace/Repos/LocalBusinessEcommerce/BusinessEcommerce/Ecommerce/src/Web/Grand.Web/Controllers", "*.cs", SearchOption.AllDirectories);

var repoReturnTypes = new List<IDartModel>();
var apiRepoReturnType = new List<IDartModel>();
var entitiesTypes = new List<IDartModel>();
foreach (var controllerFile in allControllerFiles)
{
    var analyzer = new EndpointDatasourceTokenManager(actionDescriptor, app.Services.GetRequiredService<LinkGenerator>()
    // app.Services.GetRequiredService<ITypeSearcher>()
    );
    var dartEndpoints = analyzer.GenerateDartTemplate(Path.GetFileNameWithoutExtension(controllerFile), null);

    var returnTypeEntities = dartEndpoints.Endpoints.Select(x => x.ReflectionResponseType).Distinct().ToList();

    // requiredEntities.AddRange(dartEndpoints.Endpoints.SelectMany(x => x.Params).Select(x => x.ReflectionType).Distinct());
    returnTypeEntities = returnTypeEntities.Where(x => x != null).ToList();
    var entityTokenGenerator = new EntityTokengenerator(entitiesFolder);

    var returnTypeEntitiesInfos = entityTokenGenerator.GenerateModelsWithFreezed(returnTypeEntities.ToArray());
    entitiesTypes.AddRange(returnTypeEntitiesInfos);
    repoReturnTypes.AddRange(returnTypeEntitiesInfos);

    // apiRepoReturnType.AddRange(dartEndpoints.Endpoints.Where(x=>x.IsExtra && x.ReflectionResponseType != null).Select(x=>new DartClassModel{
    //     RelativePath= entityTokenGenerator.GetFilePath(x.ReflectionResponseType, true),
    //     ClassName= x.ResponseType
    // }));

    var paramInfos = entityTokenGenerator.GenerateModelsWithFreezed(dartEndpoints.Endpoints.SelectMany(x => x.Params).Select(x => x.ReflectionType).Distinct().Where(x => x != null).ToArray());
    entitiesTypes.AddRange(paramInfos);

    var dataSourceFolder = Path.Combine(outputFolder, "remote_data_sources");
    if (!Directory.Exists(dataSourceFolder))
    {
        Directory.CreateDirectory(dataSourceFolder);
    }

    var dataSourceFilePath = Path.Combine(dataSourceFolder, dartEndpoints.DartFileInfo.FeatureName, $"{dartEndpoints.DartFileInfo.Name}.dart");
    if (!Directory.Exists(Path.GetDirectoryName(dataSourceFilePath)))
    {
        Directory.CreateDirectory(Path.GetDirectoryName(dataSourceFilePath));
    }
    foreach (var entityInfo in returnTypeEntitiesInfos)
    {
        dartEndpoints.DartFileInfo.Imports.Add(Path.GetRelativePath(Path.GetDirectoryName(dataSourceFilePath), entityInfo.RelativePath));
    }

    foreach (var entityInfo in paramInfos)
    {
        dartEndpoints.DartFileInfo.Imports.Add(Path.GetRelativePath(Path.GetDirectoryName(dataSourceFilePath), entityInfo.RelativePath));
    }

    var allEntities = returnTypeEntitiesInfos.Concat(paramInfos).DistinctBy(x => x.RelativePath).Where(x => x != null).ToList();

    var hash = Hash.FromAnonymousObject(dartEndpoints);
    Template.NamingConvention = new CSharpNamingConvention();
    var template = Template.Parse(File.ReadAllText(Path.Combine(CommonPath.BaseDirectory, "templates/data_source_template.liquid")));
    File.WriteAllText(dataSourceFilePath, template.Render(hash));


    var repositoriesFolder = Path.Combine(outputFolder, "repositories");
    if (!Directory.Exists(repositoriesFolder))
    {
        Directory.CreateDirectory(repositoriesFolder);
    }

    var repositoryFilePath = Path.Combine(repositoriesFolder, dartEndpoints.DartFileInfo.FeatureName, $"{dartEndpoints.DartFileInfo.FeatureName}_repository.dart");
    if (!Directory.Exists(Path.GetDirectoryName(repositoryFilePath)))
    {
        Directory.CreateDirectory(Path.GetDirectoryName(repositoryFilePath));
    }
    var imports = new List<string> { Path.GetRelativePath(Path.GetDirectoryName(repositoryFilePath), dataSourceFilePath), };
    // imports.AddRange(dartEndpoints.DartFileInfo.Imports.Where(x => x.StartsWith(".")));

    imports.AddRange(allEntities.Select(x => Path.GetRelativePath(Path.GetDirectoryName(repositoryFilePath), x.RelativePath)));
    var repositoryTemplate = new RepositoryTemplateDrop {
        FeatureName = dartEndpoints.DartFileInfo.InstanceName,
        Imports = imports,
        Endpoints = dartEndpoints.Endpoints.Select(x => new ControllerAnalyzer.Models.RepositoryTemplateModels.EndpointDrop {
            EntityType = x.ResponseType,
            ActionName = x.Name,
            Url = x.Path,
            Params = x.Params.Select(p => new ControllerAnalyzer.Models.RepositoryTemplateModels.ParamDrop {
                Name = p.Name,
                Type = p.Type,
                IsOptional = p.IsOptional
            }).ToList()
        }).ToList()
    };

    var repositoryHash = Hash.FromAnonymousObject(repositoryTemplate);
    var repositoryTemplateTemplate = Template.Parse(File.ReadAllText(Path.Combine(CommonPath.BaseDirectory, "templates/repository_template.liquid")));
    File.WriteAllText(repositoryFilePath, repositoryTemplateTemplate.Render(repositoryHash));
}


var constantsFolder = Path.Combine(outputFolder, "constants");
if (!Directory.Exists(constantsFolder))
{
    Directory.CreateDirectory(constantsFolder);
}

var cacheAdapterPath = Path.Combine(constantsFolder, "cache_adapter_types.dart");

var cacheAadapterTemplate = new
{
    Endpoints = repoReturnTypes.DistinctBy(x => x.RelativePath).Where(x => x != null).Concat(apiRepoReturnType.DistinctBy(x => x.RelativePath).Where(x => x != null)).Select(x => new
    {
        IsApiResponse = x.ClassName.StartsWith("ApiResponse"),
        EntityType = x.ClassName,
    }).ToList(),
    Imports = repoReturnTypes.Where(x => !x.ClassName.StartsWith("ApiResponse")).DistinctBy(x => x.RelativePath).Where(x => x != null).Select(x => Path.GetRelativePath(Path.GetDirectoryName(cacheAdapterPath), x.RelativePath)).ToList()
};

var cacheAdapterHash = Hash.FromAnonymousObject(cacheAadapterTemplate);
var cacheAdapterLiquidTemplate = Template.Parse(File.ReadAllText(Path.Combine(CommonPath.BaseDirectory, "templates/cache_adapters.liquid")));
File.WriteAllText(cacheAdapterPath, cacheAdapterLiquidTemplate.Render(cacheAdapterHash));


var fromJsonPath = Path.Combine(constantsFolder, "from_json_by_type.dart");
var fromJsonTemplate = new
{
    ClassModels = entitiesTypes.DistinctBy(x => x.RelativePath).ToList().Select(x => new
    {

        Name = x.ClassName
    }).ToList(),
    Imports = entitiesTypes.DistinctBy(x => x.RelativePath).Select(x => Path.GetRelativePath(Path.GetDirectoryName(fromJsonPath), x.RelativePath)).ToList()
};

var fromJsonHash = Hash.FromAnonymousObject(fromJsonTemplate);
var fromJsonLiquidTemplate = Template.Parse(File.ReadAllText(Path.Combine(CommonPath.BaseDirectory, "templates/from_json_by_type.liquid")));
File.WriteAllText(fromJsonPath, fromJsonLiquidTemplate.Render(fromJsonHash));

await app.DisposeAsync();