using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SaasManager.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class DatabaseUniqInstanceRevoke : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_DatabaseConfigs_InstanceName",
                table: "DatabaseConfigs");

            migrationBuilder.CreateIndex(
                name: "IX_DatabaseConfigs_InstanceName",
                table: "DatabaseConfigs",
                column: "InstanceName",
                filter: "\"IsDeleted\"  = false");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_DatabaseConfigs_InstanceName",
                table: "DatabaseConfigs");

            migrationBuilder.CreateIndex(
                name: "IX_DatabaseConfigs_InstanceName",
                table: "DatabaseConfigs",
                column: "InstanceName",
                unique: true,
                filter: "\"IsDeleted\"  = false");
        }
    }
}
