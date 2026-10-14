using DartModelGenerator;
using Grand.Api.Models.Common;
using Grand.Web.Models.Catalog;
using Grand.Web.Models.ShoppingCart;
using Grand.Web.MultiTenant.Controllers;
using Iyzipay.Model;
using Payments.Iyzico.Models;
using System.Reflection;
using System.Text;
using Widgets.LegalTexts.Models;
using Widgets.Slider.Models;

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


try
{
    // if (args.Length < 2)
    // {
    //     Console.WriteLine("Usage: ModelConverter.exe <dll-path> <output-directory>");
    //     return;
    // }
    //
    // var dllPath = Path.GetFullPath(args[0]);
    // var outputDirectory = Path.GetFullPath(args[1]);
    //
    // if (!File.Exists(dllPath))
    // {
    //     Console.WriteLine($"Error: DLL file not found at path: {dllPath}");
    //     return;
    // }

    // var collection = new SearchModel();
    // if(!Directory.Exists(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"Models")))Directory.CreateDirectory(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"Models"));

    var converter = new Generator("/workspace/Repos/LocalBusinessEcommerce_BusinessEcommerce/Platforms/store_user_app");
    // converter.GenerateModelsWithFreezed();
    converter.GenerateModelsWithFreezed(typeof(ShoppingCartInfoResponse));
    // if (!Directory.Exists(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "LocalModels")))
    //     Directory.CreateDirectory(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "LocalModels"));
    //
    // var localGenerator = new Generator(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"LocalModels"));
    //
    // localGenerator.GenerateModelsWithFreezed();
    //
    // void mergeFiles(string path)
    // {
    //     var files = Directory.GetFiles(path, "*.dart", SearchOption.AllDirectories);
    //     using (var writer = new StreamWriter(Path.Combine(path,"all_models.dart"), false, Encoding.UTF8))
    //     {
    //         foreach (var modelFile in files)
    //         {
    //             writer.Write(File.ReadAllText(modelFile));
    //             writer.WriteLine();
    //         }
    //     }
    // }
    //
    // mergeFiles(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"LocalModels"));

    Console.WriteLine("Model generation completed successfully!");
}
catch (Exception ex)
{
    Console.WriteLine($"Error: {ex.Message}");
    Console.WriteLine(ex.StackTrace);
}