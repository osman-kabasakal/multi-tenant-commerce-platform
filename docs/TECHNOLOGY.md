# Projeler, teknolojiler ve tercihlerin bedelleri

Bu tablo mevcut kaynakların rolünü açıklar. “Gerekçe”, koddan görülen kullanımın teknik açıklamasıdır; bütün alternatifler için ölçülmüş karşılaştırma veya teknoloji seçiminin her projeye uygun olduğu iddiası değildir. Sürümler 18 Ekim 2026 hazırlık girdileridir; SDK güvenlik/destek yükseltmesi [yol haritasında](ROADMAP.md) ayrıca izlenir.

## Uygulamalar

| Alan / kaynak | Kullanılan teknoloji | Neden ve nasıl kullanılıyor? | Bedeli / dikkat noktası |
| --- | --- | --- | --- |
| [Ecommerce](../Ecommerce) | C#/.NET 8, ASP.NET Core, GrandNode | Hazır katalog, müşteri, sepet, sipariş ve eklenti altyapısı üzerine tenant katmanı eklemek; aynı modülleri role özgü hostlarda kullanmak | GrandNode davranış/lisansını korumak, fork yükseltmeleri ve eski bağımlılıkları izlemek gerekir |
| [Ecommerce eklentileri](../Ecommerce/src/Plugins) / [admin eklentileri](../Ecommerce/src/AdminPlugins) | MSBuild `BuildType`, ayrı plugin çıktıları | Role göre frontend/admin/installer çıktısı; descriptor, DLL ve assetlerin doğru dizinde yüklenmesi | `BaseDir` yanlışsa build yeşilken runtime eklenti yüklenmeyebilir; çıktı envanteri şart |
| [SaaS Domain/Application](../SaasManager/src) | C#/.NET 9, katmanlı model ve uygulama istekleri | İşletme/abonelik/kurulum komutlarını web/controller ayrıntısından ayırmak | Katmanlar dağıtık transaction sağlamaz; sahiplik ve uzlaşma açık olmalıdır |
| [SaaS Infrastructure](../SaasManager/src/Infrastructure/DependencyInjection.cs) | EF Core 9 + Npgsql 9 | İlişkisel işletme modelini, mapping/değişiklik takibi ve transactionları `ApplicationDbContext` ile yönetmek | Şema sahibi/runtime hesabı ayrılmalı; EF kullanımı kuyruk/secret SQL'ini ortadan kaldırmaz |
| [Portal](../SaasManager/src/Web/ClientApp/package.json) | Angular 18.2, NgRx 18.1, RxJS 7.8, Tailwind 3.4 | Sahip oturumu, işletme durumu, domain ve derleme ekranlarında API durumu ve etkileşimleri yönetmek | İstemcide durum göstermek API yetkilendirmesinin yerine geçmez; sürüm yükseltme borcu vardır |
| [TenantManager](../TenantManager/Provisioning) | .NET worker, child process | Kalıcı işi sahiplenip plugin/installer kaynaklarını izole süreçte tenant bağlamıyla çalıştırmak | Process oluşturma, log sınırları, lease kaybı ve doğru build türü yönetilir |
| [Mobil istemci](../Platforms/store_user_app) | Flutter 3.44.6, Dart; Riverpod/Hooks, Dio, AutoRoute, get_it/injectable | Ortak Android/iOS kodundan tenant API, auth, sepet ve bildirim navigasyonu; generated API/model ve DI kodu | Gerçek API sözleşmesi ve native imzalama ayrı doğrulanır; ekran kaynakları yazara aittir; ikon/font bildirimleri ayrıca korunur |
| [nb_utils](../Platforms/modules/nb_utils) | MIT Dart yardımcıları; yerel değişiklikler | Mevcut extension/widget API'lerini uygulamada kullanmak | Paket açık lisanslıdır; paketle yan yana gelen ücretli tema dosyaları otomatik olarak MIT olmaz |
| [Device integrity modülü](../Platforms/modules/flutter_jailbreak_detection) | Flutter method channel, RootBeer, IOSSecuritySuite | Native root/jailbreak ve platform bilgilerini Dart'a taşımak | Best-effort sinyal; sunucuda kimlik doğrulama veya Play Integrity/App Attest yerine geçmez. iOS bağımlılığı BSD sürümüne sabitlenmiştir |

## Veri, kimlik ve işler

| Alan / kaynak | Teknoloji | Kullanım gerekçesi ve mekanizma | Sınır |
| --- | --- | --- | --- |
| Tenant ticaret verisi | MongoDB 8.0 | GrandNode belge modelini korumak; tenant başına DB ve sınırlı kullanıcı | Aynı Mongo sunucusunun kaynakları paylaşılır; cluster başına fiziksel izolasyon değildir |
| [İş kuyruğu](../Shared/Platform.Provisioning/PostgresProvisioningQueue.cs) | PostgreSQL 16 + Npgsql açık SQL | Claim, heartbeat, fencing ve checkpointleri kısa atomik işlemlerde görünür tutmak | Bir dış API çağrısıyla Postgres transactionı birleşmez; sağlayıcı adımı yeniden denemeye dayanmalıdır |
| [Secret deposu](../Shared/Platform.Security/PostgresSecretStore.cs) | PostgreSQL + Npgsql | Çok süreçte aynı tenant secretlarını yetkili kimlikle okuyabilmek; şifreli kayıt ve dar yetki | DB erişim/grant tasarımı ve master key yönetimi işletim sorumluluğudur |
| [Şifreleme DI](../Shared/Platform.Security/DependencyInjection.cs) | Local/Portable AES-GCM ve Azure adaptörü | Tüketiciyi sağlayıcıdan ayırmak; bulutsuz demo ile mevcut Azure seçeneğini aynı sözleşmede tutmak | Portable, Local zarfını kullanır. Eski ciphertext/anahtar için otomatik göç yok |
| [Kimlik/gateway](GATEWAY.md) | Keycloak 26.8, OIDC/JWT, üretim gateway; yerelde Python proxy | Sahip kullanıcı oturumu ile sunucular arası tenant client credentials ayrımı; tokenın doğrulanması | Client secret mobilde tutulmaz. Servis tokenı müşteri hesabı veya cihaz attestation'ı değildir |
| [Dağıtık olaylar](DISTRIBUTED_NOTIFICATIONS.md) | Redis 7.4 | Admin, storefront ve task processleri arasında notification/cache invalidation olaylarını paylaşmak | Pub/Sub kalıcı teslim kuyruğu değildir; iş durumu Postgres'ten uzlaştırılır |
| [DB bootstrap](DATABASE_BOOTSTRAP.md) | Ayrı owner aracı ve runtime grantleri | Şema oluşturan kimlik ile günlük uygulama kimliğini ayırmak | Yeni şema güncel owner aracıyla uygulanmalı; eski image'dan araç çalıştırmak sürüm uyumsuzluğu yaratabilir |

## Dış servis ve dağıtım araçları

| Alan | Kullanılan teknoloji | Neden / nasıl? | Bedeli |
| --- | --- | --- | --- |
| [Linux kurulum](LINUX_PRODUCTION.md) | Docker/Compose, çok aşamalı imajlar, Python operatör aracı | SDK'ları build katmanında tutmak ve tek sunucuda tekrarlanabilir servis paketi | Disk/cache/artifact büyümesi yönetilmeli; Compose HA orchestrator değildir |
| [Oracle altyapısı](ORACLE_DEPLOYMENT.md) | OCI Terraform/Resource Manager, SSH | Her kullanıcının kendi hesabında altyapı; GitHub Actions kotasına bağlı olmayan yerelden dağıtım | Kapasite/kredi değişkendir; VM stop, volume ve diğer kaynakları silmez |
| [İsteğe bağlı görsel işçisi](../cloudflare_image_resizing_worker/famizyo-image-resizing-worker) | TypeScript, Cloudflare Workers, Wrangler/Vitest, Images dönüşümü | Boyut/kalite/format sorgularını edge image seçeneklerine aktaran bağımsız örnek | Local demo başlatmaz; commerce.test örneği üretim doğrulaması değildir; [upstream atıf](../cloudflare_image_resizing_worker/famizyo-image-resizing-worker/NOTICE.md) korunur |
| [Domain](TENANT_DOMAINS_AND_MOBILE_IDENTITIES.md) | Cloudflare API, DNS TXT, HTTPS doğrulama | API erişimi + sahiplik + benzersiz tahsis + çakışma kuralını ayırmak | API erişimi portal kullanıcısının sahipliği değildir; geri alma ve cache süreleri vardır |
| [Google/Firebase](GOOGLE_FIREBASE.md) | Resource Manager ve Firebase yönetim API'leri | Tenant projesi/app kayıtları, gerçek sertifika fingerprint ve dağıtım | Org/folder yetkisi, kota ve billing politikası ayrı; geniş provisioner uygulamada kullanılmaz |
| [Android builder](../scripts/mobile_android.py) | Linux, Flutter, Gradle, apksigner | Paket başına keystore, flavor/native marka hazırlığı ve bağımsız APK doğrulama | İmzalama girdileri saklanmalı; emülatör/gerçek cihaz kabulü farklıdır |
| [iOS builder](../scripts/mobile_ios.py) | Mac, Xcode/codesign, Ruby hazırlığı | Native flavor, profile, takım, entitlement, archive/IPA ve sembol doğrulama | Linux'ta üretilemez; Mac/keychain/Apple sözleşmeleri ve cihaz profili gerekir |
| [Mobil teslim](MOBILE_BRANDING.md) | Firebase App Distribution + SHA-256 makbuzları | Üretilen ve servisten indirilen dosyanın eşitliğini doğrulamak | App Store/Play yayın onayı veya uygulama davranış testi değildir |
| [Push](MOBILE_NOTIFICATIONS.md) | Android FCM, iOS doğrudan APNs | Android tokenı ve iOS native APNs tokenını ayrı taşıma kanallarında kullanmak | APNs topic/team/ortamı aktif paketle eşleşmeli; anahtarların amacı karıştırılmamalı |
| E-posta | SMTP + bağımsız hazır-bildirimi akışı | Hesap doğrulaması ve tenant hazır iletilerini gerçek sağlayıcıyla göndermek | Kimlik e-postası ile hazır e-postası aynı başarı ölçütü değildir |
| [CI](../.github/workflows/verify.yml) | GitHub Actions; aynı kontrolleri çağıran yerel scriptler | Temiz kaynak, unit/integration, web ve mobil sınırlarını ayrı katmanlarda denetlemek | Bu aşamada uzak koşu yok; önceki kota engeli nedeniyle yerel doğrulama kullanıldı. Tarihli sonuçlar yeni commit için yeşil sayılmaz |
| [CodeGraph](../AGENTS.md) | İsteğe bağlı yerel kaynak indeksi | Sembol ve çağrı yollarını incelemek | İndeks private kalır; derleme bağımlılığı değildir |

## Kaynak lisansı ile servis lisansı ayrı değerlendirilir

Kök GPL-3.0-only seçimi, Docker'dan indirilen MongoDB/Redis veya bulut hizmetlerinin lisansını değiştirmez. Bu servislerin imajları repoya gömülmez. Kullanılan sürümün lisansı ve dağıtım biçimi ayrıca değerlendirilmelidir; bütün stack için “MIT/permissive” etiketi kullanılmaz. Varlık incelemesi, resolved bağımlılıkların tamamını kapsayan SBOM veya binary dağıtım onayı değildir. [Lisans kapsamı](../LICENSING.md), [hak incelemesi](LICENSE_REVIEW.md).

Eski TenantManager kaynaklarında Redis/Hangfire ve Azure yardımcıları da bulunur. Bunlar Portable headless worker'ın varsayılan yürütme yolu değildir. Hangfire'ın genel olarak kalıcı olamadığı iddia edilmez; burada tenant planı, fencing/checkpoint ve imzalı teslim makbuzları ayrı açık sözleşmelerle yürütülür.
