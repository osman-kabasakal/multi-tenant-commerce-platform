# Tenant arka plan görevlerini çalıştırma

Portable kurulumda GrandNode’un tekrar eden görevleri ayrı `task-worker` servisinde çalışır. Servis, tamamlanmış tenant kurulumlarını kalıcı kuyruktan doğrular; her tenant için ayrı GrandNode süreci açar ve zamanı gelen görevleri sırayla yürütür. Azure ve eski Keycloak/Hangfire tenant keşfi gerekmez.

`tenant-plugins`, `tenant-migrations` ve `tenant-settings` yeni işletmenin bir defalık kurulum adımlarıdır. Bu servis ise yönetim panelindeki `ScheduleTask` kayıtlarının `Enabled`, `TimeInterval`, `StopOnError` ayarlarını kullanır; tamamlanmış installer profilini tekrar uygulamaz.

## Linux kurulumunda etkinleştirme

1. [Linux kurulumunu](LINUX_PRODUCTION.md) tamamlayın. Her tenant’ın temel kurulumu, üç sıralı installer aşaması ve kalıcı kuyruğu `Succeeded` durumunda olmalıdır. Mevcut `onboarding`, `tenants` dizinlerini ve ortak şifreleme anahtarını koruyun.
2. Özel deployment girdinizde şu sağlayıcıyı seçin. İlk açılışta yalnızca deneme tenant’ının 32 karakterli canonical kimliğini kullanabilirsiniz. Boş `TenantIds` listesi bu dağıtımdaki tüm tamamlanmış tenant’ları kapsar.

```json
{
  "Providers": {
    "TenantTasks": {
      "Enabled": true,
      "PollSeconds": 30,
      "TimeoutMinutes": 20,
      "TenantIds": ["11111111111111111111111111111111"]
    }
  }
}
```

Bu bölümü diğer sağlayıcıları koruyarak mevcut özel girdiye ekleyin. Örnek dağıtımda `Enabled=false` varsayılandır.

3. Monorepo kökünden normal kurulum komutunu çalıştırın:

```sh
python3 scripts/production.py up --config /absolute/private/deployment.json --state /absolute/private/production-state
python3 scripts/production.py verify --state /absolute/private/production-state
```

Kurulum, mevcut anahtar ve hesapları koruyarak ayrı servis ayarını oluşturur. Ortak PostgreSQL okuyucusuna var olan iş tablosunda yalnızca `SELECT` hakkı eklenir; görev servisi veritabanı şeması oluşturmaz veya provisioning işi sahiplenmez. Google proje oluşturucu, App Store Connect dağıtım kimliği ve Keycloak yönetici bilgileri bu servise verilmez. FCM/APNs bildirim görevi seçildiyse mevcut `NotificationCredentialsFile` dosyası ve `FcmApns` için ortak APNs anahtarı salt okunur bağlanır. Alt süreç, parent ortamındaki geniş Google kimliğini temizler ve yalnızca açıkça seçilen bildirim gönderici dosyasını kullanır.

4. Tenant yönetiminde zamanlanmış görevlerin etkinliğini ve aralığını kontrol edin. Harici entegrasyonlar kendi hesap ve ayarlarını gerektirir. SMTP hesabı installer tarafından yapılandırılmışsa parola `platform-secret:store-smtp-password` referansından, o tenant’ın mağaza bağlamıyla çözülür.
5. Görev kaydındaki son başlangıç/başarı/hata zamanlarını izleyin. E-posta görevi her mesajın hata ve deneme sayısını ayrı tutar: görevde başarı zamanı bulunması bütün mesajların teslim edildiği anlamına gelmez. `QueuedEmail.SentOnUtc` ve `SentTries` alanlarını da kontrol edin.

Servisi durdurmak için ilgili state dosyasını kullanın:

```sh
docker compose --file /absolute/private/production-state/compose.json stop task-worker
```

Gelecek normal `up` çalıştırmalarında açılmasını istemiyorsanız özel deployment girdisinde `TenantTasks.Enabled=false` seçip `up` çalıştırın. Kurulum, yalnızca aynı dağıtımın önceden açılmış görev konteynerlerini de durdurur. `production.py stop` dağıtımdaki servisleri birlikte durdurur.

## Tenant bağlamı ve görev sırası

Host yalnızca aynı `DeploymentId` içindeki `Succeeded` işleri seçer. Metadata, mağaza kimliği, ortak sır deposundaki alias ve tenant’a özel `tenant_<canonicalId>` veritabanı eşleşmelidir. İşin ilk mobil profilinin sonradan değişmesi mevcut mağazanın rutin görevlerini yeniden kaydetmez veya durdurmaz.

GrandNode alt süreci, üç kurulum makbuzunu ve yüklü eklenti sürümlerini doğrular. Görevin `StoreId` değeri başka mağazayı gösteriyorsa onu çalıştırmaz. Her görev kendi DI kapsamını, `BackgroundTask` müşterisini ve mağaza bağlamını alır. Yalnızca gerçekten kayıtlı görev sınıfı oluşturulur; yapılandırılmamış diğer eklentilerin constructor’ları topluca çalıştırılmaz.

Görev alt süreci eklenti DLL’lerini yayımlanan Installer sürümünün `Plugins` klasöründen yükler; tenant’ın ilk kurulumundan kalan kopyaları çalıştırmaz. Yayımlanan klasör salt okunur olabilir. Tenant’ın içerik/ayar kökü ve yazılabilir `Plugins/bin` alanı kendi çalışma dizininde kalır; görev yolunda shadow copy kapatılır. Böylece kod güncellemesi tenant’ın dosyalarını taşımadan yeni sürüme geçer.

Yeni host, yayımlanmış **Installer** uygulamasını kullanır. Dolayısıyla onun eklentileri `BuildType=Installer` ile derlenir. `BaseDir` elle değiştirilmez: [beş hedefin çıktı eşlemesi](TENANT_INITIALIZATION.md#buildtype-ve-çıktı-klasörleri) geçerlidir. Eski `Grand.BackgroundJobExecuter` çıktısının `BuildType=Background` eşlemesi de korunur; Portable görev servisi bu eski hostu açmaz.

Mobil cache değişikliklerinin ayrı gönderimi için host, ilk doğrulanmış tenant çalışmasında `ClientCacheNotificationTask` kaydını ekler. Başlangıç aralığı bir dakikadır; mevcut görev satırı ve yönetici seçimleri değiştirilmez. Ortak FCM/APNs sağlayıcısı, müşteri izinleri ve yeniden deneme sınırları [istemci cache rehberinde](TENANT_CACHE.md#mobil-websocket-ve-ayrı-push-görevi) açıklanır.

## Kilit ve yeniden başlatma davranışı

Tenant Mongo veritabanındaki `PlatformScheduleLease` koleksiyonunda tek aktif batch kilidi bulunur. Süresi Mongo sunucusunun saatine göre 90 saniyedir; 30 saniyede bir yenilenir. Aynı tenant için ikinci worker kilidi alamaz. Tenant içindeki görevler tek tek çalışır; diğer tenant’lar başka worker’larda ilerleyebilir.

Görev kayıtlarının var olan `LeasedByMachineName` ve `LeasedUntilUtc` alanları aktif girişime bağlanır. Sonuç yazımı aynı sahip ve geçerli süre koşuluna bağlıdır. Eski worker, kilit başka çalışana geçtikten sonra yeni sonucu değiştiremez. Yarım kalan görev süresi dolduğunda normal uzun görev aralığını beklemeden toparlanır. Normal tamamlanmış işler kendi zaman aralığını korur.

GrandNode `IScheduleTask.Execute()` iptal parametresi almaz. Kilit kaybolursa izole alt süreç sonlanır; host kapanışında veya zaman aşımında süreç ağacı durdurulur. Normal başarı/hata güncellemeleri yöneticinin eşzamanlı `Enabled`, aralık ve diğer ayar değişikliklerini ezmez. Hata halinde `StopOnError` geçerliyse görev kapatılır.

Bir dış işlem gerçekleşip başarı kaydı yazılamadan süreç durursa tekrar deneme olabilir; ödeme, stok, e-posta gibi dış etkiler kendi idempotency mekanizmasını gerektirir. Eski Hangfire/Keycloak task hostunu aynı tenant’larda paralel açmayın. Eklenti migration veya bakımını çalıştırmadan önce rutin görev hostunu durdurun.

## Doğrulama

Docker ve .NET 8 kurulu bir makinede, bulut kimlik bilgisi olmadan:

```sh
python3 scripts/smoke_tenant_tasks.py
python3 scripts/test_production_config.py
python3 scripts/test_tenant_plugins.py
```

İlk komut yalnızca kendisine ait geçici Mongo konteynerini oluşturup kaldırır. Gerçek Mongo üzerinde sıra, zaman aralığı, devre dışı/başka mağaza görevleri, hata politikası, eşzamanlı yönetici ayarı, uzun işte kilit yenileme, eski çalışanı engelleme ve kilit süresi sonrası toparlanma kontrollerini yürütür. CI aynı komutu içerir; güncel uzak CI hesap kotası nedeniyle henüz çalışmamıştır.

Core görev hostu, entegrasyonların tamamının canlı kabulü anlamına gelmez. [Paylaşılan Redis SignalR taşıması](DISTRIBUTED_NOTIFICATIONS.md), tenant/dağıtım ayrımı ve gerçek yönetim oturumuyla süreçler arası yayın kabulü doğrulandı. Managed yeni sipariş bildirimleri artık mevcut tenant veritabanındaki kalıcı siparişlerden tamamlanır; aralık ve yeniden deneme sınırları [bildirim rehberindedir](DISTRIBUTED_NOTIFICATIONS.md#kalıcı-siparişten-bildirime). Eski cache event tüketicisi ve harici entegrasyonların tamamının kabulü devam eder. Cihaz FCM/APNs testi, uygulamadan crash raporu ve imzalı iOS kabulü de ayrı kontrollerdir.

Leases ve hata davranışları gerçek Mongo üzerinde **13 kontrolle** doğrulandı. Ayrıca bize ait sentetik SaaS tenant’ında ayrı TenantManager hostu, gerçek `QueuedMessagesSendScheduleTask` ve `ClearCacheScheduleTask` görevlerini çalıştırdı. Özel Docker ağındaki SMTP alıcısına bir mesaj ulaştı; host yeniden başlatılınca mesaj tekrar gönderilmedi ve zaman aralıkları korundu. Test servisleri kaldırıldı, sentetik tenant’ın görev ayarları geri yüklendi. [Kapsam ve kabul kaydı](validation/oracle-tenant-schedules-20261017.json).


Ayrı [sürekli sipariş kabulünde](validation/oracle-periodic-orders-20261017.json) gerçek TenantManager hostu yalnızca bize ait tamamlanmış tenant’ı seçti. Salt okunur, temiz yayımlanmış Installer ve gerçek mağaza/iş bağlamıyla iki kalıcı test siparişi bir dakikalık normal aralıkta otomatik işlendi. Aradaki host yeniden başlatması ilk görevin zamanını/sayacını değiştirmedi. Tenant klasöründe eski eklenti DLL’i yerinde dururken yeni yayın kodu kullanıldı; bu test eski kopyayı güncelleyerek sonucu taklit etmedi. Dış göndericiler ve diğer görevler yalnızca test kapsamında kapalıydı. Sentetik tenant’ın görev ayarları geri yüklendi, iki sipariş/bildirim ve test hostu kaldırıldı. Normal üretim görev servisi ayarı halen kapalıdır. Bu kanıt bir HTTP sepet/ödeme veya cihaz kabulü değildir.
