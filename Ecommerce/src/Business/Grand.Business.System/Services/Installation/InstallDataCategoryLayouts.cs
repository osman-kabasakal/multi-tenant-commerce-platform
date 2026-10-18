using Grand.Domain.Catalog;

namespace Grand.Business.System.Services.Installation;

public partial class InstallationService
{
    protected virtual Task InstallCategoryLayouts()
    {
        var categoryLayouts = new List<CategoryLayout> {
            new() {
                Name = "Grid or Lines",
                ViewPath = "CategoryLayout.GridOrLines",
                DisplayOrder = 1
            }
        };
        foreach (var layout in categoryLayouts)
            if (!_categoryLayoutRepository.Table.Any(existing => existing.ViewPath == layout.ViewPath))
                _categoryLayoutRepository.Insert(layout);
        return Task.CompletedTask;
    }
}