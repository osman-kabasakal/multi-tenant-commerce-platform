using Microsoft.EntityFrameworkCore;
using NUnit.Framework;
using Moq;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.TodoItems.Queries.GetTodoItemsWithPagination;
using SaasManager.Application.TodoLists.Queries.GetTodos;
using SaasManager.Domain.Entities;
using SaasManager.Domain.Enums;
using SaasManager.Domain.ValueObjects;
using SaasManager.Infrastructure.Data.Configurations;

namespace SaasManager.Application.UnitTests.Common.Mappings;

public class MappingTests
{
    private static TodoDatabase Database() => new();

    private sealed class TodoDatabase : DbContext
    {
        public TodoDatabase() : base(new DbContextOptionsBuilder<TodoDatabase>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString("N")).Options) { }
        public DbSet<TodoList> TodoLists => Set<TodoList>();
        public DbSet<TodoItem> TodoItems => Set<TodoItem>();
        public IApplicationDbContext Application
        {
            get
            {
                var context = new Mock<IApplicationDbContext>();
                context.Setup(x => x.TodoLists).Returns(TodoLists);
                context.Setup(x => x.TodoItems).Returns(TodoItems);
                return context.Object;
            }
        }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.ApplyConfiguration(new TodoListConfiguration());
            builder.ApplyConfiguration(new TodoItemConfiguration());
        }
    }

    [Test]
    public async Task ListsKeepGuidIdentityColourAndItemDetailsWithoutTraversingBackReferences()
    {
        await using var db = Database();
        var list = new TodoList { Id = Guid.NewGuid(), Title = "Beta", Colour = Colour.Blue };
        var item = new TodoItem { Id = Guid.NewGuid(), List = list, ListId = list.Id,
            Title = "Ship", Note = "Keep this note", Priority = PriorityLevel.High, Done = true };
        list.Items.Add(item);
        db.TodoLists.AddRange(list, new TodoList { Id = Guid.NewGuid(), Title = "Alpha" });
        await db.SaveChangesAsync();
        db.ChangeTracker.Clear();

        var result = await new GetTodosQueryHandler(db.Application).Handle(new(), default);

        Assert.That(result.Lists.Select(x => x.Title), Is.EqualTo(new[] { "Alpha", "Beta" }));
        var output = result.Lists.Single(x => x.Id == list.Id);
        Assert.That(output.Colour, Is.EqualTo(Colour.Blue.Code));
        var detail = output.Items.Single();
        Assert.Multiple(() => {
            Assert.That(detail.Id, Is.EqualTo(item.Id));
            Assert.That(detail.ListId, Is.EqualTo(list.Id));
            Assert.That(detail.Title, Is.EqualTo("Ship"));
            Assert.That(detail.Note, Is.EqualTo("Keep this note"));
            Assert.That(detail.Priority, Is.EqualTo((int)PriorityLevel.High));
            Assert.That(detail.Done, Is.True);
            Assert.That(db.ChangeTracker.Entries(), Is.Empty);
        });
    }

    [Test]
    public async Task PaginationFiltersTheRequestedListAndOrdersBeforeTakingThePage()
    {
        await using var db = Database();
        var list = new TodoList { Id = Guid.NewGuid(), Title = "Selected" };
        foreach (var title in new[] { "Gamma", "Alpha", "Beta" })
            list.Items.Add(new TodoItem { Id = Guid.NewGuid(), ListId = list.Id, Title = title });
        var other = new TodoList { Id = Guid.NewGuid(), Title = "Other" };
        other.Items.Add(new TodoItem { Id = Guid.NewGuid(), ListId = other.Id, Title = "A foreign item" });
        db.TodoLists.AddRange(list, other);
        await db.SaveChangesAsync();
        db.ChangeTracker.Clear();

        var page = await new GetTodoItemsWithPaginationQueryHandler(db.Application).Handle(
            new() { ListId = list.Id, PageNumber = 2, PageSize = 1 }, default);

        Assert.Multiple(() => {
            Assert.That(page.TotalCount, Is.EqualTo(3));
            Assert.That(page.TotalPages, Is.EqualTo(3));
            Assert.That(page.PageNumber, Is.EqualTo(2));
            Assert.That(page.HasNextPage && page.HasPreviousPage, Is.True);
            Assert.That(page.Items.Single().Title, Is.EqualTo("Beta"));
            Assert.That(page.Items.Single().Id, Is.EqualTo(list.Items.Single(x => x.Title == "Beta").Id));
            Assert.That(page.Items.Single().ListId, Is.EqualTo(list.Id));
        });
    }

    [Test]
    public async Task EmptyListRetainsItsGuidAndDefaultColour()
    {
        await using var db = Database();
        var list = new TodoList { Id = Guid.NewGuid(), Title = "Empty" };
        db.TodoLists.Add(list);
        await db.SaveChangesAsync();
        db.ChangeTracker.Clear();
        var result = await new GetTodosQueryHandler(db.Application).Handle(new(), default);
        var output = result.Lists.Single();
        Assert.Multiple(() => {
            Assert.That(output.Id, Is.EqualTo(list.Id));
            Assert.That(output.Colour, Is.EqualTo(Colour.White.Code));
            Assert.That(output.Items, Is.Empty);
        });
    }

    [Test]
    public async Task MissingListProducesAnEmptyPage()
    {
        await using var db = Database();
        var page = await new GetTodoItemsWithPaginationQueryHandler(db.Application).Handle(
            new() { ListId = Guid.NewGuid() }, default);
        Assert.Multiple(() => {
            Assert.That(page.Items, Is.Empty);
            Assert.That(page.TotalCount, Is.Zero);
            Assert.That(page.TotalPages, Is.Zero);
            Assert.That(page.HasNextPage || page.HasPreviousPage, Is.False);
        });
    }
}
