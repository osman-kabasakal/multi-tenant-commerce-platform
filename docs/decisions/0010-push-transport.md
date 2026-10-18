# ADR-010: Android FCM ve iOS doğrudan APNs

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Çok tenant Firebase projelerinde APNs anahtarı ayarını her projede elle tekrarlamak otomasyonu zorlaştırır. iOS native APNs kaydı ile FCM tokenı aynı veri değildir. Bildirim izninin açık olması sunucuda alıcı kaydının oluştuğunu tek başına göstermez.

## Karar

Android FCM, iOS doğrudan APNs taşıması kullanır. iOS native tokenı, uygulamanın takım/paket/ortam kimliğine bağlı kayıt biçimiyle sunucuya iletilir. Team scoped APNs anahtarı uygun tenant topiclerine sunucuda gönderim için kullanılır. Admin gönderimi, doğrulanmış müşteri/alıcı ve aktif uygulama kimliği üzerinden yürür; tokenlar sender tarafında tekilleştirilir. Bağlantı AASA/assetlinks ve tenant route kurallarıyla sınırlandırılır.

## Alternatifler ve farkları

iOS'u zorunlu FCM tokenına bağlamak Firebase projesindeki APNs ayarına ek bağımlılık getirir. Her tenant için ayrı APNs anahtarı üretmek gereksiz anahtar çoğalmasına yol açabilir. Aynı tokenı bütün kimlikler için kabul etmek farklı tenant/topic eşleşmesini bozar.

## Sonuçlar ve bedeller

İki push taşımasının hata/yenileme davranışı izlenmelidir. Auth key, distribution sertifikası ve App Store Connect API anahtarı birbirinin yerine geçmez. Mevcut ilk kayıt yarışında aynı token için yinelenen DB satırı oluşabilir; satır sayısı tekil cihaz sayısı değildir.

## Doğrulama ve açık sınır

iPhone native kayıt → gerçek admin formu → tek provider kabulü → cihazda görünüm → sepete yönlenme canlıda doğrulandı. İşletme bildirim ikonu cihaz yeniden başladıktan sonra doğrulandı. Fiziksel Android bildirimi, gerçek crash ve bütün cold-start/external-link çeşitleri açık kabul maddeleridir.

## Kaynaklar

[Mobil bildirim](../MOBILE_NOTIFICATIONS.md) · [Dağıtık bildirim](../DISTRIBUTED_NOTIFICATIONS.md) · [Bildirim testleri](../../tests/Notifications.Tests) · [Canlı kanıt](../VALIDATION.md)

[Karar dizinine dön](README.md).
