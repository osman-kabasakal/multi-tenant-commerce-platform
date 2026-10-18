# Mevcut görselleri koruma kararı — 18 Ekim 2026

Proje sahibi, açık kaynak hazırlığında resim ve ikonlarda yapılan bütün değişikliklerin geri alınmasını; yalnızca yeniden dağıtım kısıtı somut olarak tespit edilen dosyaların değiştirilmesini istedi. Hazırlık öncesindeki mevcut Famizyo logosu, örnek ürün fotoğrafları, sağlayıcı/plugin logoları, mobil SVG/PNG ikonları, varsayılan Flutter ikonları, splash görselleri, bayraklar ve dosya tipi ikonları geri yüklendi. İkon fontları, CSS eşlemeleri ve LineIcons çağrıları da önceki durumuna döndü.

Yazarın son kaynak beyanına göre Flutter ekran/bileşen/Riverpod kodu kendisine ait; satın alınmış Foodu kiti renk/tema referansıdır. Bu nedenle hazırlık sırasında yapılan tema değişikliği de geri alındı. Yalnız kaynağı belirsiz olduğu için yenilenen sipariş sesi ve il dosyaları da korunan eski içeriklerine döndü. Satın alınmış kitin ZIP'i/orijinal kaynak paketi eklenmedi.

## Kayıtların anlamı

- `evidenced:<lisans>`: Dosyaya ilişkin kayıtlı lisans/dağıtım kanıtı bulunur; yöntemin sınırı `provenance.json` içindedir.
- `retained:license-unconfirmed`: Mevcut dosya proje sahibinin koruma kararıyla tutulmuştur. `license: NOASSERTION` ve `retained-existing-asset-user-direction` bu kararı kaydeder; dosyanın GPL olduğu, açık lisanslı olduğu veya ayrı bir hak sahibinden izin alındığı iddia edilmez.
- `review-provenance`: Henüz kaynak ya da koruma kararı kaydedilmemiş dosya. Envanter bunu görünür tutar.

Geri yüklenen dosyalar hazırlık öncesi Git içeriğiyle SHA-256 bazında karşılaştırıldı. Hash eşitliği, dosyanın değişmediğini gösterir; hukuki izin belgesi değildir. Mevcut fotoğraf veya marka için kanıtlanmış bir kısıt bulunursa yalnız ilgili dosya ele alınır. Kök kaynak kod lisansı, üçüncü taraf görsel veya marka haklarını kendiliğinden değiştirmez.

## Korunan somut düzeltmeler

| Bileşen | Somut dayanak | Uygulanan değişiklik |
| --- | --- | --- |
| IRANSansWeb font ailesi | Gömülü font kayıtları FontIran/Moslem Ebrahimi mülkiyetini ve tüm hakların saklı olduğunu belirtir; açık yeniden dağıtım grant'i içermez. FontIran'ın lisans metni proje lisansı gerektirir. | Font dosyaları public kaynak girdisinden çıkarıldı; RTL metin OFL Vazirmatn kullanır. B_Yekan/Yekan-modified aynı kesinlikte değerlendirilmedi ve geri yüklendi. |
| IOSSecuritySuite 2.1.0 | [Sürümün EULA'sı](https://github.com/securing/IOSSecuritySuite/blob/2.1.0/LICENSE), serbest kullanım ve dağıtımı sınırlayan koşullar içerir. | BSD-2-Clause 1.9.11 sürümüne sabitleme ve ilgili bildirimler korundu. |

IRANSans metadata: `Copyright (c) 2017 by www.fontiran.com (Moslem Ebrahimi). All rights reserved.`; sürüm 5.00. Lisans sahibi: [FontIran](https://fontiran.com); yayıncının lisans belgesinin [dağıtılan kopyası](https://www.chnaihe.ac.ir/public/IRANSans4/license.pdf). Bu kayıt diğer fontları yalnızca isimleri benziyor diye kısıtlı ilan etmez.

[Lisans incelemesi](../LICENSE_REVIEW.md) · [Dosya envanteri](assets.csv) · [Kaynak kapsamı](../../LICENSING.md).
