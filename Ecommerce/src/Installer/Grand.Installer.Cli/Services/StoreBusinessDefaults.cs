using Grand.Business.Core.Dto;
using Grand.Business.Core.Interfaces.Catalog.Tax;
using Grand.Business.Core.Interfaces.Checkout.Orders;
using Grand.Business.Core.Interfaces.Checkout.Shipping;
using Grand.Business.Core.Interfaces.Common.Addresses;
using Grand.Business.Core.Interfaces.Common.Configuration;
using Grand.Business.Core.Interfaces.Common.Directory;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Business.Core.Interfaces.ExportImport;
using Grand.Business.Core.Interfaces.Storage;
using Grand.Data;
using Grand.Domain.Catalog;
using Grand.Domain.Common;
using Grand.Domain.Customers;
using Grand.Domain.Directory;
using Grand.Domain.Localization;
using Grand.Domain.Media;
using Grand.Domain.Orders;
using Grand.Domain.Payments;
using Grand.Domain.Shipping;
using Grand.Domain.Stores;
using Grand.Domain.Tax;
using Grand.Installer.Cli.Models;
using Microsoft.Extensions.DependencyInjection;
using MongoDB.Driver.Linq;

namespace Grand.Installer.Cli.Services;

// The original business profile is shared by legacy and managed tenant tasks.
public static class StoreBusinessDefaults
{
    public static async Task ApplyAsync(IServiceScope scope, TenantStatusMessage tenantStatusMessage, Store store, Customer customer, string storeUrl)
    {
        var storeService = scope.ServiceProvider.GetRequiredService<IStoreService>();
        var settingservice = scope.ServiceProvider.GetRequiredService<ISettingService>();
        var currencyService = scope.ServiceProvider.GetRequiredService<ICurrencyService>();
        var currency = await currencyService.GetCurrencyByCode("TRY");
        if (currency == null)
        {
            currency = new Currency {
                CurrencyCode = "TRY",
                Name = "Türk Lirası",
                Rate = 1,
                Published = true,
                DisplayLocale = "tr-TR",
                DisplayOrder = 1,
                CreatedOnUtc = DateTime.UtcNow,
                RoundingTypeId = RoundingType.Rounding001,
                MidpointRoundId = MidpointRounding.ToEven,
                NumberDecimal = 0,
            };

            await currencyService.InsertCurrency(currency);
        }
        var countryService = scope.ServiceProvider.GetRequiredService<ICountryService>();
        var turkey = await countryService.GetCountryByTwoLetterIsoCode("TR");
        var languageService = scope.ServiceProvider.GetRequiredService<ILanguageService>();
        var turkish = await languageService.GetLanguageByCode("tr");
        if (turkey == null || turkish == null) throw new InvalidOperationException("The base installer must create the Turkish country and language before business settings.");
        store.DefaultCurrencyId = currency.Id;
        store.DefaultCountryId = turkey?.Id;
        store.DefaultLanguageId = turkish?.Id;

        await storeService.UpdateStore(store);

        var currencySettings = scope.ServiceProvider.GetRequiredService<CurrencySettings>();
        currencySettings.PrimaryStoreCurrencyId = currency.Id;
        currencySettings.PrimaryExchangeRateCurrencyId = currency.Id;
        await settingservice.SaveSetting(currencySettings);

        if (turkish != null)
        {
            turkish.DefaultCurrencyId = currency.Id;
            await languageService.UpdateLanguage(turkish);
        }

        var customerSettings = scope.ServiceProvider.GetRequiredService<CustomerSettings>();
        customerSettings.UserRegistrationType = UserRegistrationType.Standard;
        customerSettings.UsernamesEnabled = false;
        customerSettings.GeoEnabled = true;
        customerSettings.NotifyNewCustomerRegistration = true;
        customerSettings.HideCoursesTab = true;
        customerSettings.HideSubAccountsTab = true;
        customerSettings.CustomerNameFormat = CustomerNameFormat.FullNames;
        customerSettings.FirstLastNameRequired = true;
        customerSettings.HideDownloadableProductsTab = true;
        customerSettings.DefaultPasswordFormat = PasswordFormat.Hashed;
        customerSettings.HashedPasswordFormat = HashedPasswordFormat.SHA512;
        customerSettings.StreetAddressEnabled = false;
        customerSettings.StreetAddressRequired = false;
        customerSettings.StreetAddress2Enabled = false;
        customerSettings.StreetAddress2Required = false;
        customerSettings.ZipPostalCodeEnabled = false;
        customerSettings.ZipPostalCodeRequired = false;
        customerSettings.CityEnabled = false;
        customerSettings.CityRequired = false;
        customerSettings.CountryEnabled = false;
        customerSettings.CountryRequired = false;
        customerSettings.AllowUsersToChangeEmail = false;
        customerSettings.HideReviewsTab = false;
        customerSettings.HideNotesTab = false;
        customerSettings.HideOutOfStockSubscriptionsTab = false;
        customerSettings.NewsletterBlockAllowToUnsubscribe = true;

        await settingservice.SaveSetting(customerSettings);

        var catalogSetting = scope.ServiceProvider.GetRequiredService<CatalogSettings>();
        catalogSetting.ShowSkuOnProductDetailsPage = true;
        catalogSetting.AllowViewUnpublishedProductPage = false;
        catalogSetting.DisplayDiscontinuedMessageForUnpublishedProducts = true;
        catalogSetting.ShowSkuOnProductDetailsPage = true;
        catalogSetting.ShowSkuOnCatalogPages = true;
        catalogSetting.ShowMpn = false;
        catalogSetting.ShowGtin = false;
        catalogSetting.ShowFreeShippingNotification = true;
        catalogSetting.AllowProductSorting = true;
        catalogSetting.AllowProductViewModeChanging = true;
        catalogSetting.ShowProductsFromSubcategories = true;
        catalogSetting.ShowCategoryProductNumber = true;
        catalogSetting.ShowCategoryProductNumberIncludingSubcategories = true;
        catalogSetting.CategoryBreadcrumbEnabled = true;
        catalogSetting.AskQuestionOnProduct = true;
        catalogSetting.EmailAFriendEnabled = true;
        catalogSetting.AllowAnonymousUsersToEmailAFriend = true;
        catalogSetting.RecentlyViewedProductsEnabled = true;
        catalogSetting.RecentlyViewedProductsNumber = 3;
        catalogSetting.RecommendedProductsEnabled = true;
        catalogSetting.SuggestedProductsEnabled = true;
        catalogSetting.SuggestedProductsNumber = 6;
        catalogSetting.PersonalizedProductsEnabled = true;
        catalogSetting.PersonalizedProductsNumber = 10;
        catalogSetting.NewProductsEnabled = true;
        catalogSetting.NewProductsNumber = 6;
        catalogSetting.NewProductsOnHomePage = true;
        catalogSetting.NewProductsNumberOnHomePage = 10;
        catalogSetting.ShowBestsellersOnHomepage = true;
        catalogSetting.NumberOfBestsellersOnHomepage = 10;
        catalogSetting.BestsellersFromReports = true;
        catalogSetting.PeriodBestsellers = 30;
        catalogSetting.ProductsAlsoPurchasedEnabled = true;
        catalogSetting.ProductsAlsoPurchasedNumber = 5;
        catalogSetting.NumberOfProductTags = 15;
        catalogSetting.ProductsByTagAllowCustomersToSelectPageSize = true;
        catalogSetting.ProductsByTagPageSize = 6;
        catalogSetting.ProductsByTagPageSizeOptions = "6,3,9,18,20";
        catalogSetting.CollectionsBlockItemsToDisplay = 2;
        catalogSetting.ShowSpecAttributeOnCatalogPages = true;
        catalogSetting.SecondPictureOnCatalogPages = true;
        catalogSetting.IncludeFeaturedProductsInNormalLists = true;
        catalogSetting.DisplayTierPricesWithDiscounts = true;
        catalogSetting.DisplayQuantityOnCatalogPages = false;
        catalogSetting.PublishBackProductWhenCancellingOrders = true;
        catalogSetting.ShowProductsFromSubcategoriesInSearchBox = true;
        catalogSetting.DefaultCollectionPageSize = 20;
        catalogSetting.NumberOfReview = 10;
        catalogSetting.LimitOfFeaturedProducts = 30;
        catalogSetting.MaxCatalogPageSize = 10000;
        catalogSetting.SortingByAvailability = true;
        catalogSetting.IgnoreDiscounts = false;
        catalogSetting.IgnoreFeaturedProducts = false;
        catalogSetting.IgnoreFilterableSpecAttributeOption = false;
        catalogSetting.IgnoreFilterableAvailableStartEndDateTime = false;
        catalogSetting.CustomerProductPrice = false;
        catalogSetting.ProductReviewsMustBeApproved = false;
        catalogSetting.AllowAnonymousUsersToReviewProduct = false;
        catalogSetting.NotifyStoreOwnerAboutNewProductReviews = true;
        catalogSetting.ProductReviewPossibleOnlyAfterPurchasing = true;
        catalogSetting.ProductReviewPossibleOnlyOnce = true;
        catalogSetting.DefaultProductRatingValue = 5;
        catalogSetting.FilterProductRating = "4.6,4.7,4.8,4.9,5";
        catalogSetting.SearchPageAllowCustomersToSelectPageSize = true;
        catalogSetting.SearchPageProductsPerPage = 6;
        catalogSetting.SearchPagePageSizeOptions = "6,3,9,18,20";
        catalogSetting.ProductSearchAutoCompleteEnabled = true;
        catalogSetting.ProductSearchAutoCompleteNumberOfProducts = 10;
        catalogSetting.ShowProductImagesInSearchAutoComplete = true;
        catalogSetting.ProductSearchTermMinimumLength = 3;
        catalogSetting.SearchBySku = true;
        catalogSetting.SearchByDescription = true;
        catalogSetting.SaveSearchAutoComplete = true;
        catalogSetting.CompareProductsEnabled = true;
        catalogSetting.IncludeShortDescriptionInCompareProducts = true;
        catalogSetting.IncludeFullDescriptionInCompareProducts = true;
        catalogSetting.ShowShareButton = true;
        catalogSetting.DefaultCategoryPageSizeOptions = "6,3,9,18,20";
        catalogSetting.DefaultCategoryPageSize = 20;

        await settingservice.SaveSetting(catalogSetting);

        var salesSetting = scope.ServiceProvider.GetRequiredService<OrderSettings>();

        salesSetting.IsReOrderAllowed = true;
        salesSetting.MinOrderSubtotalAmount = 50;
        salesSetting.MinOrderTotalAmount = 0;
        salesSetting.MinOrderSubtotalAmountIncludingTax = true;
        salesSetting.AnonymousCheckoutAllowed = true;
        salesSetting.TermsOfServiceOnShoppingCartPage = false;
        salesSetting.TermsOfServiceOnOrderConfirmPage = true;
        salesSetting.DisableOrderCompletedPage = false;
        salesSetting.AttachPdfInvoiceToOrderPlacedEmail = true;
        salesSetting.AttachPdfInvoiceToOrderPaidEmail = true;
        salesSetting.AttachPdfInvoiceToOrderCompletedEmail = true;
        salesSetting.DeactivateGiftVouchersAfterCancelOrder = true;
        salesSetting.DeactivateGiftVouchersAfterDeletingOrder = true;
        salesSetting.GiftVouchers_Assign_StoreId = true;
        salesSetting.CompleteOrderWhenDelivered = true;
        salesSetting.AllowCustomerToAddOrderNote = true;
        salesSetting.UserCanCancelUnpaidOrder = true;
        salesSetting.LengthCode = 8;
        salesSetting.MinimumOrderPlacementInterval = 30;
        salesSetting.UnpublishAuctionProduct = true;
        salesSetting.PageSize = 10;
        salesSetting.AttachPdfInvoiceToBinary = true;
        salesSetting.MerchandiseReturnsEnabled = true;
        salesSetting.MerchandiseReturns_AllowToSpecifyPickupAddress = true;
        salesSetting.MerchandiseReturns_AllowToSpecifyPickupDate = true;
        salesSetting.MerchandiseReturns_PickupDateRequired = true;
        salesSetting.NumberOfDaysMerchandiseReturnAvailable = 365;

        await settingservice.SaveSetting(salesSetting);

        var shoppingCartSettings = scope.ServiceProvider.GetRequiredService<ShoppingCartSettings>();


        shoppingCartSettings.AllowOutOfStockItemsToBeAddedToWishlist = true;
        shoppingCartSettings.MaximumShoppingCartItems = 1000;
        shoppingCartSettings.MaximumWishlistItems = 1000;
        shoppingCartSettings.MoveItemsFromWishlistToCart = true;
        shoppingCartSettings.ShowProductImagesOnShoppingCart = true;
        shoppingCartSettings.ShowProductImagesOnWishList = true;
        shoppingCartSettings.ShowDiscountBox = true;
        shoppingCartSettings.ShowGiftVoucherBox = true;
        shoppingCartSettings.CrossSellsNumber = 4;
        shoppingCartSettings.EmailWishlistEnabled = true;
        shoppingCartSettings.AllowAnonymousUsersToEmailWishlist = true;
        shoppingCartSettings.MiniShoppingCartEnabled = true;
        shoppingCartSettings.MiniCartProductNumber = 5;
        shoppingCartSettings.ShowImagesInsidebarCart = true;
        shoppingCartSettings.AllowCartItemEditing = true;
        shoppingCartSettings.SharedCartBetweenStores = true;
        shoppingCartSettings.AllowOnHoldCart = false;
        shoppingCartSettings.AllowToSelectWarehouse = false;
        shoppingCartSettings.GroupTierPrices = true;
        shoppingCartSettings.RoundPrices = true;

        await settingservice.SaveSetting(shoppingCartSettings);

        var loyalityPointsSettings = scope.ServiceProvider.GetRequiredService<LoyaltyPointsSettings>();
        loyalityPointsSettings.Enabled = true;
        loyalityPointsSettings.ExchangeRate = 0.005;
        loyalityPointsSettings.MinimumLoyaltyPointsToUse = 0;
        loyalityPointsSettings.PointsForRegistration = 0;
        loyalityPointsSettings.PointsForPurchases_Amount = 10;
        loyalityPointsSettings.PointsForPurchases_Points = 1;
        loyalityPointsSettings.ReduceLoyaltyPointsAfterCancelOrder = true;
        loyalityPointsSettings.DisplayHowMuchWillBeEarned = true;
        loyalityPointsSettings.PointsAccumulatedForAllStores = true;

        await settingservice.SaveSetting(loyalityPointsSettings);

        var langSetting = scope.ServiceProvider.GetRequiredService<LanguageSettings>();
        langSetting.DefaultAdminLanguageId = turkish?.Id;
        await settingservice.SaveSetting(langSetting);

        var addressSettings = settingservice.LoadSetting<AddressSettings>();

        addressSettings.CompanyEnabled = false;
        addressSettings.NoteEnabled = true;

        await settingservice.SaveSetting(addressSettings);

        var storageSettings = scope.ServiceProvider.GetRequiredService<StorageSettings>();
        storageSettings.PictureStoreInDb = true;
        await settingservice.SaveSetting(storageSettings);

        var systemSettings = scope.ServiceProvider.GetRequiredService<SystemSettings>();
        systemSettings.DaysToCancelUnpaidOrder = 7;
        await settingservice.SaveSetting(systemSettings);



        var storeInformationSetting = scope.ServiceProvider.GetRequiredService<StoreInformationSettings>();

        var addressAttributeService = scope.ServiceProvider.GetRequiredService<IAddressAttributeService>();
        var addressAttributes = scope.ServiceProvider.GetRequiredService<IRepository<AddressAttribute>>();

        var latAttribute = new AddressAttribute {
            Name = "lat",
            IsRequired = true,
            DisplayOrder = 0,
            AttributeControlType = AttributeControlType.TextBox,
            CreatedOnUtc = DateTime.UtcNow,
        };
        if (!addressAttributes.Table.Any(x => x.Name == latAttribute.Name)) await addressAttributeService.InsertAddressAttribute(latAttribute);

        var longAttribute = new AddressAttribute {
            Name = "long",
            IsRequired = true,
            DisplayOrder = 0,
            AttributeControlType = AttributeControlType.TextBox,
            CreatedOnUtc = DateTime.UtcNow,
        };
        if (!addressAttributes.Table.Any(x => x.Name == longAttribute.Name)) await addressAttributeService.InsertAddressAttribute(longAttribute);

        var bnoAttribute = new AddressAttribute {
            Name = "bno",
            IsRequired = true,
            DisplayOrder = 0,
            AttributeControlType = AttributeControlType.TextBox,
            CreatedOnUtc = DateTime.UtcNow,
        };
        if (!addressAttributes.Table.Any(x => x.Name == bnoAttribute.Name)) await addressAttributeService.InsertAddressAttribute(bnoAttribute);

        var dnoAttribute = new AddressAttribute {
            Name = "dno",
            IsRequired = true,
            DisplayOrder = 0,
            AttributeControlType = AttributeControlType.TextBox,
            CreatedOnUtc = DateTime.UtcNow,
        };
        if (!addressAttributes.Table.Any(x => x.Name == dnoAttribute.Name)) await addressAttributeService.InsertAddressAttribute(dnoAttribute);

        var knoAttribute = new AddressAttribute {
            Name = "kno",
            IsRequired = true,
            DisplayOrder = 0,
            AttributeControlType = AttributeControlType.TextBox,
            CreatedOnUtc = DateTime.UtcNow,
        };
        if (!addressAttributes.Table.Any(x => x.Name == knoAttribute.Name)) await addressAttributeService.InsertAddressAttribute(knoAttribute);

        var adres_tarifiAttribute = new AddressAttribute {
            Name = "adres_tarifi",
            IsRequired = true,
            DisplayOrder = 0,
            AttributeControlType = AttributeControlType.MultilineTextbox,
            CreatedOnUtc = DateTime.UtcNow,
        };
        if (!addressAttributes.Table.Any(x => x.Name == adres_tarifiAttribute.Name)) await addressAttributeService.InsertAddressAttribute(adres_tarifiAttribute);



        var pictureService = scope.ServiceProvider.GetRequiredService<IPictureService>();
        var storeLogo = await pictureService.GetPictureUrl(storeInformationSetting.LogoPictureId,
            storeLocation: storeUrl);
        tenantStatusMessage.LogoUrl = storeLogo;
        tenantStatusMessage.LogoId = storeInformationSetting.LogoPictureId;

        var _taxCategoryRepository = scope.ServiceProvider.GetRequiredService<IRepository<TaxCategory>>();

        foreach (var (name, rate, order) in new[] { ("Temel Gıda Ürünleri", 1, 1), ("Mobilya, Tekstil ve Temizlik Ürünleri", 10, 2), ("Lüks Tüketim Ürünleri", 20, 3) })
        {
            var category = _taxCategoryRepository.Table.FirstOrDefault(x => x.Name == name);
            if (category == null) { category = new TaxCategory { Name = name, DisplayOrder = order }; await _taxCategoryRepository.InsertAsync(category); }
            await settingservice.SetSetting($"Tax.TaxProvider.FixedRate.TaxCategoryId{category.Id}", new { Rate = rate });
        }
        var taxProviderSettings = settingservice.LoadSetting<TaxProviderSettings>();
        taxProviderSettings.ActiveTaxProviderSystemName = "Tax.FixedRate";
        await settingservice.SaveSetting(taxProviderSettings);
        var taxSettings = settingservice.LoadSetting<TaxSettings>(store.Id);
        taxSettings.TaxDisplayType = TaxDisplayType.IncludingTax;
        taxSettings.HideZeroTax = true;
        taxSettings.ForceTaxExclusionFromOrderSubtotal = true;
        taxSettings.PricesIncludeTax = true;
        await settingservice.SaveSetting(taxSettings);

        var stateImportManager = scope.ServiceProvider.GetRequiredService<IImportManager<CountryStatesDto>>();
        await using (var states=File.OpenRead(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data", "turkey_states.xlsx")))
            await stateImportManager.Import(states);
        turkey = await countryService.GetCountryByTwoLetterIsoCode("TR");
        if (turkey != null)
        {
            turkey.Name = "Türkiye";
            turkey.Published = true;
            await countryService.UpdateCountry(turkey);
        }

        var allCountry = await countryService.GetAllCountries();
        foreach (var country in allCountry)
        {
            if (country.Id != turkey.Id)
            {
                country.Published = false;
                await countryService.UpdateCountry(country);
            }
        }

        // Preserve the original cash-on-delivery payment default.
        var paymentSettings = scope.ServiceProvider.GetRequiredService<PaymentSettings>();
        var settingService = scope.ServiceProvider.GetRequiredService<ISettingService>();

        // Clear any existing active payment methods
        paymentSettings.ActivePaymentProviderSystemNames.Clear();

        // External payment providers require their own merchant configuration.
        paymentSettings.ActivePaymentProviderSystemNames.Add("Payments.CashOnDelivery");
        // paymentSettings.ActivePaymentProviderSystemNames.Add("Payments.Iyzico");

        // Save the payment settings
        await settingService.SaveSetting(paymentSettings);

        var shippingMethodService = scope.ServiceProvider.GetRequiredService<IShippingMethodService>();
        var courierShippingMethod = new ShippingMethod {
            Name = "Kapına Teslimat",
            Description = "Kurye ile anında kapında",
            DisplayOrder = 1,
            CreatedOnUtc = DateTime.UtcNow,
            CreatedBy = customer.Id,
            UpdatedOnUtc = DateTime.UtcNow,
            UpdatedBy = customer.Id
        };

        if (!(await shippingMethodService.GetAllShippingMethods()).Any(x => x.Name == courierShippingMethod.Name)) await shippingMethodService.InsertShippingMethod(courierShippingMethod);

        var merchandiseReturnService = scope.ServiceProvider.GetRequiredService<IMerchandiseReturnService>();
        var wrongProductReturnReason = new MerchandiseReturnReason {
            Name = "Yanlış ürün gönderimi",
            DisplayOrder = 1,
            CreatedOnUtc = DateTime.UtcNow,
            CreatedBy = customer.Id,
            UpdatedOnUtc = DateTime.UtcNow,
            UpdatedBy = customer.Id
        };

        if (!(await merchandiseReturnService.GetAllMerchandiseReturnReasons()).Any(x => x.Name == wrongProductReturnReason.Name)) await merchandiseReturnService.InsertMerchandiseReturnReason(wrongProductReturnReason);

        var productNotAsDescribedReturnReason = new MerchandiseReturnReason {
            Name = "Ürün açıklamasına uymuyor",
            DisplayOrder = 2,
            CreatedOnUtc = DateTime.UtcNow,
            CreatedBy = customer.Id,
            UpdatedOnUtc = DateTime.UtcNow,
            UpdatedBy = customer.Id
        };
        if (!(await merchandiseReturnService.GetAllMerchandiseReturnReasons()).Any(x => x.Name == productNotAsDescribedReturnReason.Name)) await merchandiseReturnService.InsertMerchandiseReturnReason(productNotAsDescribedReturnReason);

        var defectiveProductReturnReason = new MerchandiseReturnReason {
            Name = "Defolu ürün gönderimi",
            DisplayOrder = 3,
            CreatedOnUtc = DateTime.UtcNow,
            CreatedBy = customer.Id,
            UpdatedOnUtc = DateTime.UtcNow,
            UpdatedBy = customer.Id
        };

        if (!(await merchandiseReturnService.GetAllMerchandiseReturnReasons()).Any(x => x.Name == defectiveProductReturnReason.Name)) await merchandiseReturnService.InsertMerchandiseReturnReason(defectiveProductReturnReason);

        var wrongProductOrderedReturnReason = new MerchandiseReturnReason {
            Name = "Yanlış ürün sipariş ettim",
            DisplayOrder = 4,
            CreatedOnUtc = DateTime.UtcNow,
            CreatedBy = customer.Id,
            UpdatedOnUtc = DateTime.UtcNow,
            UpdatedBy = customer.Id
        };

        if (!(await merchandiseReturnService.GetAllMerchandiseReturnReasons()).Any(x => x.Name == wrongProductOrderedReturnReason.Name)) await merchandiseReturnService.InsertMerchandiseReturnReason(wrongProductOrderedReturnReason);

        var repairAction = new MerchandiseReturnAction() {
            Name = "Ürününümün Onarılmasını İstiyorum",
            DisplayOrder = 1,
            CreatedOnUtc = DateTime.UtcNow,
            CreatedBy = customer.Id,
            UpdatedOnUtc = DateTime.UtcNow,
            UpdatedBy = customer.Id
        };

        if (!(await merchandiseReturnService.GetAllMerchandiseReturnActions()).Any(x => x.Name == repairAction.Name)) await merchandiseReturnService.InsertMerchandiseReturnAction(repairAction);

        var replacementAction = new MerchandiseReturnAction() {
            Name = "Ürününümün Değiştirilmesini İstiyorum",
            DisplayOrder = 2,
            CreatedOnUtc = DateTime.UtcNow,
            CreatedBy = customer.Id,
            UpdatedOnUtc = DateTime.UtcNow,
            UpdatedBy = customer.Id
        };

        if (!(await merchandiseReturnService.GetAllMerchandiseReturnActions()).Any(x => x.Name == replacementAction.Name)) await merchandiseReturnService.InsertMerchandiseReturnAction(replacementAction);

        var refundAction = new MerchandiseReturnAction() {
            Name = "Para İadesini İstiyorum",
            DisplayOrder = 3,
            CreatedOnUtc = DateTime.UtcNow,
            CreatedBy = customer.Id,
            UpdatedOnUtc = DateTime.UtcNow,
            UpdatedBy = customer.Id
        };
        if (!(await merchandiseReturnService.GetAllMerchandiseReturnActions()).Any(x => x.Name == refundAction.Name)) await merchandiseReturnService.InsertMerchandiseReturnAction(refundAction);

    }
}
