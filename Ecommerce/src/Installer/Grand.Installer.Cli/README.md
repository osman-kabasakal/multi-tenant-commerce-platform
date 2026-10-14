# Grand.Installer.Cli

Bu proje, GrandNode e-ticaret platformunun çok kiracılı (multi-tenant) kurulumunu otomatikleştirmek için kullanılır.

## API Secret Yönetimi

Sistem, her kiracı (tenant) için aşağıdaki API secretlerini otomatik olarak oluşturur ve Azure Key Vault'a kaydeder:

1. **FrontendAPI-Secret-{tenantId}**: Müşteri tarafı API istekleri için kullanılan JWT token imzalama anahtarı
2. **BackendAPI-Secret-{tenantId}**: Admin/Yönetici tarafı API istekleri için kullanılan JWT token imzalama anahtarı

### Secret Oluşturma Süreci

Mağaza kurulumu tamamlandıktan sonra, program:

1. Her API için 32 karakter uzunluğunda güçlü ve benzersiz secretler oluşturur
2. Bu secretleri Azure Key Vault'a kaydeder
3. İşlem başarı veya hata durumunu loglara kaydeder

### Güvenlik Önlemleri

- Secretler sadece Azure Key Vault'ta saklanır, veritabanında saklanmaz
- Secret erişimi TenantSecretService üzerinden yapılır ve önbelleğe alınır
- DefaultAzureCredential kullanılarak Azure Key Vault'a güvenli erişim sağlanır
- Secret oluşturmada güçlü rastgeleleştirme (randomization) ve karakter çeşitliliği kullanılır

### Hata Durumları

Secret oluşturma veya kaydetme sırasında hata oluşursa:
- Hata loglara kaydedilir
- Mağaza kurulumu devam eder (kritik olmayan hata)
- Bu durumda, sistem varsayılan secretleri kullanmaya devam eder

### Bağımlılıklar

- Azure.Identity
- Azure.Security.KeyVault.Secrets
- Grand.Infrastructure.MultiTenant.TenantSecretService