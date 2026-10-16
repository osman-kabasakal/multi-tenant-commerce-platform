using FluentValidation;
using Grand.Api.Infrastructure;
using Grand.Api.Models.Common;
using Grand.Infrastructure.Configuration;
using Grand.Infrastructure.Validators;

namespace Grand.Api.Validators.Common;

public class LoginWebValidator : BaseGrandValidator<LoginWebModel>
{
    public LoginWebValidator(IEnumerable<IValidatorConsumer<LoginWebModel>> validators, FrontendAPIConfig apiConfig)
        : base(validators)
    {
        if (!apiConfig.Enabled)
        {
            RuleFor(x => x).Must(_ => false).WithMessage("API is disabled");
            return;
        }
        RuleFor(x => x.Email).NotEmpty().MaximumLength(320).EmailAddress();
        // Preserve the mobile wire format; malformed input is a validation error, never a decoding exception.
        RuleFor(x => x.Password).Must(value => CustomerTokenLogin.TryDecodePassword(value, out _))
            .WithMessage("Password must be a nonempty UTF-8 Base64 value.");
        // Account/password verification belongs to the shared action boundary, independent of MVC filter registration.
    }
}
