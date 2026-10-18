# Test kurulumunu boş veritabanlarından yeniden başlatma

Bu akış mevcut Oracle VM üzerinde uygulama kurulumunu sıfırlar. PostgreSQL, MongoDB ve Redis verileri; tenant dosyaları, oturum anahtarları, kuyruklar ve eski derleme çalışma alanları yeniden oluşturulur. VM, işletim sistemi, ağ ve sağlayıcı hesapları korunur. Yeni bir VM veya Terraform `apply` kabulü olarak değerlendirilmez.

## Kullanılan kaynak ve geri dönüş

Dağıtım girdisi commit edilmiş kaynak olmalıdır. Operatör çalışma dizinindeki bağımsız düzenlemeler Git bundle'a girmez. Bu denemenin kaynak commit'i ve sonuçları [doğrulama kaydında](validation/oracle-clean-install-20261018.json) tutulur.

Önce [soğuk yedekleme aracı](BACKUP_RESTORE.md) çalıştırılır. Yedek; private state, ortak şifreleme anahtarı ve üç veri volume'unu aynı durdurma aralığında alır. Snapshot manifest'i kesin kaynak/imaj kimliklerini ve dosya SHA-256 özetlerini içerir. TLS ve sağlayıcı kimlik dosyalarının operatör kopyası da ayrıca saklanır.

Yedek VM dışına taşınıp tekrar doğrulanır. Bu denemede özel kopya Mac'te Git dışındaki çalışma klasöründe tutuldu; asıl runtime imajları da geri dönüş için VM'de korundu. Yedekleme aracı dosyaları şifrelemez; dizinler 0700, dosyalar 0600 olarak korunur. Bu kayıt, VM kaybına karşı imajların da dışarıya arşivlendiği iddiasını içermez.

Mac’te iOS derlemelerine alan ayırmak için büyük `state.tar` dosyası daha sonra `state.tar.gz` olarak kayıpsız sıkıştırıldı. Ham kopya ancak sıkıştırılmış akışın açılmış SHA-256 özeti özgün snapshot manifest’iyle tekrar eşleştirildikten sonra kaldırıldı. `snapshot.json` değişmedi; saklama biçimi ve iki özet özel `storage-representation.json` kaydındadır. Diğer üç veri arşivi ham biçimde korunur.

Bu kopyayı normal doğrulama/geri yükleme aracına vermeden önce, yeterli disk alanı olan özel yedek klasöründe mantıksal dosyayı geri oluşturun:

```sh
gzip -dk state.tar.gz
```

Ardından [normal snapshot doğrulaması ve geri yükleme adımlarını](BACKUP_RESTORE.md) uygulayın. Sıkıştırılmış kopya bu komutla korunur; gzip şifreleme sağlamaz.

## Sıfırlama sırası

1. Uygulama dağıtım kimliği, receiver sahibi, Compose proje adı, konteyner ve volume etiketleri karşılaştırılır.
2. Yalnız seçilen test projesinin servisleri durdurulur. VM dışındaki yedek doğrulanmadan veri silinmez.
3. Dağıtım ve state kilitleri alınır. Seçilen Compose projesi `down --volumes --remove-orphans` ile kaldırılır; üç isimli veri volume'unun artık bulunmadığı doğrulanır.
4. Eski private state, kaynak checkout'ları ve test çıktıları kaldırılır. TLS/sağlayıcı dosyaları ve gerekli deployment girdisi korunur; uygulama verileri yedekten geri yüklenmez.
5. Kullanılmayan uygulama imajları ve derleme önbelleği temizlenir. Snapshot'ın kesin imaj kimlikleri korunur.
6. Mevcut görev işçisi ayarındaki tenant listesi yeni test kimlikleriyle, iOS planındaki kaynak özeti seçilen commit'in mobil kaynaklarıyla eşleştirilir.

Bu denemede özel operatör betiği silme adımını yalnız VM dışı doğrulama kaydı ve eşleşen snapshot özeti varsa çalıştırdı. Genel bir `docker system prune --volumes` veya hesaptaki bütün bulut kaynaklarını silme işlemi kullanılmadı. Google/Firebase projeleri, Apple App ID'leri ve DNS kayıtları uygulama veritabanıyla birlikte silinmez; ayrı sağlayıcı envanterinde takip edilir.

## Temiz kurulum

Normal [SSH receiver ve Docker dağıtım yolu](ORACLE_SSH_DOCKER_DEPLOYMENT.md) kullanılır: commit edilmiş HEAD bundle olarak aktarılır, ayrı kaynak dizinine açılır ve `production.py up` yeni, boş state diziniyle çağrılır.

- İlk hazırlık yeni bir installation ID, şifreleme master key ve uygulama/veritabanı parolaları üretir.
- Sunucu, Angular portal ve seçili Android araç imajı kaynaklardan derlenir. Hedeflere `BuildType` açıkça verilir.
- PostgreSQL/MongoDB/Redis ve sınırlı runtime hesapları oluşturulur; şemalar bootstrap aracıyla kurulur.
- Keycloak realm/client'ları ve yapılandırılmış kayıt/SMTP politikası uygulanır.
- SaaS, mağaza, yönetim, gateway, worker ve ayrı görev servisi başlatılır.
- Receiver başarılı revizyonu ancak gerçek HTTPS, identity ve bilinmeyen tenant reddi kontrollerinden sonra kaydeder.

İmzalı iOS derlemesi için Mac tüketicisi yeni veritabanı parolası ve yeni master key'e bağlanmalıdır. Önceki Mac ayarını olduğu gibi kullanmak yeni şifrelenmiş sırları açamaz. İmzalı iOS çıktıları kaynak checkout’unun dışında, kalıcı ve yalnız sahibinin erişebildiği bir klasörde tutulmalıdır; Mac işçisi kaynakların içine yazılan çıktı yolunu reddeder. Bu denemede bağlantı yalnız 127.0.0.1'e bağlanan, doğrulanmış SSH tünelinden geçirildi; yeni secret dosyaları Git dışında tutuldu.

## Test kapsamı

Yeni hesaplar mevcut gerçek kimlik hizmetinde, otomatik test için e-postası doğrulanmış sentetik sahipler olarak oluşturulur. Ardından gerçek public HTTPS/OIDC girişi ve normal trial kayıt API'si kullanılır. Bu, yeni bir posta kutusuna doğrulama e-postası teslim edildiği anlamına gelmez.

Yeni kurulumda boş kuyruk, değişen anahtar/parolalar, yeni işletme kurulumu, sahiplik/CSRF sınırları, mağaza/yönetim ayrımı, eklentiler, TRY, %1/%10/%20 vergi oranları ve mobil adres alanları kontrol edilir. Seçilen gerçek Google/Firebase ve Android/iOS adımlarının sonucu kendi makbuzlarıyla kaydedilir. Önceki cihaz kabulü güncel sürümün sonucu olarak aktarılmaz.

## Oracle test penceresi

Aynı minimal VM boyutu korunur. Önceki denemenin süresi dolmuşsa yeni test için yalnız bu VM'yi durduran scheduler saati açıkça yenilenip API'den doğrulanır. Eski Terraform girdileri sessizce değiştirilmez; yeni pencere özel operatör kaydında tutulur. Geçmiş denemenin son saatine kilitli `oracle.py deploy` denetimi yeni bir test penceresi sayılmaz. Bu denemede kaynak/VM sahipliği ve yenilenen canlı stop kuralı ayrıca doğrulanıp aynı standart SSH receiver çağrıldı.

Testin geçici durdurulması ile altyapının kalıcı kaldırılması farklı işlemlerdir. VM, boot disk ve Terraform kaynaklarının tamamen kaldırılması için [Oracle kaldırma rehberi](ORACLE_TEST_VE_KALDIRMA.md) kullanılır.
