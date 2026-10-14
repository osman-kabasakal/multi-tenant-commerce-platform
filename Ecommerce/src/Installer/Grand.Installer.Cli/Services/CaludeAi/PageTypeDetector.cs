namespace Grand.Installer.Cli.Services.CaludeAi;

public class PageTypeDetector : IPageTypeDetector
{
    private readonly Dictionary<string, string> _pageTypeMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
    {
        { "HomePageText", "Uygulamaya giriş yapmadan önce kullanıcıları giriş yapmaya yada kayıt olmaya ikna eden ama misafir olarak da giriş yapabileceklerini belirtilen mesaj" },
        { "AboutUs", "Tüm işletmelere uygun genel bilgiler veren mesaj" },
        { "CheckoutAsGuestOrRegister", "Sepet sayfasından ödeme adımına geçerken kullanıcılara kayıt olmalarını tavsiye eden ve kayıt olmaları halinde kazanımlarını vurgulayan mesaj" },
        { "ConditionsOfUse", "Site geneli temel seviyede kullanım koşulları hakkında bilgilendirici mesaj" },
        { "ContactUs", "İletişim sayfasında verilen bilgilendirici mesaj" },
        { "LoginRegistrationInfo", "Giriş ve kayıt bilgilendirici mesaj" },
        { "PrivacyInfo", "Gizlilik Hakkında bilgilendirici mesaj" },
        { "AccessDenied", "Yetkisiz erişim bilgilendirici mesaj" },
        { "PageNotFound", "İlgili kayanağın olmadığıni bildiren mesaj" },
        { "ShippingInfo", "Gönderiler ve dağıtım hakkında temel seviyede bilgilendirici mesaj" },
        { "ApplyVendor", "Satıcı kabul şartlarını bildiren mesaj" },
        { "KnowledgebaseHomePage", "Bilgi havuzu genel mesaj" },
        { "VendorPortalInfo", "Satıcı paneli bilgilendirici mesaj" }
    };
        
    public string DetectPageType(string systemName)
    {
        if (_pageTypeMap.TryGetValue(systemName, out var pageType))
        {
            return pageType;
        }
            
        // Bilinen bir sayfa tipi değilse, genel bir tip döndür
        return "sistem ismine göre bilgilendirici mesaj";
    }
}