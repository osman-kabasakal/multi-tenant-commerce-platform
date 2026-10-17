# İşletme alan adı ve sürümlü mobil kimlikler

Bu akış yalnızca Portable Production/Staging kurulumunda kullanılır. Yerel demo bulut DNS işlemi yapmaz. Platformun portal/kimlik ve wildcard alan adları kullanılmaya devam eder; işletme kendi mağaza ve yönetim adresini ayrıca seçebilir.

**Kabul durumu:** sahiplik, tek işletmeye atama, alan adı kuyruğu, paket başına imza, bildirim hedefi ve portal kontrolleri yerelde doğrulanmıştır. Canlı ortamda özel alan adının gerçek genel TLS bağlantısı, mağaza/yönetim erişimi ve yeni paketin gerçek imzalı Android teslimi doğrulandı. Android APK sertifikasının SHA-1 ve SHA-256 değerleri Firebase kayıtlarıyla eşleşti; aynı projedeki eski uygulamalar korundu. Gerçek imzalı iOS teslimi ve sembol yükleme tamamlandı; iki gerçek makbuzdan sonra yeni kimliğin aktif olduğu ve eski kimliğin geçmişte korunduğu gözlendi. Uygulama fiziksel iPhone’a kuruldu ve kullanıcı mağaza içeriğini gördüğünü doğruladı. Sonrasında bildirilen menü, logo ve kayıt ekranı sorunları ayrı izleniyor; tüm uygulama akışı veya APNs teslimi kabul edilmiş sayılmıyor. [Canlı kapsam ve kaynak sürümleri](validation/tenant-domains-mobile-identities-live-20261017.json), [tüm doğrulamalar](VALIDATION.md).

**Markalama kapsamı:** yeni Portable builder `tenant` flavor’ını, uygulama adı, paket/bundle ve Firebase bağlarını hazırlar. Legacy `BuildManagerClaude` içindeki `flutter_launcher_icons`, `flutter_native_splash` ve işletmeye özel AppIcon/LaunchScreen üretimi henüz bu akışa taşınmamıştır; bu aşamada ortak şablon varlıkları kullanılır. İmzalı derleme kabulü işletmeye özel markalama kabulü sayılmaz.

## İşletmecinin bir kez hazırlayacağı ayarlar

[Production girdisinin](../infra/production/deployment.example.json) diğer alanlarını koruyarak aşağıdaki bölümü ekleyin. IP ve dosya yolları örnektir:

```json
{
  "MobileApplicationIdPrefix": "com.yourcompany",
  "Providers": {
    "CustomDomains": {
      "Enabled": true,
      "AllowCloudWrites": true,
      "ApiTokenFile": "/absolute/private/cloudflare-token",
      "OriginIpv4": "YOUR_SERVER_PUBLIC_IPV4",
      "AcmeEmail": "operator@example.com"
    }
  }
}
```

- Cloudflare token'ı yalnız kullanılacak bölgelerde Zone Read, DNS Read ve DNS Edit erişimine sahip olmalıdır. Dosya normal dosya, mutlak yol ve Unix üzerinde `600` izinli olmalıdır. Sunucuda token yalnız provisioning worker'a bağlanır; portala veya mobil uygulamaya verilmez.
- Sunucunun genel HTTP 80 ve HTTPS 443 portları açık olmalıdır. Özel alan adlarında Caddy genel bir ACME sertifikası alır; platformun mevcut wildcard sertifikası ayrı kalır.
- `state/edge-tls` kalıcı sertifika verisidir. Bunu state, route dosyaları, veritabanı ve şifreleme anahtarıyla birlikte yedekleyin. Açık özel alan adı varken özelliği kapatmak veya bu dizini silmek reddedilir.
- Mobil kimlik değişimini açmak için `Providers:Mobile:Provider=AndroidIosAppDistribution`, Android araçları ve uyumlu Mac worker gerekir. Mac takım/sertifika/kaynak özeti Linux'taki `Providers:Mobile:Ios:Release` ile aynı olmalıdır. [Mac kurulumu](MOBILE.md#run-the-explicitly-configured-mac-consumer).
- Mevcut kurulumda yeni şemayı **owner bootstrap** uygular; uygulama/worker rolleri şema oluşturmaz. Yeni paket rezervasyonları ve kuyruk tabloları için üretilmiş runtime yetkilerini de güncelleyin. [Veritabanı bootstrap rehberi](DATABASE_BOOTSTRAP.md).

Alan adı alanı boş bırakılırsa yeni paket kökü `MobileApplicationIdPrefix` değerinden alınır. Normalleştirme Türkçe harfleri dönüştürür, uygun olmayan Unicode karakterlerini kodlar, sayı/Java anahtar sözcüğüyle başlayan parçaları düzeltir ve uzunluğu sınırlar. Aynı isim farklı işletmede kullanılmışsa işletme kimliğinden türetilen ek kullanılır. İlk kayıt ve sonraki kimlikler aynı PostgreSQL paket rezervasyonunu paylaşır; eski paket adları başka işletmeye verilmez.

Doğrulanmış özel alan adı seçildiğinde kök o alan adının ters DNS biçiminden üretilir. Örneğin `marka.com` ve `Çağrı Pet` için `com.marka.cagripet`; varsayılan kök `com.yourcompany` ise `com.yourcompany.cagripet`. Bir kez ayrılan değer veritabanında tutulur; çalışan uygulama adı değişince eski paket kendiliğinden yeniden hesaplanmaz.

## İlk işletme kaydında sıralı işlem

1. İşletme sahibi portalda hesap açar ve e-postasını doğrular.
2. İşletme kayıt ekranında isterse `marka.com` alan adını girer. Mağaza `https://marka.com`, yönetim `https://manage.marka.com/Admin` olur. URL, port veya yol girilmez.
3. **Alan adını kontrol et** seçilir. Worker aktif Cloudflare bölgesini, API erişimini, platform için ayrılmış bölgeleri ve DNS kayıtlarını kontrol eder. Bu aşama salt okunurdur; Cloudflare erişimi kullanıcı sahipliğinin kanıtı sayılmaz.
4. Portalda gösterilen `_commerce-verification.marka.com` TXT kaydı, gösterilen `commerce-v1=…` değeriyle alan adı sahibi tarafından eklenir. Platform bu kanıtı kendisi oluşturmaz. İlk doğrulama isteği 24 saat geçerlidir.
5. **TXT kaydını ekledim, doğrula** seçilir. Aynı bölge başka işletmeye atanmışsa işlem reddedilir. Bölge ataması PostgreSQL'de tek sahipli bir kayıtla korunur; aynı Cloudflare hesabında olmak başka işletmenin alan adını almayı sağlamaz.
6. Sahiplik doğrulandıktan sonra işletme bilgileri ve mağaza yönetimi parolası girilir, deneme başlatılır. Domain isteği sunucudaki doğrulanmış owner/tenant kaydına bağlanır. Sayfa yenileme aynı kaydı sürdürür.
7. İlk kurulum sırasıyla veritabanı, temel mağaza, eklentiler, migration'lar, eski işletme ayarları, Keycloak ve seçilmiş Google/Firebase işlemlerini tamamlar. Installer özel mağaza adresini de aynı sahiplik kaydından doğrular.
8. DNS kayıtları hazırlanır; mağaza ve yönetim yönlendirmeleri yayımlanır. DNS'nin doğru sunucuyu göstermesi, gerçek TLS ve doğru tenant/store yanıtları kontrol edilir. Başarılı doğrulamadan sonra alan adı ana adres olarak işaretlenir.
9. Seçilmiş mobil profilde paket/bundle kimlikleri aynı tenant'ın Firebase projesinde kaydedilir. Android'in gerçekten kullanılan imza sertifikasından SHA-1 ve SHA-256 eklenir; iOS uygulamasına açıkça seçilmiş Apple Team ID yazılır.
10. Birleşik profilde imzalı Android ve iOS sonuçları tamamlanır. Test sürümleri App Distribution'dan alınır. Gerçek cihazdaki kurulum, bildirim ve Crashlytics kabulü ayrıca yapılır.

Vergi, para birimi, eklentiler ve mobil adres alanlarının tam listesi [tenant kurulumu rehberindedir](TENANT_INITIALIZATION.md). Ayrıntılı ilk kurulum/kayıt adımları [yeni işletme rehberinde](YENI_ISLETME_EKLEME.md) bulunur.

## Mevcut işletmeye alan adı ekleme veya değiştirme

1. İşletme sahibi portalda **Alan adı ve uygulama** (`/dashboard/deployment`) sayfasını açar. Güncel mağaza/yönetim adresleri ve aktif mobil paket görünür.
2. Yeni alan adını aynı Cloudflare ve TXT sahiplik adımlarıyla doğrular. Geçerli deneme veya abonelik gerekir.
3. İsterse **Bu alan adına uygun yeni Android ve iOS uygulamaları da hazırlansın** seçimini açar. Bu seçim birleşik imzalama hizmeti yapılandırılmışsa sunulur. Kapalıysa alan adı değişir, mobil paket korunur.
4. **Doğrulanan alan adını etkinleştir** seçilir. İş, ilk kayıt işini değiştiren veya yeniden kuran bir işlem değildir; ayrı `domain_activation_jobs` kuyruğuna girer.
5. Worker `dns → https → store-address → primary` adımlarını tamamlar. `store-address` yalnız GrandNode mağaza URL/SSL/domain bilgilerini `IStoreService.UpdateStore` üzerinden günceller; vergi, para birimi, eklenti, ürün veya müşteri ayarlarını yeniden kurmaz. Cache invalidation ve store olayları mevcut servis yolundan geçer.
6. Eski mağaza/yönetim adresleri erişilebilir alias olarak kalır. Önceki mobil uygulamaların kayıtlı API adresi böylece geçiş sırasında kullanılmaya devam eder. Yeni ana adres tek kayıttır; başka bir geçişin ana adresini eski iş geri çeviremez.
7. Mobil değişiklik seçilmişse ayrı mobil kimlik işi açılır. Sayfa Android/iOS hazırlığını ayrı gösterir. **İki platformun eşleşen imzalı sonucu gelmeden aktif paket değişmez.** Mac kapalıysa mevcut uygulama kullanılmaya devam eder.

DNS değişikliği, alan adı geçişi başladığında önceki sunucunun yönlendirmesini değiştirir. Web ana adresi, doğrulanan HTTPS sonrasında güncellenir. Mobil kimlik geçişi bundan ayrı tamamlanır. Yeni paket, telefonda ayrı bir uygulamadır; eski paketin mağaza güncellemesi sayılmaz. Bu akış Google Play/App Store yayını veya mağaza incelemesi yapmaz.

## Güncel A kaydı ve çakışma kuralı

| Mevcut durum | Sonuç |
| --- | --- |
| Mağaza/yönetim adresinde A/AAAA/CNAME yok | Doğrulanan işletme için A kaydı oluşturulur |
| Tek A kaydı başka bir IPv4 sunucusunu gösteriyor; kayıt platform/tenant işareti taşımıyor | Sahiplik ve tek işletme ataması sonrası eski kayıt saklanır, aynı kayıt platform sunucusuna taşınır |
| A kaydı zaten platform IPv4 adresini gösteriyor, fakat bu işletmenin işaretini taşımıyor | Otomatik devralma reddedilir |
| Kayıt bu işletme ve deployment işaretini taşıyor, doğru IP ve DNS-only kullanıyor | Aynı kayıt korunur; tekrar deneme çoğaltmaz |
| Bölge başka işletmeye atanmış veya kayıt başka platform/tenant işareti taşıyor | Reddedilir |
| Çoklu adres kaydı, çakışan AAAA/CNAME veya yabancı wildcard var | Otomatik değişiklik durur; operatör kaydı incelemelidir |
| Ön kontrol/yedekten sonra kaynak DNS kaydı değişmiş | `DomainDnsChanged`; yeni kaynak otomatik benimsenmez |

Her iki hedef yazımdan önce kontrol edilir. MX, TXT ve diğer hedef adlarının kayıtları değiştirilmez. A kayıtları DNS-only (`proxied=false`) hazırlanır. Eski A kaydının ID, IPv4, TTL, proxy, comment/tag/settings bilgileri tenant'ın şifreli `domain-dns-before-v1-<domainRequestIdN>` kaydında tutulur. Başarısız/yarım geçişte operatör bu kaydı inceler; yalnız bu işin hâlen sahip olduğu kayıt için eski değeri Cloudflare'den geri yükleyebilir. Başka birinin sonradan yaptığı DNS değişikliği üzerine körlemesine geri dönüş yapılmaz. Otomatik rollback komutu bu akışta sunulmaz.

Cloudflare'nin [DNS güncelleme API'si](https://developers.cloudflare.com/api/resources/dns/subresources/records/methods/edit/) kullanılır; platform işlemi kaydı yeniden okuyarak doğrular. API'nin başka bir yöneticiyle atomik koşullu güncelleme garantisi varsayılmaz. Aktivasyon sırasında aynı DNS kaydını elle eşzamanlı değiştirmeyin.

## Paket başına imza ve aktif kimlik

`mobile_identity_versions` ilk uygulamayı geçmişiyle korur ve her yeni paket için ayrı hazırlık kaydı tutar. İlk `BusinessApp.PackageName` tarihsel ilk kayıttır; aktif mobil kimlik ortak registry'den seçilir.

| Kayıt | Görevi |
| --- | --- |
| `mobile_package_owners` | İlk kayıt ve sonraki kimlikler arasında global paket sahipliği |
| `mobile_identity_versions.request` | Paket/bundle, owner, tenant, deployment, kaynak domain ve önceki aktif kimlik |
| `prepared` | Aynı Firebase proje/uygulama ID'leri, secret referansları, Android kaynak/sertifika özeti ve Mac planı |
| `android_receipt`, `ios_receipt` | İmzalı ve dağıtılmış native sonucu bağlayan makbuzlar |
| `android-package-signing-v1-<packageSHA256>` | İlgili tenant/pakete ait şifreli keystore/sertifika |
| `firebase-mobile-identity-<versionIdN>` | Yeni uygulama çiftinin aynı projeye ait şifreli Firebase yapılandırması |

Yeni kimlik için Firebase projesi yeniden oluşturulmaz; aynı projeye yeni Android ve iOS uygulamaları eklenir. Eski Firebase uygulamaları ve sertifikalar silinmez. Eksik/bozuk bir hazırlanmış imza kaydı sessizce yeniden üretilmez. İlk eski paketin `android-release-signing-v1` anahtarı yalnız o paket için kullanılabilir.

Aktif kimlik, iki imzalı makbuz da hazırlık planına uyduğunda ve kaynak alan adı hâlâ ana adres olduğunda tek PostgreSQL işleminde değişir. Önceki kimlik `Retired` olur. Alan adı tekrar değişirse eski hedefe ait bekleyen hazırlıklar `Superseded` olur; aktif paket korunur.

Portalın **Yeni derleme** işlemi sıraya alındığı andaki aktif kimlik, Firebase/sertifika referansı ve mağaza adresini sabitler. Daha sonra aktif kimlik değişse de sıradaki iş başka pakete yönlendirilmez. Eski ve yeni APK kayıtları paketlerine ait imza ile doğrulanır; yalnız derlemeyi isteyen işletme bunları indirebilir.

## Eski ve yeni uygulamalara bildirim

Android uygulamaları aynı Firebase projesindeki FCM yolunu kullanır. iOS'ta eski uygulamaların `apns-v1` kaydı ilk bundle'a bağlı kalır. Sürümlü uygulamalar `apns-v2` cihaz kaydıyla yalnız kendi kimlik referansını taşır; istemciden serbest bundle adı alınmaz. Sunucu bu referansı aynı tenant'ın şifreli Firebase kaydından çözer, Apple takımını ve aynı Firebase projesini doğrular, her bundle için ayrı APNs bağlantısıyla gönderir. Yabancı veya eksik kimlik diğer tenant'a düşmez.

Ortak takım APNs anahtarı sunucuda kalır. İşletme başına ayrı APNs anahtarı veya Firebase Console'a anahtar yükleme gerekmez. Bu yönlendirme testleri gerçek cihaz teslimi kanıtının yerine geçmez.

## Manuel araçla doğru kimliği dışa aktarma

Portable worker/operator yapılandırmasıyla aktif kimliğin SDK dosyaları ve ona uygun `tenant.json` manifesti birlikte alınabilir. Çıktı için yeni, özel bir dizin kullanın:

```sh
dotnet run --project tools/Platform.Cloud -- export-mobile \
  --config /absolute/private/portable-worker.json \
  --tenant BUSINESS_GUID_IN_N_FORMAT \
  --output /absolute/private/mobile-export-new
```

`Provisioning:Profile=Portable` olan yapılandırmada registry'deki aktif kimlik seçilir. Belirli eski veya hazırlanmış bir kimliği incelemek için ayrıca `--identity VERSION_GUID_IN_D_FORMAT` verilebilir; başka tenant'ın kimliği seçilemez. Otomatik builder kendi sabitlenmiş planını kullanır. Elle dağıtım komutuna da aynı `--identity` seçimi verilebilir. İlk yayındaki eski manifesti yeni SDK dosyasıyla karıştırmayın; sürümlü işler için dışa aktarılan `tenant.json` kullanılmalıdır.

## İzleme ve müdahale

- Portalda domain ve kimlik geçmişi, ayrı Android/iOS durumu ve açık sertifika özetleri görünür. Token, keystore ve özel anahtar gösterilmez.
- Kuyruklar iki dakikalık yenilenen claim ve fencing token kullanır. Eski işçi sonuç yazamaz. Mac işleri yalnız eşleşen deployment/takım/sertifika/kaynak özetiyle alınır; tek Mac lane'i ardışık çalışır.
- DNS yayılımı beklemesi başarısız deneme sayısını tüketmez. Sağlayıcı/derleme hataları sınırlı sayıda denenir; sonra `Failed` ve güvenli hata kodu görünür. Sorun onarıldıktan sonra sahibi portalda yeniden deneyebilir; aynı plan ve mevcut artifact/sertifika korunur.
- Başlangıç mağazasının kurulum kuyruğu silinmez veya yeniden yazılmaz. Daha sonra alan adı ya da mobil kimlik değişimi için ilgili ayrı kuyruk kullanılır.
- Yeni domain, `TenantDomainRegistry → DomainActivationPipeline → ManagedTenantDomain`; yeni paket, `MobileIdentityRegistry → MobileIdentityPreparation → AndroidReleasePipeline / IosReleaseExecutor` yolunu izler. DI kayıtları `PortableOnboardingOptions.cs`, Mac giriş noktası `tools/Platform.Ios.Worker/Program.cs` içindedir.
- Aktif kimliği değiştirmek için SQL kısıtlarını kaldırmayın. Veri/anahtar kaybında tutarlı yedeği geri getirin; farklı sertifika veya kaynak seçmek mevcut hazırlanmış işi değiştirmez.

[GrandNode installer](TENANT_INITIALIZATION.md), [yedekleme](BACKUP_RESTORE.md), [Google/Firebase](GOOGLE_FIREBASE.md), [portal derlemeleri](PORTAL_APP_BUILDS.md) ve [SSH/Docker dağıtımı](ORACLE_SSH_DOCKER_DEPLOYMENT.md) ayrıntıları tamamlayıcıdır.


## Geçişte doğrulama ve tekrar deneme

Portalda TXT doğrulama isteği sunucu hatası veriyorsa operatör dar SaaS rolünün güncel runtime izinlerini kontrol etmelidir. Normal `production.py up` işlemi owner bootstrap sonrasında [aynı SQL kaynağını](../infra/production/runtime-security-grants.sql) uygular. `domain_requests.error_code` alanını temizleme yetkisi TXT tekrar kontrolü için gereklidir; bu yetki sahipliği `Verified` yapma veya challenge değiştirme yetkisi vermez. Uygulamaya owner/superuser hesabı vermeyin. [Gerçek üretim rolü regresyonu](../tests/Provisioning.Integration/ProductionPermissionsFixture.cs) aynı SQL dosyasını izole PostgreSQL'de uygular ve bu sınırları denetler.

DNS ve TLS hazır olduğu hâlde mağaza `x-store-token header is not valid for this request` döndürüyorsa yalnızca genel DNS sonucuna bakmak yeterli değildir. Commerce servisi `TenantRouting:CustomDomainsEnabled=true` ile aynı worker-owned `routes` dizinini **salt okunur** bağlamalıdır. Mağaza, özel host kaydındaki canonical slug ile JWT audience ve `sub_domainname` claim'ini doğrular; çözülen store ID de aynı host kaydına ait olmalıdır. İstemciden gelen `X-Platform-Tenant` başlığı sahiplik kanıtı değildir. Yönetim hostname'i mağaza rolü olarak kabul edilmez. Standart Production renderer bu ayar ve mount'u üretir.

Operatör hata nedenini giderdikten sonra portalda **Geçişi yeniden dene** seçilir. Aynı değiştirilemez plan ve tamamlanan aşamalar korunur; yeni domain isteği, yinelenen DNS kaydı veya ikinci Firebase projesi oluşturulmaz. `dns` aşamasının tamamlanması tek başına ana adresin değiştiği anlamına gelmez: gerçek HTTPS, tenant/store hazır olma yanıtı ve yönetim login yönlendirmesi de doğrulanır. Mobil aktif kimlik alanını elle değiştirmeyin; her iki imzalı native makbuz planla eşleştiğinde otomatik güncellenir.


## Installer tenant bağlamı ve bileşen güncellemesi

GrandNode cache ve store olayları HTTP isteği olmayan CLI içinde de seçili mağaza bağlamını gerektirir. Alan adı güncellemesi sahipliği doğrulanan **Store.Id** ile `ITenantIdentityAccessor` bağlamını kurar; platform tenant UUID'si cache öneki yerine kullanılmaz. İşlem mevcut başka işletme bağlamını reddeder, aynı mağaza bağlamını korur ve kendisinin kurduğu bağlamı hata durumunda da temizler. `StoreService.UpdateStore` üzerinden normal cache invalidation ve store olayları çalışmaya devam eder. Bu sınır [gerçek AsyncLocal kullanan testlerle](../tests/LocalDemo.Tests/ManagedTenantDomainContextTests.cs) denetlenir.

Yeni kurulum ve genel uygulama değişikliği için standart Production Dockerfile kullanılır. Yalnız installer bileşeninin kaynakları değiştiğinde, operatör mevcut doğrulanmış sunucu/Android imajlarından Android SDK'yı yeniden indirmeden güncelleme yapabilir:

```sh
python3 scripts/production_installer.py --base-revision FULL_PREVIOUS_COMMIT_SHA
python3 scripts/production_image.py verify --image commerce-platform:NEW_COMMIT_FIRST_12
python3 scripts/production_android.py verify --image commerce-platform:NEW_COMMIT_FIRST_12-android
python3 scripts/production.py up --config /absolute/private/deployment.json --state /absolute/private/state --image commerce-platform:NEW_COMMIT_FIRST_12 --no-build
```

Önce düzeltmeyi commit edin; araç yalnız committed Git arşivini kullanır. Aynı Linux amd64 operatörünün iki temel imajı bulunmalı, tam temel commit kimliği eşleşmeli ve en az 12 GiB boş alan olmalıdır. Araç değişen dosyaları denetler: installer dışındaki çalışma zamanı veya genel derleme kaynağı değişmişse kısmi güncellemeyi reddeder. Installer `BuildType=Installer` ile tüm eklentileriyle yeniden yayınlanır. Diğer uygulama ve Android SDK temel katmanları, kullanıcı, ortam, entrypoint ve komut ayarları karşılaştırılarak korunur. Git dışında oluşan makinece okunabilir kayıt, temel/hedef revision ve imaj kimliklerini içerir. Bu yöntem yeni bir tam SaaS/worker/SDK derlemesi olarak raporlanmaz; tam temiz kurulum güncel standart Dockerfile ile yapılabilir.


## Henüz yayımlanmamış iOS planının kaynak onarımı

Arşivleme aracındaki bir düzeltme iOS kaynak özetini değiştirirse mevcut plan yeni Mac tarafından alınmaz. Paket, Firebase uygulaması, sertifika veya tamamlanan makbuzları SQL ile değiştirmeyin. Önce güncel committed kaynağın owner bootstrap ve runtime izinlerini normal Production güncellemesiyle uygulayın; onarım tablosu ve koruyucu trigger aynı şema başlatıcısının parçasıdır.

Operatör önce Linux/Mac derleme işçilerini durdurur, veritabanı/secret ve artifact yedeğini alır ve önceki iOS claim süresinin dolmasını bekler. Eski claim için iki dakikalık ek bekleme aranır. Yeni kaynağı commit edilmiş ayrı bir checkout'ta tutun; `python3 scripts/mobile_ios_worker.py source-hash` çıktısını özel Mac yapılandırmasındaki `Provisioning:Mobile:Ios:Worker:ExpectedSourceHash` alanına yazın. Seçili Ruby ile `gem 'xcodeproj', '1.27.0'` yüklenebilmelidir; Ruby kurulumları aynı gem deposunu paylaşmayabilir.

Mac aracını yeni kaynaktan derledikten sonra yeni bir onarım kimliğiyle çalıştırın:

```sh
dotnet tools/Platform.Ios.Worker/bin/Release/net8.0/Platform.Ios.Worker.dll \
  --config /absolute/private/mac-worker.json \
  --repair-ios-source --confirm-workers-stopped \
  --tenant TENANT_GUID_N --identity MOBILE_IDENTITY_GUID_D \
  --repair-id NEW_REPAIR_GUID_D --expected-source PREVIOUS_IOS_SHA256 \
  --reason "Fix the verified iOS archive recipe in commit COMMIT_SHA"
```

Bu komut kuyruk tüketicisini başlatmaz veya Google/Apple kaynağı oluşturmaz. Aynı repair ID ve aynı parametrelerin tekrarı önceki sonucu döndürür. Aktif iş, tamamlanmış iOS makbuzu veya saklanmış iOS artifact/symbol/dağıtım kaydı varsa işlem reddedilir. Kaynak domain hâlâ işletmenin aktif ana adresi olmalıdır. Yeni Mac'teki gerçek Android kaynak özeti de önceki Android planıyla aynı kalmalıdır.

Yalnız `IosPlan.SourceHash` değişebilir. Paket/bundle, Firebase uygulama ve proje ID'leri, SDK özeti, takım, sertifika, build numarası, Android kaynakları ve tamamlanan Android makbuzu korunur. `mobile_identity_source_repairs`, eski ve yeni tam planı, işlem kimliğini, operatör DB rolünü, nedeni ve zamanı aynı transaction içinde kaydeder. Bu geçmiş güncellenemez/silinemez; geçmişteki bir kayıt başka transaction'da plan değiştirme yetkisi vermez. Portal rolünün onarım yazma veya `prepared` değiştirme yetkisi yoktur.

Başarıdan sonra Linux dağıtımının ve Mac'in özel iOS source policy'sini aynı yeni özete bağlayıp işçileri yeniden açın. İki gerçek imzalı makbuz olmadan aktif mobil kimlik yine değişmez. Tamamlanmış artifact varken kaynak onarımı yerine özgün source/workspace geri yüklenir; önceki imzalı sürüm başka kaynak etiketiyle yeniden sunulmaz.

İmzasız arşiv grafiği ve semboller, Google/Apple hesabına yazmadan tekrar denenebilir:

```sh
python3 scripts/smoke_mobile_ios.py --ruby /absolute/path/to/ruby \
  --flutter /absolute/path/to/flutter --push-transport Apns --archive-unsigned
```

Bu kontrol gerçek CocoaPods/Xcode arşivini ve sembol UUID'lerini denetler; imzalı IPA, cihaz kurulumu veya teslim kanıtı değildir. Arşivde aynı ürün adlı CocoaPods varyantları hedefe özel `UNINSTALLED_PRODUCTS_DIR` kullanır. Apple CMS profilindeki UUID'nin harf biçimi Xcode seçicisine aynen taşınır.
