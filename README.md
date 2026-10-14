# Multi-tenant Commerce Platform

Keycloak, .NET, Angular ve Flutter ile çok kiracılı bir e-ticaret platformu. Bu monorepo; mağaza motoru, mağaza yönetimi, SaaS yönetim katmanı ve bulut kurulum araçlarının ilişkisini görünür kılan bir **yerel demo sürümüdür**.

İki örnek mağaza, ayrı MongoDB veritabanları ve ayrı Keycloak istemcileri kullanır. Gizli bilgiler kurulum sırasında üretilir. Azure, Google Cloud, Firebase veya ödeme hesabı olmadan web demosu çalıştırılabilir.

> Bu sürüm geliştirme ve inceleme içindir. SaaS ekranı, iki sabit mağazaya eşlik eden bir önizlemedir; yeni işletme kaydı, ödeme, bulut kaynağı oluşturma ve mağaza yayını kapalıdır. Üretim dağıtımı değildir. [Doğrulama durumu](docs/VALIDATION.md) ve [yayın yol haritası](docs/ROADMAP.md) gerçek sınırları açıklar.

## Hızlı başlangıç

Gerekenler:

- macOS veya Linux; Windows için WSL2. İlk doğrulama macOS üzerinde yapıldı.
- Çalışan Docker ve Docker Compose v2.
- **.NET 8 ve .NET 9 SDK** birlikte. Commerce .NET 8, SaaS .NET 9 kullanır.
- Node.js **22 LTS**, npm ve Python **3.10+**.
- İlk kurulum için internet, en az 10 GB boş disk alanı; Android araçları/derlemesi için ayrıca en az 15 GB önerilir.
- Boş portlar: `18080`, `18081`, `18082`, `18083`, `18090`, `27028`, `15439`, `16389`.

Depoyu edindikten sonra kök klasörde:

```sh
python3 scripts/demo.py check
python3 scripts/demo.py up
python3 scripts/demo.py smoke
```

`up`, yerel ayarları ve rastgele parolaları üretir; MongoDB, PostgreSQL, Redis ve Keycloak'ı başlatır; uygulamaları derler; iki örnek mağazayı kurar; Keycloak istemcilerini yapılandırır ve servisleri başlatır. İlk çalıştırma paket indirmeleri nedeniyle uzayabilir. Sonraki çalıştırmalarda aynı veriler ve parolalar korunur. Hata ayrıntıları `.local/logs/` altındadır.

| Bileşen | Adres | Kullanıcı |
| --- | --- | --- |
| Demo Coffee | http://demo-a.localhost:18090 | Ziyaretçi |
| Demo Books | http://demo-b.localhost:18090 | Ziyaretçi |
| Coffee yönetimi | http://demo-a.localhost:18083/Admin | `demo-a@example.test` |
| Books yönetimi | http://demo-b.localhost:18083/Admin | `demo-b@example.test` |
| SaaS önizleme | http://localhost:18081 | Giriş için `demo-owner` |
| SaaS Keycloak girişi | http://localhost:18081/api/Auth/login?returnUrl=/ | `demo-owner` |
| Keycloak yönetimi | http://localhost:18080/admin | `demo-admin` |
| SaaS API belgesi | http://localhost:18081/api | Demo sınırlamaları geçerlidir |

Parolalar yalnızca makinenizdeki **`.local/credentials.json`** dosyasındadır:

- `store_admin`: iki örnek mağazanın yönetici parolası.
- `saas_user`: `demo-owner` kullanıcısının parolası.
- `keycloak_admin`: Keycloak yöneticisinin parolası.
- `postgres`: yerel SaaS veritabanı parolası.

`.localhost` adları tarayıcıda çözülmüyorsa hosts dosyanıza `127.0.0.1 demo-a.localhost demo-b.localhost` ekleyin. `localhost:18090` adresi ilk mağazaya gider.

### Durdurma ve tekrar başlatma

```sh
python3 scripts/demo.py stop
# Önceden derlenmiş sürümü aynı verilerle aç:
python3 scripts/demo.py infra
python3 scripts/demo.py start
```

Kaynak kodu değiştirdiğinizde `up` tekrar derler. Tek bileşen derlemesi için `python3 scripts/demo.py build --component commerce` kullanabilirsiniz (`admin`, `installer`, `saas` da desteklenir). Çalışan süreçleri yeniden başlatmadan yeni derleme etkinleşmez.

Tamamen temiz başlangıç, **yalnızca bu demoya ait tüm verileri siler**:

```sh
python3 scripts/demo.py stop
docker compose --env-file .local/compose.env down --volumes
# .local klasörünü silin; ardından up komutunu yeniden çalıştırın.
```

Veri birimlerini saklayıp `.local/credentials.json` veya anahtarları silmeyin: Keycloak ve PostgreSQL eski parolaları kullanmaya devam eder; tenant claim şifrelemesi de eski anahtarlara bağlıdır.

## Denenecek akış

1. İki mağazayı açın. Coffee mağazasında kahve/kupa, Books mağazasında kitap/kırtasiye ürünleri vardır.
2. Bir ürünün ayrıntısını ve sepet akışını inceleyin.
3. İlgili mağazanın `/Admin` adresinden giriş yapıp ürünleri yönetin.
4. Keycloak'ta `commerce-demo` realm'ini ve ayrı `demo-a` / `demo-b` istemcilerini inceleyin.
5. `smoke` kontrolüyle yanlış tenant token'ının ve değiştirilmiş imzanın reddedildiğini doğrulayın.

Mağaza yöneticisi bu profilde GrandNode parola doğrulamasını kullanır. SaaS girişi Keycloak OIDC kullanır. Üretimdeki Keycloak grup tabanlı mağaza yönetim eklentisinin tüm davranışları bu yerel profile taşınmış değildir.

## Mobil demo

Aktif uygulama `Platforms/store_user_app`, Flutter **3.44.6** ile ARM64 Android APK olarak derlendi. Android emülatörde katalog, ürün ayrıntısı ve sepete ekleme doğrulandı. [Mobil çalıştırma adımları ve doğrulama kapsamı](docs/MOBILE.md).

## Kodun organizasyonu

| Klasör | Sorumluluk |
| --- | --- |
| `Ecommerce/` | GrandNode tabanlı ticaret motoru, çok kiracılı storefront/API, yönetim paneli ve kurucu |
| `SaasManager/` | .NET 9 SaaS API, PostgreSQL modeli, Angular arayüz |
| `TenantManager/` | Bulut tenant hazırlama, dağıtım ve mobil derleme işçileri; demoda başlatılmaz |
| `Platforms/` | Flutter uygulaması ve yerel modüller |
| `cloudflare_image_resizing_worker/` | İsteğe bağlı görsel işleme işçisi |
| `scripts/` | Yerel kurulum, sunucu taraflı token ağ geçidi ve smoke kontrolü |
| `docs/` | Mimari, güvenlik temizliği, doğrulama ve yayın aşamaları |

[Architecture / English overview](docs/ARCHITECTURE.md) · [Security](SECURITY.md) · [Third-party notices](THIRD_PARTY_NOTICES.md)

## CodeGraph

CodeGraph isteğe bağlıdır; demo için gerekmez. Bu çalışma kopyasında indeks etkinleştirildi. Yeni klonda kullanmak isteyenler CodeGraph kurulumundan sonra kökte `codegraph init`, ardından `codegraph explore "TenantSecretService RequestValidationMiddleware"` çalıştırabilir. `.codegraph/` yerel kalır ve Git'e girmez. `AGENTS.md` kaynak keşfinde önce bu indeksi kullanmayı tarif eder.

## Lisans ve yayın durumu

GrandNode çekirdeğinin GPLv3 lisansı `Ecommerce/LICENSE` altında korunur. Üçüncü taraf dosyaların lisansları kendi konumlarında geçerlidir. Henüz lisansı kesinleştirilmemiş modül ve varlıklar [lisans envanterinde](THIRD_PARTY_NOTICES.md) işaretlidir; tamamı için farklı bir lisans varsayılmamalıdır. Bu sürüm private GitHub incelemesi için hazırlanmıştır; herkese açık yayın izni henüz tamamlanmamıştır. [Ayrıntılı lisans ve varlık incelemesi](docs/LICENSE_REVIEW.md) kalan kararları listeler.
