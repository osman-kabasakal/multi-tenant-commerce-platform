# ADR-008: Domain ve mobil kimliği sürümlü geçiş olarak yönetmek

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

İşletme ilk kayıtta veya daha sonra kendi domainini kullanabilir. Yeni paket adı istendiğinde Android/iOS uygulamaları, Firebase kayıtları ve imzalar birlikte değişir. Mac çevrimdışıyken yalnız Android hazır olduğu için çalışan kimlik erken değişmemelidir.

## Karar

Cloudflare erişimi, tenant'a benzersiz tahsis, DNS TXT sahipliği ve çakışma kuralları ayrı doğrulanır. Yeni paketler aynı Firebase projesinde ayrı Android/iOS uygulamaları olarak açılır. Kimlik, sertifika ve kaynak planı dondurulur. İki platformun gerçek imzalı teslim makbuzu tamamlanınca yeni kimlik etkinleşir, önceki kimlik geçmişte korunur. Yayımlanmamış plan onarımı operatör yolundan eklemeli audit geçmişiyle yapılır.

## Alternatifler ve farkları

Paket adını zorunlu olarak sabit tutmak kullanıcının domain/paket yenileme isteğini karşılamaz. Firebase uygulama kaydının adını değiştirmek mağaza paketini dönüştürmez. Tek platform başarısında aktivasyon, diğer platformu uyumsuz bırakabilir.

## Sonuçlar ve bedeller

Daha çok uygulama/sertifika/derleme kaydı ve uzun bekleyen geçiş durumu vardır. Eski mağaza uygulamasının kullanıcı tabanı kendiliğinden yeni pakete taşınmaz; app-store geçişi ayrı ürün operasyonudur. Yeni kaynak, eski imzalı plana sessizce yazılamaz.

## Doğrulama ve açık sınır

Sahiplik/tekil domain/çakışma reddi; gerçek TLS ve storefront-admin ayrımı; Firebase paket/Team ID/fingerprint; tek platform beklerken eski aktif kimlik ve iki makbuz sonrası yeni aktivasyon kontrol edilir.

## Kaynaklar

[Domain ve kimlik rehberi](../TENANT_DOMAINS_AND_MOBILE_IDENTITIES.md) · [Portal build servisi](../../SaasManager/src/Infrastructure/PortableAppBuilds.cs) · [iOS kuyruğu](../../Shared/Platform.Provisioning/PostgresIosReleaseQueue.cs)

[Karar dizinine dön](README.md).
