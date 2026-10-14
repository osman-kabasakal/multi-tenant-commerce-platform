using Core.Models.Responses;
using Microsoft.AspNetCore.Http.HttpResults;
using SaasManager.Application.Common.Models.IdentityManagement;
using SaasManager.Application.IdentityManagement.Commands.Registration;

namespace SaasManager.Web.Endpoints;

public class IdentityManagement : EndpointGroupBase
{
    public override void Map(WebApplication app)
    {
        app.MapGroup(this, $"identity")
            .RequireAuthorization()
            // .MapPost(InitiateEmailVerification, "verify-email")
            // .MapPost(VerifyCode, "verify-code")
            // .MapPost(ResendCode, "resend-code")
            .MapPost(RegistrationStep, "registration");
    }

    public async Task<Ok<ServiceResponse<RegistrationStepResponse>>> RegistrationStep(ISender sender, RegistrationCommand registrationCommand)
    {
        return TypedResults.Ok(await sender.Send(registrationCommand));
    }
    //
    // public async Task<Created<ServiceResponse<EmailVerificationResponse>>> InitiateEmailVerification(ISender sender,
    //     InitiateEmailVerificationCommand command)
    // {
    //     return TypedResults.Created("/api/identity/verify-email", await sender.Send(command));
    // }
    //
    // public async Task<Ok<ServiceResponse<VerifyCodeResponse>>> VerifyCode(ISender sender,
    //     VerifyEmailCodeCommand command)
    // {
    //     return TypedResults.Ok(await sender.Send(command));
    // }
    //
    // public async Task<Ok<ServiceResponse<EmailVerificationResponse>>> ResendCode(ISender sender,
    //     ResendEmailVerificationCodeCommand command)
    // {
    //     return TypedResults.Ok(await sender.Send(command));
    // }
}
