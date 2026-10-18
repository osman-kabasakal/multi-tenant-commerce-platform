using Grand.Domain.Catalog;

namespace Grand.Business.System.Services.Installation;

public partial class InstallationService
{
    protected virtual Task InstallCollectionLayouts()
    {
        var collectionLayouts = new List<CollectionLayout> {
            new() {
                Name = "Grid or Lines",
                ViewPath = "CollectionLayout.GridOrLines",
                DisplayOrder = 1
            }
        };
        foreach (var layout in collectionLayouts)
            if (!_collectionLayoutRepository.Table.Any(existing => existing.ViewPath == layout.ViewPath))
                _collectionLayoutRepository.Insert(layout);
        return Task.CompletedTask;
    }
}