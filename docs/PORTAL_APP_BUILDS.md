# Portal üzerinden Android sürümü oluşturma

`/dashboard/appbuilds` sayfasındaki **Yeni Derleme** formu, kurulumu tamamlanmış ve geçerli bir deneme veya ücretli aboneliği olan işletme sahibine açılır. Deneme işletmesinin `Trial` durumu değiştirilmez. Kurulum devam ediyorsa, abonelik bitmişse veya başka bir derleme sürüyorsa ilgili gerekçe gösterilir. Aynı kurallar doğrudan API çağrılarında da uygulanır.

1. İşletme sahibi hesabıyla portala giriş yapın ve Uygulama Derlemeleri sayfasını açın.
2. Yeni Derleme seçeneğini kullanın. Bir sonraki Android derleme numarası sunucu tarafından belirlenir.
3. **Derleme Oluştur** düğmesine basın. Mevcut tenant uygulama kimliği, Firebase bağlantısı ve imzalama anahtarı kullanılır. Portable profilinde bu form mevcut uygulamayı yeniden derler; logo/ikon değiştirme alanları gösterilmez.
4. Listeye döndüğünüzde iş önce `Queued`, ardından `Building` ve başarılı olduğunda `Built` görünür. Listeyi yenileyerek durumu kontrol edebilirsiniz. Tamamlanan APK'yı yalnızca ilgili işletmenin sahibi indirebilir. İlk kurulumun Android sürümü de listede görünür.

## Çalışma ve dağıtım

Portable profilindeki istekler eski Redis `NEW_BUILD` kanalına gönderilmez. `platform_provisioning.android_build_jobs` tablosu kalıcı kuyruğu tutar; mevcut TenantManager worker'ı işleri kendi deployment kimliğiyle alır. Tek tenant için aynı anda bir etkin iş vardır. Aynı istek kimliğiyle tekrar gönderim yeni sürüm oluşturmaz. Çöken worker'ın süresi dolan kilidi başka bir worker tarafından alınabilir; eski worker sonucu değiştiremez.

Her sürümün plan, APK ve App Distribution kaydı ayrı ve kalıcıdır. İlk kurulumun kayıtları korunur. İmzalama anahtarı bulunamazsa yenisi oluşturulmaz; derleme hata verir. Yerelde saklanan APK yeniden indirilirken kaydedilmiş SHA-256 ile doğrulanır.

Şema değişikliğini uygulayan hesap mevcut owner bootstrap hesabıdır; web ve worker hesapları DDL yetkisi almaz. `scripts/production.py` owner bootstrap sonrasında yeni tablo için sınırlı çalışma izinlerini verir. `scripts/production_config.py`, mobil derleme açıkken SaaS'a APK dizinini salt okunur bağlar. Çalışan bir kurulumu güncellerken yeni imajla owner bootstrap, izinlerin uygulanması ve ardından SaaS/worker yeniden başlatılması gerekir. Veritabanlarını veya ilk kurulum kuyruğunu sıfırlamayın.

Bu form Android yeniden derleme içindir. İlk iOS kurulumu ve Mac üzerinde imzalama, mevcut ayrı iOS iş hattını kullanır; form yeni iOS sürümü isteği oluşturmaz. Üretimde paylaşılan APK dizini ve şifreli secret veritabanı kalıcı ve tüm ilgili replikalar için erişilebilir olmalıdır.

## Doğrulama

Regresyon testleri geçerli deneme ve ücretli abonelikleri, bitmiş/iptal/future abonelikleri, kapalı işletmeleri, başka işletme kimliğiyle gönderilen istekleri ve kuyruk yönlendirmesini kapsar. PostgreSQL entegrasyon testi eşzamanlı aynı istek, deployment ayrımı, worker kilidi kurtarma, değiştirilemeyen tamamlanmış kayıt ve artan sürüm numarasını doğrular. Android hat testi ilk sürümün kayıtlarının ve imzalama kimliğinin korunduğunu doğrular. Bu testlerdeki sentetik provider yanıtları canlı Firebase kabul testi sayılmaz.
