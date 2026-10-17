# E-posta ve nesne eşleme bağımlılıkları

Bu kayıt 17 Ekim 2026 tarihindeki yerel doğrulamayı açıklar. İnceleme kapsamı `tests/LocalDemo.Tests` projesinin .NET 8 bağımlılık zinciri ve GrandNode’un ortak başlangıç yoludur. Tüm monorepo veya dağıtım ortamı için güvenlik onayı değildir.

## Uygulanan değişiklikler

| Bileşen | Sürüm / davranış | Kanıt |
| --- | --- | --- |
| MailKit / MimeKit | 4.16.0 | STARTTLS öncesinde tamponlanan sahte yetenekler TLS sonrasında kullanılmaz. Aynı test eski MailKit 4.5.0 ile beklenen hatayı üretir. |
| System.Security.Cryptography.Pkcs | 8.0.2 | MimeKit’in eski alt bağımlılığı yerine Microsoft’un düzeltilmiş .NET 8 paketi açıkça seçilir. |
| System.Text.Json | 8.0.6 | Ortak altyapının bağımlılık zincirinde 8.0.0 yerine yamalı sürüm seçilir. |
| AutoMapper | 13.0.1, uygulama düzeyinde derinlik sınırı | Ortak başlangıçta oluşturulan her tür eşlemesine en fazla 32 `MaxDepth` uygulanır; daha küçük mevcut sınır korunur. |

MailKit güncellemesinin dayanağı [üretici güvenlik duyurusu](https://github.com/jstedfast/MailKit/security/advisories/GHSA-9j88-vvj5-vhgr). PKCS güncellemesi [Microsoft’un Ekim 2026 duyurularını](https://github.com/dotnet/runtime/security/advisories/GHSA-846f-f764-76mx) ve [ikinci PKCS duyurusunu](https://github.com/dotnet/runtime/security/advisories/GHSA-2fmv-rv2c-59x7) kapsar. JSON sürümü [Microsoft’un düzeltilmiş sürüm tablosunun](https://github.com/dotnet/runtime/security/advisories/GHSA-8g4q-xg66-9fp4) üstündedir.

## AutoMapper sınırının kapsamı

`StartupBase.InitAutoMapper`, keşfedilen core/eklenti profillerini `AutoMapperConfig.CreateConfiguration` üzerinden oluşturur. Sınır tür eşlemesi başına uygulanır; 32 seviyeyi aşan aynı tür zincirinin devamı eşlenmez. Bu sınır bir veri tabanı şema değişikliği değildir; daha derin grafikler kullanan uygulama/eklenti akışları ayrıca değerlendirilmelidir. Düz modeller, mevcut hedef nesnesine eşleme ve koleksiyondaki ayrı nesneler kendi normal davranışlarını korur.

Bu önlem, [üreticinin önerdiği `MaxDepth` azaltımını](https://github.com/LuckyPennySoftware/AutoMapper/security/advisories/GHSA-rvv3-g6hj-g44x) uygular. **AutoMapper paketi yükseltilmedi ve NuGet uyarısı bastırılmadı.** 13.0.1 paketinin MIT lisansı korunur. Düzeltilmiş 15.1.1 sürümünün [lisans metni RPL 1.5 veya ayrı sözleşme koşullarını](https://github.com/LuckyPennySoftware/AutoMapper/blob/v15.1.1/LICENSE.md) içerdiği için bu geçiş otomatik yapılmadı. Paketin kendisinin değiştirilmesi/lisans kararı ayrı bir açık iştir.

## Yeniden doğrulama

Monorepo kökünden, .NET 8 SDK ile:

```sh
dotnet test tests/LocalDemo.Tests/LocalDemo.Tests.csproj -c Release --nologo
dotnet list tests/LocalDemo.Tests/LocalDemo.Tests.csproj package --vulnerable --include-transitive --format json
```

18 testin sekizi yeni regresyonlardır: 30 bin seviyeli profili sınırlama, küçük sınırı koruma, büyük sınırı engelleme, normal/mevcut nesneye eşleme, koleksiyon bütçesi, gerçek STARTTLS bağlantısında sahte tamponu reddetme, gerçek tenant e-posta servisinin doğru mağaza sırrıyla yerel alıcıya teslimi ve mağaza bağlamı olmadan bağlantı öncesi ret.

SMTP alıcıları yalnızca `127.0.0.1` üzerinde rastgele portlarda açılır. Parolalar ve TLS sertifikası test sırasında bellekte üretilir. Üretim sertifika doğrulaması değiştirilmez; test TLS istemcisi yalnızca kendi sertifikasını kabul eder. Dışarıya e-posta, push veya davet gönderilmez. İşletmenin gerçek SMTP hesabı kullanılmaz. Gerçek e-posta servisinin uyumluluk testi açıkça seçilmiş yerel, şifresiz test hesabı kullanır; bu ayar üretim önerisi değildir.

## Açık kalan bağımlılık uyarıları

Aynı NuGet denetimi aşağıdaki paketleri bildirmeye devam eder. Bu kayıtlar kapatılmış sayılmaz; yeni bağımlılık/üretim kararı öncesinde ele alınmalıdır:

- AutoMapper 13.0.1 — GHSA-rvv3-g6hj-g44x; uygulama düzeyinde yukarıdaki azaltım uygulanmıştır, paket halen etkilenmiş sürümdedir.
- SharpCompress 0.30.1 — GHSA-6c8g-7p36-r338; mevcut MongoDB.Driver 3.0.0 bağımlılık zincirinden gelir.
- Snappier 1.0.0 — GHSA-pggp-6c3x-2xmx; mevcut MongoDB.Driver 3.0.0 bağımlılık zincirinden gelir.

Makinenin .NET çalışma zamanının ve konteyner tabanlarının güncellenmesi ayrıca gerekir. Paket denetimi bu ortamların güvenlik durumunu kanıtlamaz. İmzalı iOS, gerçek cihazda bildirim/Crashlytics ve güncel sürümün canlı dağıtım kabulü bu kontrolün dışında kalır.

[Makinece okunabilir kabul kaydı](validation/macos-dependency-boundaries-20261017.json).
