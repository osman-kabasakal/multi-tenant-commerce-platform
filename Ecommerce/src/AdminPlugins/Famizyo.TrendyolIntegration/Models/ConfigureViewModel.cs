using Grand.Infrastructure.ModelBinding;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace Famizyo.TrendyolIntegration.Models;

public class ConfigureViewModel
{
    public ConfigureViewModel()
    {
        TrendyolSections = new List<SelectListItem>();
        TrendyolRestaurant = new List<SelectListItem>();
    }
    
    [GrandResourceDisplayName(TrendyolIntegrationDefaults.SaticiId)]
    public string? SaticiId { get; set; }
    
    [GrandResourceDisplayName(TrendyolIntegrationDefaults.ApiKey)]
    public string? ApiKey { get; set; }
    
    [GrandResourceDisplayName(TrendyolIntegrationDefaults.ApiSecret)]
    public string? ApiSecret { get; set; }
    
    [GrandResourceDisplayName(TrendyolIntegrationDefaults.StoreId)]
    public int? StoreId { get; set; }
    [GrandResourceDisplayName(TrendyolIntegrationDefaults.BestSellerSectionId)]
    public int? BestSellerSectionId { get; set; }
    [GrandResourceDisplayName(TrendyolIntegrationDefaults.NewSectionId)]
    public int? NewSectionId { get; set; }

    public List<SelectListItem> TrendyolSections { get; set; }
    public List<SelectListItem> TrendyolRestaurant { get; set; }
}