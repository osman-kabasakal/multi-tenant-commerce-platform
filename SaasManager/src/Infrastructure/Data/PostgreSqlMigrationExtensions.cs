using Microsoft.EntityFrameworkCore.Migrations;

namespace SaasManager.Infrastructure.Data;

public static class PostgreSqlMigrationExtensions
{
    private static readonly Dictionary<(Type, Type), string> TypeConversionQueries = new()
    {
        { (typeof(string), typeof(Guid)), @"
            ALTER TABLE ""{0}"" 
            ADD COLUMN ""{1}_new"" uuid{2};
            
            UPDATE ""{0}"" 
            SET ""{1}_new"" = CASE 
                WHEN ""{1}"" IS NOT NULL AND ""{1}"" ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
                THEN ""{1}""::uuid 
                ELSE NULL 
            END;
            
            ALTER TABLE ""{0}"" DROP COLUMN ""{1}"";
            ALTER TABLE ""{0}"" RENAME COLUMN ""{1}_new"" TO ""{1}"";" 
        },
        { (typeof(string), typeof(int)), @"
            ALTER TABLE ""{0}"" 
            ADD COLUMN ""{1}_new"" integer{2};
            
            UPDATE ""{0}"" 
            SET ""{1}_new"" = CASE 
                WHEN ""{1}"" ~ '^[-]?\d+$'
                THEN ""{1}""::integer 
                ELSE NULL 
            END;
            
            ALTER TABLE ""{0}"" DROP COLUMN ""{1}"";
            ALTER TABLE ""{0}"" RENAME COLUMN ""{1}_new"" TO ""{1}"";" 
        },
        { (typeof(string), typeof(decimal)), @"
            ALTER TABLE ""{0}"" 
            ADD COLUMN ""{1}_new"" numeric{2};
            
            UPDATE ""{0}"" 
            SET ""{1}_new"" = CASE 
                WHEN ""{1}"" ~ '^[-]?\d*\.?\d+$'
                THEN ""{1}""::numeric 
                ELSE NULL 
            END;
            
            ALTER TABLE ""{0}"" DROP COLUMN ""{1}"";
            ALTER TABLE ""{0}"" RENAME COLUMN ""{1}_new"" TO ""{1}"";" 
        },
        { (typeof(string), typeof(DateTime)), @"
            ALTER TABLE ""{0}"" 
            ADD COLUMN ""{1}_new"" timestamp with time zone{2};
            
            UPDATE ""{0}"" 
            SET ""{1}_new"" = CASE 
                WHEN ""{1}"" IS NOT NULL AND ""{1}"" ~ '^\d{4}-\d{2}-\d{2}.*'
                THEN ""{1}""::timestamp with time zone 
                ELSE NULL 
            END;
            
            ALTER TABLE ""{0}"" DROP COLUMN ""{1}"";
            ALTER TABLE ""{0}"" RENAME COLUMN ""{1}_new"" TO ""{1}"";" 
        },
        { (typeof(string), typeof(bool)), @"
            ALTER TABLE ""{0}"" 
            ADD COLUMN ""{1}_new"" boolean{2};
            
            UPDATE ""{0}"" 
            SET ""{1}_new"" = CASE 
                WHEN LOWER(""{1}"") IN ('true', 't', 'yes', 'y', '1') THEN true
                WHEN LOWER(""{1}"") IN ('false', 'f', 'no', 'n', '0') THEN false
                ELSE NULL 
            END;
            
            ALTER TABLE ""{0}"" DROP COLUMN ""{1}"";
            ALTER TABLE ""{0}"" RENAME COLUMN ""{1}_new"" TO ""{1}"";" 
        }
    };

    public static void AlterColumnType(
        this MigrationBuilder migrationBuilder,
        string name,
        string table,
        bool nullable,
        Type oldClrType,
        Type newClrType)
    {
        if (migrationBuilder == null)
            throw new ArgumentNullException(nameof(migrationBuilder));

        var conversionKey = (oldClrType, newClrType);
        if (!TypeConversionQueries.ContainsKey(conversionKey))
            throw new NotSupportedException($"Conversion from {oldClrType} to {newClrType} is not supported.");

        var nullableText = nullable ? " NULL" : " NOT NULL";
        var sql = string.Format(TypeConversionQueries[conversionKey], table, name, nullableText);
        
        migrationBuilder.Sql(sql);
    }
}
