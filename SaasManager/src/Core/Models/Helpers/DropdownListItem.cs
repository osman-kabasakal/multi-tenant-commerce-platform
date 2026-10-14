namespace Core.Models.Helpers;

public class DropdownListItem
{
    public string Text { get; set; } = null!;
    public string? Value { get; set; }
    public bool IsSelected { get; set; }
}
