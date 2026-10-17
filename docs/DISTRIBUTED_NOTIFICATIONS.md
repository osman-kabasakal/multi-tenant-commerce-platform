# Süreçler arasında yönetim bildirimleri

Yönetim uygulaması ile ayrı tenant görevleri aynı Redis SignalR kanalını kullanır. Böylece görev sürecinin yayını, yönetim panelini sunan süreçteki bağlı istemcilere ulaşır. Azure SignalR hizmeti gerekmez; standart Linux kurulumu mevcut özel Redis servisini kullanır.

Bu kanal yönetim panelinin `NewOrder` WebSocket bildirimleri içindir. Mobil FCM/APNs gönderimi ve Firebase proje kurulumu [tenant bildirimleri](NOTIFICATIONS.md) akışında ele alınır. Managed runtime’da yeni siparişin kalıcı Mongo kaydı, aşağıdaki tenant göreviyle bildirim kaydına tamamlanır; Keycloak grup keşfi veya eski `NEW_ORDER` dinleyicisi gerekmez. Eski cache olaylarının tüketimi ayrı kabul işidir.

## Yapılandırma

Normal `production.py up` girdisi, yönetim ve Installer/görev alt süreçlerine aynı ayarı üretir:

```json
{
  "PlatformSignalR": {
    "Provider": "Redis",
    "DeploymentId": "commerce-production"
  },
  "Redis": {
    "RedisPubSubConnectionString": "redis:6379,password=YOUR_PRIVATE_REDIS_PASSWORD"
  }
}
```

Parolayı özel deployment ayarında tutun. Örnek değer bir gerçek credential değildir. `DeploymentId` dağıtıma ait, 3–40 karakterli küçük harf/rakam/tire değeridir. Üretim Redis bağlantısında kimlik doğrulaması zorunludur. Yerel demo, yalnızca açık `LocalDemo.Enabled=true` sınırında kendi loopback Redis servisini kullanabilir; Development sınırı ortak başlangıç kodunda korunur.

`Provider=InProcess` eski tek süreçli çalışma için bulunur. Managed tenant bildirim görevi bu sağlayıcıyla gönderim sayacını artırmadan hata verir. Yanlış sağlayıcı sessizce başka taşıma yöntemine dönüşmez. Yeni demo ve üretim ayarları Redis’i açıkça seçer.

## Dağıtım ve tenant ayrımı

Redis kanal öneki `commerce:<DeploymentId>:notifications` olur. Yönetim kopyaları ve o dağıtımın görev alt süreçleri aynı öneki paylaşır; başka bir dağıtımın aynı isimli mağaza grupları yayını alamaz. SignalR grup adı mağaza kimliğini içerir.

Hub bağlantısı, doğrulanmış oturum, mevcut tenant mağazasıyla eşleşen sunucu bağlamı ve `Orders` izni gerektirir. İstemcinin seçtiği başka bir mağaza grubuna katılmasına izin verilmez. Mevcut mağaza/izin kontrolleri görev yayımlayıcısının ayrı süreçte olmasıyla kaldırılmaz. Ters vekil gerçek dış HTTPS host ve portunu korumalıdır; tenant yönlendirmesi bunları kayıtlı yönetim origin’iyle karşılaştırır.

Birden fazla yönetim web kopyasını yük dengeleyici arkasına koyarken normal SignalR negotiation akışı için oturum bağlılığı gerekir. Yalnızca WebSockets ve negotiation atlama koşulunda bu gereklilik farklıdır. Mevcut tek yönetim kopyalı Compose kurulumunda ayrıca yük dengeleyici ayarı gerekmez. [Microsoft Redis SignalR yapılandırması](https://learn.microsoft.com/en-us/aspnet/core/signalr/redis-backplane?view=aspnetcore-8.0).

## Kalıcı siparişten bildirime

`Provisioning.ManagedRuntime=true` olduğunda kaynak, geçerli tenant’ın `Order` koleksiyonudur. `ResendUnseenNotificationsTask` mevcut mağazanın eksik bildirimlerini tamamlayıp aynı Redis kanalına gönderir. Yönetici hub’a yeniden bağlandığında da aynı tamamlama yapılır. Kaybolan geçici Redis olayı veya yeniden başlayan bir görev süreci siparişin kaybolmasına yol açmaz.

[Görev servisini](TENANT_BACKGROUND_TASKS.md#linux-kurulumunda-etkinleştirme) açıkça etkinleştirin. Yeni kurulumdaki mevcut bildirim migration’ı bir dakikalık görevi ekler; yönetici tarafından değiştirilmiş görev ayarları korunur. Normal gecikme, görevin mevcut aralığı ve host’un tarama süresine bağlıdır. Bu yol ödeme isteğinin içinde anında yayın garantisi vermez. Görev servisi kapalıyken bağlı istemciye sürekli yeni yayın yapılmaz; yeniden bağlanma eksik kayıtları tamamlayabilir.

Her tarama en fazla 100 eksik sipariş kaydını tamamlar; kalanlar sonraki turda devam eder. Bildirim kimliği mağaza/siparişten kararlı olarak türetilir. Eşzamanlı ilk oluşturma ve tekrar deneme aynı kaydı kullanır. Eski bildirim kimlikleri, sayaçlar ve kullanıcı etkileşimleri değiştirilmez. Önceden kaydedilmiş fakat bildirimi bulunmayan siparişler de tamamlanır; bu yalnızca yeni siparişleri kapsayan bir tarih filtresi değildir.

Veritabanı adı canonical `tenant_<id>` biçiminde olmalı; mevcut mağaza ile istenen mağaza ve o veritabanındaki Store kaydı eşleşmelidir. Başka mağazanın siparişinden bildirim üretilemez. Yeni bildirim sayacı sıfırdır; başarılı yayın denemesinden sonra atomik artırılır. Görüntüleme/etkileşim güncellemeleri, eşzamanlı sayaç yazımlarını ezmeden kendi alanlarını değiştirir.

## Görev sonucu ve teslim sınırı

`ResendUnseenNotificationsTask`, paylaşılan taşıma hazır olduğunda yayın yapar ve başarılı yayın denemesinden sonra sayacı artırır. Hata, tenant zamanlayıcısına geri döner; görev yanlışlıkla başarılı işaretlenmez. Başka mağazanın görevleri kendi bağlamında çalışmaya devam eder.

SignalR/Redis Pub/Sub kalıcı bir mesaj kuyruğu değildir. Bağlantısız bir istemciye veya kesinti sırasında kesin teslim garantisi vermez. Görevdeki sayaç bir yayın denemesidir; kullanıcının bildirimi gördüğü veya etkileştiği bilgisi ayrı kayıttır. Kalıcı Order/bildirim kayıtları yeniden deneme ve yeniden bağlanma için kaynak sağlar; taşımanın kendisi kalıcı değildir. Süreç yayın yaptıktan sonra sayaç yazılmadan durursa tekrar yayın olabilir. Sayaç, cihaz ya da insan tarafından okunma onayı değildir.

## Tekrarlanabilir doğrulama

Docker ve .NET 8 kurulu bir makinede, monorepo kökünden:

```sh
python3 scripts/smoke_signalr.py
```

Komut yalnızca kendisine ait, loopback üzerinde erişilen parola korumalı geçici Redis konteynerini oluşturur ve sonunda kaldırır. Test, gerçek `NotificationHub` ve `ResendUnseenNotificationsTask` kodunu kullanır; kimlik/mağaza/izin ve bildirim deposu girdileri kontrollü fixture servisleridir. Bu fixture gerçek kullanıcı girişinin veya yeni sipariş kaydının kabulü değildir.

Üç ayrı web süreci, üç ayrı görev yayını süreci ve gerçek WebSocket istemcileriyle **13 kontrol geçti**. Aynı tenant’ın iki web kopyasına teslim, diğer tenant/dağıtımı dışlama, anonim/yetkisiz/yanlış mağaza bağlantısını reddetme, yeni görev süreciyle mevcut bağlantılara yayın ve hata halinde sayacın korunması doğrulandı. Dışarı e-posta, push, SMS veya tester daveti gönderilmedi. [Kapsam ve kabul kaydı](validation/oracle-signalr-transport-20261017.json).

Kalıcı sipariş kaydı, eşzamanlı ilk oluşturma, var olan kayıtların korunması, iki tenant ayrımı, 100’lük batch, atomik sayaç/etkileşim ve bağımsız süreçle toparlanma için:

```sh
python3 scripts/smoke_order_notifications.py
```

Bu komut yalnızca kendisine ait loopback Mongo konteynerini açar; iki geçici tenant veritabanında gerçek `OrderNotificationService` kodunu çalıştırır ve sonunda konteyneri kaldırır. Sipariş girdileri kontrollü kalıcı belgelerdir; test bir HTTP sepet/ödeme kabulü değildir. Bulut kimliği veya dış bildirim gerektirmez.

Gerçek Mongo üzerinde **15 kontrol geçti**: [kalıcı sipariş kabul kaydı](validation/oracle-order-notifications-20261017.json). Test kullanıcıları ve iki veritabanı kaldırıldı.

CI iki komutu da içerir. Güncel GitHub Actions çalışması hesap kotası nedeniyle yürütülmedi; gerçek Redis/WebSocket kanıtı mevcut küçük Linux test sunucusundaki kapalı fixture’a aittir.

Ayrı bir [tam yönetim kabulü](validation/oracle-signalr-native-admin-20261017.json) temiz kaynaktan yayımlanan Backend’i 24 derlenmiş eklentiyle çalıştırdı. Bize ait sentetik işletmenin mevcut parolasıyla gerçek giriş ve ürün listesi açıldı; gerçek yönetim çereziyle kurulan WebSocket bağlantısı ayrı görev sürecinin Redis yayınını aldı. Bu testte HTTP kimliği taklit edilmedi; yalnızca yayımlayıcının bildirim deposu girdisi kontrollü fixture idi. Mobil göndericiler kapalıydı. Özel test CA’sı açıkça doğrulandı, üretim TLS/DNS ayarları değiştirilmedi. Geçici servis ve özel yapılandırmalar kaldırıldı. Normal dağıtımın imajı henüz bu kabul paketiyle değiştirilmedi.


Sonraki [kalıcı sipariş yönetim kabulünde](validation/oracle-order-native-admin-20261017.json) bu depolama girdisi de gerçek Mongo/`OrderNotificationService` ile değiştirildi: bize ait tenant’a kontrollü bir Order belgesi kaydedildi; ayrı gerçek resend görevi bildirimi oluşturdu, native çerezli hub’a Redis üzerinden ulaştırdı ve kalıcı gönderim sayacı doğrulandı. Yayımlayıcının mağaza bağlamı kontrollüydü; HTTP yönetici kimliği ve tenant yönlendirmesi gerçekti. Tam sepet/ödeme isteği veya sürekli TenantManager hostu bu testte çalıştırılmadı. Test siparişi, bildirim kaydı, sınırlı Mongo kullanıcısı ve geçici servisler kaldırıldı. Normal üretim imajı ve görev servisi ayarı değiştirilmedi.
