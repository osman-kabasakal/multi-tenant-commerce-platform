# Lisans ve varlık incelemesi — 18 Ekim 2026

Yazara ait bağımsız kodlar GPL-3.0-only; GrandNode ve üçüncü taraf bildirimleri korunur. Proje sahibinin son kararıyla görsel yenileme geri alındı. Yalnızca somut kısıtı belirlenen dosyalar değiştirilir; kaynak belirsizliği tek başına görsel değiştirme nedeni değildir.

## Yazarlık ve kapsam

Yazar SaasManager/TenantManager ve Flutter ekran/bileşen/Riverpod/API kodunun kendisine ait olduğunu bildirdi. Foodu kitinden kullanılan kısmı renk/tema referansı olarak netleştirdi. Bu beyan esas alınır; Flutter teması ve mevcut ekran kodu korunur. Satın alınmış kitin orijinal ZIP'i/kaynak paketi dağıtıma eklenmez.

Yerel device-integrity modülü yazarın uygulamasıdır; RootBeer ve IOSSecuritySuite kendi lisanslarını korur. Benzer adlı BSD referans projenin bildirimi referans atfıdır; birebir upstream fork olduğu iddia edilmez.

## Güncel değişiklikler

| Kapsam | Durum | Kayıt |
| --- | --- | --- |
| Bağımsız kaynaklar ve GrandNode | Kök GPL metni eklendi; mevcut GPLv3 ve bileşen başlıkları korundu | [LICENSING](../LICENSING.md), [NOTICE](../NOTICE.md) |
| Mevcut resim/ikonlar | Famizyo, ürün fotoğrafları, mobil/default Flutter ikonları, bayraklar ve diğer görseller hazırlık öncesi içerikleriyle geri yüklendi | [Koruma kararı](licenses/ASSET_RETENTION.md) |
| İkon fontları ve tema | LineAwesome/LineIcons, Glyphicons, Simple Line font/CSS ve Flutter teması geri yüklendi | Değişiklik yerine mevcut bildirimler korunur |
| IRANSansWeb | Font metadata'sındaki mülkiyet kaydı ve lisans koşulları nedeniyle açık kaynak girdisinden çıkarıldı; OFL Vazirmatn kullanılır | [Somut dayanak](licenses/ASSET_RETENTION.md#korunan-somut-düzeltmeler), [OFL](licenses/upstream/Vazirmatn-OFL.txt) |
| B_Yekan / Yekan-modified | Kesin kısıt kaydı olmadan çıkarılmaları geri alındı | `NOASSERTION`; açık lisans iddia edilmez |
| IOSSecuritySuite | Kısıtlı 2.1.0 EULA yerine BSD-2-Clause 1.9.11 sabitlemesi korundu | [Sürüm lisansı](licenses/upstream/IOSSecuritySuite-1.9.11-BSD-2-Clause.txt) |
| Diğer font/paket bildirimleri | Urbanist, Poppins, Source Sans, Font Awesome, Droid Kufi/Open Sans ve bileşen notice metinleri korundu | [Üçüncü taraf tablosu](../THIRD_PARTY_NOTICES.md) |
| SaaS şablonu / Cloudflare örneği | Eksik MIT / CC-BY-4.0 atıfları eklendi | [Şablon metni](licenses/upstream/CleanArchitecture-9.0.5-MIT.txt), [Cloudflare NOTICE](../cloudflare_image_resizing_worker/famizyo-image-resizing-worker/NOTICE.md) |
| Sipariş sesi / il dosyaları | Kesin kısıt saptanmadan yapılan yeniden üretimler geri alındı | Mevcut dosyalar korunur |
| Gizli girdiler | Credential, imza materyali ve özel runtime verileri Git dışında tutulur | Dosya koruması ve temiz snapshot taraması |

## Kanıtı nasıl okumalı?

`provenance.json` dosya özeti, kaynak, bildirim ve yöntemi tutar. `exact-sha256` veya `decoded-RGBA-equivalence` kayıtları kendi doğrulama kapsamındadır. `bundled-component-license` bileşenin dağıtılan lisansına dayanır; ayrı bir fotoğraf sahibinden alınmış izin belgesi değildir.

Geri yüklenen varlıkların `NOASSERTION` kaydı yalnız proje sahibinin mevcut dosyayı koruma kararını belgeler. Bunlar `evidenced` sayılmaz; “bütün görsellerin açık lisansı kanıtlandı” sonucu çıkarılmaz. Değişen dosyanın hash'i eski kayıtla kabul edilmez. [Koruma politikasının ayrıntıları](licenses/ASSET_RETENTION.md).

## Open items

1. Güncel snapshot üzerinde kaynak, envanter ve secret kontrollerini kaydetmek; önceki farklı görsel sürümünün doğrulamasını bugünkü içerikle karıştırmamak.
2. Geliştirme geçmişini koruyup yalnız [belirlenmiş kısıtlı font yollarını ve blob içeriklerini](licenses/history-removals.json) bütün geçmişten temizlemek; commit metadatası/parent sırası ve diğer bütün tarihsel dosyaları karşılaştırmak. Geçmişsiz yeni başlangıç zorunlu değildir.
3. Binary/container dağıtımı için resolved bağımlılık bildirimleri ve SBOM'u bakım yol haritasında takip etmek.

Kaynak incelemesi bütün transitive bağımlılıkların hukuki onayı değildir. Somut bir hak ihlali bildirimi geldiğinde ilgili dosya ve kaynağı değerlendirilir; tüm görseller topluca değiştirilmez.

## Yeniden kontrol

```sh
python3 scripts/asset_inventory.py --index
# Yenilenen CSV'leri stage edin.
python3 scripts/asset_inventory.py --index --check --require-reviewed
python3 scripts/check_public_source.py
```

`--require-reviewed`, lisans kanıtını veya açık mevcut-dosya koruma kararını arar. Koruma kararı bir lisans grant'i olarak sunulmaz. [Temiz yayın adımları](PUBLIC_RELEASE.md).

SaaS şablon kaydı: [9.0.5 NuGet paketi](https://www.nuget.org/packages/Clean.Architecture.Solution.Template/9.0.5) metadata'sı MIT, yazar JasonTaylorDev der. Paket SHA-256: `42a56a122a3ee5b6d75332b6fb59757b98258f2887e1d778a088296279a4b737`. Tam bildirim publisher'ın [upstream LICENSE](https://github.com/jasontaylordev/CleanArchitecture/blob/main/LICENSE) dosyasından korunmuştur; bulunmayan bir Git tag'i doğrulanmış gibi gösterilmez.
