# ADR-003: Portal kullanıcısı ve tenant servis istemcisi ayrımı

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Portal işletme sahibi, mağaza müşterisi ve gateway sunucusu aynı güvenlik öznesi değildir. Confidential Keycloak istemci secretını mobil/tarayıcıya koymak, onu herkesin çıkarabileceği bir bilgiye dönüştürür.

## Karar

Portal sahibi Keycloak OIDC oturumuyla doğrulanır. Gateway bilinen tenant için sunucu tarafında client credentials alır; secret istemciye verilmez. Commerce, tokenın imzası/issuer/audience/süre ve tenant bağını doğrular. GrandNode müşteri/admin oturumları ayrıca yürür. Local admin profilinde GrandNode parola doğrulaması kullanılır.

## Alternatifler ve farkları

Her mobil uygulamada client secret taşımak kimlik güvencesi sağlamaz. Yalnız host/paket başlığına güvenmek taklit edilebilir. Bütün son kullanıcı akışını tek SSO'ya geçirmek ayrı ürün/kimlik geçişidir; mevcut Local kabul bunu kapsamaz.

## Sonuçlar ve bedeller

Gateway ve identity hizmeti erişim zincirinin parçası olur. Token cache, proxy trust ve route yayınlama ayrı korunmalıdır. Servis tokenı cihaz attestation'ı, API anahtarı müşteri oturumu veya paket adı sahiplik kanıtı değildir. Admin hostuna ulaşabilmek admin yetkisi vermez.

## Doğrulama ve açık sınır

Bozuk imza, yanlış audience/issuer/tenant, süresi dolmuş token ve bilinmeyen host reddi; storefront hostunda Admin yollarının açılmaması; sahiplik kontrolleri sınanır. Mock binding testlerinde filtre kapatılması uçtan uca auth kanıtı sayılmaz.

## Kaynaklar

[Gateway](../GATEWAY.md) · [Gateway testleri](../../tests/Gateway.Tests) · [Kayıt güvenliği](../../tests/Registration.Security.Tests)

[Karar dizinine dön](README.md).
