using Grand.Domain.Pages;

namespace Grand.Business.System.Services.Installation;

public partial class InstallationService
{
    protected virtual Task InstallPageLayouts()
    {
        var pageLayouts = new List<PageLayout> {
            new() {
                Name = "Default layout",
                ViewPath = "PageDetails",
                DisplayOrder = 1
            }
        };
        foreach (var layout in pageLayouts)
            if (!_pageLayoutRepository.Table.Any(existing => existing.ViewPath == layout.ViewPath))
                _pageLayoutRepository.Insert(layout);
        return Task.CompletedTask;
    }
}