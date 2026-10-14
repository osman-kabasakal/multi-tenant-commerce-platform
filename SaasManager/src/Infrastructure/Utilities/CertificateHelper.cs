using System.Security.Cryptography.X509Certificates;

namespace SaasManager.Infrastructure.Utilities;

public static class CertificateHelper
{
    public static X509Certificate2? LoadCertificateFromBase64(string base64String, string? password = null)
    {
        try
        {
            byte[] certBytes = Convert.FromBase64String(base64String);
            if (!string.IsNullOrEmpty(password))
            {
                return X509CertificateLoader.LoadPkcs12(certBytes, password, X509KeyStorageFlags.MachineKeySet | 
                                                                               X509KeyStorageFlags.PersistKeySet | 
                                                                               X509KeyStorageFlags.Exportable);
            }
            return X509CertificateLoader.LoadPkcs12(certBytes,password);
        }
        catch (Exception)
        {
            return null;
        }
    }
    
    public static X509Certificate2? LoadCertificateFromFile(string certPath, string keyPath)
    {
        try
        {
            var publicCert=X509CertificateLoader.LoadCertificate(File.ReadAllBytes(certPath));
            var privateKeyFlags = X509KeyStorageFlags.MachineKeySet |
                                  X509KeyStorageFlags.PersistKeySet |
                                  X509KeyStorageFlags.Exportable;
            var privateCert=X509CertificateLoader.LoadPkcs12(File.ReadAllBytes(keyPath),String.Empty,privateKeyFlags);
            var pfxCert=publicCert.CopyWithPrivateKey(privateCert.GetRSAPrivateKey()!);
            return pfxCert;
        }
        catch (Exception)
        {
            return null;
        }
    }
}
