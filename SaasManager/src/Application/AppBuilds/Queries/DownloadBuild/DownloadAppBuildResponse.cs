namespace SaasManager.Application.AppBuilds.Queries.DownloadBuild;

public class DownloadAppBuildResponse
{
    public Stream FileStream { get; set; }
    public string MimeType { get; set; }
    public string FileName { get; set; }
}
