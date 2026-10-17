# Tenant kurulumu ve eklenti derlemeleri

Bu akış yeni monoreponun Portable kurulum profilinde kullanılır. Eski installer’ın işletme ayarları korunur; başlangıç vergi oranları işletmeci onayıyla **%1, %10 ve %20** olur.

## BuildType ve çıktı klasörleri

`Plugins` altındaki **19 projenin tamamı her hedefte** derlenir. `Frontend` dışında `AdminPlugins` altındaki **5 projenin tamamı da** derlenir. Proje adı ile eklenti sistem adı aynı olmayabilir: örneğin `Authentication.Keycloak` çıktısı `ExternalAuth.Keycloak` klasörüne gider.

Her eklentiye `dotnet build` / MSBuild çağrısında **BuildType açıkça gönderilir**. `BaseDir` ayrıca ezilmez; [Grand.Common.props](../Ecommerce/src/Build/Grand.Common.props) içindeki mevcut eşleme geçerlidir.

| BuildType | BaseDir’in işaret ettiği hedef | Eklenti sayısı |
| --- | --- | --- |
| Frontend | `Ecommerce/src/Web/Grand.Web.MultiTenant/Plugins/` | 19 |
| Backend | `Ecommerce/src/Web/Grand.Web.OnlyAdmin/Plugins/` | 24 |
| Installer | `Ecommerce/src/Installer/Grand.Installer.Cli/Plugins/` | 24 |
| Background | `Ecommerce/src/Cli/Grand.BackgroundJobExecuter/Plugins/` | 24 |
| Uploader | `Ecommerce/src/Installer/Grand.Data.Uploader/Plugins/` | 24 |

Tek eklenti örneği, monorepo kökünden:

```sh
dotnet build Ecommerce/src/Plugins/Tax.FixedRate/Tax.FixedRate.csproj -c Release -p:BuildType=Frontend -p:CopyLocalLockFileAssemblies=true
```

Bir hedefin bütün eklentileri:

```sh
python3 scripts/build_ecommerce_plugins.py --build-type Frontend
python3 scripts/build_ecommerce_plugins.py --build-type Backend
python3 scripts/build_ecommerce_plugins.py --build-type Installer
python3 scripts/build_ecommerce_plugins.py --build-type Background
```

Yayın sırasında `-p:PublishTenantPlugins=true` aynı derlemeyi yayın öncesinde çalıştırır. Çıktılar ilgili projenin `Plugins` klasöründen yayın paketine alınır. NuGet bağımlılıkları da kopyalanır; örneğin mobil eklentinin Twilio ve sabit teslimat eklentisinin geometri bağımlılıkları pakette bulunmalıdır.

```sh
dotnet publish Ecommerce/src/Installer/Grand.Installer.Cli/Grand.Installer.Cli.csproj -c Release -o /tmp/commerce-installer -p:BuildType=Installer -p:PublishTenantPlugins=true -p:UseAppHost=false
dotnet /tmp/commerce-installer/Grand.Installer.Cli.dll --verify-plugins /tmp/commerce-installer Installer
```

Kaynak envanteri [ManagedTenantPlugins.props](../Ecommerce/src/Build/ManagedTenantPlugins.props) dosyasında tutulur. `python3 scripts/test_tenant_plugins.py` bu envanteri gerçek proje klasörleriyle karşılaştırır ve beş BuildType için gerçek MSBuild `BaseDir`/`OutDir` değerlerini doğrular. Yeni eklenti eklenirse envanter de güncellenmelidir.

## Eklentilerin görevleri

Derleme kapsamı yukarıdaki ortak kurala bağlıdır. Aşağıdaki tablo, içeriklerinin hangi işlemler için gerektiğini açıklar.

| Eklenti grubu | Kullanımı |
| --- | --- |
| Tax.FixedRate, Tax.CountryStateZip | Yönetimde vergi sağlayıcısı/oran düzenleme; mağazada vergi hesaplama; installer’da çeviri ve başlangıç kaydı |
| Payments.CashOnDelivery, Iyzico, StripeCheckout, BrainTree | Yönetimde ödeme ayarları; mağazada ödeme ve sağlayıcı callback’leri; installer’da eklenti varsayılanları. Yeni işletmede eski profilin kapıda ödeme seçenekleri etkinleştirilir; dış sağlayıcılar kendi hesabını gerektirir. |
| Shipping.FixedRateShipping, ByWeight, ShippingPoint | Yönetimde yöntem ve teslimat alanları; mağazada kargo hesaplama; installer’da kaynaklar. Teslimat bölgeleri işletmeye özel veri olarak ayrıca düzenlenir. |
| DiscountRules.Standard | Yönetimde kural seçimi; mağazada indirim değerlendirme; installer’da kural çevirileri |
| Authentication.Google, Authentication.Facebook | Mağaza müşteri sosyal girişi ve yönetimde sağlayıcı ayarları. Platformun işletme sahipliği/Keycloak client doğrulamasından ayrı sağlayıcılardır. |
| ExchangeRate.McExchange | Kur sağlayıcısı, yönetim ve kur güncelleme görevleri |
| Misc.MobileApp | Mobil istemcinin mesaj/SEO çözümleme uçları, müşteri kayıt kupon olayı, SMS sağlayıcıları ve yönetimde kupon ekranları; Flutter derleyicisi değildir. |
| Theme.Modern | Tema görünümleri ve tema sağlayıcısı; frontend türlerine bağımlı ortak assembly de yayın paketine alınır. |
| Widgets.Slider, GoogleAnalytics, FacebookPixel, LegalTexts | Yönetimde içerik/ayar ekranları ve mağazada widget/sözleşme kullanımı |
| AdminPlugins/Authentication.Keycloak | Eski kimlik yönetimi, tenant keşfi, Hangfire ve kurulum koordinasyonu. Derlenir; Portable profilde bu eski çalışma yolu etkinleştirilmez. Kimlik, sırlar ve yeni tenant kurulumu platformun doğrulanmış ayrı adaptörleriyle yürütülür. Eski eklentinin başlangıçtaki Hangfire koleksiyonu silme davranışı bu yola taşınmaz. |
| AdminPlugins/Famizyo.Notification | Yönetim sipariş bildirimleri, widget/SignalR ve yeniden bildirim görevi |
| AdminPlugins/Famizyo.Simpra | Yönetimde Simpra eşlemeleri; ürün/sipariş senkronizasyon servisleri ve görevleri |
| AdminPlugins/Famizyo.Integration.Adisyo | Yönetimde Adisyo ayarları; ürün ve sipariş senkronizasyon görevleri |
| AdminPlugins/Famizyo.TrendyolIntegration | Yönetimde Trendyol ayarları; menü senkronizasyon görevi |

Bir eklentinin derlenmesi, harici hesabının yapılandırıldığı veya zamanlanmış işlerinin çalıştığı anlamına gelmez. Portable web/installer süreçleri Simpra ve bildirim eklentilerinin eski global dinleyicilerini başlatmaz. Tenant başına sürekli çalışan senkronizasyon/zamanlanmış işler için ayrıca tenant bağlamı ve iş sahipliğiyle çalışan background host gerekir; yeni kurulumun üç sıralı adımı bu sürekli işlerin yerine geçmez.

## Yeni işletmede sıralama

SaaS kaydı kalıcı kuyruğa yalnızca işletme metadatasını bırakır. TenantManager ayrı süreçte aşağıdaki sırayı izler:

1. `tenant-secrets`: tenant ve başlangıç sırlarını ortak şifreli kasaya bağlar.
2. `database`: yalnızca tenant’ın Mongo veritabanına erişen hesabı oluşturur.
3. `store`: GrandNode temel verisini, mağazayı ve sahibini kurar. Eklentiler bu aşamada aktive edilmez; migration’ları yanlışlıkla tamamlanmış işaretlenmez.
4. `tenant-plugins`: çalışma profiline alınan eklentilerin `Install` metodunu o tenant veritabanında çalıştırır. Sistem adı/sürüm kaydı `InstalledPlugin` koleksiyonunda tutulur.
5. `tenant-migrations`: uygulanmamış core ve eklenti migration’larını sürüm/öncelik sırasıyla çalıştırır. Başarısız sonuç devamı durdurur.
6. `tenant-settings`: eski işletme profilini uygular ve kaydedilen ayarları geri okuyarak doğrular.
7. `identity`, isteğe bağlı `google-firebase`, `domains`: mevcut kimlik/Google/alan adı adaptörleri.
8. `publication`: tüm kurulum adımları aynı mağaza için tamamlandıktan sonra gerçek HTTPS mağaza ve yönetim girişini doğrular.
9. Seçilen profile göre mobil yayın ve ayrı hazır e-postası akışı.

Her kurulum adımı ayrı kalıcı checkpoint’tir. Sonraki adım öncekinin sahiplik ve sürüm kaydını doğrular. Bir hata olursa tenant hazır sayılmaz. Tekrar denemede aynı eklenti sürümü ikinci kez kurulmaz; tamamlanan migration atlanır.

## Korunan işletme profili

[BusinessDefaults.json](../Ecommerce/src/Installer/Grand.Installer.Cli/App_Data/BusinessDefaults.json), eski installer’ın `dfb4cdb` sürümünden alınmış **168 sabit ayarı** içerir. `tenant-settings` adımı bunları tenant veritabanından geri okuyarak karşılaştırır. Buna müşteri/kayıt, katalog, ürün arama/görünüm, sipariş/iade, sepet, sadakat, adres, görsel depolama, sistem ve vergi ayarları dahildir.

Ayrıca türetilen kayıtlar doğrulanır:

- TRY para birimi; mağazanın ana ve kur hesaplama para birimi; Türkçe yönetim/mağaza dili ve Türkiye seçimi.
- Zorunlu `lat`, `long`, `bno`, `dno`, `kno`, `adres_tarifi` adres alanları. Son alan çok satırlı metindir.
- Üç Türkçe vergi kategorisi ve çalışan `Tax.FixedRate` sağlayıcısının döndürdüğü %1/%10/%20 oranları.
- Kapıda ödeme seçenekleri, Kapına Teslimat yöntemi, dört iade nedeni ve üç iade eylemi.
- Türkiye il verileri; mevcut il/alan kimlikleri korunarak güncellenir.
- İşletme sahibinin ad/soyadı, tenant API kullanıcısı, e-posta şablonlarının işletme sahibine BCC ve varsayılan gönderici bağlantısı.

Eski SHA1/SHA256/SHA384 parola kayıtları, kendi özet biçimleriyle doğrulanmaya devam eder. Yeni parola politikası SHA512 olsa da mevcut parola veya salt değiştirilmez; giriş, parola değiştirme/silme doğrulaması ve parola geçmişi kontrolleri aynı uyumluluğu kullanır.

Ürün, sipariş, müşteri, kategori, diğer vergi kategorileri, kargo yöntemleri ve iade kayıtları topluca silinmez. Aynı adlı başlangıç kayıtları tekrar eklenmez. Tamamlanan profil tekrar çalıştırılmaz; işletmecinin sonradan yaptığı ayar değişikliklerinin üzerine rutin worker açılışında yazılmaz.

Üretim planında `Identity.Smtp` tanımlıysa aynı doğrulanmış TLS göndericisi tenant’ın başlangıç e-posta hesabına bağlanır. Parola tenant’a ait `store-smtp-password` sırrında saklanır; Mongo’daki e-posta hesabında yalnızca bu sırra referans bulunur. Gönderim sırasında parola mevcut mağaza bağlamından çözülür ve normal sertifika/hostname doğrulaması uygulanır. Kurulum kabul testleri e-posta veya SMS göndermez. Google bildirim kimliği ve APNs anahtarı eski Azure blob kopyası yerine mevcut platform bildirim adaptörlerinde kalır.

## Mevcut tamamlanmış tenant’ı tamamlama

Önce [SSH/Docker dağıtım rehberindeki](ORACLE_SSH_DOCKER_DEPLOYMENT.md) yöntemle kaynak sürümü ve veri yedeği doğrulanır. Bu işlem yalnızca bu kurulumun bütün provisioning worker’ları durdurulduğunda çalıştırılmalıdır. Başka kurulumların servisleri durdurulmaz.

```sh
# Burada mevcut özel Compose/state yolu kullanılmalı.
docker compose -p YOUR_PROJECT -f YOUR_COMPOSE_FILE stop worker
docker compose -p YOUR_PROJECT -f YOUR_COMPOSE_FILE run --rm --no-deps worker worker --Provisioning:ReconcileTenant YOUR_CANONICAL_TENANT_ID
docker compose -p YOUR_PROJECT -f YOUR_COMPOSE_FILE up -d worker
```

Komut yalnızca `Succeeded` durumundaki, özgün deployment guard kaydına sahip tenant’ı kabul eder. İşletme kimliği/slug/kuyruk isteği değiştirilmez. Yeni Google projesi, kimlik hesabı veya alan adı oluşturulmaz; üç kurulum adımı tamamlanır. Sonuçlar özel tenant dizininde `SLUG.tenant-plugins.json`, `SLUG.tenant-migrations.json`, `SLUG.tenant-settings.json` olarak tutulur. Bunlarda parola veya bağlantı dizesi bulunmaz. Ayrıntılı günlükler özel çalışma klasöründedir.

Başarısız/bekleyen normal kurulumlar bu bakım komutuyla atlanmaz; kalıcı kuyruğun mevcut yeniden deneme akışı kullanılır. Temel installer veri yazarken yarıda kesilmiş ve temel verisi eksik bir veritabanı, otomatik silip yeniden kurularak onarılmaz; kurulum hata durumunda kalır ve yedeğe dayalı inceleme gerekir.
