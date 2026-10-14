namespace Grand.Web.MultiTenant.Services;

public class PublicRouteService
{
    private List<string> _publicPaths = new List<string>() {
        "privacy-policy"
    };

    public bool IsPublicPath(string path) => path != null && _publicPaths.Contains(path.Trim().TrimStart('/').TrimEnd('/').ToLowerInvariant());


    public async Task<string> GetPublicContent(string path)
    {
        var content = string.Empty;
        switch (path)
        {
            case "privacy-policy":
                var pathContent = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "PublicPathContent",
                    "privacy-policy.html");
                if (File.Exists(pathContent))
                {
                    content = await File.ReadAllTextAsync(pathContent);
                }
                break;
            default:
                break;
        }
        return content;
    }
}