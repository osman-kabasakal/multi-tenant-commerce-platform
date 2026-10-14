namespace Grand.Business.Tenants.Constants.Hangfire;

public class HangfireConstants
{
    public const string FrontendQueue = "multi-tenant-frontend-queue";
    public const string SendMessageQueue = "multi-tenant-send-message-queue";
    public const string AddCorrelationCacheKeyQueue = "multi-tenant-add-correlation-cache-key-queue";
}