using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SaasManager.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class KeycloakMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Firstname",
                table: "GuestRegistrations",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Lastname",
                table: "GuestRegistrations",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Firstname",
                table: "GuestRegistrations");

            migrationBuilder.DropColumn(
                name: "Lastname",
                table: "GuestRegistrations");
        }
    }
}
