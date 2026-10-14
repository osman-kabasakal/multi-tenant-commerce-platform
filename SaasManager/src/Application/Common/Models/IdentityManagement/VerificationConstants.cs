namespace SaasManager.Application.Common.Models.IdentityManagement;

/// <summary>
/// Doğrulama süreçlerinde kullanılan tüm enum değerleri
/// </summary>
public static class VerificationConstants
{
    public static class Steps
    {
        public const string EmailVerification = "EMAIL_VERIFICATION";
        public const string PhoneVerification = "PHONE_VERIFICATION";
        public const string BusinessInfo = "BUSINESS_INFO";
        public const string PaymentSetup = "PAYMENT_SETUP";
        public const string Complete = "COMPLETE";
    }

    public static class ErrorCodes
    {
        public const string InvalidEmail = "INVALID_EMAIL";
        public const string EmailExists = "EMAIL_EXISTS";
        public const string InvalidCode = "INVALID_CODE";
        public const string CodeExpired = "CODE_EXPIRED";
        public const string TooManyAttempts = "TOO_MANY_ATTEMPTS";
        public const string InvalidToken = "INVALID_TOKEN";
        public const string TokenExpired = "TOKEN_EXPIRED";
        public const string ResendTimeout = "RESEND_TIMEOUT";
    }

    public static class ValidationMessages
    {
        public const string EmailRequired = "Email adresi zorunludur";
        public const string InvalidEmailFormat = "Geçerli bir email adresi giriniz";
        public const string CodeRequired = "Doğrulama kodu zorunludur";
        public const string InvalidCodeFormat = "Doğrulama kodu 6 haneli olmalıdır";
        public const string TokenRequired = "Geçici token zorunludur";
    }
}
