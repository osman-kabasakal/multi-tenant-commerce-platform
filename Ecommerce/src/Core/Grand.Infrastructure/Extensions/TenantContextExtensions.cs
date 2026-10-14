using Grand.Data;
using Microsoft.AspNetCore.Http;

namespace Grand.Infrastructure.Extensions;

public static class TenantContextExtensions
{
    public static string GetTenantId(this HttpContext context)
    {
        if (context == null)
            return null;
        return context.Items.TryGetValue("StoreId", out var value) ? value?.ToString() : null;
    }
    
    public static string GetConnectionString(this HttpContext context)
    {
        if (context == null)
            return null;
        return context.Items.TryGetValue("StoreMongoConnectionString", out var value) ? value?.ToString() : null;
    }
    
    public static DataSettings GetDataSettings(this HttpContext context)
    {
        if (context == null)
            return null;
        var connectionString = context.GetConnectionString();
        return new DataSettings() {
            ConnectionString = connectionString,
            DbProvider = DbProvider.MongoDB
        };
    }
}