using Grand.Installer.Cli.Models.CaludeAi;
using System.Text.Json;

namespace Grand.Installer.Cli.Services.CaludeAi;

public class WelcomePageService : IWelcomePageService
    {
        private readonly IClaudeAIService _claudeService;
        private readonly IPageTypeDetector _pageTypeDetector;
        
        public WelcomePageService(IClaudeAIService claudeService, IPageTypeDetector pageTypeDetector)
        {
            _claudeService = claudeService;
            _pageTypeDetector = pageTypeDetector;
        }
        
        public async Task<WelcomePage> GenerateTurkishWelcomePageAsync(WelcomePage defaultPage)
        {
            // Sayfa tipini belirle
            var pageType = _pageTypeDetector.DetectPageType(defaultPage.SystemName);
            
            // Claude AI ile içerik oluştur
            var prompt = CreatePrompt(defaultPage, pageType);
            var response = await _claudeService.GetCompletionAsync(prompt);
            
            // Yanıtı işle
            var turkishPage = ParseResponse(response, defaultPage.SystemName);
            
            return turkishPage;
        }
        
        private string CreatePrompt(WelcomePage defaultPage, string pageType)
        {
            return $@"
Famizyo e-ticaret platformu müşterileri için '{pageType}' türündeki liquid e-mail şablonu içeriğini Türkçe olarak oluşturman gerekiyor.

Orijinal içerik şu şekilde:
Sistem Adı: {defaultPage.SystemName}
Konusu: {defaultPage.Title}
Mail Şablonu: {defaultPage.Content}
Liquid belirteçleri: {defaultPage.LiquidTokens}

Lütfen aşağıdaki gereksinimlere uygun Türkçe bir içerik hazırla:
1. Sistem adı değişmemeli ve '{defaultPage.SystemName}' olarak kalmalı
2. Mail konusu Türkçe ve kısaca içeriği en iyi anlatan bir başlık olmalı
3. Mail Şablonu tamamen Türkçe olmalı ve Liquid belirteçleri ile kişiye özel olarak email ile gönderildiğinde hatasız çalışacak Html olarak hazırlanmalı
4. Orjinaş mail şablonu içerisinde bulunan tüm liquid belirteçleri korunmalı ve orjinal belirteçlerin haricinde liquid belirteci eklenmemeli
5. Mail Şablonu, responsive ve modern bir tasarıma sahip olmalı
6. Mail şablonu konusuna uygun olmalı 
7. Mail şablonu açık ve anlaşılır olmalı
8. Mail şablonu Famizyo için değil onu kullanan işletmelerin ihtiyacını karşılayacak şekilde yazılmalı
9. Mail şablonu, Famizyo e-ticaret altyapısını kullanacak her sektörden işletmeye uygun olacak şekilde yazılmalı
10. Yanıtın JSON formatında olmalı:
{{
  ""title"": ""Türkçe Mail konusu"",
  ""content"": ""Mail Şablonu HTML içeriği""
}}

Türkçe içerik {pageType} türüne ve hedef kitleye göre özelleştirilmiş olmalı.

ÖNEMLİ NOT
JSON yanıtında, HTML içeriğindeki tüm yeni satırlar (\n) ve özel karakterler JSON formatına uygun şekilde escape edilmelidir. Örneğin, HTML içeriğinizde yeni satır kullanmak için \\n kullanın veya tüm HTML'yi tek bir satır olarak yazın.
Not: Örnek olarak verilen belirteçlerin dışında yeni belirteç eklemeyin, ancak bu belirteçleri doğru yerlerde kullanın.

";
        }
        
        private WelcomePage ParseResponse(string response, string systemName)
        {
            try
            {
                // JSON yanıtı ayrıştır
                var responseData = JsonSerializer.Deserialize<WelcomePageResponse>(response.Replace("```json","").Replace("```","").Replace("\\n","\\\\n"));
                
                return new WelcomePage
                {
                    SystemName = systemName,
                    Title = responseData.title,
                    Content = responseData.content
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Yanıt ayrıştırılırken hata oluştu: {ex.Message}");
                
                // Hata durumunda varsayılan bir Türkçe içerik döndür
                return new WelcomePage
                {
                    SystemName = systemName,
                    Title = "🤗 Hoş geldiniz",
                    Content = "<p style=\"text-align: center;\">Mağazamıza hoş geldiniz! Ürünlerimizi incelemek için gezinmeye başlayabilirsiniz.</p>"
                };
            }
        }
        
        private class WelcomePageResponse
        {
            public string title { get; set; }
            public string content { get; set; }
        }
    }