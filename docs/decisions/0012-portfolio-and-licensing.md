# ADR-012: Portföy kapsamı ve dosya bazlı yayın hakkı

- Tarih: 2026-10-18
- Durum: Kabul edilen yayın yönü
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Ticari hedef; tema uyumu, POS/stok, kurye, pazaryeri, fatura ve ödeme çeşitliliği gibi mevcut kabul kapsamının çok ötesindedir. Proje şimdi öğrenilebilir ve dürüst bir portföy örneği olarak hazırlanıyor. Yazara ait Flutter ekran/Riverpod kodu ile renk referansı alınan ücretli UI kitinin kendisi ve üçüncü taraf varlıklar ayrı değerlendirilir.

## Karar

Yazara ait bağımsız kod için GPL-3.0-only seçimi uygulanır; GrandNode ve diğer bileşenlerin bildirimleri korunur. Sahibinin kaynak beyanı kaydedilir; ücretli kit yeniden dağıtılmaz. Mevcut tema, görseller ve ikonlar korunur; 18 Ekim'de hazırlık sırasında yapılan görsel yenilemeler sahibinin kararıyla geri alınmıştır. Yalnız somut kısıt bulunan dosyalar değiştirilir. Lisans kanıtı ile mevcut dosyayı koruma kararı envanterde ayrı gösterilir; belirsiz varlıklar GPL ile yeniden etiketlenmez. Kaynak koruması, varlık envanteri ve hak incelemesi ayrı kontrollerdir. Public yayın, temiz ve hakları tamamlanmış yeni snapshot geçmişiyle yapılmalıdır.

## Alternatifler ve farkları

Bir kök lisans ekleyip bütün dosyaları sahiplenmek yanlış olur. Sadece ikonları veya değişken adlarını değiştirmek satın alınan kodun türevini temizlemez. Mevcut private repoyu public yapmak geçmiş commitlerdeki kaldırılmış kaynak/varlıkları da açar.

## Sonuçlar ve bedeller

Public yayın kalan dosya/hak kontrolü ve temiz doğrulama bitene kadar bekler. Envanter, hukuki izin üretmez ve transitive bağımlılıkların tam SBOM'u değildir. Önceki özel mobil kabul ve güncel geri alma kontrolleri kendi kaynak sürümlerine aittir. Ticari entegrasyonlar bu yayın için tamamlanmış gibi gösterilmez.

## Doğrulama ve açık sınır

Kaynak/asset hashleri ve korunmuş bildirimler, sahiplik beyanı ve mevcut varlıkları koruma kaydı, temiz snapshot secret taraması ve yeni mobil/web kontrolleri gerekir. Somut yeniden dağıtım kısıtı release blocker olarak kalır; yeşil smoke test onu kapatmaz.

## Kaynaklar

[Lisans kapsamı](../../LICENSING.md) · [Hak incelemesi](../LICENSE_REVIEW.md) · [Yayın kapısı](../PUBLIC_RELEASE.md) · [Yol haritası](../ROADMAP.md)

[Karar dizinine dön](README.md).
