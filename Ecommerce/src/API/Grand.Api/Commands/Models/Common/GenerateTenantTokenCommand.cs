using MediatR;

namespace Grand.Api.Commands.Models.Common;

public class GenerateTenantTokenCommand : IRequest<string>
{
    public Dictionary<string, string> Claims { get; set; }
    public string TenantId { get; set; }
}

public class GenerateTenantTokenWebCommand : IRequest<string>
{
    public Dictionary<string, string> Claims { get; set; }
    public string TenantId { get; set; }
}