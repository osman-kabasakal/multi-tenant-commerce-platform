using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Mappings;
using SaasManager.Application.Common.Models;

namespace SaasManager.Application.TodoItems.Queries.GetTodoItemsWithPagination;

public record GetTodoItemsWithPaginationQuery : IRequest<PaginatedList<TodoItemBriefDto>>
{
    public Guid ListId { get; init; }
    public int PageNumber { get; init; } = 1;
    public int PageSize { get; init; } = 10;
}

public class GetTodoItemsWithPaginationQueryHandler : IRequestHandler<GetTodoItemsWithPaginationQuery, PaginatedList<TodoItemBriefDto>>
{
    private readonly IApplicationDbContext _context;

    public GetTodoItemsWithPaginationQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<PaginatedList<TodoItemBriefDto>> Handle(GetTodoItemsWithPaginationQuery request, CancellationToken cancellationToken)
    {
        return await _context.TodoItems
            .Where(x => x.ListId == request.ListId)
            .OrderBy(x => x.Title)
            .Select(item => new TodoItemBriefDto
            {
                Id = item.Id, ListId = item.ListId, Title = item.Title, Done = item.Done
            })
            .PaginatedListAsync(request.PageNumber, request.PageSize);
    }
}
