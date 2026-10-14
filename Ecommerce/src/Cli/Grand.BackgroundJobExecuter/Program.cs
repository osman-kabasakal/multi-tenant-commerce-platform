using Azure.Identity;
using Grand.Business.Common.Services.Security;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.Tenants.KeycloakUsers;
using Grand.Business.Tenants.Services.KeycloakUsers;
using Grand.Domain.Tenants;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Extensions;
using Grand.SharedKernel.Extensions;
using Grand.Web.ExternalSettings.Extensions;
using Hangfire;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Hosting.Internal;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;
using System.Reflection;
using StartupBase = Grand.Infrastructure.StartupBase;

namespace Grand.BackgroundJobExecuter;

public class Program
{
    
    private static IHost? _host;
    private static readonly AutoResetEvent _waitHandle = new AutoResetEvent(false);
    private static bool _isRunning = true;
    public static async Task Main(string[] args)
    {
        var loadedAssemblies = AppDomain.CurrentDomain.GetAssemblies().ToList();
        var loadedPath = loadedAssemblies.Where(a => !a.IsDynamic).Select(x => x.Location);

        var referencedAssemblyPath = Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll");
        var deltaLoad =
            referencedAssemblyPath.Where(r => !loadedPath.Contains(r, StringComparer.InvariantCultureIgnoreCase));

        foreach (var referencePath in deltaLoad)
        {
            if (referencePath.StartsWith(AppDomain.CurrentDomain.BaseDirectory + "Grand.Business")
                || referencePath.StartsWith(AppDomain.CurrentDomain.BaseDirectory + "Grand.Api"))
            {
                loadedAssemblies.Add(
                    AppDomain.CurrentDomain.Load(AssemblyName.GetAssemblyName(referencePath.ToString())));
            }
        }

        var builder = CreateHostBuilder(args);
        builder.ConfigureContainer(
            new DefaultServiceProviderFactory(new ServiceProviderOptions() {
                ValidateOnBuild = false,
                ValidateScopes = false
            })
            );
        builder.Configuration.AddEnvironmentVariables();
        builder.Configuration.AddEnvironmentVariables(prefix: "ASPNETCORE_");
        
        if (builder.Environment.IsDevelopment())
        {
            CommonPath.WebHostEnvironment =
                Path.Combine(Directory.GetParent(builder.Environment.ContentRootPath).FullName, "wwwroot");
            CommonPath.BaseDirectory = Directory.GetParent(builder.Environment.ContentRootPath).Parent.Parent.Parent.FullName;
            builder.Environment.ContentRootPath = CommonPath.BaseDirectory;
        }
        else
        {
            CommonPath.WebHostEnvironment =
                Path.Combine(builder.Environment.ContentRootPath, "wwwroot");
            CommonPath.BaseDirectory = builder.Environment.ContentRootPath;
            builder.Environment.ContentRootPath = CommonPath.BaseDirectory;
        }
        
        builder.Services.AddSingleton<IWebHostEnvironment,WebHostEnvironment.WebHostEnvironment>((s)=>new WebHostEnvironment.WebHostEnvironment {
            ApplicationName = builder.Environment.ApplicationName,
            ContentRootFileProvider = builder.Environment.ContentRootFileProvider,
            ContentRootPath = builder.Environment.ContentRootPath,
            EnvironmentName = builder.Environment.EnvironmentName,
            WebRootPath = CommonPath.WebHostEnvironment,
            WebRootFileProvider = new PhysicalFileProvider(CommonPath.WebHostEnvironment)
        });
        builder.Services.AddHttpClient();
        
        // Add full MVC services required for PDF generation and view rendering
        builder.Services.AddControllersWithViews();
        builder.Services.AddRazorPages();
        
        // Configure Razor view engine for background job context
        builder.Services.Configure<Microsoft.AspNetCore.Mvc.Razor.RazorViewEngineOptions>(options =>
        {
            options.ViewLocationFormats.Clear();
            options.ViewLocationFormats.Add("/Views/{1}/{0}.cshtml");
            options.ViewLocationFormats.Add("/Views/Shared/{0}.cshtml");
            options.ViewLocationFormats.Add("/Views/PdfTemplates/{0}.cshtml");
        });
        
        // Add additional required services for web context
        builder.Services.AddHttpContextAccessor();
        builder.Services.AddAntiforgery();
        builder.Services.AddDataProtection();
        
        // Add diagnostics explicitly - DiagnosticListener implements DiagnosticSource
        var diagnosticListener = new System.Diagnostics.DiagnosticListener("Microsoft.AspNetCore");
        builder.Services.AddSingleton<System.Diagnostics.DiagnosticSource>(diagnosticListener);
        builder.Services.AddSingleton<System.Diagnostics.DiagnosticListener>(diagnosticListener);
        builder.Services.AddSingleton<System.Diagnostics.ActivitySource>(new System.Diagnostics.ActivitySource("Microsoft.AspNetCore"));
        
        var configValues = new Dictionary<string, string>
        {
            {"MultitenantTask:Enabled", "true"},
        };
        builder.Configuration.AddInMemoryCollection(configValues);
        ((ConfigurationManager)builder.Configuration).AddJsonFile(Path.Combine(AppDomain.CurrentDomain.BaseDirectory,
            "appsettings.multitenant.json"));
        
        builder.AddServiceDefaults();
        builder.Services.AddRedisCache(builder.Configuration);
        
        StartupBase.ConfigureServices(builder.Services, builder.Configuration);
        
        
        var config = new AppConfig();
        builder.Configuration.GetSection("Application").Bind(config);
        if (config.MaxRequestBodySize.HasValue)
        {
            builder.Services.Configure<FormOptions>(opt =>
            {
                opt.MultipartBodyLengthLimit = config.MaxRequestBodySize.Value;
            });
        }
        
        _host = builder.Build();
        
        
        // Ctrl+C yakalamak için
        Console.CancelKeyPress += (sender, e) =>
        {
            e.Cancel = true;
            _isRunning = false;
            _waitHandle.Set();
        };

        {
            _host.Start();
            // UI thread'ini başlat
            var uiThread = new Thread(() =>
            {
                while (_isRunning)
                {
                    // UI güncellemeleri burada yapılabilir
                    // Örneğin, konsola bir mesaj yazdırabilirsiniz
                    // Console.WriteLine("Background job is running...");
                    Thread.Sleep(1000); // 1 saniye bekle
                }
            }) {
                IsBackground = true
            };

            uiThread.Start();
            _host.Services.GetRequiredService<RedisCacheCoordinator>().SubscribeToRedisChannel();

            // Ana thread'i beklet
            _waitHandle.WaitOne();

            // Uygulama kapatılırken
            await _host.StopAsync();
        }
    }

    public static HostApplicationBuilder CreateHostBuilder(string[] args) =>
        Host.CreateApplicationBuilder(new HostApplicationBuilderSettings {
            ApplicationName = "Grand.BackgroundJobExecuter",
            Args = args,
            Configuration = new ConfigurationManager(),
            ContentRootPath = AppDomain.CurrentDomain.BaseDirectory,
            EnvironmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT"),
            
        });
}