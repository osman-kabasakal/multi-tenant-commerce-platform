using Microsoft.AspNetCore.Http;
using System;

namespace Grand.Web.MultiTenant.MiddleWares;

public class CorrelationIdMiddleware
{
    private readonly RequestDelegate _next;

    public CorrelationIdMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // Benzersiz bir korelasyon kimliği oluştur
        var correlationId = Guid.NewGuid().ToString();
        
        // HttpContext.Items'a kaydet
        context.Items["CorrelationId"] = correlationId;
        
        // Response header'a ekle (isteğe bağlı, debug için faydalı)
        context.Response.Headers.Append("X-Correlation-ID", correlationId);
        
        await _next(context);
    }
}
