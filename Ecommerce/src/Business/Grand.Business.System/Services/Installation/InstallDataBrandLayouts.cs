using Grand.Domain.Catalog;

namespace Grand.Business.System.Services.Installation;

public partial class InstallationService
{
    protected virtual Task InstallBrandLayouts()
    {
        var brandLayouts = new List<BrandLayout> {
            new() {
                Name = "Grid or Lines",
                ViewPath = "BrandLayout.GridOrLines",
                DisplayOrder = 1
            }
        };
        foreach (var layout in brandLayouts)
            if (!_brandLayoutRepository.Table.Any(existing => existing.ViewPath == layout.ViewPath))
                _brandLayoutRepository.Insert(layout);
        return Task.CompletedTask;
    }
}