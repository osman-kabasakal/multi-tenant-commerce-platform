# Mobil bildirimler ve deeplink kurulumu

Android bildirimleri FCM HTTP v1, iOS bildirimleri doğrudan APNs üzerinden gider. Cihaz izni, alıcı kaydı, sunucu sağlayıcısı ve alan adı eşleşmesi ayrı kontrollerdir. Admin panelindeki eski Firebase tarayıcı ayarları mobil göndericinin kimlik bilgilerini değiştirmez.

## Sunucuyu hazırlama

Production planında `Providers.Notifications.Provider` değerini Android için `Fcm`, Android ve iOS için `FcmApns` seçin. Ayrı FCM gönderici hesabının credential dosyasını `NotificationCredentialsFile` ile, Apple takım anahtarını `Providers.Notifications.Apns` ile bağlayın. Credential içerikleri portala veya Git deposuna eklenmez. Örnek alanlar `infra/production/deployment.example.json` dosyasındadır; mevcut dağıtım adımlarını ilgili Production ve Oracle belgeleriyle birlikte uygulayın.

Yeni sunucu imajını Frontend, Backend ve Installer çıktılarıyla üretin. Yalnız Flutter sürümünü değiştirmek gateway veya installer düzeltmesini sunucuya taşımaz. Dağıtımı özel Production planından mevcut state dizinine uygulayın; mevcut anahtarları, tenant verisini ve sertifikaları koruyun.

## Görev servisini etkinleştirme

Production planındaki `Providers` içine şu açık ayarı ekleyin:

```json
"TenantTasks": {
  "Enabled": true,
  "PollSeconds": 30,
  "TimeoutMinutes": 20,
  "TenantIds": []
}
```

Boş `TenantIds` listesi bu dağıtımın kurulumu başarıyla tamamlanmış tüm tenant'larını seçer. Kontrollü kabul testi için yalnız test tenant kimliğini yazın. Görevler kendi MongoDB veritabanında, tenant başına sırayla ve kira kilidiyle çalışır. Admin panelinde kapatılmış görevler açılmaz; aralıklar ve hata sonrası durdurma tercihleri korunur.

Portable dağıtımda ayrı Compose servisi `task-worker` olarak görünür ve `TenantManager --tenant-schedule-worker` girişini kullanır. Eski Azure/Keycloak/Hangfire bağımlılıkları olan `Grand.BackgroundJobExecuter` bu dağıtımın giriş noktası değildir. Web uygulamalarındaki `MultitenantTask.Enabled=false` ayarı bu ayrılığı korur. Ayrı görev işçisi yalnız kendi installer alt sürecine `MultitenantTask__Enabled=true` verir; böylece Simpra gibi bu bayrağa göre kaydolan görevler de bulunur. Bu ayarı web konteynerlerinde açmayın.

Görevler başlamadan üç zorunlu ilk kurulum kaydı doğrulanır: `tenant-plugins`, `tenant-migrations`, `tenant-settings`. Sonradan eklenen `tenant-domain.<requestId>.json` kaydı periyodik görevlerin önkoşulu değildir. Alıcı kaydı ve admin panelinden doğrudan gönderim, periyodik servis kapalıyken de kendi HTTP akışında çalışır. Simpra yapılandırması bulunmayan işletmelerde isteğe bağlı Simpra görevleri, entegrasyon servislerini oluşturmadan atlanır; yapılandırılmış bir entegrasyondaki gerçek hata ise görev sonucuna yansır.

## Uygulamayı derleme ve cihazı kaydetme

1. Tenant'ın Firebase projesi, seçili Android paketi/iOS bundle ID'si ve imza bağları hazır olmalı. Kimlik değişiminde iki platformun imzalı çıktısı tamamlanmadan aktif kimlik değiştirilmez.
2. Kaynak değişiklikleri için yeni bir portal derleme isteği oluşturun. Tamamlanmış eski derlemenin kaynak özetini veya sertifikasını değiştirmeyin.
3. Android manifesti mağaza alan adını kullanır. iOS hazırlayıcısı yalnız tenant mağazasını `applinks:<host>` olarak yazar, Flutter deeplink işlemeyi etkinleştirir ve hatalı eski `https` özel URL şemasını kaldırır.
4. Apple otomasyonu uygulamanın `PUSH_NOTIFICATIONS` ve `ASSOCIATED_DOMAINS` yetkilerini doğrular. Yeni alan adı yetkisini içeren uygulama profili ayrı sürüm adıyla oluşturulur; eski profil silinmez. Dışarıdan seçilen profil de doğru alan adına izin vermelidir. Apple profilindeki associated-domains izni tek `*` metni olarak gelebilir; yalnız bu alanın wildcard biçimi diziye uyarlanır. İmzalı uygulamada yalnız tenant mağazasının `applinks:` girdisi bulunması ayrıca doğrulanır; diğer imza ve izin kontrolleri gevşetilmez.
5. İmzalı uygulamayı kurup açın ve bildirim izni verin. iOS native token'ı seçili uygulama kimliğiyle kodlar; uygulama bunu kendi tenant'ının `/PushNotifications/ProcessRegistration` adresine gönderir. Uç hem JSON hem eski tarayıcı formunu kabul eder; mobil kimlik doğrulama katmanının JSON gönderdiği durumda alanlar açıkça gövdeden bağlanır. Alıcı müşterisi istek gövdesinden alınmaz; mevcut doğrulanmış müşteri kullanılır. Geçersiz JSON başarı gibi gösterilmeden 400 döner. Özel cihaz token'ını loglara veya dokümana yazmayın.
6. Admin → Bildirimler → Alıcılar sayfasında izinli alıcıyı kontrol edin. Oturum değişiminde ve uygulama yeniden ön plana geldiğinde kayıt yenilenir. Eşzamanlı yenilemeler aynı kayıt isteğini paylaşır. Geçici HTTP hatasında iOS sonraki başlatmada kaydı yeniden dener. İzin reddedilirse alıcı izinli sayılmaz.

## Admin panelinden bildirim denemesi

Yalnız size ait test cihazlarının bulunduğu tenant'ta deneyin. Gönderim ekranı izinli alıcılara toplu gönderir. Gerçek müşterilerin bulunduğu mağazada deneme mesajı göndermeyin.

Admin → Bildirimler → Gönder ekranında başlık, metin ve isteğe bağlı görsel girin. Boş veya `/` olarak saklanmış bağlantı aktif mağazanın HTTPS adresine tamamlanır. Daha önce bu işletmeye ait olan alan adındaki kayıtlı bağlantı, yolunu ve sorgusunu koruyarak aktif mağazaya taşınır. Yönetim veya başka işletmenin alan adı kullanılamaz. Yerel `LocalSink` demosunda HTTP ayrıca desteklenir. Örneğin mağazadaki bir ürünün HTTPS bağlantısını kullanarak bildirime basınca ürünün açıldığını kontrol edin. Bağlantı aktif mağaza alan adında olmalıdır. Sağlayıcının mesajı kabul etmesi, cihazda görüldüğünü tek başına kanıtlamaz; ön planda, arka planda ve kapalı uygulamada ayrıca kontrol edin.

## Alan adı ile uygulama eşleşmesi

Gateway şu iki herkese açık JSON yanıtını yalnız çözümlenmiş tenant'ın mağaza hostunda sunar:

- `/.well-known/assetlinks.json`: gerçek Android paket adı ve imzalı çıktının SHA-256 sertifika parmak izi.
- `/.well-known/apple-app-site-association`: iOS takım/bundle bağı ve admin yollarını dışlayan uygulama yolları.

Yanıtlar özel anahtar, servis hesabı veya cihaz token'ı içermez. Kaynak, tamamlanmış Active/Retired mobil kimliklerin kayıtlarıdır. Hazırlanan ve henüz tamamlanmamış kimlikler yayınlanmaz. Kimliğin kayıtlı mağaza origin'i istenen hostla eşleşmelidir. Bilinmeyen host, admin hostu veya eksik doğrulanmış imza bağı 404 döner. Bu yanıtlar Keycloak token'ı gerektirmez ve yönlendirilmeden JSON dönmelidir.

Android'de Play App Signing kullanılmaya başlandığında mağazadan dağıtılan uygulamayı Play yeniden imzalar; yayın sertifikasını ayrıca doğrulayıp kayıt akışına dahil etmeden yerel upload sertifikasının yeterli olduğunu varsaymayın. iOS'ta Apple CDN/cihazın doğrulama durumu da uygulamanın gerçek bir HTTPS bağlantısından açılmasıyla kontrol edilmelidir.

Kaynaklar: [Android website associations](https://developer.android.com/training/app-links/configure-assetlinks), [Apple associated domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains), [Apple capability types](https://developer.apple.com/documentation/appstoreconnectapi/capabilitytype).

## Geliştirici doğrulaması

Repo kökünde:

```sh
dotnet test tests/Notifications.Tests/Notifications.Tests.csproj -c Release
dotnet test tests/Gateway.Tests/Gateway.Tests.csproj -c Release
dotnet test tests/Portable.Provisioning.Tests/Portable.Provisioning.Tests.csproj -c Release
python3 scripts/smoke_tenant_tasks.py
```

`scripts` dizininde:

```sh
python3 -m unittest discover -p 'test_mobile_ios*.py'
python3 -m unittest test_production_config
```

`Platforms/store_user_app` dizininde:

```sh
flutter test test/core/services/deeplink_service_test.dart
flutter test --dart-define=IOS_PUSH_TRANSPORT=Apns \
  --dart-define=PACKAGE_NAME_IOS=com.example.tenant \
  --dart-define=IOS_DEVELOPMENT_TEAM=ABC123DEFG \
  --dart-define=MOBILE_IDENTITY_ID=123456781234123412341234567890ab \
  test/core/services/push_registration_test.dart \
  test/core/services/apns_notification_bridge_test.dart
```

Test paketleri sentetik veri kullanır; gerçek bildirim göndermez. Canlı kabul sonucu ayrıca `docs/validation` altında tutulur.
