using System.ComponentModel.DataAnnotations;

namespace SaasManager.Application.Common.Models.GrandModels;

public class BaseApiEntityModel
{
    [Key] public string Id { get; set; }

    public DateTime CreatedOnUtc { get; set; }
    public DateTime? UpdatedOnUtc { get; set; }
}
