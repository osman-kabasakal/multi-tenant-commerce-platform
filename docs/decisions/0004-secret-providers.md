# ADR-004: Şifreleme sağlayıcısını DI ile seçmek

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Azure şifrelemeye doğrudan bağımlılık, bulut hesabı olmadan çalıştırmayı ve birden fazla süreçten tenant secret erişimini zorlaştırır. Secretın saklanması ile şifreleme algoritması/anahtar sağlayıcısı ayrı sorumluluklardır.

## Karar

Ortak security sözleşmeleri DI ile bağlanır. Local ve Portable sağlayıcılar ortak AES-GCM zarfı/anahtar davranışını kullanır; PortableEncryptionService bu davranışı açıkça sarar. Azure adaptörü ayrı seçilebilir. Şifreli tenant kayıtları ortak Postgres deposundan yetkili sunucu tarafından çalışma anında çözülür. İş kuyruğu ve public mobil defines yalnız referans/izinli public bilgiyi taşır.

## Alternatifler ve farkları

Yalnız Azure desteği demo taşınabilirliğini azaltır. Düz metin tenant parolası veya iş metadata'sına credential yazmak dağıtımı kolaylaştırsa da secret sınırını yok eder. Her süreçte ayrı rastgele master key üretmek ortak kayıtların çözülememesine yol açar.

## Sonuçlar ve bedeller

Aynı master key bütün yetkili süreçlere güvenli sağlanmalı ve DB'den ayrı yedeklenmelidir. Anahtar rotasyonu/ciphertext göçü açık işlem gerektirir; Azure ciphertext'i yerel sağlayıcıda kendiliğinden çalışmaz. Bir algoritma arayüzü, key yönetimi ve yetkilendirmenin yerine geçmez.

## Doğrulama ve açık sınır

Çok instance'ta aynı kayıt çözümü, yanlış anahtar/tahrif edilmiş zarf reddi, tenant sahipliği ve en az yetkiyle okuma test edilir. Yedek restore denemesi secret DB ile doğru anahtarın birlikte bulunmasını kapsamalıdır.

## Kaynaklar

[Security DI](../../Shared/Platform.Security/DependencyInjection.cs) · [Portable adaptör](../../Shared/Platform.Security/PortableEncryptionService.cs) · [İşletim/göç sınırı](../TENANT_SECURITY.md)

[Karar dizinine dön](README.md).
