# Geliştirme geçmişini koruyarak public yayın hazırlama

Public sürüm tek `main` dalından yayımlanır. Geliştirme geçmişini sıfırlamak gerekmez: yalnız somut kısıtı belirlenen dosyalar ve aynı içeriğin farklı yollardaki kopyaları geçmişten çıkarılır. Yazar, tarih, commit mesajı ve parent sırası korunur; etkilenen Git hashleri değişir. Boşalan commitler de korunur.

## 1. Yayın kapsamı

Yazarın bağımsız kodu GPL-3.0-only; GrandNode ve üçüncü taraf bildirimleri korunur. Flutter ekran/Riverpod kodu yazara aittir; satın alınmış UI kitinin orijinal paketi dağıtılmaz. Mevcut görseller [koruma kararı](licenses/ASSET_RETENTION.md) kapsamında kalır. `retained:license-unconfirmed` lisans grant'i değildir.

Kesin temizlik listesi [history-removals.json](licenses/history-removals.json) içindedir: IRANSansWeb ailesinin 48 dosya yolu ve 48 Git blob kimliği. Bu liste bütün görselleri veya belirsiz fontları kaldırmaz. IOSSecuritySuite 2.1.0 bu repoya kaynak olarak vendored edilmemiştir; mevcut BSD-2-Clause 1.9.11 sabitlemesi korunur. Eski bir bağımlılık sürümünün manifestte anılması, kütüphanenin kaynak kodunun repoda dağıtılmasıyla aynı şey değildir.

123 commitlik ilk geçmiş taramasında Gitleaks bulgu üretmedi. Bu kayıt bir gizli bilgi ifşası tespiti değildir. Dosyanın güncel sürümden silinmesi ise eski committeki kopyasını kaldırmaz; somut font temizliğinin nedeni budur.

## 2. Kaynağı doğrula ve özel yedeği koru

Yalnız yayınla ilgili değişiklikleri commit edin. İlgisiz unstaged kullanıcı değişiklikleri yayın girdisine alınmaz. Credential, `.local`, müşteri verisi, keystore, `.p8`, `.env` veya gerçek provider dosyası commit edilmez.

```sh
python3 scripts/asset_inventory.py --index --check --require-reviewed
python3 scripts/check_public_source.py
```

Envanter mevcut kanıt veya açık koruma kararını denetler; yeniden dağıtım hakkı üretmez. Kaynak ve binary yükümlülükleri [LICENSING.md](../LICENSING.md) içinde ayrılır.

Yayın aracı seçilen HEAD geçmişini private `.bundle` dosyasına yedekler ve `git bundle verify` çalıştırır. Bu çalışmada ayrıca bütün ilk Git referanslarının yedeği ve iki bağımsız kullanıcı düzenlemesinin patch'i Git dışındaki özel alanda korunmuştur. Bu yedekler temizlenmemiş eski dosyaları içerir; public repoya, release asset'ine veya Actions artifact'ine yüklenmez.

## 3. Ayrı kopyada hedefli geçmiş temizliği

Git-filter-repo ayrı bir sanal ortama kurulur; kaynak çalışma dizininin geçmişi hazırlık sırasında değiştirilmez.

```sh
python3 -m venv /absolute/private/history-tools
/absolute/private/history-tools/bin/python -m pip install git-filter-repo==2.47.0

python3 scripts/prepare_public_history.py \
  --output .local/public-history-candidate \
  --gitleaks /absolute/path/to/gitleaks \
  --filter-repo /absolute/private/history-tools/bin/git-filter-repo
```

Çıktı klasörü, yedek veya receipt zaten varsa araç üzerine yazmaz. Yalnız commit edilmiş HEAD kullanılır. Diğer referanslarda HEAD'e dahil olmayan commit varsa işlem durur; bu geçmişin kapsamı açıkça değerlendirilmelidir. Bu repodaki yayın bir dalda bütün mevcut geliştirme commitlerini kapsar.

Araç:

1. Ayrı ve hardlink kullanmayan Git kopyası oluşturur.
2. Yalnız listelenmiş yolları ve blob içeriklerini siler; yeniden adlandırılmış aynı binary de çıkarılır.
3. Her eski commit'i yeni karşılığıyla eşleştirir. Commit sayısı, yazar/committer/tarih/mesaj, parent sırası ve her tarihsel dosyanın mode/type/blob kimliği karşılaştırılır. Temizlik listesi dışındaki tek farkta işlem başarısız olur.
4. Eski font nesnelerinin yeni Git nesne veritabanından da çıktığını doğrular.
5. Tek `main` dalı ve remote içermeyen aday üretir; kaynak, envanter, güncel snapshot ve bütün geçmiş için gerçek Gitleaks kontrollerini çalıştırır.
6. Commit-map, filtre günlüğü, bundle ve makbuzu private aday alanında tutar. Push veya GitHub görünürlük işlemi yapmaz.

Tekrar kontrol:

```sh
cd .local/public-history-candidate
python3 scripts/prepare_public_history.py --check
python3 scripts/check_public_source.py
```

Eski tek snapshot aracı `prepare_public_release.py`, geçmişin özellikle istenmediği ayrı dağıtımlar için isteğe bağlı kalır. Bu projenin public yayını için geçmişi silmek veya squash yapmak zorunlu değildir.

## 4. GitHub'da yayın

Git geçmişinin temizliği ile GitHub'daki eski PR referansları, cached commit görünümü ve Actions artifact'leri farklı şeylerdir. Sadece force-push, bunların tamamını sildiği garantisini vermez. [GitHub'ın açıkladığı sınırlar](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository).

Bu yayında mevcut GitHub reposu private yedek olarak saklanır; eski branchler ve 18 eski Actions artifact'i public yapılmaz. Aynı asıl repo adı/adresi, temizlenmiş tam geliştirme geçmişinin yüklendiği yeni bağımsız repo için kullanılır. Bu bir fork değildir. Eski repodaki issue/PR, release, secret, variable, yıldız ve fork sayıları hazırlıkta sıfırdı; eski CI kayıtları private yedekte korunur.

Sıra: temiz adayı doğrula → mevcut repoyu private yedek adıyla koru → asıl isimde yeni private repo oluştur → yalnız temiz `main` dalını yükle → remote branch/HEAD ve kaldırılmış nesnelere erişimi kontrol et → açık yetkiyle public yap → anonim klon ve kaynak/geçmiş taramasını doğrula. `git push --mirror` veya eski private branchlerin yeniden push edilmesi kullanılmaz.

Yerel ana çalışma kopyası daha sonra temiz `main` geçmişine hizalanır; staged olmayan iki kullanıcı değişikliği ve `.local` içeriği korunur. Eski klonlardan merge/push eski dosyaları yeniden getirebilir. Dondurulmuş canlı test kayıtları özgün kaynak hashlerini tutar; eski/yeni commit eşlemesi private yayın makbuzundadır.

## 5. Doğrulama kapsamı

Bu işlem uygulama davranışını değiştirmez. Son canlı Linux/Android/iOS kabulü [kaynakla bağlı kayıtta](validation/oracle-clean-install-20261018.json) yer alır. Yeni yayın araçlarının fixture'ları gerçek Git üzerinde birleştirmeleri, boş commitleri, farklı yoldaki aynı blob'u, mevcut çıktı ve staged değişiklik korumalarını denetler. GitHub Actions'ın kaynak işi yeni commitlerde tam geçmiş ve temizlik listesi kontrolünü sürdürür.

Public kaynak, satışa hazır SaaS veya bütün cihaz/ödeme senaryolarının kabul edildiği anlamına gelmez. Bulut/mobil akışları kendi hesap ve imzalama girdilerini gerektirir. Aynı uygulama kaynakları için önceki tarihli kabul ile bu yayın adayının yerel kaynak kontrolleri ayrı belirtilir.
