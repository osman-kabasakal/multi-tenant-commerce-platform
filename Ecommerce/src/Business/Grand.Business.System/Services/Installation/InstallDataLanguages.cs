using Grand.Domain.Localization;

namespace Grand.Business.System.Services.Installation;

public partial class InstallationService
{
    protected virtual async Task InstallLanguages()
    {
        var languageTr = new Language {
            Name = "Türkçe",
            LanguageCulture = "tr-TR",
            UniqueSeoCode = "tr",
            FlagImageFileName = "tr.png",
            Published = true,
            DisplayOrder = 1
        };
        await _languageRepository.InsertAsync(languageTr);

        var languageEn = new Language {
            Name = "English",
            LanguageCulture = "en-US",
            UniqueSeoCode = "en",
            FlagImageFileName = "us.png",
            Published = true,
            DisplayOrder = 2
        };
        await _languageRepository.InsertAsync(languageEn);
    }
}