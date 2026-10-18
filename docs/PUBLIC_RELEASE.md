# Temiz public sürüm hazırlama

Bu belge kaynak yayınını anlatır. Mevcut repo private kalır; bu hazırlık sırasında GitHub görünürlüğü değiştirilmez. Kök GPL metni, üçüncü taraf haklarını veya geçmiş commitleri otomatik temizlemez.

## 1. Kapsamı sabitle

Yazarın bağımsız kodu GPL-3.0-only; GrandNode ve diğer paket bildirimleri korunur. Flutter ekran/Riverpod kodu yazara aittir; ücretli UI kiti dağıtım girdisi değildir. Bilinen font/ikon değişiklikleri [NOTICE](../NOTICE.md), dosya bazlı kanıtlar [provenance.json](licenses/provenance.json) içindedir.

Somut kısıtı saptanan dosyalar [LICENSE_REVIEW.md](LICENSE_REVIEW.md) içinde ele alınır. Mevcut görseller [koruma kararı](licenses/ASSET_RETENTION.md) kapsamında tutulur; belirsizlik tek başına toplu değiştirme nedeni değildir. Yeni artifact/asset girdiğinde yalnız dosya adını değil içeriğini ve kaynağını gözden geçirin. Salt envanter üretmek izin belgesi oluşturmaz.

## 2. Aday kaynağı seç ve doğrula

Önce yalnız bu yayınla ilgili değişiklikleri review edip stage edin. İlgisiz kullanıcı değişiklikleri adaya dahil edilmemelidir. Aşağıdaki `--index` seçimi staged blobları okur; çalışma dizinindeki bağımsız değişiklikler yayın girdisi olmaz.

```sh
python3 scripts/asset_inventory.py --index
# Envanter CSV'lerini de gözden geçirip stage edin.
python3 scripts/asset_inventory.py --index --check --require-reviewed
python3 scripts/check_public_source.py
```

`--require-reviewed`, dosya bazlı lisans kanıtı veya açık mevcut-dosya koruma kararı olmayan varlıkta başarısız olur. `retained:license-unconfirmed` durumu lisans grant'i değildir. Kanıtlı dosyanın hash'i değiştiyse eski kanıtla devam edilmez. Bir bağımlılığın source grant'i ile binary notice yükümlülükleri farklı olabilir; resolved dependency/SBOM işi [yol haritasında](ROADMAP.md) izlenir.

Aday üzerinde ilgili Python/.NET/portal/Flutter kontrollerini çalıştırın. Ardından temiz Linux ortamında `python3 scripts/demo.py up` ve `smoke` çalıştırın. `.github/workflows/verify.yml` kontrol gruplarını tanımlar; GitHub Actions kotası doluysa aynı kontroller mevcut CI veya yerel izole Linux üzerinde yapılabilir. Önceki commitin yeşil CI sonucu yeni adayın sonucu olarak gösterilmez.

## 3. Eski ancestry'yi taşımadan snapshot oluştur

Private geçmiş kaldırılmış kısıtlı fontları içerebilir; güncel dosya kontrolleri geçmişteki girdileri kapsamaz. Güncel dalı doğrudan public yapmayın, private geçmişi bu işlem için zorla yeniden yazmayın.

```sh
# Çıktı klasörü daha önce var olmamalıdır. Gitleaks kurulu olmalıdır.
python3 scripts/prepare_public_release.py \
  --output .local/public-candidate \
  --gitleaks /path/to/gitleaks
```

Araç staged tree'den dosya snapshot'ı çıkarır; eski commit/remote/credentialları kopyalamaz. Yeni yerel adayda ayrı Git deposu/index oluşturup kaynak, lisans envanteri ve secret taramasını tekrar çalıştırır. Commit veya push yapmaz. Adayı incelemek için private çalışma dizinindeki `.local/public-candidate` kullanılır. Bir tarama hatasında araç başarı bildirmez; çıktı yalnız inceleme için kalır.

Adaya gerçek müşteri ekran görüntüsü, servis hesabı dosyası, `.local`, `.env`, keystore veya imza dosyası eklemeyin. Secretların kaynakta olmaması, daha önce kullanılmış anahtarları iptal etmez; gerekli rotasyon sağlayıcılarda yapılır.

## 4. Yayın anı

Adayın lisans ve doğrulama kaydı tamamlanınca README'deki private dal/klon bilgisi gerçek public dal/etikete göre güncellenir. Yeni public başlangıç ayrı geçmişle oluşturulur; mevcut private uzak repo kendiliğinden dönüştürülmez. İlk commit/tag ve GitHub yayını ayrı son işlem olarak yapılır. Bu çalışmanın aday üretmesi, public push/görünürlük değişimi yapıldığı anlamına gelmez.

Yayın notunda şu ayrım korunmalıdır: yerel demo çalışır; cloud/mobile yolları açık sağlayıcı girdileri ister; geçmiş canlı kabul ve yeni aday kontrolleri farklıdır. Gerçek tahsilat, market yayını, gözetimsiz Mac ve fiziksel Android bildirimi kabul edilmeden “tam üretim ürünü” ifadesi kullanılmaz.
