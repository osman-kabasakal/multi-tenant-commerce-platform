using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Application.Common.Models;
using SaasManager.Application.Common.Security;
using SaasManager.Domain.Enums;

namespace SaasManager.Application.TodoLists.Queries.GetTodos;

[Authorize]
public record GetTodosQuery : IRequest<TodosVm>;

public class GetTodosQueryHandler : IRequestHandler<GetTodosQuery, TodosVm>
{
    private readonly IApplicationDbContext _context;

    public GetTodosQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<TodosVm> Handle(GetTodosQuery request, CancellationToken cancellationToken)
    {
        return new TodosVm
        {
            PriorityLevels = Enum.GetValues(typeof(PriorityLevel))
                .Cast<PriorityLevel>()
                .Select(p => new LookupDto { Id = (int)p, Title = p.ToString() })
                .ToList(),

            Lists = await _context.TodoLists
                .AsNoTracking()
                .Select(list => new TodoListDto
                {
                    Id = list.Id, Title = list.Title, Colour = list.Colour.Code,
                    Items = list.Items.Select(item => new TodoItemDto
                    {
                        Id = item.Id, ListId = item.ListId, Title = item.Title,
                        Done = item.Done, Priority = (int)item.Priority, Note = item.Note
                    }).ToList()
                })
                .OrderBy(t => t.Title)
                .ToListAsync(cancellationToken)
        };
    }
}
