# Süreçler arasında yönetim bildirimleri

Yönetim uygulaması ile ayrı tenant görevleri aynı Redis SignalR kanalını kullanır. Böylece görev sürecinin yayını, yönetim panelini sunan süreçteki bağlı istemcilere ulaşır. Azure SignalR hizmeti gerekmez; standart Linux kurulumu mevcut özel Redis servisini kullanır.

Bu kanal yönetim panelinin `NewOrder` WebSocket bildirimleri içindir. Mobil FCM/APNs gönderimi ve Firebase proje kurulumu [tenant bildirimleri](NOTIFICATIONS.md) akışında ele alınır. Yeni siparişlerin eski Keycloak keşfi olmadan bu kanala alınması ve cache olaylarının tüketilmesi ayrıca tamamlanmalıdır.

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

## Görev sonucu ve teslim sınırı

`ResendUnseenNotificationsTask`, paylaşılan taşıma hazır olduğunda yayın yapar ve başarılı yayın denemesinden sonra sayacı artırır. Hata, tenant zamanlayıcısına geri döner; görev yanlışlıkla başarılı işaretlenmez. Başka mağazanın görevleri kendi bağlamında çalışmaya devam eder.

SignalR/Redis Pub/Sub kalıcı bir mesaj kuyruğu değildir. Bağlantısız bir istemciye veya kesinti sırasında kesin teslim garantisi vermez. Görevdeki sayaç bir yayın denemesidir; kullanıcının bildirimi gördüğü veya etkileştiği bilgisi ayrı kayıttır. Mongo bildirim kayıtları, yeniden bağlanma ve yeni sipariş olaylarının kalıcı işlenmesi bu taşıma katmanından ayrıdır.

## Tekrarlanabilir doğrulama

Docker ve .NET 8 kurulu bir makinede, monorepo kökünden:

```sh
python3 scripts/smoke_signalr.py
```

Komut yalnızca kendisine ait, loopback üzerinde erişilen parola korumalı geçici Redis konteynerini oluşturur ve sonunda kaldırır. Test, gerçek `NotificationHub` ve `ResendUnseenNotificationsTask` kodunu kullanır; kimlik/mağaza/izin ve bildirim deposu girdileri kontrollü fixture servisleridir. Bu fixture gerçek kullanıcı girişinin veya yeni sipariş kaydının kabulü değildir.

Üç ayrı web süreci, üç ayrı görev yayını süreci ve gerçek WebSocket istemcileriyle **13 kontrol geçti**. Aynı tenant’ın iki web kopyasına teslim, diğer tenant/dağıtımı dışlama, anonim/yetkisiz/yanlış mağaza bağlantısını reddetme, yeni görev süreciyle mevcut bağlantılara yayın ve hata halinde sayacın korunması doğrulandı. Dışarı e-posta, push, SMS veya tester daveti gönderilmedi. [Kapsam ve kabul kaydı](validation/oracle-signalr-transport-20261017.json).

CI aynı komutu içerir. Güncel GitHub Actions çalışması hesap kotası nedeniyle yürütülmedi; gerçek Redis/WebSocket kanıtı mevcut küçük Linux test sunucusundaki kapalı fixture’a aittir.

Ayrı bir [tam yönetim kabulü](validation/oracle-signalr-native-admin-20261017.json) temiz kaynaktan yayımlanan Backend’i 24 derlenmiş eklentiyle çalıştırdı. Bize ait sentetik işletmenin mevcut parolasıyla gerçek giriş ve ürün listesi açıldı; gerçek yönetim çereziyle kurulan WebSocket bağlantısı ayrı görev sürecinin Redis yayınını aldı. Bu testte HTTP kimliği taklit edilmedi; yalnızca yayımlayıcının bildirim deposu girdisi kontrollü fixture idi. Mobil göndericiler kapalıydı. Özel test CA’sı açıkça doğrulandı, üretim TLS/DNS ayarları değiştirilmedi. Geçici servis ve özel yapılandırmalar kaldırıldı. Normal dağıtımın imajı henüz bu kabul paketiyle değiştirilmedi.
