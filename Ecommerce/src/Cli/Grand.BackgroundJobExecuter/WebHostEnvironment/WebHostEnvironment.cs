using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting.Internal;

namespace Grand.BackgroundJobExecuter.WebHostEnvironment;

public class WebHostEnvironment: HostingEnvironment, IWebHostEnvironment
{
    
    public string WebRootPath { get; set; }
    public IFileProvider WebRootFileProvider { get; set; }
}