# Doğrulama kaydı — 2026-10-14

macOS kontrolleri aşağıda kayıtlıdır. [Private GitHub CI](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/workflows/verify.yml) temiz Ubuntu 24.04 üzerinde kaynak koruması, web kurulumu/smoke ve Android debug derlemesi çalıştırır. İlk koşuda Linux dosya sahipliği nedeniyle Keycloak realm içe aktarması başarısız oldu; hosttaki 0600 dosya artık doğrudan bağlanmak yerine yalnızca bu demoya ait Docker veri birimine, Keycloak kullanıcısına ait 0600 dosya olarak aktarılıyor. İlk Android CI koşusu APK çıktı aşamasında disk yetersizliğiyle durdu; yalnızca geçici GitHub Android makinesindeki kullanılmayan araçlar temizlenir ve derlemeden önce 20 GiB boş alan aranır. Temiz Linux web koşusu 2/2 şifreleme testi ve 25/25 smoke kontrolüyle geçti. Android CI için ayrıca 4 GiB Gradle heap, 1 GiB metaspace ve iki işçi sınırı uygulanır; bellek/disk kullanımı derleme günlüğüne yazılır. Güncel tam CI sonucu bağlantıdan takip edilir.

| Kontrol | Sonuç |
| --- | --- |
| Commerce, admin, installer ve SaaS Release publish | Başarılı; mevcut nullable/dependency uyarıları var |
| Angular demo derlemesi | Başarılı |
| `demo.py up` | Başarılı; MongoDB, PostgreSQL, Redis ve Keycloak sağlıklı; iki tenant aynı verilerle yeniden başlatıldı |
| `demo.py smoke` | **25/25 başarılı** |
| İki mağazanın HTTP kataloğu ve ürün ayrıntısı | 200; her mağaza yalnızca kendi ürünlerini gösterdi |
| Keycloak mağaza token'ları | Geçerli token kabul edildi; eksik, imzası değiştirilmiş ve farklı tenant token'ları reddedildi |
| Bilinmeyen mağaza adresleri | Gateway ve yönetim sunucusu reddetti |
| Yönetici girişleri — tarayıcı | Her iki hesapla giriş ve ürün listesi başarılı; Coffee oturumu Books yönetimine giriş sağlamadı |
| Web sepeti — tarayıcı | Coffee: Demo Espresso, 1 adet, $10.00; aynı tarayıcıda Books sepeti boş |
| SaaS OIDC — tarayıcı | Keycloak ile giriş başarılı; `sessionInfo` gerçek Demo Owner oturumunu döndürdü |
| SaaS korumaları | Anonim sessionInfo reddedildi; sahte callback oturum açmadı; bulut/ödeme mutasyonları kapalı |
| Yerel profil ortam sınırı | Commerce ve SaaS, Production ortamında LocalDemo kullanımını reddetti |
| Yerel şifreleme testleri | 2/2 başarılı: tenant değiştirme/tahrifat reddi ve eşzamanlı anahtar oluşturma |
| Flutter statik analiz | 0 error; 2.587 mevcut warning/info |
| Flutter debug bundle ve Android APK | Başarılı; Flutter 3.44.6, ARM64, `demo` flavor |
| Android emülatör — API 36 ARM64 | Uygulama kuruldu ve açıldı; örnek ürünler, ürün ayrıntısı, sepete ekleme ve $10.00 sepet özeti doğrulandı |
| Mobil HTTP kontrolleri | Her iki tenant için misafir token'ı, ürün listesi ve sepet API'si başarılı |
| Gitleaks kaynak taraması | Takip edilen güncel kaynaklarda **0 bulgu**; tarama raporu değerleri maskeli |
| Git dosya koruması | Gizli/üretilmiş dosya sınıfları takip edilen kaynakta yok |
| Proje referansları | Takip edilen tüm doğrudan ProjectReference/Import hedefleri mevcut |
| Özgün kaynak depolar | HEAD, Git durumu ve 14.552 takip edilen dosyanın SHA-256 özeti başlangıçla aynı |

## Tekrar çalıştırma

Repo kökünde:

```sh
python3 scripts/demo.py up
python3 scripts/demo.py smoke
dotnet test tests/LocalDemo.Tests/LocalDemo.Tests.csproj
```

Mobil komutlar [MOBILE.md](MOBILE.md) içindedir. Tarayıcı ve emülatör akışları elle doğrulandı; `smoke` bunların tüm görsel adımlarını otomatikleştirmez. Yerel ekran görüntüleri `output/playwright/` altında tutulur ve Git'e eklenmez.

Bu doğrulama sırasında düzeltilen başlıca sorunlar: HTTP demo oturum çerezleri, SaaS girişinde gereksiz offline erişim izni, mobil misafir oturumunun tenant'a özel token uç noktasını kullanması, Android ikon başvuruları ve metin/HTML hata yanıtlarının güvenli işlenmesi. Yerel mobil profil, yüklenmeyen slider eklentisini ve bildirim sorgularını atlar.

## Doğrulanmayan kapsam

- iOS, fiziksel cihaz dağıtımı, release imzası ve mağazalara yayın.
- Tam satın alma/ödeme, yeni işletme oluşturma, e-posta/bildirim teslimi ve buluta dağıtım.
- Uzun süreli mobil oturum yenileme ve tüm hesap/kayıt akışları.
- Üretim yükü, kapsamlı güvenlik denetimi ve bütün üçüncü taraf lisanslarının yayın izni.

Mevcut tüm test projeleri yeşil değildir: eski test altyapısında MongoDB `MessageEncoderSettings` erişimi ve `MemoryCacheBase` yapıcı imzası uyumsuzlukları var. Yeni yerel profil testleri ayrı projede gerçek uygulama koduna karşı çalışır. Android araç zinciri gelecekteki Flutter sürümleri için Gradle/AGP/Kotlin yükseltme uyarıları verir; bu kayıt yukarıdaki sabit sürümle yapılan derlemeyi kapsar.

İlk Android derlemesinde disk doldu. Kullanıcının onayıyla Docker yeniden başlatıldı; veri birimleri korundu ve web testleri tekrar geçti. Devam eden derlemelerde boş alan izlendi, yalnızca bu çalışma sırasında oluşturulan geçici dosyalar temizlendi. Yeni kurulumda README'deki disk alanı gereksinimlerini karşılayın.

## 2026-10-15 — ortak tenant güvenliği

- Yeni ortak kütüphane, SaaS Web, TenantManager, kurucu, commerce API ve yönetim uygulaması derlendi.
- Yerel/Azure sağlayıcı sözleşmeleri için 4 test; SaaS kayıt/işletme sahipliği/mesaj güvenliği için 3 test geçti. Azure testi SDK taklitleri ve gerçek yerel RSA/AES kullanır; canlı Key Vault bağlantısı kurulmadı.
- Bağımsız .NET süreçleri ve gerçek PostgreSQL üzerinde dağıtık secret kontrolleri geçti; 24 eşzamanlı sağlayıcı aynı tenant anahtarını korudu.
- `demo.py up` ve 25/25 smoke kontrolü yeni ortak depo ile geçti.
- Bu değişikliğin GitHub CI koşusu, Docker image derlemeleri, canlı Azure/Google işlemleri ve mobil yayınlama çalıştırılmadı.
- [Kurulum, yapılandırma ve geçiş sınırları](TENANT_SECURITY.md).

## Durable onboarding foundation (2026-10-16)

- `Shared/Platform.Provisioning` and SaaS Web Release builds passed. Existing inherited SaaS compiler warnings remain.
- Five registration/security tests passed, including the durable queue branch without Atlas/Redis calls and owner-only job status/retry access.
- Twenty-one real-PostgreSQL provisioning checks passed against an isolated disposable database, including independent-process reads, concurrent claims, lease recovery, stale-worker fencing and checkpoint-preserving retries.
- Full new-tenant enrollment, infrastructure adapters, cloud/mobile deployment and remote CI are still pending; this evidence does not establish end-to-end provisioning readiness.

- Five encryption/provider tests passed, including independent legacy ciphertext compatibility and explicit portable production selection. Real PostgreSQL checks confirm an existing encrypted store can be read without changing ciphertext. Commerce MultiTenant Release builds with the new environment bootstrap. Complete portable host startup remains pending.

- Publishable changed-source Gitleaks scan found no leaks; source filename guard and license/asset inventory checks passed (140 licensing inputs). No full demo bootstrap, new-tenant end-to-end run or live cloud deployment was performed in this foundation phase.


## Actual local trial onboarding (2026-10-16)

- Standard `demo.py up` built all five .NET components plus the Angular demo and started the headless TenantManager. Existing sample tenants remained functional after enabling Mongo authentication.
- A fresh HTTP/OIDC run created two new verified accounts and trial businesses: **50 onboarding checks passed**. This includes live storefronts, actual admin login, mobile customer tokens/catalogs, durable SaaS completion, cross-owner access denial, cross-tenant token/admin-cookie denial and Mongo read/write isolation. No cloud/payment provider was invoked.
- The original **25 demo smoke checks passed**. Six registration/security tests passed, including queue-outage replay without duplicate subscriptions or payments and denial outside Development.
- New-tenant Flutter debug bundle generation passed using generated public-only Dart defines. Dart analysis of `lib/core` reported 61 inherited warnings/info and no errors. No new emulator or signed release run was performed. Angular demo compilation passed.
- CI now includes the live two-business onboarding test, but the updated remote workflow has not yet been run. Portable production startup and all real cloud/mobile-distribution gates remain in [PROVISIONING.md](PROVISIONING.md).

## Optional Google/Firebase provider (2026-10-16)

- Eighteen HTTP contract/adapter tests passed against the real Google provisioning, encrypted-store adapter boundary, client publication, per-tenant FCM transport and App Distribution code. Cases include owned-resource replay, partial provider failure, async polling, IAM conditions/etag conflicts, billing mismatch, app pagination, client configuration ownership and a saved target change being refused before cloud writes. No ADC credentials were loaded by these tests.
- Five existing encryption/provider tests passed. Shared Google/adapters and the management tool built with no warnings/errors; TenantManager built with 187 existing warnings and no errors. The management tool's help command ran successfully.
- Default local onboarding registration still contains exactly five steps and does not register a Google credential provider. This was verified in the adapter test; no fresh full Docker/bootstrap/onboarding run was performed in this phase.
- Source filename guard passed for 12,815 files. Asset/license inventory passed with 144 licensing inputs. The changed-source Gitleaks scan found no leaks; whitespace checks passed.
- CI now includes the Google contract tests and management tool build; the updated remote workflow has not been run. No live Google project, real FCM device delivery, signed mobile upload, Crashlytics report or public deployment was verified. [Google setup and remaining gates](GOOGLE_FIREBASE.md).

## Tenant notification runtime and live consent (2026-10-16)

- Commerce and the actual tenant-admin send action now use the shared tenant sender. Fourteen notification tests passed, including independent tenant scopes, verified HTTP routing instead of an ambient tenant, missing/foreign config denial, per-token failures, private local captures, permission revocation, batching and safe errors. Eighteen Google provisioning/transport contracts also passed against the updated transport. No live Google credentials were loaded by these contract tests.
- A fresh real HTTP/OIDC run created two new businesses and passed **82 checks**: onboarding, actual storefront/admin notification sending, canonical tenant captures, opt-out, rejection of private credential uploads, owner/tenant isolation, mobile catalog tokens and Mongo database isolation. The original **25 demo smoke checks passed** afterwards. Test data remains in ignored local storage.
- The live probe exposed a null fallback binder on the storefront login page. MVC now continues to its normal providers when that binder does not handle the parameter type. Four production-source binding tests passed; actual tenant login forms loaded during the final notification smoke. This does not establish every customer login/checkout flow.
- Updated commerce, admin, installer and worker components published successfully. Existing compiler/dependency warnings remain. Flutter analysis of the changed FCM service found no errors, with two existing warnings and two existing info messages. No Firebase-enabled emulator/device or signed mobile release was run.
- Private credential fields were removed from notification settings; new submissions are rejected, existing legacy values are preserved, and settings no longer rewrite a shared browser service-worker file. Automatic browser push and the legacy Redis FCM cache-invalidation consumer remain outside the completed notification path.
- Source filename guard, asset/license inventory (147 inputs), changed-source Gitleaks (no leaks) and whitespace checks passed. Updated remote CI, real FCM/APNs delivery, automatic signed builds/Crashlytics and portable production deployment still require verification; see [NOTIFICATIONS.md](NOTIFICATIONS.md) and [PROVISIONING.md](PROVISIONING.md).

## Portable SaaS card and file providers (2026-10-16)

- Ten production-source tests passed for card envelopes without CVV, tenant ownership, tamper/master-key rejection, private filesystem safety and atomic writes, handler access checks, and Azure SDK CRUD through a test HTTP transport. No existing encryption engine, ciphertext or key was migrated.
- SaaS Web Release build passed with inherited compiler warnings. The provider tests are included in CI using the SaaS .NET 9 SDK selection.
- Live file HTTP flows, payments, legacy card decryption, real Azure resources, complete production startup and the updated remote CI have not been verified for this change. [Provider selection and compatibility limits](SAAS_PROVIDERS.md).

## Commit preparation verification (2026-10-16)

- Re-ran 57 tests: Google contracts 18, notification routing/consent 14, model binding 4, portable SaaS providers 10, registration security 6 and encryption 5. All passed. SaaS Web and the Firebase management tool built successfully; SaaS retained compiler warnings.
- The staged changed-source Gitleaks scan found no leaks. The tracked-source filename guard passed for 12,836 paths; the asset/license inventory passed with 148 inputs. Whitespace checks passed. No Docker services or cloud resources were started for these commit checks; remote CI was not run.
