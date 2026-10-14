using System.Globalization;

namespace TenantManager.Email;

public class EmailTemplateRenderer
{
    private readonly string _templateHtml;

    public EmailTemplateRenderer(string templateHtml)
    {
        _templateHtml = templateHtml;
    }

    public string RenderWelcomeEmail(TenantStatusMessage model)
    {
        var renderedHtml = _templateHtml;

        // Temel değişimler
        var replacements = new Dictionary<string, string>
        {
            {"{İşletme_Sahibi_Adı}", $"{model.FirstName} {model.Lastname}"},
            {"{İşletme_Adı}", model.StoreName ?? model.CompanyName},
            {"{Email_Adresi}", model.OwnerEmail ?? model.CompanyEmail},
            {"{Hesap_Türü}", model.Role ?? "İşletme Sahibi"}
        };

        // Temel değişimleri uygula
        foreach (var replacement in replacements)
        {
            renderedHtml = renderedHtml.Replace(replacement.Key, replacement.Value);
        }

        // Sosyal medya linkleri ve ikonları için varsayılan değerler
        var socialMedia = new Dictionary<string, (string Url, string Icon)>
        {
            {"[FACEBOOK_URL]", ("https://facebook.com/famizyo", "https://sanal-donusum.commerce.test/images/social/facebook-logo.png")},
            {"[TWITTER_URL]", ("https://x.com/famizyo", "https://sanal-donusum.commerce.test/images/social/x-logo.png")},
            {"[INSTAGRAM_URL]", ("https://instagram.com/famizyo", "https://sanal-donusum.commerce.test/images/social/instagram-logo.png")}
        };

        // Sosyal medya değişimlerini uygula
        foreach (var social in socialMedia)
        {
            renderedHtml = renderedHtml
                .Replace(social.Key, social.Value.Url)
                .Replace(social.Key.Replace("URL", "ICON"), social.Value.Icon);
        }

        

        // HTML'i sanitize et ve döndür
        return SanitizeHtml(renderedHtml);
    }

    private string SanitizeHtml(string html)
    {
        // Basit HTML sanitization
        return html
            .Replace("&", "&amp;")
            .Replace("<script", "&lt;script")
            .Replace("javascript:", "disabled-javascript:")
            .Replace("data:", "disabled-data:");
    }
}


public interface ITemplateEngine
{
    string Render<TModel>(string template, TModel model) where TModel : class;
    string RenderSection<TModel>(string sectionTemplate, TModel model) where TModel : class;
}

// 2. Email Template Base Configuration
public class EmailTemplateConfig
{
    public string LogoUrl { get; set; } = "https://sanal-donusum.commerce.test/images/logo.svg";
    public string CompanyName { get; set; } = "Famizyo";
    public Dictionary<string, (string Url, string Icon)> SocialMedia { get; set; } = new()
    {
        {"facebook", ("https://facebook.com/famizyo", "https://sanal-donusum.commerce.test/images/social/facebook-logo.png")},
        {"twitter", ("https://x.com/famizyo", "https://sanal-donusum.commerce.test/images/social/x-logo.png")},
        {"instagram", ("https://instagram.com/famizyo", "https://sanal-donusum.commerce.test/images/social/instagram-logo.png")}
    };
    public string SupportEmail { get; set; } = "support@commerce.test";
    public int Year { get; set; } = DateTime.UtcNow.Year;
}

// 3. Template Engine Implementation
public class EmailTemplateEngine : ITemplateEngine
{
    private readonly EmailTemplateConfig _config;
    private readonly Dictionary<string, string> _templateSections;

    public EmailTemplateEngine(EmailTemplateConfig config, string baseTemplate)
    {
        _config = config;
        _templateSections = ParseTemplateSections(baseTemplate);
    }

    private Dictionary<string, string> ParseTemplateSections(string template)
    {
        // Basit bir section parser - geliştirilebilir
        var sections = new Dictionary<string, string>
        {
            { "header", ExtractSection(template, "<!-- Header -->", "<!-- End Header -->") },
            { "footer", ExtractSection(template, "<!-- Footer -->", "<!-- End Footer -->") }
        };
        return sections;
    }

    private string ExtractSection(string template, string startMarker, string endMarker)
    {
        var startIndex = template.IndexOf(startMarker);
        var endIndex = template.IndexOf(endMarker);
        if (startIndex == -1 || endIndex == -1) return string.Empty;
        return template.Substring(startIndex, endIndex - startIndex);
    }

    public string Render<TModel>(string template, TModel model) where TModel : class
    {
        var renderedTemplate = template;

        // Header render
        renderedTemplate = renderedTemplate.Replace("<!-- Header -->", RenderHeader());
        
        // Footer render
        renderedTemplate = renderedTemplate.Replace("<!-- Footer -->", RenderFooter());

        // Main content render - model specific
        renderedTemplate = RenderMainContent(renderedTemplate, model);

        return SanitizeHtml(renderedTemplate);
    }

    public string RenderSection<TModel>(string sectionTemplate, TModel model) where TModel : class
    {
        // Model property'lerini reflection ile al
        var properties = model.GetType().GetProperties();
        var rendered = sectionTemplate;

        foreach (var prop in properties)
        {
            var value = prop.GetValue(model)?.ToString() ?? string.Empty;
            rendered = rendered.Replace($"{{{prop.Name}}}", value);
        }

        return rendered;
    }

    private string RenderHeader()
    {
        var header = _templateSections["header"]
            .Replace("[LOGO_URL]", _config.LogoUrl);
        return header;
    }

    private string RenderFooter()
    {
        var footer = _templateSections["footer"]
            .Replace("{YEAR}", _config.Year.ToString())
            .Replace("[COMPANY_NAME]", _config.CompanyName)
            .Replace("[SUPPORT_EMAIL]", _config.SupportEmail);

        // Social media links
        foreach (var social in _config.SocialMedia)
        {
            footer = footer
                .Replace($"[{social.Key.ToUpper(CultureInfo.GetCultureInfo("en_EN"))}_URL]", social.Value.Url)
                .Replace($"[{social.Key.ToUpperInvariant()}_ICON]", social.Value.Icon);
        }

        return footer;
    }

    private string RenderMainContent<TModel>(string template, TModel model) where TModel : class
    {
        return RenderSection(template, model);
    }

    private string SanitizeHtml(string html)
    {
        return html
            .Replace("&", "&amp;")
            .Replace("<script", "&lt;script")
            .Replace("javascript:", "disabled-javascript:")
            .Replace("data:", "disabled-data:");
    }
}
