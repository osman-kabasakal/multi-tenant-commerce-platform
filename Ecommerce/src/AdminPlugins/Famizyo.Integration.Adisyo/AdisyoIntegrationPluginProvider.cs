using Famizyo.Integration.Adisyo.Tasks;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Domain.Tasks;
using Grand.Infrastructure.Plugins;
using Grand.SharedKernel.Extensions;
using Microsoft.Extensions.Logging;

namespace Famizyo.Integration.Adisyo;

public class AdisyoIntegrationPluginProvider : BasePlugin
{
    private readonly ILogger<AdisyoIntegrationPluginProvider> _logger;
    private readonly IScheduleTaskService _scheduleTaskService;
    private readonly ITranslationService _translationService;
    private readonly ILanguageService _languageService;

    public AdisyoIntegrationPluginProvider(
        ILogger<AdisyoIntegrationPluginProvider> logger,
        IScheduleTaskService scheduleTaskService,
        ITranslationService translationService,
        ILanguageService languageService)
    {
        _logger = logger;
        _scheduleTaskService = scheduleTaskService;
        _translationService = translationService;
        _languageService = languageService;
    }

    private string GetTaskTypeFullname<TTask>()
    {
        var scheduleType = typeof(TTask);
        var taskAssemblyName = scheduleType.Assembly.GetName().Name;
        var taskFullname = $"{scheduleType.FullName}, {taskAssemblyName}";
        return taskFullname;
    }

    public override async Task Install()
    {
        await InsertAdisyoOrderTask();

        await InsertAdisyoProductTask();
        
        // Install translation resources
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.FriendlyName, "Adisyo Entegrasyonu");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.ApiKey, "API Anahtarı");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.ApiSecret, "API Gizli Anahtarı");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.Consumer, "Tüketici Adı");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.BaseUrl, "API Base URL");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.EnableProductSync, "Ürün Senkronizasyonu Etkin");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.ProductMappingStrategy, "Ürün Eşleştirme Stratejisi");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.SelectedCategoryIds, "Seçili Kategori ID'leri");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.ProductSyncInterval, "Ürün Senkronizasyon Aralığı (Dakika)");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.UpdateExistingProducts, "Mevcut Ürünleri Güncelle");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.CreateNewProducts, "Yeni Ürün Oluştur");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.SyncProductPrices, "Ürün Fiyatlarını Senkronize Et");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.SyncProductFeatures, "Ürün Özelliklerini Senkronize Et");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.PublishSyncedProducts, "Senkronize Edilen Ürünleri Yayınla");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.OrderType, "Sipariş Tipi");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.PaymentMethodId, "Ödeme Yöntemi ID");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.EnableOrderStatusSync, "Sipariş Durumu Senkronizasyonu");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.OrderStatusSyncInterval, "Senkronizasyon Aralığı (Dakika)");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.EnableOrderCancellation, "Sipariş İptali Etkin");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.IngredientPropertyName, "Malzeme Özellik Adı");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.MapOtherPropertiesAsSpecifications, "Diğer Özellikleri Spesifikasyon Olarak Ekle");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.SyncCategoryIds, "Senkronize Edilecek Kategori ID'leri");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.HomepageCategoryIds, "Ana Sayfada Gösterilecek Kategori ID'leri");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.FeaturedProductCategoryIds, "Öne Çıkan Ürünler Kategori ID'leri");
        
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.ProductLayoutId, "Ürün Düzeni ID");
        
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.TaxCategoryId, "Vergi Kategorisi ID");
        
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            AdisyoIntegrationDefaults.ServiceFeeCategoryId, "Hizmet Ücreti Kategorisi ID");

        _logger.LogInformation("Adisyo Integration plugin installed successfully");
    }

    private async Task InsertAdisyoOrderTask()
    {
        // Install scheduled task for order synchronization
        var task = await _scheduleTaskService.GetTaskByType(GetTaskTypeFullname<AdisyoOrderSyncTask>());
        if (task == null)
        {
            _logger.LogInformation("Installing Adisyo Order Sync Task");
            await _scheduleTaskService.InsertTask(new ScheduleTask()
            {
                ScheduleTaskName = "Adisyo Order Sync Task",
                Type = GetTaskTypeFullname<AdisyoOrderSyncTask>(),
                Enabled = true,
                StopOnError = false,
                TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(1).TotalMinutes)
            });
        }
        else
        {
            task.ScheduleTaskName = "Adisyo Order Sync Task";
            task.Enabled = true;
            task.StopOnError = false;
            task.TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(1).TotalMinutes);
            await _scheduleTaskService.UpdateTask(task);
        }
    }
    
    private async Task InsertAdisyoProductTask()
    {
        // Install scheduled task for order synchronization
        var task = await _scheduleTaskService.GetTaskByType(GetTaskTypeFullname<AdisyoProductSyncTask>());
        if (task == null)
        {
            _logger.LogInformation("Installing Adisyo products Sync Task");
            await _scheduleTaskService.InsertTask(new ScheduleTask()
            {
                ScheduleTaskName = "Adisyo Products Sync Task",
                Type = GetTaskTypeFullname<AdisyoProductSyncTask>(),
                Enabled = true,
                StopOnError = false,
                TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(2).TotalMinutes)
            });
        }
        else
        {
            task.ScheduleTaskName = "Adisyo Products Sync Task";
            task.Enabled = true;
            task.StopOnError = false;
            task.TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(2).TotalMinutes);
            await _scheduleTaskService.UpdateTask(task);
        }
    }

    public override string ConfigurationUrl()
    {
        return "AdisyoIntegration/Configure";
    }
}