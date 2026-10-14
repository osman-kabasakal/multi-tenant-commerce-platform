using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Data;
using Grand.Domain.Common;
using Grand.Infrastructure.Plugins;
using Grand.SharedKernel.Extensions;
using Widgets.Slider.Domain;

namespace Widgets.Slider;

/// <summary>
///     Plugin
/// </summary>
public class SliderWidgetPlugin : BasePlugin, IPlugin
{
    private readonly IDatabaseContext _databaseContext;
    private readonly ILanguageService _languageService;
    private readonly IPictureService _pictureService;
    private readonly IRepository<PictureSlider> _pictureSliderRepository;
    private readonly ITranslationService _translationService;

    public SliderWidgetPlugin(IPictureService pictureService,
        IRepository<PictureSlider> pictureSliderRepository,
        ITranslationService translationService,
        ILanguageService languageService,
        IDatabaseContext databaseContext)
    {
        _pictureService = pictureService;
        _pictureSliderRepository = pictureSliderRepository;
        _translationService = translationService;
        _languageService = languageService;
        _databaseContext = databaseContext;
    }

    /// <summary>
    ///     Install plugin
    /// </summary>
    public override async Task Install()
    {
        //Create index
        await _databaseContext.CreateIndex(_pictureSliderRepository,
            OrderBuilder<PictureSlider>.Create().Ascending(x => x.SliderTypeId).Ascending(x => x.DisplayOrder),
            "SliderTypeId_DisplayOrder");


        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.DisplayOrder", "Display order");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.LimitedToGroups", "Limited to groups");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.LimitedToStores", "Limited to stores");


        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.FriendlyName", "Widget Slider");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Added",
            "Slider added");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Addnew",
            "Add new slider");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.AvailableStores", "Available stores");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.AvailableStores.Hint", "Select stores for which the slider will be shown.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Backtolist", "Back to list");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Category",
            "Category");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Category.Hint", "Select the category where slider should appear.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Category.Required", "Category is required");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Description", "Description");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Description.Hint", "Enter the description of the slider");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.DisplayOrder", "Display Order");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.DisplayOrder.Hint", "The slider display order. 1 represents the first item in the list.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Edit",
            "Edit slider");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Edited",
            "Slider edited");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Displayorder", "Display Order");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Link", "Link");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.ObjectType", "Slider type");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Picture", "Picture");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Published", "Published");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Title", "Title");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.FullWidth",
            "Full width");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.FullWidth.hint", "Full width");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Info",
            "Info");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.LimitedToStores", "Limited to stores");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.LimitedToStores.Hint",
            "Determines whether the slider is available only at certain stores.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Link",
            "URL");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Link.Hint",
            "Enter URL. Leave empty if you don't want this picture to be clickable.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Manage",
            "Manage Bootstrap Slider");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Collection", "Collection");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Collection.Hint", "Select the collection where slider should appear.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Collection.Required", "Collection is required");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Brand",
            "Brand");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Brand.Hint", "Select the brand where slider should appear.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Brand.Required", "Brand is required");

        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Name",
            "Name");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Name.Hint",
            "Enter the name of the slider");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Name.Required", "Name is required");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Picture",
            "Picture");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Picture.Required", "Picture is required");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Published",
            "Published");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Published.Hint", "Specify it should be visible or not");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.SliderType", "Slider type");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.SliderType.Hint", "Choose the slider type. Home page, category or collection page.");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Stores",
            "Stores");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.StartDate",
            "Start Date");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.EndDate",
            "End Date");
            
        // Yeni eklenen gelişmiş link oluşturma için dil kaynakları
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.LinkType",
            "Link Type");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.LinkType.Hint",
            "Select the type of link for the slider item");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.ReferenceId",
            "Reference ID");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.ReferenceId.Hint",
            "ID of the referenced content item");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.ReferenceParameters",
            "Reference Parameters");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.ReferenceParameters.Hint",
            "Additional parameters for the referenced content");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Product",
            "Product");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Product.Hint",
            "Select a product to link to");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.Product.Required",
            "Product is required");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.BlogPostId",
            "Blog Post");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.BlogPostId.Hint",
            "Select a blog post to link to");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.BlogPostId.Required",
            "Blog post is required");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.SearchTerm",
            "Search Term");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Widgets.Slider.SearchTerm.Hint",
            "Enter search term for search page");
            
        // Enum değerleri için dil kaynakları
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Manual",
            "Manual URL");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Category",
            "Category Page");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Product",
            "Product Page");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Brand",
            "Brand Page");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Collection",
            "Collection Page");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Blog",
            "Blog Post");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.BlogList",
            "Blog List");
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Search",
            "Search Page");

        await AddTurkishTranslations();

        await base.Install();
    }

    /// <summary>
    ///     Uninstall plugin
    /// </summary>
    public override async Task Uninstall()
    {
        //clear repository
        await _pictureSliderRepository.DeleteAsync(_pictureSliderRepository.Table.ToList());

        //locales
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Added");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Addnew");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.AvailableStores");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.AvailableStores.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Backtolist");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Category");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Category.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Category.Required");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Description");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Description.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.DisplayOrder");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.DisplayOrder.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Edit");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Edited");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Displayorder");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Fields.Link");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Fields.ObjectType");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Picture");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Published");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Title");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Info");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.LimitedToStores");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.LimitedToStores.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Link");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Link.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Manage");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Collection");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Collection.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Collection.Required");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Brand");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Brand.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Brand.Required");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Name");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Name.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Name.Required");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Picture");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Picture.Required");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Published");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.Published.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.SliderType");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Widgets.Slider.SliderType.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Stores");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.StartDate");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.EndDate");
        
        // Gelişmiş link oluşturma kaynakları
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.LinkType");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.LinkType.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.ReferenceId");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.ReferenceId.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.ReferenceParameters");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.ReferenceParameters.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Product");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Product.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.Product.Required");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.BlogPostId");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.BlogPostId.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.BlogPostId.Required");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.SearchTerm");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Widgets.Slider.SearchTerm.Hint");
        
        // Enum değerleri
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Manual");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Category");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Product");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Brand");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Collection");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Blog");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.BlogList");
        await this.DeletePluginTranslationResource(_translationService, _languageService, "Enums.Widgets.Slider.SliderLinkType.Search");

        await base.Uninstall();
    }
    
    private async Task AddTurkishTranslations()
    {
        // Create or get Turkish language
        var turkish = await _languageService.GetLanguageByCode("tr-TR") 
            ?? await _languageService.GetLanguageByCode("tr");
        
        if (turkish == null)
            return;
    
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.DisplayOrder", "Görüntüleme sırası", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.LimitedToGroups", "Gruplarla sınırlı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.LimitedToStores", "Mağazalarla sınırlı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.FriendlyName", "Slider Widget'ı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Added", "Slider eklendi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Addnew", "Yeni slider ekle", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.AvailableStores", "Kullanılabilir mağazalar", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.AvailableStores.Hint", "Slider'in gösterileceği mağazaları seçin.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Backtolist", "Listeye geri dön", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Category", "Kategori", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Category.Hint", "Slider'in görüneceği kategoriyi seçin.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Category.Required", "Kategori gereklidir", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Description", "Açıklama", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Description.Hint", "Slider açıklamasını girin", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.DisplayOrder", "Görüntüleme Sırası", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.DisplayOrder.Hint", "Slider görüntüleme sırası. 1, listedeki ilk öğeyi temsil eder.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Edit", "Slider düzenle", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Edited", "Slider düzenlendi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Displayorder", "Görüntüleme Sırası", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Link", "Bağlantı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.ObjectType", "Slider tipi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Picture", "Resim", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Published", "Yayınlandı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Fields.Title", "Başlık", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.FullWidth", "Tam genişlik", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.FullWidth.hint", "Tam genişlik", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Info", "Bilgi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.LimitedToStores", "Mağazalarla sınırlı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.LimitedToStores.Hint",
            "Slider'in yalnızca belirli mağazalarda kullanılabilir olup olmadığını belirler.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Link", "URL", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Link.Hint", "URL girin. Bu resmin tıklanabilir olmasını istemiyorsanız boş bırakın.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Manage", "Bootstrap Slider'ı Yönet", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Collection", "Koleksiyon", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Collection.Hint", "Slider'ı bir koleksiyona yönlendirmek ilgli yönledirilecek koleksiyonu seçin.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Collection.Required", "Koleksiyon gereklidir", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Brand", "Marka", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Brand.Hint", "Slider'ı yönlendirmek istediğin markayı seçin.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Brand.Required", "Marka gereklidir", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Name", "İsim", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Name.Hint", "Slider'ın adını girin", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Name.Required", "İsim gereklidir", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Picture", "Resim", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Picture.Required", "Resim gereklidir", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Published", "Yayınlandı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.Published.Hint", "Görünür olup olmayacağını belirtin", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.SliderType", "Slider tipi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Widgets.Slider.SliderType.Hint", "Slider tipini seçin. Ana sayfa, kategori veya koleksiyon sayfası.", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Stores", "Mağazalar", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.StartDate", "Başlangıç Tarihi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.EndDate", "Bitiş Tarihi", languageCulture: turkish.LanguageCulture);
            
        // Gelişmiş link oluşturma için Türkçe çeviriler
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.LinkType", "Bağlantı Türü", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.LinkType.Hint", "Slider öğesi için bağlantı türünü seçin", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.ReferenceId", "Referans ID", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.ReferenceId.Hint", "Referans verilen içeriğin ID'si", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.ReferenceParameters", "Referans Parametreleri", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.ReferenceParameters.Hint", "Referans için ek parametreler", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Product", "Ürün", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Product.Hint", "Bağlanacak bir ürün seçin", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.Product.Required", "Ürün gereklidir", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.BlogPostId", "Blog Yazısı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.BlogPostId.Hint", "Bağlanacak bir blog yazısı seçin", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.BlogPostId.Required", "Blog yazısı gereklidir", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.SearchTerm", "Arama Terimi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Widgets.Slider.SearchTerm.Hint", "Arama sayfası için arama terimi girin", languageCulture: turkish.LanguageCulture);
            
        // Enum değerleri için Türkçe çeviriler
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Enums.Widgets.Slider.SliderLinkType.Manual", "Manuel URL", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Enums.Widgets.Slider.SliderLinkType.Category", "Kategori Sayfası", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Enums.Widgets.Slider.SliderLinkType.Product", "Ürün Sayfası", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Enums.Widgets.Slider.SliderLinkType.Brand", "Marka Sayfası", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Enums.Widgets.Slider.SliderLinkType.Collection", "Koleksiyon Sayfası", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Enums.Widgets.Slider.SliderLinkType.Blog", "Blog Yazısı", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Enums.Widgets.Slider.SliderLinkType.BlogList", "Blog Listesi", languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService, 
            "Enums.Widgets.Slider.SliderLinkType.Search", "Arama Sayfası", languageCulture: turkish.LanguageCulture);
    }

    public override string ConfigurationUrl()
    {
        return SliderWidgetDefaults.ConfigurationUrl;
    }
}