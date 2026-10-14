using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SaasManager.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class SubscriptionSelectionState1Migration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AttemptCount",
                table: "RegistrationStates",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsTrialSelected",
                table: "RegistrationStates",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "PaymentMethodId",
                table: "RegistrationStates",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "SelectedPlanId",
                table: "RegistrationStates",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "SelectionDate",
                table: "RegistrationStates",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "SubscriptionSelectionState_LastErrorMessage",
                table: "RegistrationStates",
                type: "text",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_RegistrationStates_PaymentMethodId",
                table: "RegistrationStates",
                column: "PaymentMethodId");

            migrationBuilder.CreateIndex(
                name: "IX_RegistrationStates_SelectedPlanId",
                table: "RegistrationStates",
                column: "SelectedPlanId");

            migrationBuilder.AddForeignKey(
                name: "FK_RegistrationStates_PaymentMethods_PaymentMethodId",
                table: "RegistrationStates",
                column: "PaymentMethodId",
                principalTable: "PaymentMethods",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_RegistrationStates_SubscriptionPlans_SelectedPlanId",
                table: "RegistrationStates",
                column: "SelectedPlanId",
                principalTable: "SubscriptionPlans",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_RegistrationStates_PaymentMethods_PaymentMethodId",
                table: "RegistrationStates");

            migrationBuilder.DropForeignKey(
                name: "FK_RegistrationStates_SubscriptionPlans_SelectedPlanId",
                table: "RegistrationStates");

            migrationBuilder.DropIndex(
                name: "IX_RegistrationStates_PaymentMethodId",
                table: "RegistrationStates");

            migrationBuilder.DropIndex(
                name: "IX_RegistrationStates_SelectedPlanId",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "AttemptCount",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "IsTrialSelected",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "PaymentMethodId",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "SelectedPlanId",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "SelectionDate",
                table: "RegistrationStates");

            migrationBuilder.DropColumn(
                name: "SubscriptionSelectionState_LastErrorMessage",
                table: "RegistrationStates");
        }
    }
}
