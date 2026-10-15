using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text.Json;
using Platform.Security;

namespace Platform.Provisioning.Adapters;

public sealed class StoreInstallerStep(LocalOnboardingOptions options, ITenantSecrets secrets) : IProvisioningStep
{
    public string Name => "store";
    public async Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string,ProvisioningStepResult> completed, CancellationToken ct)
    {
        var output=Path.Combine(options.TenantDirectory,request.Slug+".json");
        if (!File.Exists(output))
        {
            var work=Path.Combine(options.WorkingDirectory,request.TenantId);
            Directory.CreateDirectory(Path.Combine(work,"Plugins"));
            Directory.CreateDirectory(Path.Combine(work,"wwwroot"));
            Directory.CreateDirectory(Path.Combine(work,"App_Data"));
            var installerDirectory=Path.GetDirectoryName(options.InstallerPath)!;
            foreach (var name in new[] { "Resources", "MessageTemplates", "LandingPages" })
            {
                var source=Path.Combine(installerDirectory,"App_Data",name);
                foreach (var file in Directory.GetFiles(source,"*",SearchOption.AllDirectories))
                {
                    var destination=Path.Combine(work,"App_Data",name,Path.GetRelativePath(source,file));
                    Directory.CreateDirectory(Path.GetDirectoryName(destination)!);File.Copy(file,destination,true);
                }
            }
            File.Copy(Path.Combine(installerDirectory,"wwwroot","logo.png"),Path.Combine(work,"wwwroot","logo.png"),true);
            var states=Path.Combine(installerDirectory,"App_Data","turkey_states.xlsx");
            if (File.Exists(states)) File.Copy(states,Path.Combine(work,"App_Data","turkey_states.xlsx"),true);
            var start=new ProcessStartInfo("dotnet") { WorkingDirectory=work,UseShellExecute=false,RedirectStandardOutput=true,RedirectStandardError=true };
            start.ArgumentList.Add(options.InstallerPath);
            var values=new Dictionary<string,string> {
                ["TenantId"]=request.TenantId,["StoreName"]=request.StoreName,["StoreSubDomain"]=request.Slug,
                ["OwnerEmail"]=request.OwnerEmail,["FirstName"]=request.FirstName,["Lastname"]=request.LastName,["Role"]="business_owner",
                ["CompanyName"]=request.StoreName,["CompanyAddress"]=request.CompanyAddress,["CompanyPhoneNumber"]=request.CompanyPhone,
                ["CompanyEmail"]=request.CompanyEmail,
                ["Password"]=await secrets.GetAsync(request.TenantId,TenantSecretNames.InitialPassword,ct),
                ["MongoConnectionString"]=await secrets.GetAsync(request.TenantId,TenantSecretNames.DatabaseConnection,ct)
            };
            foreach (var item in values) start.Environment["TenantMessage__"+item.Key]=item.Value;
            start.Environment["DOTNET_ENVIRONMENT"]="Development";start.Environment["ASPNETCORE_ENVIRONMENT"]="Development";
            start.Environment["LocalDemo__Enabled"]="true";start.Environment["LocalDemo__ConfigPath"]=options.CommerceConfigPath;
            start.Environment["LocalDemo__TenantOutput"]=output;
            start.Environment["Provisioning__ManagedInstaller"]="true";
            using var process=Process.Start(start) ?? throw new InvalidOperationException("Installer could not start.");
            // Drain output without propagating provider payloads or credentials into job logs.
            var lines=new ConcurrentQueue<string>();
            var redactions=new[] {values["Password"],values["MongoConnectionString"]};
            var stdout=DrainAsync(process.StandardOutput,lines,redactions,ct);var stderr=DrainAsync(process.StandardError,lines,redactions,ct);
            using var timeout=CancellationTokenSource.CreateLinkedTokenSource(ct);timeout.CancelAfter(TimeSpan.FromMinutes(20));
            try { await process.WaitForExitAsync(timeout.Token);await Task.WhenAll(stdout,stderr); }
            catch { if (!process.HasExited) process.Kill(true);throw; }
            finally {await PrivateFiles.WriteAsync(Path.Combine(work,"installer.log"),string.Join(Environment.NewLine,lines),CancellationToken.None);}
            if (process.ExitCode!=0) throw new InvalidOperationException("Tenant installer failed.");
        }
        using var result=JsonDocument.Parse(await File.ReadAllTextAsync(output,ct));
        if (result.RootElement.GetProperty("tenantId").GetString()!=request.TenantId || result.RootElement.GetProperty("slug").GetString()!=request.Slug)
            throw new InvalidOperationException("Installer output belongs to a different tenant.");
        var storeId=result.RootElement.GetProperty("storeId").GetString()!;
        await secrets.BindAliasAsync(request.TenantId,storeId,ct);
        return new("GrandNode",new Dictionary<string,string> { ["storeId"]=storeId });
    }
    private static async Task DrainAsync(StreamReader reader,ConcurrentQueue<string> lines,string[] redactions,CancellationToken ct)
    {
        while (await reader.ReadLineAsync(ct) is string line)
        {
            foreach(var value in redactions) line=line.Replace(value,"[REDACTED]",StringComparison.Ordinal);
            if (lines.Count<4000) lines.Enqueue(line.Length>8192?line[..8192]:line);
        }
    }
}
