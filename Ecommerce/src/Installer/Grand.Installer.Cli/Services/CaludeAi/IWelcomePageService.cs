using Grand.Installer.Cli.Models.CaludeAi;

namespace Grand.Installer.Cli.Services.CaludeAi;

public interface IWelcomePageService
{
    Task<WelcomePage> GenerateTurkishWelcomePageAsync(WelcomePage defaultPage);
}