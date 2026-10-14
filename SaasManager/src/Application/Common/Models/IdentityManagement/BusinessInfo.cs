using System.ComponentModel;

namespace SaasManager.Application.Common.Models.IdentityManagement;

public record BusinessInfo(
    string Name,
    string OwnerName,
    string TaxNumber,
    string TaxOffice,
    string Address,
    string City,
    string District,
    string PostalCode,
    string LegalCompanyName
);
