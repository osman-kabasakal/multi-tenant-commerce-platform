using System.Data;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;
using SaasManager.Application.Common.Interfaces.Data;
using SaasManager.Infrastructure.Data;
using SaasManager.Web.Infrastructure;

namespace SaasManager.Web.Endpoints;

public class DbQueries : EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        app.MapGroup(this)
            .AddEndpointFilter(async (ctx, next) =>
            {
                // Middleware olarak request'ten "db-query-key" header'ını kontrol et
                var apiKey = ctx.HttpContext.Request.Headers["db-query-key"].FirstOrDefault();
                
                // Environment'dan API anahtarını al veya varsayılan olarak "r876hjygfcfrvvbh" kullan
                var validApiKey = Environment.GetEnvironmentVariable("DB_QUERY_API_KEY") ?? "r876hjygfcfrvvbh";
                
                if (string.IsNullOrEmpty(apiKey) || apiKey != validApiKey)
                {
                    return Results.Unauthorized();
                }
                
                var logger = ctx.HttpContext.RequestServices.GetRequiredService<ILogger<DbQueries>>();
                logger.LogInformation("DB Query API accessed with valid key from IP: {IpAddress}", 
                    ctx.HttpContext.Connection.RemoteIpAddress);
                
                return await next(ctx);
            })
            .MapPost(ExecuteQuery, "execute")
            .MapGet(GetTableNames, "tables")
            .MapGet(GetTableColumns, "table/{tableName}/columns")
            .MapGet(GetBusinessApps, "businessapps/{businessId}")
            .MapGet(GetBusinessesByGuestId, "businesses/{guestId}");
    }

    public async Task<Results<Ok<QueryResponse<List<Dictionary<string, object>>>>, Ok<QueryAffectedRowsResponse>, BadRequest<ErrorResponse>, StatusCodeHttpResult>> ExecuteQuery(IApplicationDbContext dbContext, ILogger<DbQueries> logger, SqlQueryRequest request)
    {
        if (string.IsNullOrEmpty(request.Query))
        {
            return TypedResults.BadRequest(new ErrorResponse("Query cannot be empty"));
        }

        try
        {
            logger.LogWarning("SQL query executed: {Query}", request.Query);

            var connection = ((ApplicationDbContext)dbContext).Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
            {
                await connection.OpenAsync();
            }

            using var command = connection.CreateCommand();
            command.CommandText = request.Query;
            command.CommandType = CommandType.Text;

            // Select sorguları için
            if (request.Query.TrimStart().StartsWith("SELECT", StringComparison.OrdinalIgnoreCase))
            {
                using var reader = await command.ExecuteReaderAsync();
                var result = new List<Dictionary<string, object>>();
                
                while (await reader.ReadAsync())
                {
                    var row = new Dictionary<string, object>();
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        var columnName = reader.GetName(i);
                        var value = reader.IsDBNull(i) ? null : reader.GetValue(i);
                        row[columnName] = value;
                    }
                    result.Add(row);
                }

                return TypedResults.Ok(new QueryResponse<List<Dictionary<string, object>>>(result));
            }
            // Insert, Update, Delete sorguları için
            else
            {
                var affectedRows = await command.ExecuteNonQueryAsync();
                return TypedResults.Ok(new QueryAffectedRowsResponse(affectedRows));
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error executing SQL query: {Query}", request.Query);
            return TypedResults.StatusCode(StatusCodes.Status500InternalServerError);
        }
    }

    public async Task<Results<Ok<TableNamesResponse>, StatusCodeHttpResult>> GetTableNames(IApplicationDbContext dbContext, ILogger<DbQueries> logger)
    {
        try
        {
            var connection = ((ApplicationDbContext)dbContext).Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
            {
                await connection.OpenAsync();
            }

            var tableNames = new List<string>();

            // PostgreSQL için tablo adlarını alın
            using var command = connection.CreateCommand();
            command.CommandText = @"
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_type = 'BASE TABLE'
                ORDER BY table_name";

            using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                tableNames.Add(reader.GetString(0));
            }

            return TypedResults.Ok(new TableNamesResponse(tableNames));
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error getting table names");
            return TypedResults.StatusCode(StatusCodes.Status500InternalServerError);
        }
    }

    public async Task<Results<Ok<TableColumnsResponse>, StatusCodeHttpResult>> GetTableColumns(IApplicationDbContext dbContext, ILogger<DbQueries> logger, string tableName)
    {
        try
        {
            var connection = ((ApplicationDbContext)dbContext).Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
            {
                await connection.OpenAsync();
            }

            var columns = new List<TableColumnInfo>();

            // PostgreSQL için kolon bilgilerini alın
            using var command = connection.CreateCommand();
            command.CommandText = @"
                SELECT 
                    column_name, 
                    data_type,
                    is_nullable,
                    column_default
                FROM 
                    information_schema.columns
                WHERE 
                    table_schema = 'public' AND 
                    table_name = @tableName
                ORDER BY 
                    ordinal_position";

            var parameter = command.CreateParameter();
            parameter.ParameterName = "@tableName";
            parameter.Value = tableName;
            command.Parameters.Add(parameter);

            using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                columns.Add(new TableColumnInfo
                {
                    Name = reader.GetString(0),
                    DataType = reader.GetString(1),
                    IsNullable = reader.GetString(2) == "YES",
                    DefaultValue = reader.IsDBNull(3) ? null : reader.GetString(3)
                });
            }

            return TypedResults.Ok(new TableColumnsResponse(columns));
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error getting columns for table {TableName}", tableName);
            return TypedResults.StatusCode(StatusCodes.Status500InternalServerError);
        }
    }

    public async Task<Results<Ok<BusinessAppsResponse>, StatusCodeHttpResult>> GetBusinessApps(IApplicationDbContext dbContext, ILogger<DbQueries> logger, Guid businessId)
    {
        try
        {
            var businessApps = await dbContext.BusinessApps
                .Where(b => b.BusinessId == businessId)
                .ToListAsync();

            var businessAppDtos = businessApps.Select(b => new BusinessAppDto
            {
                Id = b.Id,
                BusinessId = b.BusinessId,
                Type = b.Type.ToString(),
                AppName = b.AppName,
                PackageName = b.PackageName,
                Created = b.CreatedAt,
                CreatedBy = b.CreatedBy.ToString()
            }).ToList();

            return TypedResults.Ok(new BusinessAppsResponse(businessAppDtos));
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error getting business apps for business {BusinessId}", businessId);
            return TypedResults.StatusCode(StatusCodes.Status500InternalServerError);
        }
    }

    public async Task<Results<Ok<BusinessesResponse>, StatusCodeHttpResult>> GetBusinessesByGuestId(IApplicationDbContext dbContext, ILogger<DbQueries> logger, Guid guestId)
    {
        try
        {
            var businesses = await dbContext.Businesses
                .Where(b => b.CreatedByGuestId == guestId)
                .ToListAsync();

            var businessDtos = businesses.Select(b => new BusinessDto
            {
                Id = b.Id,
                Name = b.Name,
                LegalCompanyName = b.LegalCompanyName,
                CreatedByGuestId = b.CreatedByGuestId,
                Status = b.Status.ToString(),
                IsActive = b.IsActive,
                Created = b.CreatedAt
            }).ToList();

            return TypedResults.Ok(new BusinessesResponse(businessDtos));
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error getting businesses for guest {GuestId}", guestId);
            return TypedResults.StatusCode(StatusCodes.Status500InternalServerError);
        }
    }
}

// Response Classes
public class BaseResponse
{
    public bool Success { get; }

    public BaseResponse(bool success = true)
    {
        Success = success;
    }
}

public class ErrorResponse : BaseResponse
{
    public string Error { get; }

    public ErrorResponse(string error) : base(false)
    {
        Error = error;
    }
}

public class QueryResponse<T> : BaseResponse
{
    public T Data { get; }

    public QueryResponse(T data) : base(true)
    {
        Data = data;
    }
}

public class QueryAffectedRowsResponse : BaseResponse
{
    public int AffectedRows { get; }

    public QueryAffectedRowsResponse(int affectedRows) : base(true)
    {
        AffectedRows = affectedRows;
    }
}

public class TableNamesResponse : BaseResponse
{
    public List<string> Tables { get; }

    public TableNamesResponse(List<string> tables) : base(true)
    {
        Tables = tables;
    }
}

public class TableColumnsResponse : BaseResponse
{
    public List<TableColumnInfo> Columns { get; }

    public TableColumnsResponse(List<TableColumnInfo> columns) : base(true)
    {
        Columns = columns;
    }
}

public class BusinessAppsResponse : BaseResponse
{
    public List<BusinessAppDto> Data { get; }

    public BusinessAppsResponse(List<BusinessAppDto> data) : base(true)
    {
        Data = data;
    }
}

public class BusinessesResponse : BaseResponse
{
    public List<BusinessDto> Data { get; }

    public BusinessesResponse(List<BusinessDto> data) : base(true)
    {
        Data = data;
    }
}

// Request/DTO Classes
public class SqlQueryRequest
{
    public string Query { get; set; } = string.Empty;
}

public class TableColumnInfo
{
    public string Name { get; set; }
    public string DataType { get; set; }
    public bool IsNullable { get; set; }
    public string? DefaultValue { get; set; }
}

public class BusinessAppDto
{
    public Guid Id { get; set; }
    public Guid BusinessId { get; set; }
    public string Type { get; set; }
    public string AppName { get; set; }
    public string PackageName { get; set; }
    public DateTime Created { get; set; }
    public string CreatedBy { get; set; }
}

public class BusinessDto
{
    public Guid Id { get; set; }
    public string Name { get; set; }
    public string LegalCompanyName { get; set; }
    public Guid CreatedByGuestId { get; set; }
    public string Status { get; set; }
    public bool IsActive { get; set; }
    public DateTime Created { get; set; }
}
