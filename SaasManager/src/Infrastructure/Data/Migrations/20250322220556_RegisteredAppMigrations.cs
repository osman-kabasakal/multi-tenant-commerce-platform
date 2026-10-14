using System;
using System.Text.Json;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SaasManager.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class RegisteredAppMigrations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AppBuilds",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessAppId = table.Column<Guid>(type: "uuid", nullable: false),
                    Platform = table.Column<string>(type: "text", nullable: false),
                    Version = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    BuildNumber = table.Column<int>(type: "integer", nullable: false),
                    FileSize = table.Column<long>(type: "bigint", nullable: false),
                    FilePath = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    FileHash = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    BuildStatus = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    BuildDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    ExpiryDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    Configuration = table.Column<JsonDocument>(type: "jsonb", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppBuilds", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AppBuilds_BusinessApps_BusinessAppId",
                        column: x => x.BusinessAppId,
                        principalTable: "BusinessApps",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AppMediaAssets",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessAppId = table.Column<Guid>(type: "uuid", nullable: false),
                    AssetType = table.Column<string>(type: "text", nullable: false),
                    Platform = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    FileName = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    FilePath = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    FileSize = table.Column<int>(type: "integer", nullable: false),
                    Width = table.Column<int>(type: "integer", nullable: false),
                    Height = table.Column<int>(type: "integer", nullable: false),
                    IsDefault = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppMediaAssets", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AppMediaAssets_BusinessApps_BusinessAppId",
                        column: x => x.BusinessAppId,
                        principalTable: "BusinessApps",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AppScreenshots",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessAppId = table.Column<Guid>(type: "uuid", nullable: false),
                    ScreenType = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    FileName = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    FilePath = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    FileSize = table.Column<int>(type: "integer", nullable: false),
                    Width = table.Column<int>(type: "integer", nullable: false),
                    Height = table.Column<int>(type: "integer", nullable: false),
                    DisplayOrder = table.Column<int>(type: "integer", nullable: false, defaultValue: 0),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppScreenshots", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AppScreenshots_BusinessApps_BusinessAppId",
                        column: x => x.BusinessAppId,
                        principalTable: "BusinessApps",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AppStoreMetadata",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessAppId = table.Column<Guid>(type: "uuid", nullable: false),
                    Platform = table.Column<string>(type: "text", nullable: false),
                    AppTitle = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    ShortDescription = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    FullDescription = table.Column<string>(type: "character varying(4000)", maxLength: 4000, nullable: true),
                    Keywords = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    PrimaryCategory = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    SecondaryCategory = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    MinimumOsVersion = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    SupportUrl = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    PrivacyPolicyUrl = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    AppleAppId = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    GooglePackageName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppStoreMetadata", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AppStoreMetadata_BusinessApps_BusinessAppId",
                        column: x => x.BusinessAppId,
                        principalTable: "BusinessApps",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AppReleases",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessAppId = table.Column<Guid>(type: "uuid", nullable: false),
                    Platform = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    AppBuildId = table.Column<Guid>(type: "uuid", nullable: false),
                    Version = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    ReleaseNotes = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    ReleaseStatus = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    SubmissionDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    PublishedDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    RejectionReason = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppReleases", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AppReleases_AppBuilds_AppBuildId",
                        column: x => x.AppBuildId,
                        principalTable: "AppBuilds",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AppReleases_BusinessApps_BusinessAppId",
                        column: x => x.BusinessAppId,
                        principalTable: "BusinessApps",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AppBuilds_BuildDate",
                table: "AppBuilds",
                column: "BuildDate");

            migrationBuilder.CreateIndex(
                name: "IX_AppBuilds_BuildStatus",
                table: "AppBuilds",
                column: "BuildStatus");

            migrationBuilder.CreateIndex(
                name: "IX_AppBuilds_BusinessAppId_Version_BuildNumber_Platform",
                table: "AppBuilds",
                columns: new[] { "BusinessAppId", "Version", "BuildNumber", "Platform" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AppBuilds_ExpiryDate",
                table: "AppBuilds",
                column: "ExpiryDate");

            migrationBuilder.CreateIndex(
                name: "IX_AppMediaAssets_BusinessAppId_AssetType_Platform",
                table: "AppMediaAssets",
                columns: new[] { "BusinessAppId", "AssetType", "Platform" });

            migrationBuilder.CreateIndex(
                name: "IX_AppMediaAssets_FilePath",
                table: "AppMediaAssets",
                column: "FilePath",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AppReleases_AppBuildId",
                table: "AppReleases",
                column: "AppBuildId");

            migrationBuilder.CreateIndex(
                name: "IX_AppReleases_BusinessAppId_Version_Platform",
                table: "AppReleases",
                columns: new[] { "BusinessAppId", "Version", "Platform" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AppReleases_PublishedDate",
                table: "AppReleases",
                column: "PublishedDate");

            migrationBuilder.CreateIndex(
                name: "IX_AppReleases_ReleaseStatus",
                table: "AppReleases",
                column: "ReleaseStatus");

            migrationBuilder.CreateIndex(
                name: "IX_AppReleases_SubmissionDate",
                table: "AppReleases",
                column: "SubmissionDate");

            migrationBuilder.CreateIndex(
                name: "IX_AppScreenshots_BusinessAppId_ScreenType_DisplayOrder",
                table: "AppScreenshots",
                columns: new[] { "BusinessAppId", "ScreenType", "DisplayOrder" });

            migrationBuilder.CreateIndex(
                name: "IX_AppScreenshots_FilePath",
                table: "AppScreenshots",
                column: "FilePath",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AppStoreMetadata_AppleAppId",
                table: "AppStoreMetadata",
                column: "AppleAppId");

            migrationBuilder.CreateIndex(
                name: "IX_AppStoreMetadata_BusinessAppId_Platform",
                table: "AppStoreMetadata",
                columns: new[] { "BusinessAppId", "Platform" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AppStoreMetadata_GooglePackageName",
                table: "AppStoreMetadata",
                column: "GooglePackageName");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AppMediaAssets");

            migrationBuilder.DropTable(
                name: "AppReleases");

            migrationBuilder.DropTable(
                name: "AppScreenshots");

            migrationBuilder.DropTable(
                name: "AppStoreMetadata");

            migrationBuilder.DropTable(
                name: "AppBuilds");
        }
    }
}
