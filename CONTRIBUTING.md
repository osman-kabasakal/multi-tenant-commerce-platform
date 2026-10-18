# Katkıda bulunma

Önce [README](README.md), [AGENTS](AGENTS.md), [mimari](docs/ARCHITECTURE.md) ve [güvenlik bildirme](SECURITY.md) belgelerini okuyun. CodeGraph indeksi varsa kaynak keşfinde onu kullanın; `.codegraph/` yerel kalır.

## Kaynak ve lisans

Yazara ait bağımsız yeni katkılar GPL-3.0-only kapsamındadır. Mevcut üçüncü taraf grant/attribution'larını koruyun; bir dosyanın adını veya namespace'ini değiştirmek onu size ait yapmaz. Ayrıntı: [LICENSING](LICENSING.md), [third-party notices](THIRD_PARTY_NOTICES.md).

Yeni görsel/font/veri/ses için `docs/licenses/provenance.json` içine dosya yolu, SHA-256, kaynak ve bilinen notice/yöntemi kaydedin. Mevcut varlıkların korunması kararı [ayrı kayıttadır](docs/licenses/ASSET_RETENTION.md); bu karar açık lisans kanıtı olarak gösterilmez. Özgün çalışmanın da kaynağını/üreticisini belirtin. Değişen hash eski kanıtı kullanamaz. İlgili değişiklikleri stage ettikten sonra:

```sh
python3 scripts/asset_inventory.py --index
# Yenilenen CSV'leri de inceleyip stage edin.
python3 scripts/asset_inventory.py --index --check --require-reviewed
python3 -m unittest discover -s scripts -p test_release_source.py -v
```

Gerçek credential, müşteri verisi, işletme görseli, signing girdisi veya üretilmiş çalışma dizini eklemeyin. İhtiyaç duyulan özel girdiler `.local` altında kalır.

## Değişiklik ve doğrulama

PR açıklamasında sorunu, değişen davranışı, hedef profili ve gerçekten çalıştırdığınız kontrolleri belirtin. Uygulama akışı değişiyorsa ilgili component/testleri ve gerektiğinde `python3 scripts/demo.py up` + `smoke` ile doğrulayın. Belge değişikliğinde yerel linkleri ve Mermaid'i; asset değişikliğinde hash/grant, biçim ve tüketici uyumluluğunu kontrol edin. Eski canlı kabulü yeni kaynağın sonucu olarak kullanmayın.

Bulut provisioning, DNS, bildirim gönderimi, tahsilat ve mobil signing testleri açık sağlayıcı girdileriyle ayrı yapılır; varsayılan demo bunları çalıştırmaz. Mimari karar değiştiğinde [karar dizinine](docs/decisions/README.md) yeni ADR ekleyin; önceki kararı silmek yerine yerine geçen kaydı belirtin.
