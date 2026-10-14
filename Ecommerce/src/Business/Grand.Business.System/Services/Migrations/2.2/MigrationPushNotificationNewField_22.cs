using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Data;
using Grand.Domain.Localization;
using Grand.Infrastructure.Migrations;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Grand.Business.System.Services.Migrations._2._2;

public class MigrationPushNotificationNewField_22: IMigration
{
    public DbVersion Version => new(2, 2);
    public Guid Identity => new("04a02c76-0f93-495e-b53c-139fba2b6156");
    public string Name => "Push notification new field resources 2.2";
    public int Priority => 0;
    public bool UpgradeProcess(IDatabaseContext database, IServiceProvider serviceProvider)
    {
        var logger = serviceProvider.GetRequiredService<ILogger<MigrationPushNotificationNewField_22>>();
        try
        {
            var translationService = serviceProvider.GetRequiredService<ITranslationService>();
            var languageService = serviceProvider.GetRequiredService<IRepository<Language>>();
            var languages = languageService.Table.ToList();
            foreach (var language in languages)
            {
                try
                {
                    AddOrUpdateResourceString(translationService, language.Id,
                        "Admin.Settings.PushNotifications.ServiceAccountFile", "Google service hesabı dosyası",
                        TranslationResourceArea.Admin).GetAwaiter().GetResult();
                    logger.LogInformation(
                        "Push Notification translation resource Admin.Settings.PushNotifications.ServiceAccountFile added for {Language}",
                        language.Name);
                    
                    AddOrUpdateResourceString(translationService, language.Id,
                        "Admin.Settings.PushNotifications.ServiceAccountJson", "Google service hesabı json dosyası",
                        TranslationResourceArea.Admin).GetAwaiter().GetResult();
                    logger.LogInformation(
                        "Push Notification translation resource Admin.Settings.PushNotifications.ServiceAccountJson added for {Language}",
                        language.Name);
                    
                    AddOrUpdateResourceString(translationService, language.Id,
                        "Admin.Settings.PushNotifications.UseHttpV1Api", "Google service hesabı json dosyası",
                        TranslationResourceArea.Admin).GetAwaiter().GetResult();
                    logger.LogInformation(
                        "Push Notification translation resource Admin.Settings.PushNotifications.ServiceAccountJson added for {Language}",
                        language.Name);
                    
                    AddOrUpdateResourceString(translationService, language.Id,
                        "Admin.Settings.PushNotifications.ServiceAccountFile.Configured", "Google service hesabı başarıyla yüklendi",
                        TranslationResourceArea.Admin).GetAwaiter().GetResult();
                    logger.LogInformation(
                        "Push Notification translation resource Admin.Settings.PushNotifications.ServiceAccountFile.Configured added for {Language}",
                        language.Name);
                    
                    AddOrUpdateResourceString(translationService, language.Id,
                        "Admin.Settings.PushNotifications.ServiceAccountFile.Hint", "Google service hesabı dosyanız google cloud console için gerekli olan json dosyasıdır. Bu dosyayı yükleyerek google service hesabınızı yapılandırabilirsiniz",
                        TranslationResourceArea.Admin).GetAwaiter().GetResult();
                    logger.LogInformation(
                        "Push Notification translation resource Admin.Settings.PushNotifications.ServiceAccountFile.Hint added for {Language}",
                        language.Name);
                    
                    AddOrUpdateResourceString(translationService, language.Id,
                        "Admin.Settings.PushNotifications.ServiceAccountFile.Hint", "Google service hesabı başarıyla yüklendi",
                        TranslationResourceArea.Admin).GetAwaiter().GetResult();
                    logger.LogInformation(
                        "Push Notification translation resource Admin.Settings.PushNotifications.ServiceAccountFile.Hint added for {Language}",
                        language.Name);

                }
                catch (Exception e)
                {
                    logger.LogError(e,"Push Notification translation resource migration failed");
                    return false;
                }
            }
            return true;
        }
        catch (Exception e)
        {
            logger.LogError(e,"Push Notification translation resource migration failed");
            return false;
        }
    }
    
    async Task AddOrUpdateResourceString(ITranslationService translationService,string languageId, string name, string value, TranslationResourceArea  area)
    {
        var resource = await translationService.GetTranslateResourceByName(name, languageId);
        if (resource == null)
        {
            await translationService.InsertTranslateResource(new TranslationResource() {
                LanguageId = languageId,
                Name = name,
                Value = value,
                Area = area
            });
        }
        else
        {
            resource.Value = value;
            resource.Area = area;
            await translationService.UpdateTranslateResource(resource);
        }
    }
}