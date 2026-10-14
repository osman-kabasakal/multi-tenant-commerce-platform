using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SaasManager.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class RegisteredAppMigrations_ConvertAuditableEntity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedAt",
                table: "AppStoreMetadata",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<Guid>(
                name: "CreatedBy",
                table: "AppStoreMetadata",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "AppStoreMetadata",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DeletedBy",
                table: "AppStoreMetadata",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AppStoreMetadata",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "UpdatedAt",
                table: "AppStoreMetadata",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<uint>(
                name: "xmin",
                table: "AppStoreMetadata",
                type: "xid",
                rowVersion: true,
                nullable: false,
                defaultValue: 0u);

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedAt",
                table: "AppScreenshots",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<Guid>(
                name: "CreatedBy",
                table: "AppScreenshots",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "AppScreenshots",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DeletedBy",
                table: "AppScreenshots",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AppScreenshots",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "UpdatedAt",
                table: "AppScreenshots",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<uint>(
                name: "xmin",
                table: "AppScreenshots",
                type: "xid",
                rowVersion: true,
                nullable: false,
                defaultValue: 0u);

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedAt",
                table: "AppReleases",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<Guid>(
                name: "CreatedBy",
                table: "AppReleases",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "AppReleases",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DeletedBy",
                table: "AppReleases",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "AppReleases",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AppReleases",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "UpdatedAt",
                table: "AppReleases",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<uint>(
                name: "xmin",
                table: "AppReleases",
                type: "xid",
                rowVersion: true,
                nullable: false,
                defaultValue: 0u);

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedAt",
                table: "AppMediaAssets",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<Guid>(
                name: "CreatedBy",
                table: "AppMediaAssets",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "AppMediaAssets",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DeletedBy",
                table: "AppMediaAssets",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "AppMediaAssets",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AppMediaAssets",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "UpdatedAt",
                table: "AppMediaAssets",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<uint>(
                name: "xmin",
                table: "AppMediaAssets",
                type: "xid",
                rowVersion: true,
                nullable: false,
                defaultValue: 0u);

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedAt",
                table: "AppBuilds",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<Guid>(
                name: "CreatedBy",
                table: "AppBuilds",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "AppBuilds",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DeletedBy",
                table: "AppBuilds",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "AppBuilds",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AppBuilds",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "UpdatedAt",
                table: "AppBuilds",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<uint>(
                name: "xmin",
                table: "AppBuilds",
                type: "xid",
                rowVersion: true,
                nullable: false,
                defaultValue: 0u);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "AppStoreMetadata");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                table: "AppStoreMetadata");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "AppStoreMetadata");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "AppStoreMetadata");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AppStoreMetadata");

            migrationBuilder.DropColumn(
                name: "UpdatedAt",
                table: "AppStoreMetadata");

            migrationBuilder.DropColumn(
                name: "xmin",
                table: "AppStoreMetadata");

            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "AppScreenshots");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                table: "AppScreenshots");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "AppScreenshots");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "AppScreenshots");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AppScreenshots");

            migrationBuilder.DropColumn(
                name: "UpdatedAt",
                table: "AppScreenshots");

            migrationBuilder.DropColumn(
                name: "xmin",
                table: "AppScreenshots");

            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "AppReleases");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                table: "AppReleases");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "AppReleases");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "AppReleases");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "AppReleases");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AppReleases");

            migrationBuilder.DropColumn(
                name: "UpdatedAt",
                table: "AppReleases");

            migrationBuilder.DropColumn(
                name: "xmin",
                table: "AppReleases");

            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "AppMediaAssets");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                table: "AppMediaAssets");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "AppMediaAssets");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "AppMediaAssets");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "AppMediaAssets");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AppMediaAssets");

            migrationBuilder.DropColumn(
                name: "UpdatedAt",
                table: "AppMediaAssets");

            migrationBuilder.DropColumn(
                name: "xmin",
                table: "AppMediaAssets");

            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "AppBuilds");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                table: "AppBuilds");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "AppBuilds");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "AppBuilds");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "AppBuilds");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AppBuilds");

            migrationBuilder.DropColumn(
                name: "UpdatedAt",
                table: "AppBuilds");

            migrationBuilder.DropColumn(
                name: "xmin",
                table: "AppBuilds");
        }
    }
}
