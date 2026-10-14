namespace Grand.Installer.Cli.Services.CaludeAi;

public interface IClaudeAIService
{
    Task<string> GetCompletionAsync(string prompt);
}