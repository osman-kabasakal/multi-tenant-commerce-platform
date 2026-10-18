# Mimari karar kayıtları

Bu kayıtlar **18 Ekim 2026 tarihinde mevcut uygulamadan geriye dönük hazırlanmıştır**. Her kayıt; bağlamı, mevcut kararı, alternatiflerin farkını, bedelleri ve kabul sınırını açıklar. Geçmişte yapılmamış bir karar toplantısı veya benchmark varsayılmaz. Yeni bir kararda eski kaydı silmek yerine onu değiştiren yeni ADR ekleyin.

| Kayıt | Konu | Durum |
| --- | --- | --- |
| [ADR-001](0001-shared-runtime.md) | Ortak çalışma ortamı, tenant başına ticaret verisi | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-002](0002-persistence.md) | SaaS için EF Core, kalıcı işler için açık SQL | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-003](0003-identity-boundaries.md) | Portal kullanıcısı ve tenant servis istemcisi ayrımı | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-004](0004-secret-providers.md) | Şifreleme sağlayıcısını DI ile seçmek | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-005](0005-durable-work.md) | Kalıcı kurulum işleri, checkpoint ve fencing | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-006](0006-build-roles.md) | BuildType ile host ve eklenti çıktılarını ayırmak | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-007](0007-opt-in-cloud.md) | Yerel demo ve açıkça seçilen bulut sağlayıcıları | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-008](0008-versioned-identities.md) | Domain ve mobil kimliği sürümlü geçiş olarak yönetmek | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-009](0009-platform-builders.md) | Linux Android ve Mac iOS çalışanlarının ortak planı | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-010](0010-push-transport.md) | Android FCM ve iOS doğrudan APNs | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-011](0011-tenant-scheduling.md) | Tekrarlanan görevleri web süreçlerinden ayırmak | Mevcut uygulamanın geriye dönük kaydı |
| [ADR-012](0012-portfolio-and-licensing.md) | Portföy kapsamı ve dosya bazlı yayın hakkı | Kabul edilen yayın yönü |

## Yeni kayıt şablonu

Yeni ADR; tarih/durum, bağlam, karar, gerçek alternatifler, sonuçlar, kaynak bağlantıları ve doğrulama sınırını içermelidir. Öneri henüz uygulanmadıysa bunu “önerilen” olarak işaretleyin. Koddaki değişiklik ve ilgili kabul kanıtı yoksa “tamamlandı” yazmayın.

[Mimari](../ARCHITECTURE.md) · [Teknolojiler](../TECHNOLOGY.md) · [Yol haritası](../ROADMAP.md).
