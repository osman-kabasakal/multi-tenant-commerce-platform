# Lisans kapsamı ve yeniden dağıtım sınırı

Yazar Osman Kabasakal, kendisine ait bağımsız SaaS/TenantManager ve diğer özgün kodları için **GPL-3.0-only** seçmiştir (18 Ekim 2026). Tam metin [LICENSE](LICENSE) dosyasındadır. Bu seçim, üçüncü taraf dosyaların mevcut lisansını değiştirmez ve yazara ait olmayan hakları vermez.

| Kapsam | Uygulanan kural |
| --- | --- |
| Yazara ait bağımsız sunucu kodu, araçlar ve özgün yeni kod | GPL-3.0-only; aksini belirten dosya/bileşen bildirimi yoksa |
| GrandNode tabanlı `Ecommerce/` | Mevcut [GPLv3 metni](Ecommerce/LICENSE) ve upstream dosya bildirimleri korunur |
| İsteğe bağlı Cloudflare görsel işçisi örneğinin upstream bölümleri | CC-BY-4.0 kaynak/atıf bildirimi korunur; kök GPL ile yeniden etiketlenmez |
| SaaS Clean Architecture başlangıç şablonu | Template 9.0.5 MIT bildirimi korunur; yazara ait iş/entegrasyon değişiklikleri GPL-3.0-only |
| MIT/Apache/BSD/OFL/ISC bileşen ve fontlar | Kendi sürüm/dosya lisansı ve attribution'ı geçerlidir |
| `Platforms/store_user_app` | Yazara ait ekran, Riverpod/API ve entegrasyon kodu GPL-3.0-only; font/ikonlar kendi bildirimleriyle |
| Satın alınmış UI kitinin orijinal kaynak paketi | Bu repoda yeniden dağıtılmaz; GPL kapsamına alınmaz |
| Yerel `nb_utils` | Orijinal MIT grant/attribution korunur; yanındaki ücretli UI'ye uygulanmaz |
| Özel runtime tenant görselleri, imzalar, credential ve müşteri verileri | Git dışında tutulur. Mevcut repo demo görselleri koruma kararına tabidir; kaynak kod lisansı üçüncü taraf marka/fotoğraf haklarını değiştirmez |
| Haricen indirilen konteynerler ve servisler | Kendi lisans/sözleşmeleri; repoya vendored değildir |

Yazarın netleştirdiği kaynak beyanına göre Flutter ekran/bileşenleri ve Riverpod tabanlı uygulama kendisine aittir; [Flutter Master Toolkit / Foodu](https://codecanyon.net/item/flutter-master-toolkit-the-biggest-flutter-ui-kit/55088981) yalnız renk/tema referansıdır. Mevcut tema ve görseller proje sahibinin kararıyla korunur; hazırlık sırasında yapılan görsel/ikon yenilemeleri geri alınmıştır. Dosyaya özel kanıt olmayan varlıklar `NOASSERTION` olarak kaydedilir; bu kayıt üçüncü taraf görsellerine GPL veya yeni bir yayın hakkı atfetmez. [Mevcut varlıkları koruma kararı](docs/licenses/ASSET_RETENTION.md).

Bir paketin ayrıca açık lisanslı dağıtılan parçaları (örneğin MIT `nb_utils` ve OFL fontlar) kendi grantleriyle kullanılabilir. Orijinal ücretli UI kiti ve varsa sonradan eklenecek ücretli kod/assetler, yalnız satın alınmış olmaları nedeniyle GPL sayılamaz; [Envato koşulları](https://codecanyon.net/licenses/terms/regular) kendi kapsamlarında kalır.

Bu dosya geçici olarak bütün monorepo için yayın izni verildiği şeklinde okunmamalıdır. Dosya/varlık ve resolved dependency incelemeleri [LICENSE_REVIEW.md](docs/LICENSE_REVIEW.md) içinde tutulur. Dosya bazlı kanıt [provenance.json](docs/licenses/provenance.json), kapsam envanteri [assets.csv](docs/licenses/assets.csv) içindedir. Bir dosyanın hash'i değişirse eski kanıt yeni içeriğe uygulanmaz. Envanter tek başına hak yaratmaz.

## Dağıtım biçimi

GPL kapsamındaki kod dağıtılırken kaynak, lisans ve ilgili bildirim yükümlülükleri korunmalıdır. Üçüncü taraf notice/font lisansları paketle birlikte tutulmalıdır. Uygulama binary'si, Docker imajı, mobil paket veya değiştirilmiş kaynak dağıtımı için resolved bağımlılıklar ayrıca incelenmelidir. Bütün bağımlılıkların tek bir GPL etiketiyle yeniden lisanslandığı varsayılmaz.

Eski private Git commitleri bugün kaldırılmış kısıtlı fontları içerebilir; güncel envanter yalnız güncel dosyaları kapsar. Mevcut repoyu public yapmak o commitleri de açar. Public aday, hak incelemesi tamamlanan güncel dosyalardan **ayrı ve temiz geçmişle** oluşturulmalıdır. [Yayın adımları](docs/PUBLIC_RELEASE.md).

[Third-party notices](THIRD_PARTY_NOTICES.md) · [Yerel değişiklik bildirimi](NOTICE.md) · [Yayın durumu](docs/LICENSE_REVIEW.md).
