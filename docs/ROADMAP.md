# Açık kaynak ve portföy yol haritası

Amaç, çalışan tenant kurulum ve mobil teslim mimarisini insanların anlayıp deneyebileceği biçimde paylaşmaktır. Bu yol haritası ücretli SaaS ürün planı veya teslim tarihi taahhüdü değildir. Canlıda doğrulanan özel sürüm ile güncel kaynak snapshot'ının kontrolleri tarihli kayıtlarla ayrı değerlendirilir. Tarihli kanıtlar [VALIDATION.md](VALIDATION.md) içindedir.

## 1. Mevcut çalışan temel

| Alan | Durum | Kanıt / rehber |
| --- | --- | --- |
| Bulutsuz iki tenant web demosu ve yeni yerel işletme | Tamamlanan temel | [README](../README.md#yerelde-çalıştırma), [onboarding](PROVISIONING.md) |
| Tenant DB/kullanıcı, token ve secret ayrımı | Uygulandı ve odaklı kontroller mevcut | [Güvenlik](TENANT_SECURITY.md), [gateway](GATEWAY.md) |
| PostgreSQL lease/checkpoint kuyruğu ve tamamlanma uzlaştırması | Uygulandı | [ADR-005](decisions/0005-durable-work.md) |
| Linux Compose/Oracle, HTTPS, kayıt/e-posta ve yedekten dönüş | Özel test ortamında kabul edildi | [Linux](LINUX_PRODUCTION.md), [Oracle](ORACLE_DEPLOYMENT.md) |
| Installer ayarları, plugin BuildType ve sıralı tenant görevleri | Uygulandı; test tenant'ında canlı doğrulandı | [Installer](TENANT_INITIALIZATION.md), [görevler](TENANT_BACKGROUND_TASKS.md) |
| Domain sahipliği ve yeni paket/Firebase/imza geçmişi | Yerel ve canlı geçiş kabulü mevcut | [Domain/kimlik](TENANT_DOMAINS_AND_MOBILE_IDENTITIES.md) |
| İmzalı Android APK ve iOS IPA App Distribution teslimi | İki gerçek artifact ve bağımsız indirme kabulü mevcut | [Doğrulama geçmişi](VALIDATION.md) |
| İşletme logo/ikon/splash ve iPhone deneyimi | Önceki özel test sürümünde kabul edildi | [Markalama](MOBILE_BRANDING.md) |
| iOS APNs alıcısı, admin gönderimi ve sepet bağlantısı | Gerçek iPhone'da kullanıcı tarafından kabul edildi | [Bildirim](MOBILE_NOTIFICATIONS.md) |

Kaynakta bulunmasıyla canlı kabulü karıştırılan eski maddeler buradan çıkarılmıştır. Örneğin iOS imzalı teslimi artık “geliştirilecek” değildir; gözetimsiz imzalama ve fiziksel Android bildirim kabulü hâlâ açıktır.

## 2. İlk public sürümün kapısı — öncelik P0

| İş | Tamamlanma ölçütü | Durum |
| --- | --- | --- |
| Yazarlık ve GPL kapsamı | Yazara ait bağımsız kodlar GPL-3.0-only; üçüncü taraf istisnaları açık | Yazar seçimi alındı; [kapsam](../LICENSING.md) yazıldı |
| Mobil kaynak kapsamını netleştirme | Yazara ait ekran/API kodu; ücretli kitin kendisi yeniden dağıtılmaz | Sahibin son beyanı kaydedildi; mevcut tema korundu |
| Mobil ikonlar / örnek katalog | Mevcut görseller korunur; yalnız somut kısıt varsa dosya değiştirilir | Hazırlıkta yapılan bütün resim/ikon değişiklikleri geri alındı; [koruma kararı](licenses/ASSET_RETENTION.md) |
| Font / native dependency hakları | Her font/native paketin sürümüne uygun notice; kısıtlı dosya yok | IRANSans çıkarıldı; Yekan ve LineAwesome geri yüklendi; IOSSecuritySuite BSD sürümüne sabitlendi; sürüme özgü bildirimler tamamlandı |
| Kalan vendor görselleri, ses ve veri | Kaynak kanıtı ile mevcut-dosya koruma kararı ayrı kaydedilir | Ses ve il dosyaları eski içerikleriyle korundu; kanıtlanmamış dosyalara GPL atfedilmez |
| Temiz kaynak ve lisans kanıtları | Envanter güncel, gizli dosya/secret taraması temiz, hak blokajı yok | [Yayın kontrolü](PUBLIC_RELEASE.md) |
| Temiz Linux doğrulaması | Aday snapshot'ta demo `up`/`smoke`, gerekli backend/portal ve mobil kontrolleri | Linux kaynak aşaması: 137 geçti / 1 platform testi atlandı; tam demo/Android imaj işleri bu aşamada tekrarlanmadı |
| Mobil regresyon | Tema/ikon geri alma sonrası test ve bulutsuz derleme; önceki cihaz kabulü kendi tarihine aittir | [Güncel geri alma kaydı](validation/asset-restoration-20261018.json) |
| Geçmişi koruyan public yayın | Yalnız somut kısıt listesindeki fontlar çıkarılır; commit sayısı, metadata ve diğer tarihsel dosyalar korunur; tek `main` dalı | [Doğrulanan yayın akışı](PUBLIC_RELEASE.md); geçmişi sıfırlamak gerekmez |

Bu kapı tamamlanmadan “tamamı açık kaynak”, “herkes tam mobil sürümü derleyebilir” veya “public yayına hazır” denmez. README ve ADR belgeleri hazırlanmış olması hak onayı değildir.

## 3. Yeniden üretilebilirlik ve bakım — öncelik P1

- **Fiziksel Android push kabulü:** gerçek Android alıcısı, admin gönderimi, doğru ikon ve bağlantıya dokunma sonucu kayıt altına alınmalı.
- **Push alıcısı benzersizliği:** aynı tokenın eşzamanlı ilk kaydında yinelenen satırı önleyen DB/idempotency davranışı; mevcut veriyi kaybetmeyen onarım. Başarı ölçütü iki eşzamanlı kayıtla tek mantıksal alıcıdır.
- **Gözetimsiz Mac çalışanı:** Keychain erişimi, yeniden başlatma, disk sınırı, iş lease'i ve artifact yedeği; kullanıcı penceresi olmadan kontrollü imza kabulü.
- **Dış bağlantı matrisi:** Android App Links ve iOS Universal Links için kapalı/açık/arka plan uygulama, geçersiz tenant ve eski kimlik durumları.
- **SDK/bağımlılık yenileme:** .NET 8/9, Angular, Flutter, Gradle/CocoaPods ve eski vendor kütüphaneleri için destek/güvenlik analizi, küçük yükseltme adımları ve regresyon kanıtı. Eski uyarılar yeşil smoke ile kapatılmaz.
- **SBOM ve binary notices:** resolved NuGet/npm/Dart/CocoaPods/Gradle bağımlılıkları, asset ve konteyner sürümleri; source ve binary yükümlülükleri ayrı belgelenmeli.
- **Kaynak tüketimi:** tekrar eden imaj/SDK/artifact saklama sınırları ve tenant başına ölçüm. Ölçüm olmadan maliyet/kârlılık veya eşzamanlı tenant kapasitesi rakamı verilmemeli.
- **Kısa portföy gösterimi:** yalnız sentetik işletmeyle ekran görüntüleri/video; gerçek müşteri markaları, domainleri veya credentialları içermemeli.

## 4. Ürün kararı gerektiren ticari kapsam — ayrı havuz

Bu işler mevcut kamuya açık örneği anlatmak için ön koşul değildir. Başlamadan hedef işletme segmenti, kullanıcı ihtiyacı, partner/test ortamı ve sürdürülebilir bakım kaynağı belirlenmelidir.

| Fikir | Açık ürün/entegrasyon ihtiyacı |
| --- | --- |
| İşletmeye özel tema sistemi | Web/mobil tasarım sözleşmesi, tema sürümü ve erişilebilirlik |
| Fiziksel mağaza / POS | Çevrimdışı kullanım, stok kaynağı, iade ve kasa işlemleri |
| Pazaryeri entegrasyonları | Ürün/sipariş eşleme, API kota ve yetki, mutabakat |
| Stok / ERP bağlantıları | Stok kaynağı, çakışma çözümü ve yeniden oynatma |
| E-fatura / muhasebe | Sağlayıcı sözleşmesi, hatalı/iptal belge ve denetim izi |
| Kurye / araç takibi | Konum izni, operasyon ekranları ve veri saklama |
| Ödeme çeşitliliği | Tahsilat/iade/iptal, webhook doğruluğu ve sağlayıcı kabulü |

Kaynakta Simpra/Adisyo/Trendyol veya başka plugin adı bulunması bu entegrasyonların yeni platformda ticari kabulünün tamamlandığı anlamına gelmez.

## 5. Portföyde nasıl anlatılmalı?

“GrandNode'un ticaret motorunu tenant izolasyonu, Keycloak kimliği, dayanıklı kurulum işleri, özel domain ve sürümlü Android/iOS imzalama/teslim modeliyle birleştirdim” ifadesi gerçek katkıyı anlatır. Hazır motor ve paketler açıkça belirtilmelidir. “Sıfırdan bütün e-ticaret motoru”, “eksiksiz omnichannel ürün” veya “maliyeti kanıtlanmış ölçek” iddiaları bu repo tarafından desteklenmez.

[Mimari kararlar](decisions/README.md) · [Güncel mimari](ARCHITECTURE.md) · [Yayın hazırlığı](PUBLIC_RELEASE.md).
