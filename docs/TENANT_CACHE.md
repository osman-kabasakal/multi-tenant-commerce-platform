# Tenant önbelleği ve istemci değişiklik kayıtları

Mağaza, yönetim ve tenant görevleri aynı mantıksal önbellek anahtarına mağaza kimliğini yalnızca bir kez ekler. `Get`, `GetAsync` ve `SetAsync` yöntemlerinin varsayılan/süre belirtilen çağrıları aynı kayda erişir. HTTP isteğinde sunucunun doğruladığı `StoreId`; HTTP dışındaki görevlerde `ITenantIdentityAccessor.TenantId` kullanılır. Zamanlayıcı bu alanı mevcut mağaza kimliğiyle ayarlar.

Portable ve yerel demo profillerinde sunucu önbelleği, müşteri isteklerinin bağımlılıkları ve istemci bildirimleri ortak Redis değişiklik kaydını kullanır. Sunucu hattı gerçek Redis, JWT ve WebSocket kontrollerinden geçmiştir. Flutter tarafında açılış/çevrimiçi dönüş/uygulamaya dönüş kontrolleri ve push tüketimi etkindir. Aşağıdaki yerel kontroller, gerçek sağlayıcıdan fiziksel cihaza teslim kabulünün yerine geçmez.

## Silme ve dağıtım sınırı

`RemoveAsync` bir anahtarı; `RemoveByPrefix` yalnızca tam tenant önekiyle **başlayan** anahtarları kaldırır. Başka bir tenant anahtarının ortasında aynı metnin geçmesi eşleşme sayılmaz. Redis yayını beklenir; alıcı süreç silme işlemini tekrar yayınlamaz. Alıcı DI kapsamı, önbellek işlemi ve uygulama olayı tamamlanana kadar açık kalır.

`Clear` geçerli tenant bağlamını gerektirir. O tenant’ın tam önekini taşıyan silme mesajı yayımlanır; başka mağazaların bulunduğu süreç topluca temizlenmez. Eski boş anahtarlı `ClearCache` mesajları yok sayılır. Eski mesaj bir tenant öneki taşıyorsa yalnızca o önek uygulanır.

Normal Linux yapılandırması, dağıtıma özgü `Redis.RedisPubSubChannel` değerini üretir. Aynı dağıtımın uygulamaları bunu paylaşır; farklı dağıtımlar aynı Redis içinde farklı kanallar kullanmalıdır. Portable/yerel demo kaydı, `RedisPubSubEnabled=true` ve açıkça ayrılmış bir kanal gerektirir. Bu ayar [yönetim SignalR kanalıyla](DISTRIBUTED_NOTIFICATIONS.md) aynı protokol değildir.

## Bağlantı kesildiğinde yeniden doğrulama

Redis Pub/Sub kalıcı geçmiş değildir. Managed cache yöneticisi, yayın öncesinde tenant kapsamındaki değişiklik sürümünü Redis’e yazar. Her bellek değeri okunduğu epoch/sürümü taşır; tekrar kullanılırken mevcut kayıtla karşılaştırılır. Anlık yayını kaçıran başka bir sunucu, etkilenmiş eski değeri yeniden kullanmaz. Veri okunurken silme gelirse o yanıtın eski gözlemi korunur ve değer güncel diye belleğe yerleştirilmez.

Kayıt anahtarları dağıtım ve mağaza kapsamındadır. İstek bağımlılıkları ayrıca mevcut müşteriye bağlanır. Correlation GUID’sini sunucu üretir; müşteri veya mağaza kimliği istek gövdesinden seçilmez. `POST /StaleCache/stale-cache-keys`, en fazla 100 correlation kabul eder ve mevcut müşteri/mağaza bağlamıyla sorgular. İstemcinin `AsOf` zamanı güvenilir değişiklik kaynağı değildir. Eksik/başka sahibin correlation kaydı aynı biçimde stale döner; sahibinin kimliğini açıklamaz.

| Sınır | Davranış |
| --- | --- |
| Kayıt ömrü | 24 saat; kaydı bulunamayan correlation yeniden alınmalıdır |
| Mağaza değişiklik geçmişi | En fazla 5.000 anahtar/önek olgusu; geçmişi budanmış eski gözlem güncel sayılmaz |
| Müşteri istek geçmişi | En fazla 512 correlation; hızlı eşzamanlı isteklerde de son kayıt sırası korunur |
| Bir yanıtın bağımlılıkları | En fazla 256; sınır aşılırsa yanıt ihtiyatlı biçimde stale sayılır |
| Redis kayıt kaybı | Epoch/sürüm/olgular eksilirse yeni epoch oluşur ve eski gözlemler geçersizleşir |

Redis okuması kullanılamadığında sunucu bellek değerini kullanmadan veri kaynağına gider. Stale sorgusu Redis’e ulaşamazsa istenen correlation’ları stale döndürür. Veritabanı yazımı ile Redis değişiklik yazımı ortak transaction değildir: yazımdan sonra Redis hatası alan bir işlem yeniden deneme/iş kaydı incelemesi gerektirir; bu mekanizma bütün veri yazımları için transaction outbox garantisi sağlamaz.

## Mobil WebSocket ve ayrı push görevi

`GET /api/ws/fcm`, normal tenant erişim doğrulamasına ek olarak `FrontendAPI` müşteri bearer token’ını doğrular. Token’daki müşteri mevcut çalışma bağlamıyla eşleşmelidir. Başka browser origin’i reddedilir. Token süresi dolunca veya en geç bir saatte bağlantı kapanır; istemci güncel token ile yeniden bağlanmalıdır. `stale-cache-websocket-protocol` alt protokolü desteklenir.

Sunucu `{correlationIds, timestamp}` mesajlarını en fazla 100 correlation halinde gönderir. Her cihazın kendi bağlantı içi teslim görünümü vardır. Başka cihazın veya push görevinin teslim kaydı bu görünümü tüketmez. Bağlantı yeniden açıldığında Redis’te kalan etkilenmiş kayıtlar tekrar okunur. İstemciden veri çerçevesi kabul edilmez; müşteri seçimi ve ortak teslim kaydı değişikliği yapılamaz.

[Ayrı tenant görev servisi](TENANT_BACKGROUND_TASKS.md) ilk çalışmada `ClientCacheNotificationTask` kaydını o tenant veritabanına ekler. Başlangıç aralığı bir dakikadır. Var olan kayıt varsa etkinlik/aralık/yönetici seçimleri korunur. İşlem, eski Keycloak grup keşfini ve global Redis FCM listesini kullanmaz.

Görev mevcut tenant’ın aktif müşterilerinin izin verdiği cihazları ortak `ITenantPushSender` üzerinden gönderir. `Notifications.Provider=Disabled` gönderim yapmaz; yerel demoda `LocalSink`, gerçek kurulumda `Fcm` veya `FcmApns` seçilir. Her data mesajında en fazla 20 correlation bulunur. Alanlar `Type=cache_invalidation`, canonical `TenantId`, `StoreId`, JSON `CorrelationIds` ve `RefreshCacheTime` olur. Başarılı sağlayıcı kabulünden sonra ilgili sürüm işaretlenir; hata veya kısmi kabul yeniden deneme için kalır. Sağlayıcı kabulü cihazın mesajı aldığının onayı değildir. Süreç, dış gönderimden sonra teslim kaydı yazamadan durursa aynı geçersizleştirme tekrar gönderilebilir.

## Flutter istemcisinde yenileme

İstemci açıldığında, ağ geri geldiğinde ve uygulama ön plana döndüğünde cache kontrolünü başlatır. Ön planda ve çevrimiçi kaldığı sürece 30 saniyede bir HTTP kontrolü yapar; WebSocket kapandıysa güncel müşteri token’ıyla yeniden bağlanır. Duraklama, çevrimdışı kalma ve oturum kapanışı eski bağlantıyı kapatır. Geç tamamlanan bir bağlantı önceki oturuma eklenmez. TLS sertifika doğrulaması geliştirme modunda da korunur.

Dio yanıtındaki `X-Correlation-ID`, başlığın büyük/küçük harfinden bağımsız okunur ve yanıt tamamlanmadan Hive’a kaydedilir. Aynı yerel cache kaydını oluşturan eşzamanlı isteklerin correlation’ları kaybolmadan birleştirilir. İlişki listesi sınırlıdır; ilişkisi bulunamayan eski cache değeri güncel sayılmaz. Kontrol istekleri kendilerini veri bağımlılığı olarak kaydetmez. Correlation listeleri tekilleştirilip 50’lik HTTP gruplarına ayrılır; aynı yerel değer bir mesajda yalnızca bir kez geçersizleştirilir. Silme sırasında tamamlanan eski bir veri üreticisi değeri cache’e geri yazamaz.

`Type=cache_invalidation` push verisi, bu derlemenin `TENANT_ID` değeriyle eşleşmeli ve sınırlandırılmış GUID listesi taşımalıdır. Ön plandaki FCM/APNs verisi ilgili cache kayıtlarını siler. Android arka plan isolate’ı Hive’ı açmaz; uygulamanın özel destek dizininde atomik bir yenileme sürümü bırakır. Ön plandaki süreç cache’i yeniledikten sonra o sürümü işler. İşlem sırasında yeni bir bildirim gelirse yeni sürüm kaybolmaz.

iOS’ta native APNs işleyicisi, Flutter hazır olmadan veya iOS uygulamayı askıya almadan önce kendi `UserDefaults` alanına bir sürüm kaydeder. Sonraki native başlangıç/ön plana dönüşte cache yenilenir ve yalnızca işlenen sürüm onaylanır. Native callback en fazla beş saniye bekler; Dart hazır olmasa da yerel işaret korunur. Bu app-owned `UserDefaults` kullanımı, Runner kaynaklarına eklenmiş `PrivacyInfo.xcprivacy` içinde `CA92.1` ile belirtilir; [Apple’ın required-reason API örneği](https://developer.apple.com/documentation/technotes/tn3183-adding-required-reason-api-entries-to-your-privacy-manifest) kullanılır.

Müşteri oturumu `FlutterSecureStorage` üzerinden tek bir kayıt halinde saklanır. Kayıt mağaza adresi, canonical tenant tanımı ve yerel demodaki tenant başlığına bağlıdır; başka mağazaya yüklenmez. Token süresi JWT’nin gerçek `exp` alanından alınır. Çıkış, bekleyen refresh veya storage yazımının eski oturumu geri getirmesini engeller; yeni süreçte doğru müşteri oturumu geri yüklenir. Keycloak servis hesabının sırrı mobil uygulamaya girmez.

Yerel Python geçidi `/api/ws/fcm` bağlantısını da taşır. Upgrade başlığıyla aynı pakette gelen ilk frame korunur; diğer Upgrade yolları ve bilinmeyen tenant’lar reddedilir. İstemcinin `x-store-token` ve yönlendirme başlıkları kullanılmaz; geçit kendi tenant doğrulamasını yapar. `LOCAL_TENANT_HOST` kullanılıyorsa yerel WebSocket de aynı Host başlığını taşır.

Flutter paket klasöründen:

```sh
flutter test --no-pub test/core/services/cache/client_cache_test.dart test/core/services/auth/auth_session_cache_test.dart test/core/services/apns_notification_bridge_test.dart test/core/config/tenant_firebase_identity_test.dart
```

Bu komutta 49 test; gerçek Hive dosyaları, gerçek loopback WebSocket ve kontrollü native method channel/credential deposu ile çalışır. Monorepo kökünde `python3 -m unittest discover -s scripts -p test_demo_gateway.py -v` ayrıca gerçek loopback geçitte beş kontrol yapar. [Mobil kabul kaydı](validation/macos-mobile-cache-20261017.json), demo Android APK derlemesini ve imzasını da kaydeder. Bu demo `LOCAL_DEMO=true` kullanır; Firebase hesabı veya dış bildirim istemez. USB/emülatörde `127.0.0.1:18090` kullanımı için demo geçidi çalışmalı ve gerekiyorsa `adb reverse tcp:18090 tcp:18090` kurulmalıdır.

Fiziksel Android/iOS cihazında gerçek FCM/APNs teslimi, imzalı iOS arşivi ve bu yeni kaynak sürümünün canlı dağıtımı ayrı kabul adımları olarak kalır.

## Tekrarlanabilir kontrol

Docker ve .NET 8 kurulu makinede, monorepo kökünden:

```sh
python3 scripts/smoke_cache.py --managed
python3 scripts/smoke_tenant_tasks.py
```

İlk komut yalnızca kendisine ait loopback/parolalı Redis konteynerini kullanır. Veriler geçici bellek alanındadır ve anonim veri birimi oluşturulmadığı kontrol edilir. Temel 12 cache kontrolüne ek olarak 32 managed kontrol; kalıcı bağımlılık, anlık yayın kaybı, okuma/silme yarışı, kayıt sınırları, gerçek JWT ile controller, iki cihazın WebSocket teslimi, başka müşteri ayrımı, gerçek stale sorgu işleyicisi ve LocalSink üzerinden görev yeniden denemesini doğrular. Veri üreticileri, tenant HTTP bağlamı, müşteri kayıtları ve JWT issuer’ı kontrollü test girdileridir. Dışarı FCM/APNs gönderilmez; normal Keycloak/gateway üzerinden mobil cihaz girişi bu fixture’ın kapsamında değildir.

İkinci komut kendine ait MongoDB konteynerinde 19 kontrol yapar: sıralama, lease/yenileme/toparlanma ve otomatik görev kaydında paralel başlatma/yönetici seçimlerini koruma ve sınırlı gönderici kimliğinin alt sürece aktarımı. Komutlar sonunda kendi süreçlerini/konteynerlerini ve anonim veri birimlerini kaldırır.

Makinede bulunan bir Redis çalıştırılabilir dosyasıyla Docker yerine:

```sh
python3 scripts/smoke_cache.py --managed --redis-server /absolute/path/to/redis-server
```

Bu seçenek mevcut Redis servisine bağlanmaz: ayrı loopback portunda kendine ait, 64 MB veri sınırı olan geçici süreç açar. Kalıcılık kapalıdır; süreç ve geçici kimlik bilgileri sonunda kaldırılır. Sistem servisi kurmaz. [Sunucu kabul kapsamı](validation/macos-client-cache-journal-20261017.json), [önceki 12 kontrolün regresyon karşılaştırması](validation/macos-tenant-cache-20261017.json).

CI managed Docker kontrolünü içerir. Uzak GitHub Actions, hesap kotası nedeniyle bu oturumda çalıştırılmadı.
