using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Infrastructure.Plugins;

namespace DiscountRules.Standard;

public class DiscountPlugin : BasePlugin, IPlugin
{
    private readonly ILanguageService _languageService;
    private readonly ITranslationService _translationService;


    public DiscountPlugin(
        ITranslationService translationService,
        ILanguageService languageService)
    {
        _translationService = translationService;
        _languageService = languageService;
    }

    public override async Task Install()
{
    //CustomerGroup
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.CustomerGroups.Fields.CustomerGroup", "Required customer group");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.CustomerGroups.Fields.CustomerGroup.Hint",
        "Discount will be applied if customer is in the selected customer group.");

    //HadSpentAmount
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.Standard.HadSpentAmount.Fields.Amount", "Required spent amount");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.Standard.HadSpentAmount.Fields.Amount.Hint",
        "Discount will be applied if customer has spent/purchased x.xx amount.");

    //HasAllProducts
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.HasAllProducts.Fields.Products", "Restricted products");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.HasAllProducts.Fields.Products.Hint",
        "The comma-separated list of product identifiers (e.g. 77, 123, 156). You can find a product ID on its details page. You can also specify the comma-separated list of product identifiers with quantities ({Product ID}:{Quantity}. for example, 77:1, 123:2, 156:3). And you can also specify the comma-separated list of product identifiers with quantity range ({Product ID}:{Min quantity}-{Max quantity}. for example, 77:1-3, 123:2-5, 156:3-8).");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.HasAllProducts.Fields.Products.AddNew", "Add product");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.HasAllProducts.Fields.Products.Choose", "Choose");

    //HasOneProduct
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.HasOneProduct.Fields.Products", "Restricted products");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.HasOneProduct.Fields.Products.Hint",
        "The comma-separated list of product identifiers (e.g. 77, 123, 156). You can find a product ID on its details page. You can also specify the comma-separated list of product identifiers with quantities ({Product ID}:{Quantity}. for example, 77:1, 123:2, 156:3). And you can also specify the comma-separated list of product identifiers with quantity range ({Product ID}:{Min quantity}-{Max quantity}. for example, 77:1-3, 123:2-5, 156:3-8).");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.HasOneProduct.Fields.Products.AddNew", "Add product");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.HasOneProduct.Fields.Products.Choose", "Choose");

    //Shipping cart
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.ShoppingCart.Fields.Amount", "Required spent amount");
    await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
        "Plugins.DiscountRules.ShoppingCart.Fields.Amount.Hint",
        "Discount will be applied if the subtotal  in shopping cart is x.xx.");

    //Turkish translations
    var turkish = await _languageService.GetLanguageByCode("tr");
    if (turkish != null)
    {
        //CustomerGroup
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.CustomerGroups.Fields.CustomerGroup", "Gerekli müşteri grubu", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.CustomerGroups.Fields.CustomerGroup.Hint",
            "Müşteri seçili müşteri grubunda ise indirim uygulanacaktır.", 
            languageCulture: turkish.LanguageCulture);

        //HadSpentAmount
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.Standard.HadSpentAmount.Fields.Amount", "Gerekli harcama tutarı", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.Standard.HadSpentAmount.Fields.Amount.Hint",
            "Müşteri x.xx tutarında harcama/satın alma yapmışsa indirim uygulanacaktır.", 
            languageCulture: turkish.LanguageCulture);

        //HasAllProducts
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasAllProducts.Fields.Products", "Kısıtlı ürünler", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasAllProducts.Fields.Products.Hint",
            "Virgülle ayrılmış ürün tanımlayıcıları listesi (örn. 77, 123, 156). Ürün kimliğini ürün detay sayfasında bulabilirsiniz. Ayrıca miktarlı ürün tanımlayıcılarının virgülle ayrılmış bir listesini de belirtebilirsiniz ({Ürün ID}:{Miktar}. örneğin, 77:1, 123:2, 156:3). Ve aynı zamanda miktar aralıklı ürün tanımlayıcılarının virgülle ayrılmış bir listesini de ({Ürün ID}:{Min miktar}-{Maks miktar}. örneğin, 77:1-3, 123:2-5, 156:3-8) belirtebilirsiniz.", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasAllProducts.Fields.Products.AddNew", "Ürün ekle", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasAllProducts.Fields.Products.Choose", "Seç", 
            languageCulture: turkish.LanguageCulture);

        //HasOneProduct
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasOneProduct.Fields.Products", "Kısıtlı ürünler", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasOneProduct.Fields.Products.Hint",
            "Virgülle ayrılmış ürün tanımlayıcıları listesi (örn. 77, 123, 156). Ürün kimliğini ürün detay sayfasında bulabilirsiniz. Ayrıca miktarlı ürün tanımlayıcılarının virgülle ayrılmış bir listesini de belirtebilirsiniz ({Ürün ID}:{Miktar}. örneğin, 77:1, 123:2, 156:3). Ve aynı zamanda miktar aralıklı ürün tanımlayıcılarının virgülle ayrılmış bir listesini de ({Ürün ID}:{Min miktar}-{Maks miktar}. örneğin, 77:1-3, 123:2-5, 156:3-8) belirtebilirsiniz.", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasOneProduct.Fields.Products.AddNew", "Ürün ekle", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasOneProduct.Fields.Products.Choose", "Seç", 
            languageCulture: turkish.LanguageCulture);

        //Shipping cart
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.ShoppingCart.Fields.Amount", "Gerekli harcama tutarı", 
            languageCulture: turkish.LanguageCulture);
        await this.AddOrUpdatePluginTranslateResource(_translationService, _languageService,
            "Plugins.DiscountRules.ShoppingCart.Fields.Amount.Hint",
            "Alışveriş sepetindeki ara toplam x.xx ise indirim uygulanacaktır.", 
            languageCulture: turkish.LanguageCulture);
    }

    await base.Install();
}

    public override async Task Uninstall()
    {
        //CustomerGroup
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.CustomerGroups.Fields.CustomerGroup");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.CustomerGroups.Fields.CustomerGroup.Hint");

        //HadSpentAmount
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.Standard.HadSpentAmount.Fields.Amount");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.Standard.HadSpentAmount.Fields.Amount.Hint");

        //HasAllProducts
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasAllProducts.Fields.Products");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasAllProducts.Fields.Products.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasAllProducts.Fields.Products.AddNew");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasAllProducts.Fields.Products.Choose");

        //HasOneProduct
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasOneProduct.Fields.Products");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasOneProduct.Fields.Products.Hint");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasOneProduct.Fields.Products.AddNew");
        await this.DeletePluginTranslationResource(_translationService, _languageService,
            "Plugins.DiscountRules.HasOneProduct.Fields.Products.Choose");

        await base.Uninstall();
    }
}