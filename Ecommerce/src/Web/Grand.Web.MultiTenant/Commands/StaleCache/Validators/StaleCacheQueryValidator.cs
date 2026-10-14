using FluentValidation;
using Grand.Infrastructure.Validators;
using Grand.Web.MultiTenant.Commands.StaleCache.Models;
using Org.BouncyCastle.Math.EC.Rfc7748;
using System;

namespace Grand.Web.MultiTenant.Commands.StaleCache.Validators;

public class StaleCacheQueryValidator : BaseGrandValidator<StaleCacheQuery>
{
    public StaleCacheQueryValidator(IEnumerable<IValidatorConsumer<StaleCacheQuery>> validators

) : base(validators)
    {
        RuleFor((model) => model.StaleCacheItems).Custom((field, context) =>
        {
            if (field.Count == 0)
            {
                context.AddFailure("StaleCacheItems", "Bayat sorgu göndermi zorunludur");
            }

            if (field.Any(x => string.IsNullOrEmpty(x.CorrelationId) || x.AsOf == DateTime.MinValue || Guid.TryParse(x.CorrelationId, out _) == false))
            {
                context.AddFailure("StaleCacheItems", "Bayat sorguların eşleşme kimlikleri boş veya benzersiz bir kimlik olmalıdır ve geçerlilik süresi belirtilmelidir");
            }
        });
    }

}
