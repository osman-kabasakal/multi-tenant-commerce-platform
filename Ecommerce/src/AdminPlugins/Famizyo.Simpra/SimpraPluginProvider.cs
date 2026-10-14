using Famizyo.Simpra.Tasks;
using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.System.ScheduleTasks;
using Grand.Domain.Tasks;
using Grand.Infrastructure.Plugins;
using Grand.SharedKernel.Extensions;
using Microsoft.Extensions.Logging;

namespace Famizyo.Simpra;

public class SimpraPluginProvider: BasePlugin, IPlugin
{
    private readonly ITranslationService _translationService;
    private readonly IScheduleTaskService _scheduleTaskService;
    private readonly ILogger<SimpraPluginProvider> _logger;
    private readonly ILanguageService _languageService;

    public SimpraPluginProvider(
        ITranslationService translationService,
        IScheduleTaskService scheduleTaskService,
        ILogger<SimpraPluginProvider> logger,
        ILanguageService languageService)
    {
        _translationService = translationService;
        _scheduleTaskService = scheduleTaskService;
        _logger = logger;
        _languageService = languageService;
    }

    public override async Task Install()
    {
        // Turkish translations
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Famizyo.Simpra.FriendlyName", "Simpra Entegrasyonu", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.AccessToken", "Erişim Token'ı", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.Environment", "Ortam", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableProductSync", "Ürün Senkronizasyonunu Etkinleştir", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.SyncProductPrices", "Ürün Fiyatlarını Senkronize Et", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.RevenueCenterId", "Gelir Merkezi ID", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.SalesChannelId", "Satış Kanalı ID", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.EmployeeId", "Çalışan ID", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.PropertyId", "Mülk ID", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableOrderStatusSync", "Sipariş Durumu Senkronizasyonunu Etkinleştir", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.OrderStatusSyncInterval", "Sipariş Durumu Senkronizasyon Aralığı (dakika)", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.RedisChannelPrefix", "Redis Kanal Öneki", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.PaymentMethodMappings", "Ödeme Yöntemi Eşlemeleri", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.TaxCategoryMappings", "Vergi Kategorisi Eşlemeleri", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ExportToSimpra", "Simpra'ya Aktar", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportFromSimpra", "Simpra'dan İçe Aktar", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportPhotoFromSimpra", "Simpra'dan Fotoğraf İçe Aktar", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ForceUpdateSku", "SKU'yu Zorla Güncelle", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.DefaultImportCategoryId", "Varsayılan İçe Aktarma Kategori ID", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.SyncCategoryIds", "Senkronize Edilecek Kategori ID'leri", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.HomepageCategoryIds", "Ana Sayfa Kategori ID'leri", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.FeaturedProductCategoryIds", "Öne Çıkan Ürün Kategori ID'leri", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportSimpraCategories", "Simpra Kategorilerini İçe Aktar", languageCulture:"languageCulture:tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductLayoutId", "Ürün Düzeni ID", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.TaxCategoryId", "Vergi Kategori ID", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.DefaultSimpraMenuItemGroupId", "Varsayılan Simpra Menü Öğesi Grup ID", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductMappingStrategy", "Ürün Eşleme Stratejisi", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.SelectedCategoryIds", "Seçili Kategori ID'leri", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductSyncInterval", "Ürün Senkronizasyon Aralığı", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.UpdateExistingProducts", "Mevcut Ürünleri Güncelle", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.CreateNewProducts", "Yeni Ürünler Oluştur", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.PublishSyncedProducts", "Senkronize Edilmiş Ürünleri Yayınla", languageCulture:"tr-TR");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableOrderCancellation", "Sipariş İptali Etkinleştir", languageCulture:"tr-TR");

        // English translations
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Famizyo.Simpra.FriendlyName", "Simpra Integration", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.AccessToken", "Access Token", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.Environment", "Environment", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableProductSync", "Enable Product Sync", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.SyncProductPrices", "Sync Product Prices", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.RevenueCenterId", "Revenue Center ID", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.SalesChannelId", "Sales Channel ID", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.EmployeeId", "Employee ID", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.PropertyId", "Property ID", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableOrderStatusSync", "Enable Order Status Sync", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.OrderStatusSyncInterval", "Order Status Sync Interval (minutes)", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.RedisChannelPrefix", "Redis Channel Prefix", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.PaymentMethodMappings", "Payment Method Mappings", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.TaxCategoryMappings", "Tax Category Mappings", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ExportToSimpra", "Export to Simpra", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportFromSimpra", "Import from Simpra", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportPhotoFromSimpra", "Import Photo from Simpra", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ForceUpdateSku", "Force Update SKU", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.DefaultImportCategoryId", "Default Import Category ID", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.SyncCategoryIds", "Sync Category IDs", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.HomepageCategoryIds", "Homepage Category IDs", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.FeaturedProductCategoryIds", "Featured Product Category IDs", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportSimpraCategories", "Import Simpra Categories", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductLayoutId", "Product Layout ID", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.TaxCategoryId", "Tax Category ID", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.DefaultSimpraMenuItemGroupId", "Default Simpra Menu Item Group ID", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductMappingStrategy", "Product Mapping Strategy", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.SelectedCategoryIds", "Selected Category IDs", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductSyncInterval", "Product Sync Interval", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.UpdateExistingProducts", "Update Existing Products", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.CreateNewProducts", "Create New Products", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.PublishSyncedProducts", "Publish Synced Products", languageCulture:"en-US");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableOrderCancellation", "Enable Order Cancellation", languageCulture:"en-US");
        
        
        // Insert scheduled tasks
        await InsertSimpraOrderSyncTask();
        await InsertSimpraProductSyncTask();

        await base.Install();
    }

    public override async Task Uninstall()
    {
        // Remove all localization resources
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Famizyo.Simpra.FriendlyName");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.AccessToken");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.Environment");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableProductSync");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.SyncProductPrices");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.RevenueCenterId");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.SalesChannelId");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.EmployeeId");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.PropertyId");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableOrderStatusSync");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.OrderStatusSyncInterval");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.RedisChannelPrefix");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.PaymentMethodMappings");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.TaxCategoryMappings");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.ExportToSimpra");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportFromSimpra");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportPhotoFromSimpra");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.ForceUpdateSku");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.DefaultImportCategoryId");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.SyncCategoryIds");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.HomepageCategoryIds");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.FeaturedProductCategoryIds");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.ImportSimpraCategories");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductLayoutId");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.TaxCategoryId");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.DefaultSimpraMenuItemGroupId");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductMappingStrategy");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.SelectedCategoryIds");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.ProductSyncInterval");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.UpdateExistingProducts");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.CreateNewProducts");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.PublishSyncedProducts");
        await this.DeletePluginTranslationResource(_translationService, _languageService,"Plugins.Simpra.Fields.EnableOrderCancellation");
        
        // Remove scheduled tasks
        var orderTask = await _scheduleTaskService.GetTaskByType(GetTaskTypeFullname<SimpraOrderSyncTask>());

        if (orderTask != null)
        {
           await  _scheduleTaskService.DeleteTask(orderTask);
        }
        
        var productTask = await _scheduleTaskService.GetTaskByType(GetTaskTypeFullname<SimpraProductSyncTask>());
        if (productTask == null)
        {
            await _scheduleTaskService.DeleteTask(productTask);
        }

        await base.Uninstall();
    }
    
    private string GetTaskTypeFullname<TTask>()
    {
        var scheduleType = typeof(TTask);
        var taskAssemblyName = scheduleType.Assembly.GetName().Name;
        var taskFullname = $"{scheduleType.FullName}, {taskAssemblyName}";
        return taskFullname;
    }
    
    private async Task InsertSimpraOrderSyncTask()
    {
        // Install scheduled task for order synchronization
        var task = await _scheduleTaskService.GetTaskByType(GetTaskTypeFullname<SimpraOrderSyncTask>());
        if (task == null)
        {
            _logger.LogInformation("Installing Simpra Order Sync Task");
            await _scheduleTaskService.InsertTask(new ScheduleTask()
            {
                ScheduleTaskName = "Simpra Order Sync Task",
                Type = GetTaskTypeFullname<SimpraOrderSyncTask>(),
                Enabled = true,
                StopOnError = false,
                TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(1).TotalMinutes)
            });
        }
        else
        {
            task.ScheduleTaskName = "Simpra Order Sync Task";
            task.Enabled = true;
            task.StopOnError = false;
            task.TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(1).TotalMinutes);
            await _scheduleTaskService.UpdateTask(task);
        }
    }
    
    private async Task InsertSimpraProductSyncTask()
    {
        // Install scheduled task for order synchronization
        var task = await _scheduleTaskService.GetTaskByType(GetTaskTypeFullname<SimpraProductSyncTask>());
        if (task == null)
        {
            _logger.LogInformation("Installing Simpra Product Sync Task");
            await _scheduleTaskService.InsertTask(new ScheduleTask()
            {
                ScheduleTaskName = "Simpra Product Sync Task",
                Type = GetTaskTypeFullname<SimpraProductSyncTask>(),
                Enabled = true,
                StopOnError = false,
                TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(2).TotalMinutes)
            });
        }
        else
        {
            task.ScheduleTaskName = "Simpra Product Sync Task";
            task.Enabled = true;
            task.StopOnError = false;
            task.TimeInterval = CommonHelper.To<int>(TimeSpan.FromMinutes(2).TotalMinutes);
            await _scheduleTaskService.UpdateTask(task);
        }
    }
}