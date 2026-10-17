# Yeni işletme ekleme rehberi

[GitHub Actions gerektirmeyen Oracle kurulum ve dağıtım adımları](ORACLE_DEPLOYMENT.md). Oracle hesabı ve özel girdiler bir kez hazırlanır; uygulama dağıtımı Mac veya mevcut CI üzerinden aynı araçla çalıştırılır.

Bu rehber, repoyu ilk kez kuran platform işletmecisini ve SaaS üzerinden mağaza açan işletme sahibini aynı akışta buluşturur. **A bölümü her kurulum için bir kez**, **B bölümü her yeni işletme için** uygulanır. C bölümü yerel deneme içindir; D bölümü sorunları ve son kabul kontrollerini açıklar.

**Sürüm durumu — 17 Ekim 2026:** gerçek genel HTTPS/OIDC SaaS kaydıyla yeni bir Android etkin işletme oluşturuldu. Kalıcı kuyruğun 11 adımı; ayrı veritabanı, 23 etkin eklenti ve 168 işletme ayarı, kimlik, Google/Firebase, alan adları, HTTPS mağaza ve imzalı Android App Distribution yayınıyla tamamlandı. Firebase’den indirilen APK’nın imzası, Firebase/Crashlytics kaynakları ve dosya özeti bağımsız salt okunur Linux süreçten doğrulandı. Servisler yeniden başladıktan sonra aynı mağaza parolası, APK, imzalama kimliği ve tamamlanmış iş korundu; yeni durum ve veri birimlerinin tutarlı yedeği de alınıp ayrı makineye aktarılarak doğrulandı. Bu Oracle yedeğinde boş hedefe geri dönüş testi yapılmadı; önceki üç işletmeli Linux kabulü ayrı bir soğuk geri dönüş kanıtıdır. İmzalı iOS, bu APK’nın cihazda açılışı, cihazdaki crash/bildirim ve sürekli background görevleri bekliyor. [Son Android kanıtı](validation/oracle-saas-android-20261017.json) ve [doğrulama geçmişi](VALIDATION.md) ayrıntıları ve sınırları içerir.

## A. Platform işletmecisinin bir kez yapacağı kurulum

### 1. Kullanılacak kapsamı seçin

| İstenen sonuç | Gerekli seçim |
| --- | --- |
| Bilgisayarda web demosu | C bölümü; bulut hesabı gerekmez |
| Linux üzerinde web mağazaları | Production Compose, DNS/TLS ve doğrulanmış kullanıcı hesabı |
| Her işletmeye ayrı Google/Firebase projesi | Google sağlayıcısı ve yetkili proje oluşturucu |
| Android test uygulamasının otomatik dağıtılması | Google + `AndroidAppDistribution` |
| Android ve iOS test uygulamalarının otomatik dağıtılması | Google + `AndroidIosAppDistribution` + çalışan Mac düğümü |
| Android FCM ve doğrudan iOS bildirimi | `FcmApns`, ortak APNs anahtarı ve uyumlu mobil sürüm; canlı kabulü bekliyor |

Azure zorunlu değildir. Üretilen Linux kurulumu `AesGcm` kullanır. Ayrı servis kurulumlarında ortak arayüz üzerinden Azure seçimi de mümkündür; [şifreleme rehberini](TENANT_SECURITY.md) izleyin. Şifreleme sağlayıcısını değiştirmek mevcut verilerin otomatik taşınması anlamına gelmez.

### 2. Kaynak kodu ve Linux sunucusunu hazırlayın

Private inceleme sürümüne erişimi olan hesapla:

```sh
git clone --branch codex/local-demo --single-branch https://github.com/osman-kabasakal/multi-tenant-commerce-platform.git
cd multi-tenant-commerce-platform
mkdir -p .local
cp infra/production/deployment.example.json .local/production-input.json
```

Sunucu uygulamaları Linux AMD64 ve ARM64 üzerinde çalışır. Hazır otomatik Android derleme imajı şu anda **Linux AMD64** gerektirir; standart Compose kurulumu ARM64 üzerinde Android yayınlama seçimini reddeder. Tek sunucuda web ve otomatik Android için AMD64 seçin. ARM64, web/Google kabulü için kullanılabilir. Mevcut ayrı Mac kuyruğu iOS içindir.

Linux hesabı root olmamalı ve Docker erişimine sahip olmalıdır. Git, Python 3.10+, OpenSSL ve Docker Compose v2 gerekir. Sunucu imajı için en az 20 GiB; Android imajı derlemesi için en az 30 GiB boş alan ayırın. Ayrıntılar: [Linux kurulumu](LINUX_PRODUCTION.md).

Özel girdideki örnek değerleri gerçek kurulumunuzla değiştirin:

1. Sabit bir `DeploymentId` seçin; çalışan kurulumda sonradan gelişigüzel değiştirmeyin.
2. `PortalHost` ve `IdentityHost` alanlarını doldurun.
3. `StoreParentDomain` ve `AdminParentDomain` için wildcard DNS kayıtlarını sunucunuza yönlendirin. Örneğin `*.shops.example.com` ve `*.manage.example.com`.
4. Portal, kimlik ve iki wildcard adı kapsayan geçerli TLS sertifika zinciri ile özel anahtarın mutlak dosya yollarını `Tls` bölümüne yazın.
5. Kullanılmayan bir Docker `/24` ağı seçin. Wildcard kayıtlarını gerçekten hazırladıktan sonra `Providers:Domains:WildcardConfigured=true` yapın. Bu sağlayıcı DNS API çağrısı yapmaz.
6. `TrialPlan` bölümünü deneme planınızla doldurun. Bu akış yeni işletmeye sıfır tutarlı deneme kaydı açar; kart çekimi yapmaz.

Cloudflare’in standart nameserver kurulumunda ücretsiz Universal SSL, `tenant.shops.example.com` gibi ikinci seviye tenant adlarını kapsamaz. Ücretsiz kurulum için tenant wildcard kayıtlarını **DNS only** tutup sunucuya bu adları kapsayan, tarayıcıların güvendiği bir sertifika verin. Wildcard sertifikası DNS-01 ile alınabilir; yenilemesini de planlayın. Yalnızca Cloudflare Origin CA sertifikası doğrudan tarayıcı bağlantısına yetmez. [DNS/TLS ayrıntıları](LINUX_PRODUCTION.md#complete-compose-entry-point).

Cloudflare ile ayrı DNS kaydı oluşturmayı tercih ederseniz [domain sağlayıcısı ayarlarını](PORTABLE_PROVISIONING.md#domain-providers) uygulayın. Tenant alan adlarını tek tek kaynak koduna yazmayın.

### 3. Kullanıcı kaydı ve e-posta teslimini açın

1. [identity.example.json](../infra/production/identity.example.json) dosyasındaki `Identity` bölümünü özel Production girdisine ekleyin.
2. `RegistrationAllowed=true` seçin ve SMTP alanlarını gerçek rölenizle doldurun. Örnekteki parola/hesap değerlerini kullanmayın; SMTP değerleri string olmalıdır.
3. E-posta doğrulamasını koruyun. Kimlik girişindeki hesap parolası ile işletmenin mağaza yönetimi parolası ayrı bilgilerdir.
4. Gerçek bir test hesabıyla kayıt ve doğrulama e-postasının gelen kutusuna ulaşmasını kontrol edin.

Kimlik doğrulama e-postası ile “mağazanız hazır” e-postası ayrı akışlardır. Hazır e-postasını da istiyorsanız `Providers:ReadinessEmail` altında SMTP sağlayıcısını ayrıca yapılandırın; [hazır e-postası rehberini](READINESS_EMAIL.md) izleyin. Sağlayıcı kapalıysa kurulum başarılı olsa bile e-posta gönderilmez.

### 4. Google/Firebase ve Android bildirim kimliklerini hazırlayın

Mobil veya gerçek FCM kullanmayacaksanız bu adımı atlayın ve sağlayıcıları `Disabled` bırakın.

1. Yeni tenant projelerinin sahibi olacağınız **gerçek organization/folder** kaynağını belirleyin. Girdide `organizations/…` veya `folders/…` kullanılır. Mevcut bir projenin kimliği parent yerine geçmez; `No organization` durumunun çözümü [Google rehberindedir](GOOGLE_FIREBASE.md#when-the-existing-project-shows-no-organization).
2. Proje oluşturacak servis hesabına bu parent üzerinde gerekli oluşturma/yönetim izinlerini verin. Mevcut tek bir projede Project Creator rolü olması, yeni kardeş projeleri oluşturmaya yeterli değildir.
3. Organizasyon yöneticisi kullanıcıların her tenant projesini Console üzerinden yönetmesini istiyorsanız Google bölümünde `GrantOrganizationAdminUsersProjectOwner=true` seçin. Worker, organizasyon IAM kaydındaki doğrudan ve koşulsuz Organization Administrator kullanıcılarına **Owner** ekler; bu tam proje yetkisidir. Grup/koşullu üyelikler otomatik açılmaz. Ayrıntılar ve gereken okuma izni [konsol erişimi rehberindedir](GOOGLE_FIREBASE.md#console-owner-access).
4. Ayrı bir **FCM gönderici** servis hesabı oluşturun ve merkezi gönderici projesinde FCM API'sini açın. Proje oluşturucu kimliği ile uygulamanın bildirim gönderici kimliğini ayrı tutun. Tenant worker, göndericiye her yeni tenant projesinde gerekli FCM rolünü verir.
5. [Google örneğinin](../infra/google/provisioning.example.json) yalnızca içteki `Google` nesnesini özel girdinin `Providers:Google` bölümüne alın. Parent, `DeploymentId`, proje öneki ve `SenderServiceAccount` değerlerini doldurun. Deployment kimliği ana girdidekiyle aynı olmalıdır.
6. `GoogleCredentialsFile` ve `NotificationCredentialsFile` alanlarına iki özel ADC dosyasının mutlak yollarını verin. Dosyalar Git dışında ve yalnız sahibinin okuyabileceği izinlerle saklanmalıdır.
7. `DistributionGroupAlias` ile test grubunu seçin. `TesterEmails` listesini doldurun veya işletme sahibine de davet göndermek için bilerek `IncludeOwnerAsTester=true` seçin. Billing hesabı gerekiyorsa gerçek hesabı ve bağlama iznini ayrıca yapılandırın.
8. Önce seçtiğiniz kimlikle erişimi kontrol edin; yalnız bu hedeflerde gerçek kaynak oluşturulmasını istediğinizde `AllowCloudWrites=true` yapın:

```sh
dotnet run --project tools/Platform.Cloud -c Release -- check-access   --credentials /absolute/private/provisioning-service-account.json   --parent folders/REPLACE_WITH_ACTUAL_FOLDER_NUMBER
```

Bu kontrol için yerelde .NET SDK gerekir; sunucu kurulumu host SDK gerektirmez. Yetki kontrolü başarılı olsa bile gerçek proje oluşturma, API etkinleştirme ve hesap kotası ayrıca başarılı olmalıdır. Ayrıntılı roller ve dosya biçimleri: [GOOGLE_FIREBASE.md](GOOGLE_FIREBASE.md).

### 5. Android ve iOS derlemesini seçin

**Android:** [android.example.json](../infra/production/android.example.json) içindeki `Providers:Mobile` bölümünü özel girdiye alın. SDK koşullarını kabul ettikten sonra `AcceptAndroidSdkLicenses`; tenant imzalama anahtarı üretimini onayladıktan sonra `AllowSigningKeyCreation`; ortak artifact/secret yedeklerini hazırladıktan sonra `SharedArtifactsConfirmed` alanlarını etkinleştirin. Varsayılan false değerleri hazırlık yapılmadan değiştirmeyin.

**Android + iOS:** Android-only bölüm yerine [android-ios.example.json](../infra/production/android-ios.example.json) kullanın. Linux üzerinde Android derlenir; iOS için ayrıca Mac çalışır. Apple tarafında birbirinden farklı şu girdiler gerekir:

| Girdi | Kullanıldığı yer | Hazırlık sıklığı |
| --- | --- | --- |
| Apple Developer Team ID | App ID, profil ve imzalama takımı | Takım başına |
| App Store Connect API `.p8`, Key ID ve Issuer ID | Mac worker'ın Apple kaynaklarını yönetmesi | Operatör kurulumu |
| Apple Distribution sertifikası **ve kullanılabilir özel anahtarı** | Mac keychain üzerinde gerçek IPA imzalama | Sertifika yaşam döngüsü boyunca |
| Kayıtlı ve etkin tester UDID'leri | Ad hoc dağıtım profilleri | Test cihazı listesi değiştiğinde |
| Production, Team Scoped APNs `.p8` ve Key ID | Sunucunun iOS bildirimi göndermesi | Takım başına; tenant başına gerekmez |

App Store Connect anahtarı APNs anahtarının yerine geçmez. API erişimi tek başına imzalama sertifikası/özel anahtarı oluşturmuş olmaz. Mevcut Mac üzerinde Apple Distribution kimliği kullanılabilir olmalıdır.

1. Mac'e aynı kaynak sürümünü, .NET 9 SDK, Flutter 3.44.6, Python, Ruby/xcodeproj, CocoaPods ve Xcode kurun.
2. [mac-worker.example.json](../infra/ios/mac-worker.example.json) ve [apple.example.json](../infra/ios/apple.example.json) dosyalarını Git dışında özel konumlara kopyalayın. Apple API kimliği, seçilen sertifika SHA-256'sı, açık tester listesi, araç ve artifact yollarını doldurun.
3. Mac'in aynı PostgreSQL kuyruk/secret deposuna **korumalı bağlantıyla** erişmesini sağlayın. Aynı `DeploymentId` ve mevcut AesGcm anahtarı/Azure yapılandırması kullanılmalıdır. Mac için runtime yetkilerini [Mac worker rehberine](MOBILE.md#run-the-explicitly-configured-mac-consumer) göre verin; runtime schema initialization kapalı kalır.
4. Mac'teki aynı checkout kökünde kaynak özetini alın:

```sh
python3 -B scripts/mobile_ios_worker.py source-hash
```

5. Linux özel girdisindeki `Providers:Mobile:Ios:Release` alanlarını Mac ile aynı takım, sertifika SHA-256'sı, kaynak özeti ve ilk build numarasıyla doldurun. Linux girdisine Apple özel anahtarı, UDID veya Mac dosya yollarını koymayın.
6. Apple kaynak yazımı, imzalama ve profil kurulumu izinlerini ancak ilgili hazırlıkları tamamladıktan sonra açıkça etkinleştirin. Mac artifact dizini ve signing keychain için ayrıca yedek hazırlayın; Linux yedeği bunları içermez.
7. Mac worker'ı ayrı bir terminal/servis olarak çalıştırın:

```sh
DOTNET_ENVIRONMENT=Production dotnet run   --project tools/Platform.Ios.Worker/Platform.Ios.Worker.csproj -c Release --   --config /absolute/private/mac-worker.json
```

Mac kapalıysa, uykuya geçerse veya worker çalışmıyorsa yeni iOS işleri sırada bekler. Linux Compose Xcode başlatmaz. İşletme başına App ID ve push capability Mac worker tarafından oluşturulur/uzlaştırılır; her işletme için elle ayrı APNs anahtarı üretme adımı yoktur.

### 6. Bildirim yolunu yapılandırın

Android için `Providers:Notifications:Provider=Fcm` seçimi ve ayrı gönderici kimliği kullanılır. Doğrudan iOS için aynı özel girdide `FcmApns` seçilir. [APNs örneğini](../infra/production/apns.example.json) mevcut girdiye ekleyin:

```json
{
  "Providers": {
    "Google": {
      "IosPushTransport": "Apns",
      "IosDevelopmentTeam": "YOURTEAMID"
    },
    "Notifications": {
      "Provider": "FcmApns",
      "Apns": {
        "Environment": "Production",
        "DevelopmentTeam": "YOURTEAMID",
        "KeyId": "YOURKEYID0",
        "KeyFile": "/absolute/private/AuthKey.p8",
        "LifetimeSeconds": 3600
      }
    }
  }
}
```

Bu parça tam kurulum dosyası değildir; **Google bölümündeki mevcut parent, kimlik ve diğer ayarları koruyarak** ekleyin. Takım/Key ID yer tutucularını gerçek 10 karakterli kimliklerle değiştirin. APNs takımını Mac imzalama takımıyla aynı tutun. `.p8` dosyası normal dosya, mutlak yol ve yalnız sahibine açık izinler taşımalıdır; mobil uygulamaya veya Git'e girmez. Linux üreticisi anahtarı yalnız commerce/admin konteynerlerine bağlar. Mac'in Google bölümüne de aynı `IosPushTransport` ve `IosDevelopmentTeam` değerlerini verin.

Bu seçimde iOS cihazları doğrudan APNs'ye, Android cihazları FCM'ye yönlenir; iOS Crashlytics ve App Distribution Firebase üzerinde kalır. Firebase'e her tenant için APNs anahtarı yüklemek bu akışın bir adımı değildir. Firebase'in yayımlanmış [iOS uygulaması REST işlemleri](https://firebase.google.com/docs/reference/firebase-management/rest/v1beta1/projects.iosApps) APNs anahtarı yükleme sunmuyor; Firebase üzerinden iOS push için belgelenen akış [konsoldan yüklemedir](https://firebase.google.com/docs/cloud-messaging/flutter/get-started#upload_your_apns_authentication_key). Ortak anahtar oluşturma: [Apple anahtar rehberi](https://developer.apple.com/help/account/keys/create-a-private-key/).

**APNs bölümü henüz sürüm kabulünü tamamlamadı.** İmzalı gerçek cihazda izin, kayıt, gönderim ve bildirime dokunma kontrolleri geçmeden bu yapılandırmayı doğrulanmış canlı özellik olarak sunmayın. Mevcut FCM yolu ve doğrulama sınırları [NOTIFICATIONS.md](NOTIFICATIONS.md) içindedir.

### 7. Platformu başlatın ve doğrulayın

Gerekli sağlayıcıları **yeni işletme kaydından önce** yapılandırdıktan sonra Linux checkout kökünde:

```sh
python3 scripts/production.py up --config .local/production-input.json --state .local/production
python3 scripts/production.py verify --state .local/production
```

İlk komut commit edilmiş kaynaktan imaj üretir, özel ayar/anahtarları hazırlar, altyapıyı ve servisleri başlatır. Çalışma kopyasındaki commit edilmemiş değişiklikler sunucu imajına girmez. İkinci komut kurulum kontrollerini çalıştırır; gerçek cihaz teslimini ispatlamaz.

Özel state, veritabanları ve master key birlikte korunmalıdır. Birden fazla düğümde aynı secret deposu/şifreleme kimliği ve gerekli ortak kalıcı dosya alanları kullanılmalıdır. Ayrı bilgisayarlarda aynı dosya yolunu yazmak ortak depolama sağlamaz. [Yedek/geri yükleme rehberini](BACKUP_RESTORE.md) uygulayın.

## B. Her yeni işletmede izlenecek adımlar

### 8. İşletme sahibi hesabını oluşturun

1. Platformun portalını açın; örneğin `https://portal.example.com/register`.
2. Kimlik girişinden yeni hesap açın veya mevcut hesabınızla giriş yapın. E-posta doğrulamasını tamamlayın.
3. Kayıt ekranına dönün. Varsayılan deneme akışında **“İşletmenizi oluşturun”**, seçilmiş plan ve deneme süresi görünür.

Mevcut akışta bir hesap tek işletmeye bağlanır. Başka bir işletme için ayrı doğrulanmış sahip hesabı kullanın. Tenant kimliği, Google proje kimliği, package/bundle ID veya secret değerleri işletme sahibinden istenmez; bunlar sunucu tarafından bağlanır.

### 9. İşletme bilgilerini doldurun

| Alan | Mevcut doğrulama |
| --- | --- |
| İşletme adı | 2–100 karakter; ayrıca kullanılabilir 3–40 karakterlik tenant DNS etiketine dönüşmeli |
| Şirket unvanı | 2–200 karakter |
| Şirket sahibi ad soyad | 2–100 karakter |
| Vergi numarası | 10 rakam; başka işletmeyle çakışmamalı |
| Vergi dairesi | Zorunlu; en fazla 100 karakter |
| Telefon | 10 rakam; bu formda `+90`, baştaki `0` ve boşluk kullanılmaz |
| Tam adres | 10–500 karakter |
| İl / ilçe | Zorunlu; her biri en fazla 50 karakter |
| Posta kodu | 5 rakam |
| Mağaza yönetimi parolası | 12–128 karakter |

**“Deneme aboneliğini başlat”** düğmesine basın. Bu yol kart istemez ve ödeme almaz; deneme süresini sunucudaki plandan alır. Ücretli abonelik farklı bir seçimdir: gerçek merchant ayarları ve sunucunun doğruladığı aktivasyon gerekir; [PAYMENTS.md](PAYMENTS.md) izlenir. Canlı ödeme kabulü tamamlanmadan deneme sonucunu ödeme kanıtı saymayın.

Tarayıcı aynı kayıt kimliğini yeniden kullanır. Sayfayı yenilemek veya aynı isteği tekrarlamak ikinci işletme/deneme oluşturmak ya da mağaza parolasını değiştirmek için kullanılmaz.

### 10. Otomatik kurulumun ilerlemesini izleyin

Ekranda **“Mağazanız hazırlanıyor”** görünür. Sayfayı kapatsanız da iş kuyruğu çalışır; aynı hesapla `/register` adresine dönerek durumu görebilirsiniz.

| Sıra | Otomatik işlem | Beklenen sonuç |
| --- | --- | --- |
| 1 | İşletme, abonelik ve tenant secret kaydı | Aynı işletmeye bağlı kalıcı kimlik ve şifreli bilgiler |
| 2 | Veritabanı ve temel mağaza kurulumu | Ayrı MongoDB ve sınırlı kullanıcı; ilk mağaza/yönetici |
| 3 | Eklentiler → migration'lar → işletme ayarları | Portable profilde üç ayrı kalıcı görev; TRY, mobil adres alanları, vergi sağlayıcıları ve eski işletme profili veritabanından doğrulanır |
| 4 | Keycloak istemcisi | Tenant'a bağlı sunucu kimliği |
| 5 | Google/Firebase, seçildiyse | Ayrı proje, Android/iOS uygulamaları, SDK ayarları, tester grubu ve gönderici yetkisi |
| 6 | Domain ve yönlendirme | Sahip olunan mağaza/yönetim adresleri |
| 7 | Web yayını doğrulaması | Gerçek HTTPS mağaza yanıtı ve sahip yönetici girişi |
| 8 | Mobil yayın, seçildiyse | Android derlemesi/dağıtımı; birleşik profilde paralel Mac iOS işi |
| 9 | Sonuçların uzlaştırılması | Gerekli tüm sonuçlardan sonra işletmenin hazır durumu; açıksa hazır e-postası |

Google veya mobil sağlayıcı `Disabled` ise ilgili gerçek bulut işlemi yapılmaz. Web'in hazır olması kapalı sağlayıcının da çalıştığı anlamına gelmez. Birleşik mobil profilde Android bitse bile iOS sonucu beklenir; Mac için “sırada/hazırlanıyor” görünmesi tek başına hata değildir.

Portable kurulumun üçüncü satırındaki görevler tenant başına sırayla çalışır. Bunlar sürekli senkronizasyon yapan ayrı background görevleri değildir. Eklentilerin hangi hedefe derlendiği, 168 eski işletme ayarı ve mevcut mağazayı veri silmeden tamamlama komutu [tenant kurulum rehberindedir](TENANT_INITIALIZATION.md).

### 11. Mağazayı açın ve yönetici girişini deneyin

1. **“Mağazanız hazır”** ekranındaki **“Mağazayı aç”** bağlantısını açın. Adresi tahmin etmek yerine bu bağlantıyı kullanın.
2. **“Mağaza yönetimi”** bağlantısını açın. Sahip hesabının e-posta adresi ve 9. adımda seçtiğiniz **mağaza parolasıyla** giriş yapın.
3. Bir test ürünü oluşturun; mağazada ürün ayrıntısı ve sepete eklemeyi deneyin. İşletme adı ve içerik doğru mağazaya ait olmalıdır.
4. Portable profilde yönetimden TRY'nin ana mağaza ve kur para birimi olduğunu; iki vergi sağlayıcısının ve %1/%10/%20 oranlarının bulunduğunu kontrol edin. Adres özelliklerinde `lat`, `long`, `bno`, `dno`, `kno`, `adres_tarifi` alanları zorunlu olmalıdır. Harici ödeme/entegrasyon hesabı isteyen eklentileri ayrıca yapılandırın.
5. **“İşletme paneline devam et”** ile SaaS paneline dönün. Yeni tenant için tüm platformu yeniden başlatmanız gerekmez.

### 12. Mobil test sürümlerini teslim alın

1. Yapılandırılan tester e-postasıyla Firebase App Distribution davetini kabul edin. `IncludeOwnerAsTester=false` ve boş tester listesi varsa işletme sahibine kendiliğinden davet gitmesi beklenmez.
2. Android APK'yı kurup doğru işletmenin kataloğunu açın.
3. iOS ad hoc sürümünü yalnız seçilmiş profilde kayıtlı cihazda kurun. Yeni bir test cihazı profil politikasının ayrıca güncellenmesini gerektirir; yalnız davet e-postası imza izni vermez.
4. Uygulamanın gösterdiği işletme, API adresi ve Firebase projesinin aynı tenant'a ait olduğunu doğrulayın.

Bu akış test dağıtımıdır. Google Play veya App Store mağaza yayını, incelemesi ve mağaza kaydı otomatik tamamlanmış sayılmaz. Uygulamanın sonraki sürümlerini yayımlamak, ilk kurulum kuyruğunu silip yeniden çalıştırarak yapılmaz.

### 13. Bildirim ve Crashlytics kabulünü tamamlayın

1. Uygulamada bildirim izni verin; o işletmenin yönetimindeki bildirim ekranından test gönderin.
2. Android ve gerçek iOS cihazında açık uygulama, arka plan ve bildirimden açılma durumlarını ayrı kontrol edin. iOS için imzalı/entitlement'ı doğru uygulama ve seçilen Production APNs yolu gerekir.
3. Bildirimdeki bağlantının doğru işletmede açıldığını, varsa görselin yüklendiğini ve izin kapatıldığında yeni gönderimlere katılımın durduğunu kontrol edin.
4. Ayrı bir test tenant'ında kontrollü crash oluşturun, uygulamayı yeniden açın ve raporun **doğru Firebase projesinde**, okunabilir sembollerle görünmesini bekleyin. Gerçek müşteri oturumunu bu test için kullanmayın.
5. Sonuç, cihaz/OS, kaynak sürümü ve tarih bilgisini özel kabul kaydına yazın; token, özel anahtar veya kullanıcı verisini kanıt olarak yayımlamayın.

API'nin mesajı kabul etmesi cihazın gösterdiğini; API etkinleştirme de crash raporunun ulaştığını kanıtlamaz. “Tamamlandı” demek için D bölümündeki teslim kontrolünü kullanın.

## C. Önce yerelde yeni işletme denemek

Bu yol A bölümündeki Linux/bulut ayarlarını gerektirmez. Docker/Compose, .NET 8 ve 9 SDK, Node 22 ve Python 3.10+ gerekir. Repo kökünde:

```sh
python3 scripts/demo.py check
python3 scripts/demo.py up
python3 scripts/demo.py smoke
```

1. `http://localhost:18081/local-onboarding.html` adresini açın.
2. `demo-owner` hesabıyla giriş yapın. Parola `.local/credentials.json` içindeki `saas_user` değeridir; dosyayı paylaşmayın.
3. Benzersiz işletme adı ve 12–128 karakterlik mağaza parolası girin.
4. Kurulum tamamlanınca verilen mağaza/yönetim bağlantılarını açın. Yönetim e-postası sahip hesabının e-postasıdır.
5. Başka işletme denemesi için ayrı, e-postası doğrulanmış Keycloak test hesabı kullanın.
6. İşiniz bittiğinde `python3 scripts/demo.py stop` ile bu demoyu durdurun; veriler korunur.

Yereldeki `LocalSink` bildirimleri `.local/notifications/` altında yakalar; gerçek cihaza göndermez. Mobil manifestler `.local/mobile/` altında oluşur; bunlar imzalı Production dağıtımı sayılmaz. Özel dosyaları veya master key'i veritabanlarını tutarken silmeyin. Ayrıntılar: [README yerel başlangıç](../README.md#hızlı-başlangıç).

## D. Sorun giderme ve işletme teslim kaydı

### 14. Başarısız veya bekleyen kurulumu sürdürün

| Gözlenen durum | İzlenecek yol |
| --- | --- |
| E-posta doğrulanmamış / 401 | Doğru sahip hesabıyla giriş yapın ve doğrulamayı tamamlayın |
| Kayıt çakışması / 409 | Hesabın mevcut işletmesini, kayıt kimliğini, vergi numarasını ve seçilmiş planı kontrol edin |
| Google 403 / parent hatası | Proje oluşturucunun gerçek organization/folder izinlerini ve politikaları düzeltin; sender'a yönetici yetkisi vererek aşmaya çalışmayın |
| Google/dağıtım kotası veya eksik API | O tenant'ın doğru projesinde kota/API/hesap durumunu kontrol edin |
| Web yayını doğrulanamıyor | DNS, TLS, gateway ve o tenant'ın mağaza/yönetim adreslerini kontrol edin |
| iOS sürekli sırada | Mac worker, ağ/DB bağlantısı, kaynak özeti, takım ve sertifika eşleşmesini kontrol edin |
| iOS imzalama hatası | Mac'teki sertifikanın özel anahtarını, geçerliliğini ve seçilmiş cihazları kontrol edin |
| APNs yetki/cihaz hatası | Production anahtarı, takım/bundle eşleşmesi, entitlement ve cihazın yeni kayıt durumunu kontrol edin |
| İşletme hazır ama e-posta gelmedi | Ayrı readiness SMTP kuyruğunu ve gerçek gelen kutusunu kontrol edin; mağaza kurulumunu yeniden başlatmayın |

Ayarlar düzeltildikten sonra başarısız iş için sahip hesabıyla `/register` ekranındaki **“Kurulumu tekrar dene”** düğmesini kullanın. İşletme/kuyruk/secret kayıtlarını silmeyin. Tamamlanan adımlar ve ilk mobil kaynak/sertifika/build bağları korunur; farklı kimliklere geçiş için açık taşıma/onarım gerekir.

Yetkili teknik incelemede aynı sahip oturumuyla `GET /api/Provisioning/{businessId}` durumu okunabilir. `POST /api/Provisioning/{businessId}/retry` sahiplik, geçerli abonelik ve antiforgery gerektirir; tarayıcıdaki düğme bunları yönetir. Başka işletmenin kimliğini kullanmak yetki sağlamaz. API durumuna secret eklemeyin.

Ödeme sonucu belirsizse veya Apple kaynak oluşturma yanıtı kaybolmuşsa önce sağlayıcı ve kaydedilmiş işlem niyetini uzlaştırın; sırf tekrar denemek için bu kayıtları temizlemeyin. Ayrıntılar [ödemeler](PAYMENTS.md) ve [Apple kaynak yönetimi](MOBILE.md#run-the-explicitly-configured-mac-consumer) rehberlerindedir.

### 15. İşletmeyi teslim etmeden önce kaydı tamamlayın

Her işletme için özel bir teslim kaydında işletme/tenant kimliğini, kullanılan kaynak sürümünü, etkin sağlayıcıları, tarihi ve aşağıdaki kontrollerin sonucunu tutun:

- [ ] Doğrulanmış sahip hesabı ve geçerli deneme/ücretli abonelik.
- [ ] Başarılı kurulum durumu, gerçek HTTPS mağaza ve sahip yönetici girişi.
- [ ] İkinci tenant ile veri ve yetki ayrımı.
- [ ] Açıksa doğru tenant Google/Firebase projesi ve tester erişimi.
- [ ] Seçilen her mobil platformda gerçek kurulum ve doğru mağazadan veri okuma.
- [ ] Android/iOS için seçilen bildirim yolunda gerçek cihaz teslimi ve bağlantı davranışı.
- [ ] Crashlytics'te doğru projeye ulaşan okunabilir test raporu.
- [ ] Açıksa hazır e-postasının gerçek gelen kutusuna teslimi.
- [ ] Veritabanı, master key, tenant imzalama kimlikleri ve artifact alanlarının kurtarılabilir yedeği.

Etkin olmayan özellikleri “kapsam dışı” olarak işaretleyin. Canlıda doğrulanmayanları “bekliyor” bırakın; sadece derleme veya API yanıtıyla başarılı saymayın. Genel sürüm kabul kanıtlarını [VALIDATION.md](VALIDATION.md) ile ilişkilendirin. Belge, kalan APNs/iOS ve canlı hesap testleri tamamlandığında bu sonuçlarla güncellenmelidir.
