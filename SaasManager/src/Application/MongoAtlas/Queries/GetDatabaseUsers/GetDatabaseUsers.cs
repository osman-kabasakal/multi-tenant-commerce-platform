// using Core.Models.Responses;
// using SaasManager.Application.Common.Interfaces;
// using SaasManager.Application.Common.Models.MongoAtlasModels;
//
// namespace SaasManager.Application.MongoAtlas.Queries.GetDatabaseUsers;
//
// public record GetDatabaseUsersQuery : IRequest<ServiceResponse<List<MongoDatabaseUser>>>
// {
// }
//
// public class GetDatabaseUsersQueryValidator : AbstractValidator<GetDatabaseUsersQuery>
// {
//     public GetDatabaseUsersQueryValidator()
//     {
//     }
// }
//
// public class GetDatabaseUsersQueryHandler : IRequestHandler<GetDatabaseUsersQuery, ServiceResponse<List<MongoDatabaseUser>>>
// {
//     private readonly IApplicationDbContext _context;
//
//     public GetDatabaseUsersQueryHandler(IApplicationDbContext context)
//     {
//         _context = context;
//     }
//
//     public async Task<ServiceResponse<List<MongoDatabaseUser>>> Handle(GetDatabaseUsersQuery request, CancellationToken cancellationToken)
//     {
//         throw new NotImplementedException();
//     }
// }
