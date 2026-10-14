using Grand.Data;
using Grand.Domain.Messages;
using Grand.Domain.Pages;
using Grand.Infrastructure.Migrations;
using Grand.SharedKernel.Extensions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace Grand.Business.System.Services.Migrations._2._2;

class MigrationMessageTemplateTranslation_22 : IMigration
{
    public class WelcomePage
    {
        public string SystemName { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public string LiquidTokens { get; set; }
    }
    public DbVersion Version => new(2, 2);
    public Guid Identity => new("b5f371fe-7e5c-4f88-b76d-0caaa5677fff");
    public string Name => "All default Message template translations";
    public int Priority => 0;
    public bool UpgradeProcess(IDatabaseContext database, IServiceProvider serviceProvider)
    {
        var logger = serviceProvider.GetRequiredService<ILogger<MigrationLandingPageTranslation>>();
        try
        {
            var landingPagesDirectory = Path.Combine(CommonPath.AppData, "MessageTemplates");
            if (!Directory.Exists(landingPagesDirectory))
            {
                return false;
            }

            var pageTable = database.Table<MessageTemplate>(typeof(MessageTemplate).Name);
            var pages = pageTable.ToList();
            foreach (var page in pages)
            {
                try
                {
                    var pagePath = Path.Combine(landingPagesDirectory, page.Name + ".json");
                    if (!File.Exists(pagePath))
                        continue;
                    var pageModel = JsonSerializer.Deserialize<WelcomePage>(File.ReadAllText(pagePath));
                    var repository = serviceProvider.GetRequiredService<IRepository<MessageTemplate>>();
                    page.Subject = pageModel.Title;
                    page.Body = pageModel.Content.Replace("\\n","");
                    repository.Update(page);
                    logger.LogInformation("Page {Page} updated", page.Name);
                }
                catch (Exception e)
                {
                    logger.LogError(e,"Error while processing page {Page}", page.Name);
                    continue;
                }
            }
            logger.LogInformation("Page translations migration completed");
            return true;
        }
        catch (Exception e)
        {
            logger.LogError(e,"Page translations migration error");
            return false;
        }
    }
}