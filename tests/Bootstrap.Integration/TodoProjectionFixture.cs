using Microsoft.EntityFrameworkCore;
using SaasManager.Application.TodoItems.Queries.GetTodoItemsWithPagination;
using SaasManager.Application.TodoLists.Queries.GetTodos;
using SaasManager.Domain.Entities;
using SaasManager.Domain.Enums;
using SaasManager.Domain.ValueObjects;
using SaasManager.Infrastructure.Data;

internal static class TodoProjectionFixture
{
    public static async Task RunAsync(string ownerConnection, string readerConnection, Action<bool,string> check)
    {
        var list = new TodoList { Id = Guid.NewGuid(), Title = "Beta", Colour = Colour.Blue };
        var empty = new TodoList { Id = Guid.NewGuid(), Title = "Alpha" };
        var selected = new TodoItem { Id = Guid.NewGuid(), ListId = list.Id, List = list,
            Title = "Beta item", Priority = PriorityLevel.High, Note = "Preserved", Done = true };
        list.Items.Add(selected);
        list.Items.Add(new TodoItem { Id = Guid.NewGuid(), ListId = list.Id, Title = "Alpha item" });
        list.Items.Add(new TodoItem { Id = Guid.NewGuid(), ListId = list.Id, Title = "Gamma item" });
        await using (var owner = Database(ownerConnection))
        {
            owner.TodoLists.AddRange(list, empty);
            await owner.SaveChangesAsync();
        }
        // This connection has SELECT only, including during nested/owned-type projection.
        await using var reader = Database(readerConnection);
        var result = await new GetTodosQueryHandler(reader).Handle(new(), default);
        var detail = result.Lists.Single(x => x.Id == list.Id);
        var item = detail.Items.Single(x => x.Id == selected.Id);
        check(result.Lists.Select(x => x.Id).SequenceEqual(new[]{empty.Id,list.Id}) &&
            detail.Colour == Colour.Blue.Code && item.ListId == list.Id && item.Priority == (int)PriorityLevel.High &&
            item.Note == "Preserved" && item.Done,
            "Actual PostgreSQL projects list/item GUIDs, owned colour and cyclic-navigation details with a read-only runtime role");
        check(result.Lists.Single(x => x.Id == empty.Id).Items.Count == 0 &&
            result.Lists.Single(x => x.Id == empty.Id).Colour == Colour.White.Code && !reader.ChangeTracker.Entries().Any(),
            "Empty lists and default colour remain valid without tracking entities or loading parent navigation");
        var page = await new GetTodoItemsWithPaginationQueryHandler(reader).Handle(
            new() { ListId = list.Id, PageNumber = 2, PageSize = 1 }, default);
        check(page.TotalCount == 3 && page.TotalPages == 3 && page.PageNumber == 2 &&
            page.Items.Single().Id == selected.Id && page.Items.Single().ListId == list.Id &&
            page.HasPreviousPage && page.HasNextPage,
            "Actual PostgreSQL filters and orders before GUID-safe page selection");
        var missing = await new GetTodoItemsWithPaginationQueryHandler(reader).Handle(
            new() { ListId = Guid.NewGuid() }, default);
        check(missing.TotalCount == 0 && missing.Items.Count == 0 && !missing.HasPreviousPage && !missing.HasNextPage,
            "A missing list returns an empty page without integer identifier conversion");
    }

    private static ApplicationDbContext Database(string connection) => new(
        new DbContextOptionsBuilder<ApplicationDbContext>().UseNpgsql(connection).Options);
}
