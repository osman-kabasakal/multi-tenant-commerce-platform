# Tenant önbelleği ve istemci değişiklik kayıtları

Mağaza, yönetim ve tenant görevleri aynı mantıksal önbellek anahtarına mağaza kimliğini yalnızca bir kez ekler. `Get`, `GetAsync` ve `SetAsync` yöntemlerinin varsayılan/süre belirtilen çağrıları aynı kayda erişir. HTTP isteğinde sunucunun doğruladığı `StoreId`; HTTP dışındaki görevlerde `ITenantIdentityAccessor.TenantId` kullanılır. Zamanlayıcı bu alanı mevcut mağaza kimliğiyle ayarlar.

Portable ve yerel demo profillerinde sunucu önbelleği, müşteri isteklerinin bağımlılıkları ve istemci bildirimleri ortak Redis değişiklik kaydını kullanır. Sunucu hattı gerçek Redis, JWT ve WebSocket kontrollerinden geçmiştir. Flutter tarafında açılış/çevrimiçi dönüş/uygulamaya dönüş kontrollerinin ve push tüketicisinin tamamlanması hâlâ gereklidir; aşağıdaki sunucu kabulü çalışan mobil cihaz kabulü değildir.

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
