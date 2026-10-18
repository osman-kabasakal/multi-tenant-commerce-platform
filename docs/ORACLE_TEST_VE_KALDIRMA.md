# Oracle test sunucusu erişimi ve test sonunda kaynakları kaldırma

Bu rehber, mevcut Oracle sunucusunda testi tekrar çalıştırmayı, kullanılan kimlik dosyalarını bulmayı ve test tamamlanınca altyapıyı tamamen kaldırmayı anlatır. Uygulamalar SSH üzerinden dağıtılır ve Docker Compose ile çalışır. Terraform state dosyasının asıl kopyası Oracle Resource Manager’dadır; Mac’teki `state/` klasörü kurulumun kimliklerini ve yerel işlem kayıtlarını tutar.

**Durdurmak, sunucuyu silmek ve Resource Manager stack’ini silmek farklı işlemlerdir.** Tam kaldırmada önce yedek alınır, silme korumaları özel bir şablon kopyasında kaldırılır, kaynaklar Destroy ile silinir ve en son boş stack kaldırılır. Bu rehberin hazırlanması sırasında Destroy veya stack silme işlemi yapılmadı.

## 1. Kimlik bilgilerini bulun

Bu kurulum kalıcı **OCI API anahtarı** kullanır. Süreli oturum token’ı veya Oracle Console tarayıcı oturumu değildir. Dosyaların içeriklerini Git’e eklemeyin.

| Dosya | İşlevi |
| --- | --- |
| `oci-config` | `COMMERCE` profili; kullanıcı, tenancy, bölge, fingerprint ve `key_file` yolu |
| `api-key.pem` | Oracle API çağrılarını imzalayan private key |
| `api-key-public.pem` | Oracle kullanıcı hesabına kaydedilmiş public key |
| `deploy-key` ve `deploy-key.pub` | Sunucuya SSH bağlantısının private/public anahtarları; OCI anahtarından ayrıdır |
| `known_hosts` | Daha önce doğrulanmış SSH sunucu anahtarı |
| `credit-minimal/operator.json` | Çalışan kredi testinin özgün Terraform girdileri |
| `credit-minimal/state/installation.json` | Resource Manager stack/plan/apply kimlikleri ve sahiplik kaydı |
| `credit-minimal/state/outputs.json` | VM, public IP, test compartment, durdurma zamanlayıcısı ve politika kimlikleri |

Bu çalışma ortamının **gerçek mutlak yolları**, Git dışında tutulan `.local/ORACLE_OPERATOR.md` dosyasındadır. Bu dosya her operatörün kendi makinesinde hazırlanır; repoyu klonlayan başka biri sizin kimlik bilgilerinizi edinmez. Genel kurulum için [Oracle dağıtım rehberindeki](ORACLE_DEPLOYMENT.md) `.local/oracle/` örneği kullanılabilir.

Dosyalar `0600`, özel dizinler `0700` olmalı. `oci-config` içindeki `key_file` doğru mutlak private key yolunu göstermeli. API anahtarını kaldırmak gerekirse Oracle Console → kullanıcı profili → API Keys bölümünde ilgili fingerprint’i silin. Yerel dosyayı silmek, Oracle’daki anahtarı iptal etmez; bu anahtar Terraform stack’inin yönettiği bir kaynak değildir.

Mac/Linux operatör terminalinde aşağıdaki değişkenleri kendi gerçek yollarınıza göre tanımlayın. Özel operatör rehberindeki örnek mevcut kurulumun yollarını hazır verir:

```sh
cd /path/to/multi-tenant-commerce-platform
oracle_credentials="$PWD/.local/oracle"
oracle_inputs="$oracle_credentials/credit-minimal"
oracle_state="$oracle_inputs/state"
oci_cli="/absolute/path/to/oci"
```

Doğrulanan CLI sürümü `3.95.0`’dır. CLI daha önce geçici bir dizine kurulmuş ve kaybolmuşsa Python 3.12 ile kalıcı, Git dışında bir kurulum hazırlayabilirsiniz:

```sh
python3.12 -m venv .local/tools/oci
.local/tools/oci/bin/python -m pip install 'oci-cli==3.95.0'
oci_cli="$PWD/.local/tools/oci/bin/oci"
"$oci_cli" --version
```

Komutları kısaltan işlev yalnızca profil ve bölge seçer; anahtar içeriğini yazdırmaz:

```sh
commerce_oci() {
  "$oci_cli" --config-file "$oracle_credentials/oci-config" \
    --profile COMMERCE --auth api_key --region eu-frankfurt-1 \
    --output json --no-retry "$@"
}
```

Başka hesabınızda bölgeyi kendi home region’ınızla değiştirin. VM ve stack kimliklerini **kredi testinin** state klasöründen okuyun; ilk ücretsiz ARM denemesinin klasörü farklıdır:

```sh
oracle_instance=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["instance_id"]["value"])' "$oracle_state/outputs.json")
oracle_stack=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["stack"])' "$oracle_state/installation.json")
oracle_ip=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["public_ip"]["value"])' "$oracle_state/outputs.json")
commerce_oci compute instance get --instance-id "$oracle_instance" \
  --query 'data.{state:"lifecycle-state",shape:shape,resources:"shape-config"}'
commerce_oci resource-manager stack get --stack-id "$oracle_stack" \
  --query 'data.{name:"display-name",ownership:"freeform-tags"}'
```

## 2. Sunucuyu açın ve durdurma saatini kontrol edin

Oracle Console → Compute → Instances bölümünden özgün test VM’sini açabilirsiniz. Aynı işlem API ile şu şekildedir:

```sh
commerce_oci compute instance action --instance-id "$oracle_instance" --action START
```

Mevcut container’ların restart politikası uygulamaları açılışta yeniden başlatır. `running` görünmesi tek başına veritabanının ve tenant’ın hazır olduğu anlamına gelmez; aşağıdaki kabul kontrolünü de çalıştırın.

Kredi testi ilk durdurma saatinden itibaren **24 saat boyunca saatlik STOP_RESOURCE** kuralına sahiptir. Bu süre içinde elle açtığınız sunucu bir sonraki saatlik çalışmada yeniden durabilir. Zamanlayıcının `time-next-run`, `time-ends`, `lifecycle-state` ve son çalışma sonucunu kontrol edin:

```sh
oracle_schedule=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["stop_schedule_id"]["value"])' "$oracle_state/outputs.json")
commerce_oci resource-scheduler schedule get --schedule-id "$oracle_schedule" \
  --query 'data.{state:"lifecycle-state",next:"time-next-run",end:"time-ends",lastResult:"last-run-status"}'
```

Bunlar UTC saatleridir. Kuralın 24 saatlik penceresi bittiyse sonraki manuel açılışı otomatik durduracağı varsayılmamalı; yeni test için sınırlı bir stop kuralı ayrıca planlanmalıdır. Eski `stop_at_utc` değerini yerelde değiştirerek kayıtlı kurulumu tekrar apply etmeyin. VM durdurma komutu süresi geçmiş özgün girdilerle çalışmaya devam eder.

## 3. SSH ile durum ve uçtan uca kabul kontrolü

**Mac/Linux operatör terminalinde** daha önce doğrulanmış sunucu anahtarını kullanın:

```sh
ssh -F /dev/null -i "$oracle_credentials/deploy-key" \
  -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes \
  -o UserKnownHostsFile="$oracle_credentials/known_hosts" \
  -o ForwardAgent=no "ubuntu@$oracle_ip"
```

`Please login as the user "ubuntu" rather than the user "opc"` hatası alırsanız SSH istemcinizde kullanıcıyı `ubuntu` yapın. Bu kurulum Ubuntu imajı kullanır. OCI API kimliği veya `api-key.pem` dosyası SSH giriş anahtarı değildir; SSH için `deploy-key` kullanılır.

IP veya host key değişirse doğrulamayı kapatmayın; [Console üzerinden host key doğrulamasını](ORACLE_DEPLOYMENT.md#4-sunucu-kimliğini-bir-kez-doğrulayın) tekrar yapın. SSH zaman aşımında VM’nin RUNNING durumunu ve operatörün güncel IPv4 adresinin izinli `/32` ile eşleştiğini kontrol edin.

Aşağıdaki komutlar artık **Oracle sunucusunun terminalinde** çalışır. `DEPLOYMENT_ID` yerine `outputs.json` içindeki kimliği yazın:

```sh
server_root=/home/ubuntu/commerce-DEPLOYMENT_ID
revision=$(cat "$server_root/last-successful-revision")
server_source="$server_root/sources/$revision"
python3 "$server_source/scripts/production.py" verify --state "$server_root/state"
docker compose --file "$server_root/state/compose.json" ps --all
```

Servisleri daha önce `docker compose stop` ile elle kapattıysanız restart politikası onları kapalı tutabilir. Böyle bir durumda aynı sunucuda `docker compose --file "$server_root/state/compose.json" up -d --no-build --pull never` ile mevcut imajları/verileri yeniden açın ve kabul kontrolünü tekrarlayın.

`bootstrap`, yalnızca ilk hazırlamada kullanılan `initialize` profiline aittir; sürekli çalışan bir servis değildir. Ayrı tenant görev servisi seçilmişse `task-worker` da çalışmalı. Kaynak sürümünü `last-successful-revision` ve uygulama imajının revision etiketiyle karşılaştırın. Mac’teki HEAD’in ilerlemesi mevcut sunucuyu güncellemez.

Mevcut test işletmesinin şifrelerini komut satırına koymadan [kabul aracını](../scripts/smoke_existing_deployment.py) çalıştırın. Eski dağıtımda dosya yoksa yalnızca bu aracı doğrulanmış SSH ile özel bir operatör klasörüne kopyalayıp dağıtımın `scripts` dizinini `PYTHONPATH` olarak seçebilirsiniz:

```sh
PYTHONPATH="$server_source/scripts" python3 /absolute/private/smoke_existing_deployment.py \
  --state "$server_root/state" \
  --fixture /absolute/private/existing-test-owner.json \
  --receipt "$server_root/test-results/existing-tenant.json"
```

Receipt dizini `0700`, fixture dosyası `0600` olmalı. Fixture yalnızca size ait mevcut test işletmesini göstermeli; `tenant` (32 karakterli tenant kimliği), `username`, `email`, `password` (portal hesabı), `tenantPassword` (mağaza yöneticisi) ve mevcut `statusUrl` alanları gerekir. Bu denemede zaten oluşturulmuş özel fixture’ın yolu yerel operatör rehberindedir. Araç yeni kullanıcı/işletme, Google projesi veya mobil sürüm oluşturmaz; kimlik oturumları açar, veri okur ve yönetim grid’lerinin salt okunur POST sorgularını kullanır.

Kontrol, gerçek HTTPS/OIDC girişini, sahibine ait tamamlanmış kurulum işini, mağazayı, yönetici girişini, ürün sayfası CSS/JS kaynaklarını, TRY para birimini, iki vergi sağlayıcısını, %1/%10/%20 oranlarını ve altı zorunlu mobil adres alanını doğrular. Eklenti kurulumunu operatörün tenant veritabanındaki `InstalledPlugin` kayıtlarından salt okunur denetler; tenant sahibinin merkezi eklenti yönetimine erişim yetkisini genişletmez. Yanlış client secret, anonim tenant durumu ve mağaza alanındaki `/Admin` istekleri reddedilmeli. Bu kontrol yeni işletmenin sıfırdan kurulması veya cihaz bildirimi testi yerine geçmez.

### Tarayıcıdan kendi kabulünüz

1. Portal ana sayfasında “Hemen Başlayın” ile Keycloak’a gidin; “Register” bağlantısının göründüğünü kontrol edin.
2. Yeni kayıt senaryosunda kendi e-posta adresinizle kayıt olun, gerçek doğrulama e-postasını açın ve parola adımını tamamlayın. Var olan kayıtla oturum açmak yeni kayıt/posta teslimini test etmez.
3. İşletme formunu doldurup denemeyi başlatın. Bu adım yeni tenant, Google/Firebase kaynakları ve seçili mobil derlemeyi gerçekten oluşturur. Aynı iş hata verirse mevcut kaydı yeniden deneyin; ikinci işletme oluşturarak aşmayı denemeyin.
4. Kurulumun “Mağazanız hazır” sonucunu ve mağaza/yönetim bağlantılarını kontrol edin. Sayfayı yenileyince aynı işletme gelmeli.
5. Yönetimde eklentileri, TRY’yi, `%1`, `%10`, `%20` vergi kategorilerini ve `lat`, `long`, `bno`, `dno`, `kno`, `adres_tarifi` zorunlu adres alanlarını kontrol edin. Ürün sayfasındaki CSS/JS hatalarını tarayıcı Network bölümünden izleyin.
6. Ayrı test ürünüyle sepet ve seçtiğiniz test ödeme yöntemini deneyin. Gerçek ödeme sağlayıcısına geçmeden test hesabını seçin. İkinci işletme hesabından ilk işletmenin yönetimine/verisine erişilememeli.
7. Android APK’yı fiziksel cihazda kurup giriş, Crashlytics, FCM ve bildirime dokunma akışını; iOS’ta imzalı IPA ve APNs akışını ayrı doğrulayın. Sadece APK yüklemesinin başarılı olması cihazda çalıştığının kanıtı değildir.

İşletme ekleme ekranlarının ayrıntıları [yeni işletme rehberindedir](YENI_ISLETME_EKLEME.md). Sonuçların kaynak sürümü ve sınırları [doğrulama kayıtlarında](VALIDATION.md) tutulur.

### Disk alanı ve derleme önbelleği

Oracle'daki boot disk kapasitesi ile `df` çıktısındaki **Available** değeri farklı ölçümlerdir: biri toplam kapasiteyi, diğeri dosya sisteminde boş kalan alanı gösterir. Bölümler, dosya sistemi ve kullanılan birimler de toplam gösterimini etkiler. Bu testte kök dosya sistemi `96G` görünüyordu; Android worker hazırlığı öncesinde yalnızca yaklaşık `19G` boştu.

Üretim uygulaması derlenirken .NET SDK'ları, NuGet paketleri, ara çıktılar ve Docker katmanları; mobil worker hazırlanırken Android SDK/NDK, JDK ve Flutter ayrıca yer kaplar. Önceki uygulama imajı geri dönüş için korunur. Docker build cache ve imaj boyutları ortak katman içerebildiğinden bunları toplayarak fiziksel disk tüketimi hesaplamayın. Docker volume toplamı da hosttaki mobil çalışma dizinlerini ve APK'ları kapsamaz.

Sunucuda salt okunur kontrol:

```sh
df -h /
docker system df
docker builder du
du -h --max-depth=1 "$server_root/state"
```

Büyük imaj dışa aktarımı sürerken Docker'ın alan raporu gecikebilir; önce `df` ve derleme logunu kontrol edin. Android worker hazırlığı en az **30 GiB boş alan** ister. Derlemeyi başlatmadan önce yeterli alan bırakın; minimuma ulaşıldığında disk dolana kadar zorlamayın.

Bu denemede çalışan veritabanları, volume'lar ve imajlar korunarak kullanılmayan Docker derleme önbelleği temizlendi; boş alan yaklaşık **19 GiB'den 43 GiB'ye** çıktı. Devam eden SDK hazırlığı yeniden alan tüketti. Tekrar temizlik gerekirse önce bu makinedeki diğer projeleri ve etkin derlemeleri kontrol edin. `docker builder prune --filter until=24h` kullanılmayan eski önbelleği onayla temizler ve sonraki derlemeleri yavaşlatabilir. Genel `docker system prune --volumes` veya toplu volume silme bu bakım adımının parçası değildir. Veritabanları, master key, tenant imzalama anahtarları ve mobil çıktılar uygulama verisidir; önbellek gibi silinmemelidir.

## 4. Yeniden açılışta MongoDB başlamazsa

17 Ekim testinde işletim sistemi güncellemesi sonrası `7.0.0-1013-oracle` çekirdeği açıldı ve MongoDB, `SERVER-121912` hatasıyla başlamayı reddetti. [MongoDB’nin resmî açıklaması](https://www.mongodb.com/docs/v8.0/release-notes/8.0/) Linux 6.19–7.0.13 aralığını uyumsuz olarak tanımlar; container kullanmak ana makinenin çekirdeğini değiştirmez.

Mevcut test VM’sinde önceden kurulu `6.17.0-1020-oracle` seçilerek yeniden açılış yapıldı. Yalnızca bu VM’de `/etc/default/grub.d/99-commerce-mongodb-kernel.cfg` dosyası eklendi; önceki kernel paketi otomatik silinmemesi için manual işaretlendi. Bu seçim MongoDB veri formatını veya veritabanı imajını değiştirmez. Aynı seçim başka sunucuda kernel/GRUB kimlikleri kontrol edilmeden kopyalanmamalıdır.

Sunucuda `uname -r`, MongoDB sağlık durumu ve açılış loglarını birlikte kontrol edin. Gelecekte uyumlu ve desteklenen Oracle çekirdeğine geçerken bu özel GRUB dosyasını kaldırıp `sudo update-grub` çalıştırın ve planlı yeniden açılış yapın. Mevcut uyumsuz çekirdeği tekrar varsayılan yapmak sorunu geri getirir. Genel Terraform şablonundaki Ubuntu imajı yeni bir kurulumda ayrıca doğrulanmalıdır; bu canlı onarım bütün yeni imajların doğrulandığı anlamına gelmez.

## 5. Testi geçici olarak durdurun

**Mac/Linux operatör terminalinde**, özgün kredi girdileri ve state ile:

```sh
python3 scripts/oracle.py stop \
  --variables "$oracle_inputs/operator.json" --state "$oracle_state" \
  --oci "$oci_cli" --oci-config "$oracle_credentials/oci-config" --profile COMMERCE
commerce_oci compute instance get --instance-id "$oracle_instance" \
  --query 'data."lifecycle-state"' --raw-output
```

`STOPPING` ardından `STOPPED` beklenir. Bu işlem VM’nin verilerini, 100 GB boot diskini, ağını ve stack’ini korur; saklanan diskin kota/ücret kullanımı sürebilir. Sadece Docker servislerini durdurmak veya işletim sistemini kapatmak Oracle API stop işleminin yerini tutmaz. [Oracle stop/faturalandırma açıklaması](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/resource-billing-stopped-instances.htm).

## 6. Kalıcı kaldırmadan önce yedeği VM dışına alın

Uygulama verileri gerekiyorsa **sunucuda**, özgün Linux kullanıcısıyla, yeni bir yedek dizini seçin:

```sh
mkdir -p "$server_root/backups"
chmod 700 "$server_root/backups"
python3 "$server_source/scripts/production_backup.py" backup \
  --state "$server_root/state" --backup "$server_root/backups/before-destroy"
python3 "$server_source/scripts/production_backup.py" verify \
  --backup "$server_root/backups/before-destroy"
```

Soğuk yedek bu Compose kurulumunda kısa kesinti oluşturur ve daha önce çalışan servisleri geri açar. `state.tar`, PostgreSQL/MongoDB/Redis arşivleri ve manifest aynı takımda korunmalı; master key olmadan şifreli tenant secret’ları kurtarılamaz. Yedek şifrelenmemiştir; VM dışında erişimi kısıtlı, şifreli depolamaya kopyalayın. Gereken orijinal uygulama/worker ve veri servislerinin imajlarını da `snapshot.json` içindeki immutable kimliklerle özel olarak saklayın. [Yedek ve geri yükleme ayrıntıları](BACKUP_RESTORE.md).

**Mac’te** uzak Terraform state ve şablonunu da yeni bir özel dizine indirin:

```sh
umask 077
teardown_dir="$oracle_inputs/teardown"
mkdir -m 700 "$teardown_dir"
commerce_oci resource-manager stack get-stack-tf-state \
  --stack-id "$oracle_stack" --file "$teardown_dir/before.tfstate"
commerce_oci resource-manager stack get-stack-tf-config \
  --stack-id "$oracle_stack" --file "$teardown_dir/original.zip"
commerce_oci resource-manager stack get --stack-id "$oracle_stack" \
  > "$teardown_dir/original-stack.json"
unzip "$teardown_dir/original.zip" -d "$teardown_dir/template"
```

Bu state kopyası bir kayıt/yedektir. Aynı kaynakları hem yerel Terraform hem Resource Manager ile eşzamanlı yönetmeyin; yerelde boş state ile `terraform destroy` çalıştırmak uzak kaynakları bulmaz.

## 7. Silme korumalarını yalnızca özel kaldırma kopyasında değiştirin

Normal şablonda yanlışlıkla silmeyi engelleyen üç ayar var. İndirdiğiniz ZIP’in `template/` kopyasında aşağıdaki değişiklikleri yapın; repodaki `infra/oracle` korumalarını değiştirmeyin:

| Konum | Normal kurulum | Kalıcı kaldırma kopyası |
| --- | --- | --- |
| `main.tf` ve `credit.tf` içindeki kaynak lifecycle blokları | `prevent_destroy = true` | `prevent_destroy = false` |
| `main.tf` → `oci_core_instance.platform` | `preserve_boot_volume = true` | `preserve_boot_volume = false` |
| `credit.tf` → `oci_identity_compartment.credit_test` | `enable_delete = false` | `enable_delete = true` |
| `main.tf` → VM lifecycle içindeki tek `precondition` bloğu | Kredi bitiş saatinin gelecekte olmasını ister | Yalnızca kaldırma kopyasından bu bloğu çıkarın |

Son satır, süresi geçmiş testte hazırlık planının hata vermemesi içindir. `stop_at_utc` girdisi ve gerçek zamanlayıcının saati değiştirilmez. İlk ücretsiz ARM profilinde compartment kaynağı `count=0`’dır. Çalışan kredi profilinin kaynakları 6 ağ/VM + compartment + politika + zamanlayıcı olmak üzere **9 yönetilen kaynak**tır; kendi uzak state’inizi esas alın.

Boot diski korunursa VM silinse bile disk kalır. Compartment `enable_delete=false` kalırsa Terraform onu state’ten çıkarırken buluttan silmeyebilir. Bu nedenle bu iki değişikliği **Destroy’dan önce planlayıp apply ederek uzak state’e kaydedin**. [Sabit OCI sağlayıcısının compartment davranışı](https://github.com/oracle/terraform-provider-oci/blob/v7.23.0/website/docs/r/identity_compartment.html.markdown), [boot disk koruma ayarı](https://github.com/oracle/terraform-provider-oci/blob/v7.23.0/website/docs/r/core_instance.html.markdown).

Terraform 1.5.7 ile özel kopyada biçim/şema kontrolü yapabilirsiniz:

```sh
terraform -chdir="$teardown_dir/template" fmt -check
terraform -chdir="$teardown_dir/template" init -backend=false -lockfile=readonly
terraform -chdir="$teardown_dir/template" validate
(cd "$teardown_dir/template" && zip "$teardown_dir/retirement.zip" main.tf credit.tf cloud-init.yaml .terraform.lock.hcl)
```

`teardown_dir` mutlak yol olmalı. ZIP’e state, anahtar veya uygulama girdilerini eklemeyin. Oracle Console → Developer Services → Resource Manager → Stacks → **özgün test stack’i** → Edit üzerinden yalnızca bu ZIP’i yükleyin; özgün değişkenler, bölge ve Terraform/sağlayıcı sürümleri korunmalı. Aynı işlem CLI ile yapılabilir:

```sh
commerce_oci resource-manager stack update \
  --stack-id "$oracle_stack" --config-source "$teardown_dir/retirement.zip"
commerce_oci resource-manager job create-plan-job --stack-id "$oracle_stack" \
  > "$teardown_dir/retirement-plan-job.json"
```

Planın normal bir hazırlık planı olduğunu unutmayın: **0 oluşturma, 0 silme, 0 yeniden yaratma** ve yalnızca disk/compartment koruma alanlarında yerinde güncelleme beklenir. VM’nin değişmesi/yeniden yaratılması, ağ veya saat değişikliği görünürse apply etmeyin; doğru eski ZIP ve özgün girdileri karşılaştırın. Console’da planı inceleyip yalnızca bu planı apply edin veya aynı job kimliğini kullanın:

```sh
retirement_plan=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["data"]["id"])' "$teardown_dir/retirement-plan-job.json")
commerce_oci resource-manager job get --job-id "$retirement_plan" \
  --query 'data."lifecycle-state"' --raw-output
# Plan SUCCEEDED ve değişiklikleri incelenmiş olmalı.
commerce_oci resource-manager job create-apply-job --stack-id "$oracle_stack" \
  --execution-plan-strategy FROM_PLAN_JOB_ID --execution-plan-job-id "$retirement_plan" \
  > "$teardown_dir/retirement-apply-job.json"
```

Apply job’ın da `SUCCEEDED` olduğunu Console veya `job get` ile doğrulayın. Uzak state’i tekrar indirip `oci_core_instance` için `preserve_boot_volume=false`, kredi compartment’ı için `enable_delete=true` olduğunu kontrol edin. Bu hazırlık VM’yi silmez. Kaldırma şablonu yüklendikten sonra normal `oracle.py plan/apply/deploy` yoluna dönmeyin; sahiplik hash denetimi bu kasıtlı şablon değişikliğini reddedebilir. Amaç bu kurulumu emekliye ayırmaktır.

## 8. Kaynakları Destroy ile kaldırın

Bu adım uygulama verileri dahil altyapıyı kalıcı siler. Yedeğin VM dışındaki kopyasını ve doğru stack’i kontrol ettikten sonra Console’daki **Destroy** işlemini kullanın. CLI karşılığı:

```sh
commerce_oci resource-manager job create-destroy-job --stack-id "$oracle_stack" \
  --execution-plan-strategy AUTO_APPROVED \
  > "$teardown_dir/destroy-job.json"
destroy_job=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["data"]["id"])' "$teardown_dir/destroy-job.json")
commerce_oci resource-manager job get --job-id "$destroy_job" \
  --query 'data."lifecycle-state"' --raw-output
```

OCI `create-destroy-job` yalnızca `AUTO_APPROVED` stratejisini kabul eder: bu komut silmeyi hemen başlatır, önizleme değildir. Yukarıdaki hazırlık planı da bir destroy önizlemesi değildir. İş sürerken tekrar destroy göndermeyin; mevcut job’ı takip edin. Komut bağlantı hatası verirse önce Jobs listesinden sonucu uzlaştırın. [Oracle Destroy işi](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/create-job-destroy.htm), [CLI parametreleri](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/oci_cli_docs/cmdref/resource-manager/job/create-destroy-job.html).

`SUCCEEDED` sonrasında uzak state’te yönetilen kaynak kalmadığını ve Oracle Console’da VM, **boot volume**, VCN/subnet/route/security list/internet gateway, saatlik durdurma kuralı, ona ait politika ve kredi test compartment’ının silindiğini doğrulayın. Bağımlılık veya saklanan disk nedeniyle başarısızsa stack/state’i koruyun, kalan sahip olunan kaynağı tespit edin ve aynı kurulumun temizliğini tamamlayın. Compartment silinmesinin OCI tarafında tamamlanması zaman alabilir.

Kaynaklar tamamen kalktıktan sonra boş stack’i silebilirsiniz:

```sh
commerce_oci resource-manager stack delete --stack-id "$oracle_stack"
```

**Stack’i önce silmeyin:** kaynaklar kalır, bunların state kaydı silinir. [Oracle stack silme davranışı](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/delete-stack.htm). Daha önce yalnızca plan oluşturulmuş ücretsiz ARM denemesinin ayrı stack’i de olabilir; onun Jobs/state ve kaynak listesini ayrı kontrol edin. Başka kurulumun stack’ine toplu silme uygulamayın.

## 9. Terraform dışında kalanları ayrıca kontrol edin

Bu stack Google/Firebase, Apple veya Cloudflare kaynaklarını yönetmez. Oracle Destroy bunları kaldırmaz:

- Cloudflare’de yalnızca bu kurulumun `portal`, `identity`, `*.shops` ve `*.manage` kayıtlarını kaldırın veya yeni sunucuya yönlendirin. Alan adının kendisini ve diğer DNS kayıtlarını koruyun.
- Tenant Google/Firebase projeleri, uygulamalar ve App Distribution sürümleri için ayrı test kaynağı envanterini izleyin. Ortak provisioner/FCM hesaplarını, gerçek işletme projelerini veya ortak Apple APNs/dağıtım sertifikalarını bu testle birlikte silmeyin.
- DNS-01/SMTP/OCI gibi erişim kimliklerini, artık kullanılmıyorsa ilgili sağlayıcıda iptal edin. Terraform yerel `api-key.pem` veya kullanıcıya kayıtlı API key’i kaldırmaz.
- Ücretsiz kapasite denemelerinden kalmış boot disk/yedek, ayrı stack veya Console’dan elle açılmış kaynakları inceleyin. Bunlar mevcut 9 kaynaklı state’in dışında olabilir.

Yerel `.local`, Terraform kayıtları ve VM dışına alınan yedekleri kaynakların kalktığı doğrulanmadan silmeyin. Saklanacak verileri şifreli arşivledikten sonra özel dosyaların yerel temizliğini yapın. Oracle maliyet/kota ekranından kalan kaynakları son kez kontrol edin; `STOPPED` VM veya stack’in kaybolması tek başına tam temizlik kanıtı değildir.
