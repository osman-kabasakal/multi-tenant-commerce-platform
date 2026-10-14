using Grand.Infrastructure.ModelBinding;
using Grand.Infrastructure.Models;
using Grand.Web.Common.Link;
using Grand.Web.Common.Models;
using System.ComponentModel.DataAnnotations;
using Widgets.Slider.Domain;

namespace Widgets.Slider.Models;

public class SlideModel : BaseEntityModel, ILocalizedModel<SlideLocalizedModel>, IStoreLinkModel
{
    [GrandResourceDisplayName(Resources.General.Name)]
    public string Name { get; set; }

    [GrandResourceDisplayName(Resources.General.Description)]
    public string Description { get; set; }

    [GrandResourceDisplayName(Resources.General.Link)]
    public string Link { get; set; }

    [GrandResourceDisplayName(Resources.General.LinkType)]
    public SliderLinkType LinkType { get; set; }

    [GrandResourceDisplayName(Resources.General.ReferenceId)]
    public string ReferenceId { get; set; }

    [GrandResourceDisplayName(Resources.General.ReferenceParameters)]
    public string ReferenceParameters { get; set; }

    [GrandResourceDisplayName(Resources.General.DisplayOrder)]
    public int DisplayOrder { get; set; }

    [GrandResourceDisplayName(Resources.General.Published)]
    public bool Published { get; set; }

    [GrandResourceDisplayName(Resources.General.FullWidth)]
    public bool FullWidth { get; set; }

    [GrandResourceDisplayName(Resources.General.SliderType)]
    public int SliderTypeId { get; set; }

    [GrandResourceDisplayName(Resources.General.Picture)]
    [UIHint("Picture")]
    public string PictureId { get; set; }

    [GrandResourceDisplayName(Resources.General.Category)]
    public string CategoryId { get; set; }

    [GrandResourceDisplayName(Resources.General.Collection)]
    public string CollectionId { get; set; }

    [GrandResourceDisplayName(Resources.General.Brand)]
    public string BrandId { get; set; }
    [GrandResourceDisplayName(Resources.General.Product)]
    public string ProductId { get; set; }

    [GrandResourceDisplayName(Resources.General.BlogPostId)]
    public string BlogPostId { get; set; }

    [GrandResourceDisplayName(Resources.General.SearchTerm)]
    public string SearchTerm { get; set; }

    [GrandResourceDisplayName(Resources.General.StartDate)]
    [UIHint("DateTimeNullable")]
    public DateTime? StartDateUtc { get; set; }

    [GrandResourceDisplayName(Resources.General.EndDate)]
    [UIHint("DateTimeNullable")]
    public DateTime? EndDateUtc { get; set; }

    public IList<SlideLocalizedModel> Locales { get; set; } = new List<SlideLocalizedModel>();

    //Store acl
    [GrandResourceDisplayName(Resources.General.LimitedToStores)]
    [UIHint("Stores")]
    public string[] Stores { get; set; }
}

public class SlideLocalizedModel : ILocalizedModelLocal
{
    [GrandResourceDisplayName(Resources.General.Name)]
    public string Name { get; set; }

    [GrandResourceDisplayName(Resources.General.Description)]
    public string Description { get; set; }

    public string LanguageId { get; set; }
}