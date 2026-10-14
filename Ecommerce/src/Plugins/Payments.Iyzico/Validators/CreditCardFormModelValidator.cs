using FluentValidation;
using Payments.Iyzico.Services;
using Payments.Iyzico.Utilities;

namespace Payments.Iyzico.Validators;

public class CreditCardFormModelValidator : DynamicFormValidator<CreditCardFormModel>
{
    public CreditCardFormModelValidator(
        IIyzicoPayService iyzicoPayService
    ):base(false)
    {
        When(x => string.IsNullOrEmpty(x.CardToken) , () =>
        {
            CreateDefaultRules();
            When(x=>(x.ApproveCartStoreWithIyzico??false), ()=>{
                RuleFor(x=>x.CardAlias).NotNull().NotEmpty().WithMessage("Kart ismi gereklidir!");
            });
        });

        When(x => !string.IsNullOrEmpty(x.CardToken), () =>
        {
            RuleFor(x => x.CardToken).CustomAsync(async (cardToken, context, cancellationToken) =>
            {
                var result = await iyzicoPayService.GetUserCard(cardToken!);
                if (result == null)
                {
                    context.AddFailure("Kart bilgileri alınamadı!");
                }
            });
        });
    }
}
