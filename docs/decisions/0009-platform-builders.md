# ADR-009: Linux Android ve Mac iOS çalışanlarının ortak planı

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Flutter kodu ortak olsa da iOS arşiv/IPA üretimi Xcode ve Apple imzası gerektirir. Linux sunucudaki Android işinin hazır olması Mac'in de erişilebilir veya anahtarının kullanıma açık olduğunu göstermez.

## Karar

Android Gradle Linux'ta, iOS Xcode Mac'te çalışır. Her iş tenant flavorını, public defines'ı, paket/Firebase kimliğini, logo/ikon/splash girdilerini ve imzalama referansını planla bağlar. Launcher icons ve native splash hazırlığı flavor üretimine dahildir. Artifact imzası ve iç kimliği kontrol edilir; App Distribution'dan bağımsız indirme ile hash eşitliği ayrıca doğrulanır.

## Alternatifler ve farkları

iOS'u Linux'ta üretme varsayımı çalışmaz. Ortak tek credential/sertifikayı paketten bağımsız seçmek yanlış uygulamayı imzalatabilir. Yalnız build komutunun exit code'una güvenmek paket/sertifika/simge içeriğini ve teslimi kanıtlamaz.

## Sonuçlar ve bedeller

Mac araç/SDK sürümleri, disk alanı, profile ve Keychain izinleri işletim gereksinimidir. Cihaz kabulü için UDID/profile ve fiziksel cihaz gerekir. App Distribution bir test teslim kanalıdır; App Store/Play yayımlama onayı değildir. Gözetimsiz Mac imzalama ayrıca kabul edilmelidir.

## Doğrulama ve açık sınır

Unsigned/native hazırlık, gerçek codesign/apksigner, profile/entitlement/paket eşleşmesi, sembol UUID ve teslim hashleri ayrı kontrol edilir. Kaynak/marka değişikliğinden sonra eski imzalı kabul yeni sürüme taşınmaz.

## Kaynaklar

[Android aracı](../../scripts/mobile_android.py) · [iOS aracı](../../scripts/mobile_ios.py) · [Mac worker](../../scripts/mobile_ios_worker.py) · [Markalama](../MOBILE_BRANDING.md)

[Karar dizinine dön](README.md).
