namespace Grand.Web.Admin.Infrastructure;

/// <summary>Keep saved notification paths on the store's current canonical origin.</summary>
public static class StorePushLinks
{
    public static string Default(string storeUrl, IEnumerable<string> knownOrigins, string? saved, bool allowHttp = false)
    {
        if (!Uri.TryCreate(storeUrl, UriKind.Absolute, out var current) || (current.Scheme != "https" && !(allowHttp && current.Scheme == "http")) || current.UserInfo.Length != 0)
            throw new InvalidOperationException("Configure the active HTTPS store origin.");
        var root = new Uri(current.GetLeftPart(UriPartial.Authority) + "/");
        if (string.IsNullOrWhiteSpace(saved)) return root.AbsoluteUri;
        Uri? target;
        if (Uri.TryCreate(saved, UriKind.Relative, out var relative))
        {
            if (!Uri.TryCreate(root, relative, out target) || target.Scheme != root.Scheme || target.Authority != root.Authority || target.UserInfo.Length != 0)
                return root.AbsoluteUri;
        }
        else if (Uri.TryCreate(saved, UriKind.Absolute, out var absolute))
        {
            if (absolute.Scheme != root.Scheme || absolute.UserInfo.Length != 0 ||
                !knownOrigins.Append(storeUrl).Any(x => Uri.TryCreate(x, UriKind.Absolute, out var origin) && origin.Authority.Equals(absolute.Authority, StringComparison.OrdinalIgnoreCase)))
                return root.AbsoluteUri;
            target = new Uri(root, absolute.PathAndQuery + absolute.Fragment);
        }
        else if (!Uri.TryCreate(root, saved, out target) || target.Authority != root.Authority || target.UserInfo.Length != 0)
            return root.AbsoluteUri;
        if (target.AbsolutePath.Equals("/Admin", StringComparison.OrdinalIgnoreCase) || target.AbsolutePath.StartsWith("/Admin/", StringComparison.OrdinalIgnoreCase))
            return root.AbsoluteUri;
        return target.AbsoluteUri;
    }
}
