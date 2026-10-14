using Grand.Business.Core.Interfaces.Storage;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

namespace Grand.Web.MultiTenant.MiddleWares;

public class FileStoreMiddleware
{
    private readonly RequestDelegate _next;

    public FileStoreMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context, IMediaFileStore fileStore)
    {
        
        if (IsStaticFileRequest(context.Request.Path))
        {
            var fileInfo = await fileStore.GetFileInfo(context.Request.Path);
            if (fileInfo?.PhysicalPath == null ||!File.Exists(fileInfo.PhysicalPath) || fileInfo.Length==0)
            {
                var pictureService = context.RequestServices.GetRequiredService<IPictureService>();
                var pictureSplit = Path.GetFileNameWithoutExtension(context.Request.Path).Split("_");
                var pictureSize = pictureSplit.Length > 1 && pictureSplit.First() != pictureSplit.Last()
                    ? int.TryParse(pictureSplit.Last(), out var pictureSizeParsed) ? pictureSizeParsed : 0
                    : 0;
                await pictureService.GetPictureUrl(pictureSplit.First(), pictureSize);
            }
        }
        await _next(context: context);
    }
    
    private bool IsStaticFileRequest(PathString path)
    {
        // Statik dosya uzantıları
        string[] staticFileExtensions = new[] 
        { 
            ".png", ".jpg", ".jpeg", 
            ".gif", ".svg", ".ico", ".webp"
        };

        // Path'in uzantısını al
        string fileExtension = Path.GetExtension(path.Value);

        // Uzantı statik dosya uzantıları listesinde mi?
        return staticFileExtensions.Contains(fileExtension);
    }
}