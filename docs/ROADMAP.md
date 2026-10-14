# Yayın yol haritası

## Bu hazırlık sürümü

- Ayrı klasörde, eski Git geçmişini taşımayan monorepo.
- Gizli yapılandırmalar, müşteri verisi ve mobil imzalama dosyaları dışarıda.
- Yerel Keycloak, MongoDB, PostgreSQL, Redis; gerçek .NET mağaza motoru.
- İki örnek tenant, gerçek katalog ve mağaza yönetimi.
- SaaS önizleme; bulut kurulum/ödeme işlemleri kapalı.
- Flutter debug profili; ARM64 Android APK derlemesi ve emülatörde katalog/ürün/sepet akışı doğrulandı.
- CodeGraph ile ilişkiler keşfedilebilir; indeks Git'e girmez.

## Private yayın

- `osman-kabasakal/multi-tenant-commerce-platform` private olarak oluşturuldu; temiz ilk commit gönderildi.
- İki sipariş PDF’si gönderilen Git geçmişinden çıkarıldı; kaynak koruması eklendi.
- Urbanist/Poppins lisans dosyaları tamamlandı. 3.660 varlık ve 134 lisans/bağımlılık girdisi envantere alındı.
- Ayrıntılı açık hak kararları: [LICENSE_REVIEW.md](LICENSE_REVIEW.md).
- Temiz Ubuntu kaynak/web/Android CI sonuçları: [VALIDATION.md](VALIDATION.md).

## Herkese açık GitHub sürümünden önce

1. `THIRD_PARTY_NOTICES.md` içindeki lisans/varlık haklarını netleştir; eksik lisanslı modülü lisansla veya değiştir.
2. Yerel demoyu temiz bir Linux/CI makinesinde `up` + `smoke` ile doğrula; test edilmeyen kapsamı `docs/VALIDATION.md` içinde açık tut.
3. Eski kaynaklarda bulunmuş gerçek anahtarları ilgili sağlayıcılarda yenile. Temiz kopya, eski anahtarları iptal etmez.
4. .NET 8/9 ve eski istemci bağımlılıkları için yükseltme planını uygula; ayrıntılı dependency/security taramasını tamamla.
5. Demo ekran görüntüleri, kısa tanıtım videosu, mimari anlatımı ve katkı rehberi ekle.
6. Son kaynak taraması ve hak kararları tamamlandıktan sonra public görünürlüğe geçişi ayrıca değerlendir; ilk herkese açık sürümü etiketle ve paylaş.

## Sonraki teknik aşamalar

- SaaS panelinden yeni yerel tenant yaratma: sabit iki tenant yerine ayrı ve test edilebilir local provisioning akışı.
- Keycloak grup/rol tabanlı mağaza yönetimi; çapraz tenant yetki testleri.
- Simüle ödeme, sipariş, e-posta ve bildirim senaryoları.
- Elle doğrulanan Android akışlarını otomatik emülatör testlerine taşı; iOS simülatör akışını doğrula.
- Azure ve Google/Firebase için ayrı opt-in bulut profili: plan/dry-run, minimum yetki, kaynak sınırı, maliyet ve temizleme adımları.
- CI/CD: önce doğrulama; bulut dağıtımı yalnızca açık yapılandırma ve environment onayı ile.

## İş başvurularında anlatılabilecek kapsam

GrandNode tabanlı ticaret motorunu; tenant bazında veri ayrımı, Keycloak token doğrulaması, SaaS kayıt/orchestration modeli ve Flutter istemciyle birleştiren bir platform çalışması. Hazır bileşenler ile projeye özgü entegrasyonlar ayrı ayrı belirtilmeli. Yerel demoda doğrulanmayan bulut dağıtımı veya mobil yayın akışları için “tamamlandı” ifadesi kullanılmamalı.
