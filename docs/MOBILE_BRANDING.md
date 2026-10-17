# İşletmeye özel mobil markalama

Portable derleyiciler logo, uygulama ikonu ve native açılış ekranını izole `tenant` flavor’ında üretir. Android ve iOS aynı Firebase uygulamalarını ve paketlerine ait mevcut imzalama kimliklerini kullanır. Markalama değişikliği yeni bir derleme numarası oluşturur; önceki imzalı APK/IPA, kaynak planı ve makbuzları değiştirilmez.

## Portalda adımlar

1. İşletme sahibi hesabıyla portala giriş yapın. İlk mağaza/mobil kurulumu tamamlandıktan sonra **Yeni Derleme** ekranını açın.
2. İlk markalı sürüm için işletme logosunu ve kare uygulama ikonunu seçin. İkon en az 512×512 piksel olmalıdır; iOS için 1024×1024 önerilir. PNG/JPEG kabul edilir; her dosya en fazla 5 MiB ve 4096×4096 piksel olabilir.
3. İsterseniz açılış ekranı görseli seçin. Seçilmezse işletme logosu kullanılır. Android 12 ve sonraki sürümlerde sistemin ikon alanı için uygulama ikonu kullanılır.
4. Sonraki derlemelerde değiştirmediğiniz dosyaları yeniden yüklemeniz gerekmez. Formdan seçilen ortak görseller Android ve iOS için kaydedilir. Altyapı platforma özel dosyaları da ayrı tutabilir.
5. **Derleme Oluştur** düğmesine basın. Portal, o andaki görselleri ve aktif paket/sertifika bağını işin değişmez girdisi olarak kaydeder. Daha sonra yüklenen bir logo başlamış işi değiştirmez.
6. Android ve iOS etkin kurulumda iki iş aynı veritabanı transaction’ında oluşturulur. Android başarılı olduğunda Mac iOS işini alır; Mac kapalıysa iOS bekler. Bir iOS işi beklerken aynı işletme için sonraki sürüm başlatılmaz.
7. Derleme listesinde iki platformu ayrı izleyin. Android APK’sı portal üzerinden indirilebilir. iOS teslimi Firebase App Distribution üzerinden yapılır; cihazın Ad Hoc profiline kayıtlı olması gerekir. Test grubu boşsa otomatik davet/e-posta gönderilmez.

İlk otomatik kayıt görsel girilmeden tamamlanmışsa mevcut sürüm ortak şablon varlıklarını kullanır; yukarıdaki adımlar ilk markalı sürümü oluşturur. Logo henüz tanımlı değilken menü ve giriş ekranlarında işletme adı yedek olarak gösterilir. Bu özellik kayıt formunda ilk kurulumdan önce zorunlu görsel yükleme adımı eklemez.

## Dağıtık derleme akışı

Portalın özel dosya deposundan okunan görseller içerik SHA-256 değerleriyle `platform_provisioning.mobile_brand_images` tablosuna alınır. Linux ve Mac aynı tenant’a ait aynı baytları buradan okur. Mobil uygulamaya portal oturum çerezi, depo erişim URL’si, bulut anahtarı veya yerel dosya yolu gömülmez. Logo uygulama paketine alınır ve çevrimdışı görüntülenebilir.

Android hazırlığı `tenant.defines.json` içine `STORE_LOGO` varlık yolunu yazar. Sabitlenmiş `flutter_launcher_icons` ve `flutter_native_splash`, bağımlılıklar alındıktan sonra ve native derlemeden önce çalışır. iOS hazırlığı aynı görsel politikasıyla AppIcon ve LaunchScreen kaynaklarını üretir. Ortak checkout değiştirilmez; tüm üretilen dosyalar işe özel workspace içindedir. Kaynak özeti ile görsel özeti ayrı doğrulanır; üretilen pubspec/varlık dosyaları kaynak sürümünü değiştirmiş sayılmaz. APK/IPA içindeki logo, ikon kaynağı ve açılış görseli baytları seçilen özetlerle karşılaştırılır.

Başarılı Android/iOS markalama yenilemesi aktif uygulama kimliğini değiştirmez. Daha sonraki alan adı/paket geçişi, son iki platformu da tamamlanmış markalamayı yeni kimliğe taşır. Önceki markalama, paket ve sertifika geçmişi korunur.

## İşletmecinin güncelleme adımları

1. Mevcut Linux state/veritabanları, şifreleme anahtarı, özel dosya deposu ve Mac artifact/sembol/profil klasörünü yedekleyin. Tamamlanmış IPA’nın kaynak sürümüyle ilişkisini koruyun.
2. Yeni kaynak sürümünün sunucu ve Android worker çıktılarını hazırlayın. Yeni tabloları mevcut owner bootstrap ile uygulayın; güncel `runtime-security-grants.sql` yetkilerini yükleyin. Runtime uygulama rolleri DDL çalıştırmaz.
3. Yeni işler için Linux’taki `Provisioning:Mobile:Ios:Release:ExpectedSourceHash` ile Mac worker’ın kaynak sürümü/özeti aynı olmalıdır. Yayımlanmış ilk planın kaynak özetini değiştirmeyin; yeni sürüm kendi `ReleaseId` ve derleme numarasını kullanır.
4. Güncellenmiş Linux servislerini ve Mac tüketicisini çalıştırın. İlk kurulum ve alan adı kimlik kuyrukları ile sonraki iOS sürüm kuyruğu aynı Mac hattında, süreli claim token’larıyla tüketilir.
5. Yeni sürümün makbuzunu, paket adını, sertifikasını, görsel özetini ve gerçek dağıtım indirmesini doğrulayın. Önceki artifact’ın baytlarını değiştirmeyin.

Yeni iOS sürümleri `platform_provisioning.ios_build_jobs` içindedir; ilk `ios_release_jobs` ve alan adı kaynak onarım geçmişi ayrı kalır. iOS artifact/sembol/dağıtım journal isimleri `ios-build-{ReleaseId}-release-…-v1` biçimindedir. Bu, ilk veya önceki sürümün dosyasını yeniden seçmeyi önler. Görsel içerikleri değişmezdir; bu tablolara elle UPDATE/DELETE uygulanmaz. Veritabanı veya dosya kaybında yedek geri yüklenir.

Kodun giriş noktaları: [portal görsel seçimi](../SaasManager/src/Infrastructure/MobileBrandingCapture.cs), [ortak görsel deposu](../Shared/Platform.Provisioning/MobileBranding.cs), [sürüm çifti](../Shared/Platform.Provisioning/AndroidBuildQueue.cs), [iOS sürüm kuyruğu](../Shared/Platform.Provisioning/IosBuildQueue.cs), [native hazırlık](../scripts/mobile_android.py), [Mac yürütücüsü](../Shared/Platform.Provisioning.Adapters/IosReleaseExecutor.cs).

## Doğrulama kapsamı

Yerel kontroller; değiştirilmiş/başka tenant’a ait görselleri, paket içindeki eksik logo baytlarını, eşzamanlı tekrarı, değiştirilmiş iOS planını ve süresi dolmuş Mac claim’ini reddeder. Gerçek sabitlenmiş ikon/splash araçları izole Android/iOS klasörlerinde çalıştırılmıştır. Bu kontroller tek başına yeni markalı imzalı APK/IPA veya fiziksel cihaz kabulü değildir; canlı kabul sonucu ayrıca [doğrulama günlüğünde](VALIDATION.md) kaydedilir.

Araçların ayarları: [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons), [flutter_native_splash](https://pub.dev/packages/flutter_native_splash). Repo kilit dosyasında sabitlenmiş sürümler kullanılır.
