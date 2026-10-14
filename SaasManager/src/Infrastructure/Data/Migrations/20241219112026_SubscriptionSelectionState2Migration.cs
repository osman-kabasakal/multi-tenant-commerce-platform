using System.Text.Json;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SaasManager.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class SubscriptionSelectionState2Migration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<JsonDocument>(
                name: "PaymentProviderData",
                table: "PaymentMethods",
                type: "jsonb",
                nullable: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PaymentProviderData",
                table: "PaymentMethods");
        }
    }
}
