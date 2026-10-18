# Lisans ve mevcut varlık kayıtları

- `assets.csv`: Her varlık yolu, boyut, SHA-256 ve durum.
- `inputs.csv`: Lisans, notice, manifest/lock ve karar girdilerinin özetleri.
- `provenance.json`: Lisans kanıtı ile mevcut dosyayı koruma kararını ayrı tutan dosya bazlı kayıtlar.
- `ASSET_RETENTION.md`: Proje sahibinin mevcut resim/ikonları koruma kararı ve somut kısıt nedeniyle korunan düzeltmeler.
- `replacements.json`: Görsel değişimlerinin geri alındığını kaydeder; etkin görsel değişimi yoktur.
- `upstream/`: Korunan tam lisans ve copyright metinleri.

`evidenced:<lisans>` lisans/dağıtım kaydını, `retained:license-unconfirmed` ise yalnız mevcut dosyayı koruma kararını gösterir. `NOASSERTION` bir izin veya GPL grant'i değildir. Yeni dosya ya da içerik değişikliği eski kaydı kullanamaz.

```sh
python3 scripts/asset_inventory.py --index
# CSV'leri stage ettikten sonra:
python3 scripts/asset_inventory.py --index --check --require-reviewed
```

Görsel yeniden üretici kaldırılmıştır; Famizyo, ürün fotoğrafları ve ikonlar otomatik olarak yeniden çizilmez. [İnceleme](../LICENSE_REVIEW.md) · [Kapsam](../../LICENSING.md) · [Yayın adımları](../PUBLIC_RELEASE.md).
