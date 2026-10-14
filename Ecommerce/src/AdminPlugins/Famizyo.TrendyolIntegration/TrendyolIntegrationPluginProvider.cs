using Famizyo.TrendyolIntegration.Tasks;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Domain.Tasks;
using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Plugins;
using Grand.SharedKernel.Extensions;
using Microsoft.Extensions.Logging;

namespace Famizyo.TrendyolIntegration;

public class TrendyolIntegrationPluginProvider(
    ILogger<TrendyolIntegrationPluginProvider> logger,
    IScheduleTaskService scheduleTaskService,
    ISettingService settingService,
    ICacheBase cacheBase,
    ITranslationService translationService,
    ILanguageService languageService)
    : BasePlugin, IPlugin
{
    private readonly ISettingService _settingService = settingService;
    private readonly ICacheBase _cacheBase = cacheBase;
    private readonly ITranslationService _translationService = translationService;
    private readonly ILanguageService _languageService = languageService;

    private string GetTaskTypeFullname<TTask>()
    {
        var scheduleType = typeof(TTask);
        var taskAssemblyName = scheduleType.Assembly.GetName().Name;
        var taskFullname = $"{scheduleType.FullName}, {taskAssemblyName}";
        return taskFullname;
    }
    public override async Task Install()
    {
        var task = await scheduleTaskService.GetTaskByType(GetTaskTypeFullname<TrendyolRestaurantMenuSyncTask>());
        if (task == null)
        {
            logger.LogInformation("Trendyol Restaurant Menu Sync Task installed.");
            await scheduleTaskService.InsertTask(new ScheduleTask()
            {
                ScheduleTaskName = "Trendyol Restaurant Menu Sync Task",
                Type = GetTaskTypeFullname<TrendyolRestaurantMenuSyncTask>(),
                Enabled = true,
                StopOnError = false,
                TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(10).TotalMinutes)
            });
            return;
        }
        else
        {
            task.ScheduleTaskName = "Trendyol Restaurant Menu Sync Task";
            task.Enabled = true;
            task.StopOnError = false;
            task.TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(4).TotalMinutes);
            await scheduleTaskService.UpdateTask(task);
        }

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            TrendyolIntegrationDefaults.TrendyolIntegrationFriendlyName, "Trendyol Entegrasyonu");
        
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            TrendyolIntegrationDefaults.ApiKey, "Api Anahtarı");
        
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            TrendyolIntegrationDefaults.ApiSecret, "Api Gizli Anahtarı");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            TrendyolIntegrationDefaults.SaticiId, "Satici Id");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            TrendyolIntegrationDefaults.StoreId, "Store Id");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            TrendyolIntegrationDefaults.BestSellerSectionId, "En Çok Satanlar Bölümü");
        
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            TrendyolIntegrationDefaults.NewSectionId, "Yeni Ürünler Bölümü");

    }

    public override string ConfigurationUrl()
    {
        return "TrendyolIntegration/Configure";
    }
}