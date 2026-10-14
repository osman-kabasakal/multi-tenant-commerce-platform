using Grand.Infrastructure.Models;

namespace Payments.Iyzico.Models;

public class StoredCardModel: BaseModel
{
    public string CardAlias { get; set; }

    public string CardNumber { get; set; }

    public string CardHolderName { get; set; }

    public int ExpirationMonth { get; set; }

    public int ExpirationYear { get; set; }

    public string CardType { get; set; }

    public string CardToken { get; set; }

    public bool IsSelected { get; set; }
}
