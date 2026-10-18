using Grand.Domain.Catalog;

namespace Grand.Business.System.Services.Installation;

public partial class InstallationService
{
    protected virtual Task InstallProductLayouts()
    {
        var productLayouts = new List<ProductLayout> {
            new() {
                Name = "Simple product",
                ViewPath = "ProductLayout.Simple",
                DisplayOrder = 10
            },
            new() {
                Name = "Grouped product (with variants)",
                ViewPath = "ProductLayout.Grouped",
                DisplayOrder = 100
            }
        };
        foreach (var layout in productLayouts)
            if (!_productLayoutRepository.Table.Any(existing => existing.ViewPath == layout.ViewPath))
                _productLayoutRepository.Insert(layout);
        return Task.CompletedTask;
    }
}