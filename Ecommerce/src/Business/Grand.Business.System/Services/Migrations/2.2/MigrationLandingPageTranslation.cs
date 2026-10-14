using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Interfaces.Common.Stores;
using Grand.Data;
using Grand.Domain.Pages;
using Grand.Infrastructure.Migrations;
using Grand.SharedKernel.Extensions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace Grand.Business.System.Services.Migrations._2._2;

public class MigrationLandingPageTranslation: IMigration
{
    
    public class WelcomePage
    {
        public string SystemName { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
    }
    public DbVersion Version => new(2, 2);
    public Guid Identity => new("9add4839-b385-472a-9133-d203f61e115b");
    public string Name => "All default landing page translations";
    public int Priority => 0;
    public bool UpgradeProcess(IDatabaseContext database, IServiceProvider serviceProvider)
    {
        var logger = serviceProvider.GetRequiredService<ILogger<MigrationLandingPageTranslation>>();
        try
        {
            var landingPagesDirectory = Path.Combine(CommonPath.AppData, "LandingPages");
            if (!Directory.Exists(landingPagesDirectory))
            {
                return false;
            }

            var pageTable = database.Table<Page>(typeof(Page).Name);
            var pages = pageTable.ToList();
            foreach (var page in pages)
            {
                try
                {
                    var pagePath = Path.Combine(landingPagesDirectory, page.SystemName + ".json");
                    if (!File.Exists(pagePath))
                        continue;
                    var pageModel = JsonSerializer.Deserialize<WelcomePage>(File.ReadAllText(pagePath));
                    var repository = serviceProvider.GetRequiredService<IRepository<Page>>();
                    page.Title = pageModel.Title;
                    page.Body = pageModel.Content;
                    repository.Update(page);
                    logger.LogInformation("Page {Page} updated", page.SystemName);
                }
                catch (Exception e)
                {
                    logger.LogError(e,"Error while processing page {Page}", page.SystemName);
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