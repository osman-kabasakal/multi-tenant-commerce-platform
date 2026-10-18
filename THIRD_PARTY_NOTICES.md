# Third-party notices

Yazara ait bağımsız kod GPL-3.0-only; aşağıdaki bileşenler kendi lisans/attribution'larını korur. Kök lisans üçüncü taraf dosyaları yeniden lisanslamaz. [Kapsam](LICENSING.md), [dosya kanıtları](docs/licenses/provenance.json), [varlık envanteri](docs/licenses/assets.csv).

| Bileşen | Lisans / kapsam | Bildirim |
| --- | --- | --- |
| Cloudflare görsel işçisi örneği | Cloudflare dokümantasyon örneği CC-BY-4.0; yerel katkılar ayrı | [Yerel atıf ve değişiklikler](cloudflare_image_resizing_worker/famizyo-image-resizing-worker/NOTICE.md), [korunan metin](docs/licenses/upstream/Cloudflare-docs-CC-BY-4.0.txt) |
| SaaS başlangıç şablonu: Clean.Architecture.Solution.Template 9.0.5 | MIT, JasonTaylorDev; özgün iş kodundan ayrı | [Korunan MIT metni](docs/licenses/upstream/CleanArchitecture-9.0.5-MIT.txt); tam 9.0.5 NuGet metadata'sı MIT beyan eder |
| GrandNode türevi commerce | Mevcut GPLv3 | [Ecommerce/LICENSE](Ecommerce/LICENSE); kaynak başlıkları korunur |
| Fine Uploader / Roxy Fileman | Dağıtılan kopyaların GPLv3 bildirimi | Kendi dizinlerindeki LICENSE/ LICENSE.txt korunur; yeni assetler varsa ayrıca belirtilir |
| Kendo UI Core 2021.3.914 | Apache-2.0 | [Kanonik paket bildirimi](docs/licenses/upstream/kendo-ui-core-2021.3.914-Apache-2.0.txt), [tam Apache metni](docs/licenses/Apache-2.0.txt) |
| Kendo Grid 2014.1.318 | Dağıtılan dosya başlığındaki GPLv3 seçeneği | Çevre klasörünün 2021.3.914 adı grid'in sürümü değildir; ticari lisans varsayılmaz |
| Admin tema | MIT; Aigars Silkalns, Colorlib, Morteza Karimi | `Ecommerce/src/Web/Grand.SharedUIResources/wwwroot/administration/License.txt` |
| jQuery UI ve temaları | MIT | [1.12.1 bildirimi](docs/licenses/upstream/jquery-ui-themes-1.12.1-MIT.txt); paket kanıtı dosya bazlıdır |
| elFinder | BSD-3-Clause, Studio 42 | [2.1.61 bildirimi](docs/licenses/upstream/elfinder-BSD-3-Clause.txt) |
| Bootstrap 3.3.7 / Glyphicons | Paketin MIT grant'i | [Bildirim](docs/licenses/upstream/Bootstrap-3.3.7-MIT.txt); mevcut font dosyaları ve eşlemeler korundu; paket grant'i dosya bazlı kesinlik yerine geçirilmez |
| Simple Line Icons 2.5.5 | MIT | [Bildirim](docs/licenses/upstream/simple-line-icons-2.5.5-MIT.txt); mevcut font/CSS ve yerel bildirim korundu |
| Summernote | MIT; dağıtılan sürüm bildirimi | [0.8.18 bildirimi](docs/licenses/upstream/summernote-0.8.18-MIT.txt); kendi retained notices dosyası da korunur |
| nb_utils 7.0.4 yerel kopyası | MIT, Bhoomin Naik | [Orijinal LICENSE](Platforms/modules/nb_utils/LICENSE), [paket bildirimi](docs/licenses/upstream/nb-utils-7.0.4-MIT.txt) |
| Urbanist / Poppins / Vazirmatn | SIL OFL 1.1 | Fontların yanındaki OFL dosyaları; [Vazirmatn](docs/licenses/upstream/Vazirmatn-OFL.txt) |
| Source Sans Pro 2.021 / Font Awesome 4.7.0 | SIL OFL 1.1 | [Source Sans](docs/licenses/upstream/Source-Sans-Pro-2.021-OFL.txt), [Font Awesome](docs/licenses/upstream/Font-Awesome-4.7.0-OFL.txt) |
| Droid Arabic Kufi 1.00 / Open Sans 1.10 | Gömülü font kayıtlarındaki Apache-2.0 | [Telif/versiyon kaydı](docs/licenses/upstream/Droid-Kufi-and-Open-Sans-NOTICE.txt), [tam metin](docs/licenses/Apache-2.0.txt) |
| FamFamFam flag icons | Yazar Mark James'in public-domain beyanı | [Orijinal readme](docs/licenses/upstream/FamFamFam-flags-Public-Domain.txt) |
| RootBeer 0.1.1 | Apache-2.0 | [Sürüm lisansı](docs/licenses/upstream/RootBeer-Apache-2.0.txt) |
| IOSSecuritySuite 1.9.11 | BSD-2-Clause | [Sürüm lisansı](docs/licenses/upstream/IOSSecuritySuite-1.9.11-BSD-2-Clause.txt); 2.1.0 EULA'sı bu sürüme uygulanmaz |
| flutter_jailbreak_detection referans projesi | BSD-3-Clause referans bildirimi | [Korunan upstream referans](docs/licenses/upstream/flutter-jailbreak-detection-BSD-3-Clause.txt); yerel modülün kaynak beyanı kendi README'sindedir |

Hazırlık sırasında yapılan katalog/ikon/ses yenilemeleri geri alındı. Mevcut görsel, ikon fontu ve sesler [koruma kararı](docs/licenses/ASSET_RETENTION.md) kapsamında tutulur; `NOASSERTION` kayıtları için açık lisans iddia edilmez. İşletme veya sağlayıcı adını gösteren metinler/markalar bir onay/iş ortaklığı veya marka hakkı devri anlamına gelmez. Gerçek tenant markalaması Git dışındadır.

Satın alınmış Flutter Master Toolkit/Foodu paketinin kendisi yeniden dağıtılmaz. Yazar; ekran, bileşen, Riverpod ve API kodunun kendisine ait olduğunu, kitin renk/tema referansı olarak kullanıldığını netleştirmiştir. MIT nb_utils ve OFL fontların bağımsız grantleri ayrıca korunur.

NuGet/npm/Dart/CocoaPods/Gradle paketleri ve dış servis imajları kendi şartlarını korur. Buradaki tablo tam transitive SBOM veya bütün binary dağıtım biçimlerinin onayı değildir. MongoDB/Redis gibi dış imajlar kök GPL altında yeniden lisanslanmış sayılmaz. [Yayın kontrolü](docs/PUBLIC_RELEASE.md).
