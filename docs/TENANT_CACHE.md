# Tenant önbelleği ve süreçler arası temizleme

Mağaza, yönetim ve tenant görevleri aynı mantıksal önbellek anahtarını kullanırken mağaza kimliğini yalnızca bir kez ekler. `Get`, `GetAsync` ve `SetAsync` yöntemlerinin varsayılan/süre belirtilen çağrıları aynı kayda erişir. HTTP isteğinde sunucunun doğruladığı `StoreId`; HTTP dışındaki görevlerde `ITenantIdentityAccessor.TenantId` kullanılır. Zamanlayıcı bu alanı mevcut mağaza kimliğiyle ayarlar.

Bu bölüm sunucudaki bellek önbelleği ve Redis mesaj yolunu açıklar. Mobil uygulamanın correlation/stale-cache kayıtları, WebSocket/FCM kuyruğu ve kesinti sonrası tam senkronizasyonu henüz aynı kabulü tamamlamadı. Bunları etkin ve tamamlanmış saymayın.

## Silme ve dağıtım sınırı

`RemoveAsync` bir anahtarı; `RemoveByPrefix` yalnızca tam tenant önekiyle **başlayan** anahtarları kaldırır. Başka bir tenant anahtarının ortasında aynı metnin geçmesi eşleşme sayılmaz. Yerel değişiklikten sonra Redis yayını beklenir; alıcı süreç geçerli silme işlemini tekrar yayınlamaz. Alıcı DI kapsamı, önbellek işlemi ve uygulama olayı tamamlanana kadar açık kalır.

`Clear` geçerli tenant bağlamını gerektirir. O tenant’ın tam önekini taşıyan silme mesajı yayımlanır; başka mağazaların bulunduğu süreç topluca temizlenmez. Eski sürümlerin boş anahtarlı `ClearCache` mesajları yok sayılır. Eski mesaj bir tenant öneki taşıyorsa yalnızca o önek uygulanır.

Normal Linux yapılandırması, dağıtıma özgü `Redis.RedisPubSubChannel` değerini üretir. Aynı dağıtımın uygulamaları bunu paylaşır; farklı dağıtımlar aynı Redis içinde farklı kanallar kullanmalıdır. Bu ayar [yönetim SignalR kanalıyla](DISTRIBUTED_NOTIFICATIONS.md) aynı protokol değildir.

Redis Pub/Sub kalıcı kuyruk değildir. Bu değişiklik; kopuk bir alıcının bütün geçmiş mesajları alacağını veya mobil istemcinin yeni veriyi aldığını kanıtlamaz. Uzun kesintide yeniden doğrulama ve mobil stale-cache/tüketici yolu ayrı çalışma olmaya devam eder.

## Tekrarlanabilir kontrol

Docker ve .NET 8 kurulu makinede, monorepo kökünden:

```sh
python3 scripts/smoke_cache.py
```

Komut yalnızca kendisine ait loopback/parolalı Redis konteynerini açar, üç gerçek web sürecini çalıştırır ve sonunda kaynaklarını kaldırır. Redis verisi geçici bellek alanındadır; anonim Docker veri birimi oluşturulmadığı da kontrol edilir. Diğer bağımsız Redis/Mongo smoke komutları kendi konteynerlerini kaldırırken kendilerine ait anonim veri birimlerini de kaldırır. İki süreç aynı dağıtımı, üçüncüsü farklı bir dağıtımı temsil eder. Mağaza kimliği ve veri üretici girdileri kontrollü test girdileridir; bu bir gerçek müşteri girişinin veya checkout’un kabulü değildir.

Docker açmadan, makinede zaten bulunan bir Redis çalıştırılabilir dosyasıyla aynı komut:

```sh
python3 scripts/smoke_cache.py --redis-server /absolute/path/to/redis-server
```

Bu seçenek de mevcut bir Redis servisine bağlanmaz: farklı loopback portunda kendine ait, 64 MB veri sınırı olan geçici süreç açar. Kalıcılık kapalıdır; süreç ve geçici kimlik bilgileri sonunda kaldırılır. Komut bir sistem servisi kurmaz.

Gerçek Redis ve üç web süreciyle 12 kontrol geçmiştir: overload tutarlılığı, iki tenant ayrımı, arka plan bağlamı, iki SetAsync yolu, başka sürece silme, prefix sınırı, tenant’a özel Clear, farklı dağıtımı koruma, eski boş/dolu Clear mesajları, bağlamsız silmeyi reddetme ve eşzamanlı erişim. Değiştirilmemiş kaynak karşılaştırması bu testlerin önceki hataları yakaladığını ayrıca gösterir. [Kapsam ve kaynak özetleri](validation/macos-tenant-cache-20261017.json).

CI Docker yolunu içerir. Bu oturumda hem resmi Redis sürümünün Mac üzerindeki özel geçici derlemesi hem de varsayılan Docker komutu aynı 12 kontrolden geçti. Güncel uzak GitHub Actions hesap kotası nedeniyle çalıştırılmadı.
