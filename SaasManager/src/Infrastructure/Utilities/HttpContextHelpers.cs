using Microsoft.AspNetCore.Http;

namespace SaasManager.Infrastructure.Utilities;

public static class HttpContextHelpers
{
    public static bool IsAjaxRequest(this HttpContext context)
    {
        if (context == null)
            throw new ArgumentNullException(nameof(context));

        // Check X-Requested-With header
        if (context.Request.Headers.TryGetValue("X-Requested-With", out var requestedWith))
        {
            return requestedWith.ToString().Equals("XMLHttpRequest", StringComparison.OrdinalIgnoreCase);
        }

        // Check if the request accepts JSON
        if (context.Request.Headers.TryGetValue("Accept", out var accept))
        {
            return accept.ToString().Contains("application/json", StringComparison.OrdinalIgnoreCase);
        }

        return false;
    }
    
}
