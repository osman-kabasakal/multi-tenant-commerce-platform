using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SaasManager.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class BusinessInfoRegistrationStateMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "BusinessId",
                table: "RegistrationStates",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "LastTaxValidationAttempt",
                table: "RegistrationStates",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "LastValidationError",
                table: "RegistrationStates",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ValidatedTaxNumber",
                table: "RegistrationStates",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ValidationAttempts",
                table: "RegistrationStates",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_RegistrationStates_BusinessId",
                table: "RegistrationStates",
                column: "BusinessId");

            migrationBuilder.AddForeignKey(
                name: "FK_RegistrationStates_Businesses_BusinessId",
                table: "RegistrationStates",
                column: "BusinessId",
                principalTable: "Businesses",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_RegistrationStates_Businesses_BusinessId",
                table: "RegistrationStates");

            migrationBuilder.DropIndex(
                name: "IX_RegistrationStates_BusinessId",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "BusinessId",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "LastTaxValidationAttempt",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "LastValidationError",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "ValidatedTaxNumber",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "ValidationAttempts",
                table: "RegistrationStates");
        }
    }
}
