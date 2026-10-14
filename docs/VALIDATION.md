# Doğrulama kaydı — 2026-10-14

macOS kontrolleri aşağıda kayıtlıdır. [Private GitHub CI](https://github.com/osman-kabasakal/multi-tenant-commerce-platform/actions/workflows/verify.yml) temiz Ubuntu 24.04 üzerinde kaynak koruması, web kurulumu/smoke ve Android debug derlemesi çalıştırır. İlk koşuda Linux dosya sahipliği nedeniyle Keycloak realm içe aktarması başarısız oldu; hosttaki 0600 dosya artık doğrudan bağlanmak yerine yalnızca bu demoya ait Docker veri birimine, Keycloak kullanıcısına ait 0600 dosya olarak aktarılıyor. İlk Android CI koşusu APK çıktı aşamasında disk yetersizliğiyle durdu; yalnızca geçici GitHub Android makinesindeki kullanılmayan araçlar temizlenir ve derlemeden önce 20 GiB boş alan aranır. Güncel sonuç CI kaydından takip edilir.

| Kontrol | Sonuç |
| --- | --- |
| Commerce, admin, installer ve SaaS Release publish | Başarılı; mevcut nullable/dependency uyarıları var |
| Angular demo derlemesi | Başarılı |
| `demo.py up` | Başarılı; MongoDB, PostgreSQL, Redis ve Keycloak sağlıklı; iki tenant aynı verilerle yeniden başlatıldı |
| `demo.py smoke` | **25/25 başarılı** |
| İki mağazanın HTTP kataloğu ve ürün ayrıntısı | 200; her mağaza yalnızca kendi ürünlerini gösterdi |
| Keycloak mağaza token'ları | Geçerli token kabul edildi; eksik, imzası değiştirilmiş ve farklı tenant token'ları reddedildi |
| Bilinmeyen mağaza adresleri | Gateway ve yönetim sunucusu reddetti |
| Yönetici girişleri — tarayıcı | Her iki hesapla giriş ve ürün listesi başarılı; Coffee oturumu Books yönetimine giriş sağlamadı |
| Web sepeti — tarayıcı | Coffee: Demo Espresso, 1 adet, $10.00; aynı tarayıcıda Books sepeti boş |
| SaaS OIDC — tarayıcı | Keycloak ile giriş başarılı; `sessionInfo` gerçek Demo Owner oturumunu döndürdü |
| SaaS korumaları | Anonim sessionInfo reddedildi; sahte callback oturum açmadı; bulut/ödeme mutasyonları kapalı |
| Yerel profil ortam sınırı | Commerce ve SaaS, Production ortamında LocalDemo kullanımını reddetti |
| Yerel şifreleme testleri | 2/2 başarılı: tenant değiştirme/tahrifat reddi ve eşzamanlı anahtar oluşturma |
| Flutter statik analiz | 0 error; 2.587 mevcut warning/info |
| Flutter debug bundle ve Android APK | Başarılı; Flutter 3.44.6, ARM64, `demo` flavor |
| Android emülatör — API 36 ARM64 | Uygulama kuruldu ve açıldı; örnek ürünler, ürün ayrıntısı, sepete ekleme ve $10.00 sepet özeti doğrulandı |
| Mobil HTTP kontrolleri | Her iki tenant için misafir token'ı, ürün listesi ve sepet API'si başarılı |
| Gitleaks kaynak taraması | Takip edilen güncel kaynaklarda **0 bulgu**; tarama raporu değerleri maskeli |
| Git dosya koruması | Gizli/üretilmiş dosya sınıfları takip edilen kaynakta yok |
| Proje referansları | Takip edilen tüm doğrudan ProjectReference/Import hedefleri mevcut |
| Özgün kaynak depolar | HEAD, Git durumu ve 14.552 takip edilen dosyanın SHA-256 özeti başlangıçla aynı |

## Tekrar çalıştırma

Repo kökünde:

```sh
python3 scripts/demo.py up
python3 scripts/demo.py smoke
dotnet test tests/LocalDemo.Tests/LocalDemo.Tests.csproj
```

Mobil komutlar [MOBILE.md](MOBILE.md) içindedir. Tarayıcı ve emülatör akışları elle doğrulandı; `smoke` bunların tüm görsel adımlarını otomatikleştirmez. Yerel ekran görüntüleri `output/playwright/` altında tutulur ve Git'e eklenmez.

Bu doğrulama sırasında düzeltilen başlıca sorunlar: HTTP demo oturum çerezleri, SaaS girişinde gereksiz offline erişim izni, mobil misafir oturumunun tenant'a özel token uç noktasını kullanması, Android ikon başvuruları ve metin/HTML hata yanıtlarının güvenli işlenmesi. Yerel mobil profil, yüklenmeyen slider eklentisini ve bildirim sorgularını atlar.

## Doğrulanmayan kapsam

- iOS, fiziksel cihaz dağıtımı, release imzası ve mağazalara yayın.
- Tam satın alma/ödeme, yeni işletme oluşturma, e-posta/bildirim teslimi ve buluta dağıtım.
- Uzun süreli mobil oturum yenileme ve tüm hesap/kayıt akışları.
- Üretim yükü, kapsamlı güvenlik denetimi ve bütün üçüncü taraf lisanslarının yayın izni.

Mevcut tüm test projeleri yeşil değildir: eski test altyapısında MongoDB `MessageEncoderSettings` erişimi ve `MemoryCacheBase` yapıcı imzası uyumsuzlukları var. Yeni yerel profil testleri ayrı projede gerçek uygulama koduna karşı çalışır. Android araç zinciri gelecekteki Flutter sürümleri için Gradle/AGP/Kotlin yükseltme uyarıları verir; bu kayıt yukarıdaki sabit sürümle yapılan derlemeyi kapsar.

İlk Android derlemesinde disk doldu. Kullanıcının onayıyla Docker yeniden başlatıldı; veri birimleri korundu ve web testleri tekrar geçti. Devam eden derlemelerde boş alan izlendi, yalnızca bu çalışma sırasında oluşturulan geçici dosyalar temizlendi. Yeni kurulumda README'deki disk alanı gereksinimlerini karşılayın.
