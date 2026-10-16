# GitHub Actions kullanmadan Oracle dağıtımı

GitHub yalnızca kaynak deposu olarak kullanılır. Bu akış GitHub Actions, GitHub Container Registry veya ücretli Oracle DevOps derleme hizmeti başlatmaz. Aynı `scripts/oracle.py` aracı Mac/Linux operatör bilgisayarından ya da elinizdeki bir CI çalıştırıcısından çağrılabilir. Derleme Linux sunucusunda yapılır; sunucuya GitHub erişim anahtarı gönderilmez.

Bu sürüm altyapı için Terraform + Oracle Resource Manager, uygulama için doğrulanan SSH + mevcut [Production Compose girişini](LINUX_PRODUCTION.md) kullanır. İlk kurulumda hesap yetkilendirmesi, SSH sunucu kimliğinin doğrulanması, alan adı/TLS ve özel sağlayıcı girdileri gerekir. Bu adımlardan sonra her uygulama dağıtımı tek `deploy` çağrısıdır. Push sonrası kendiliğinden çalışan bir CI sunucusu kurulmuş değildir.

## 1. Kendi Oracle hesabınızı hazırlayın

[Oracle CLI'yi kurun](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm). Araç OCI CLI **3.95.0** komutlarıyla doğrulanmıştır. Ayrı bir özel profil kullanın; hesabınızı bir kez `oci setup config` ile yapılandırabilir veya kısa ömürlü `oci session authenticate` oturumu açabilirsiniz. API anahtarı, profil ve token dosyaları Git dışında, yalnızca sahibinin okuyabildiği şekilde tutulmalı. Profil dosyası `0600` olmalı; token oturumu süre dolduğunda yenilenir. Parola/anahtar içeriğini loglara veya sohbete yazmayın.

Hedef compartment, home region, availability domain ve **resmî Always Free eligible Canonical Ubuntu 24.04 ARM64** imajının OCID'sini Console'dan seçin. Bir imaj kimliği seçildikten sonra araç onu otomatik olarak en yeni imajla değiştirmez. Operatörün [Resource Manager ve kaynak yönetimi izinleri](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm) bu compartment için tanımlanmalı; grup/politika otomatik oluşturulmaz.

Şablon tek `VM.Standard.A1.Flex`, **2 OCPU / 12 GB RAM / 100 GB boot disk**, bir VCN ve internet bağlantısı oluşturur. SSH yalnızca verdiğiniz tek genel IPv4 `/32` adresine; HTTP/HTTPS internete açıktır. Veritabanı portları yayımlanmaz. Load balancer, NAT gateway veya Kubernetes kurulmaz.

Bu boyutlar, 17 Ekim 2026'da kontrol edilen [Always Free kapsamına](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) göre seçilmiştir. **Hesabın diğer kaynakları da aynı kotayı tüketir**; uygulamadan önce kalan OCPU/RAM/disk kotasını ve imajın ücretsiz uygunluğunu Console'da kontrol edin. Araç home region dışını reddeder; ücret garantisi veya bütçe sınırı değildir. Bölge kapasitesi yetersizse ücretli shape'e veya başka bölgeye kendiliğinden geçmez. Oracle, uzun süre boşta kalan ücretsiz makineleri geri alabilir; özel durum ve veritabanı yedeklerini makine dışında saklayın.

## 2. Özel girdiyi ve SSH erişimini hazırlayın

```sh
mkdir -p .local/oracle
chmod 700 .local/oracle
cp infra/oracle/operator.example.json .local/oracle/operator.json
chmod 600 .local/oracle/operator.json
ssh-keygen -t ed25519 -f .local/oracle/deploy-key
```

`operator.json` içindeki tüm `REPLACE` alanlarını kendi hesabınızdan doldurun. `ssh_public_key` yalnızca `.pub` dosyasının tek satırlık içeriği; `ssh_source_cidr` dağıtımı çalıştıracak bilgisayarın sabit genel IPv4 adresi + `/32` olmalı. Özel SSH anahtarı Terraform'a gönderilmez. Örnek bölgeyi kendi home region'ınızla değiştirin. `deployment_id` benzersiz ve Production `DeploymentId` ile aynı olmalı.

## 3. Altyapıyı planlayın ve oluşturun

```sh
python3 scripts/oracle.py package --variables .local/oracle/operator.json --state .local/oracle/state
python3 scripts/oracle.py plan --variables .local/oracle/operator.json --state .local/oracle/state
```

`package` ağ erişimi yapmaz. ZIP yalnızca `main.tf`, `cloud-init.yaml` ve sağlayıcı kilit dosyasını içerir. `plan`, Resource Manager stack ve plan işini oluşturur; **sanal makine oluşturmaz**. Terraform sürümü [Resource Manager'ın desteklediği 1.5.x](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Reference/terraformversions.htm), OCI sağlayıcısı `7.23.0` olarak sabittir. Terraform durumunu Oracle yönetir; uygulama anahtarları ve TLS dosyaları bu duruma girmez.

Console → Developer Services → Resource Manager → Stacks bölümünden oluşturulan stack ve planı inceleyin. Planın yalnızca beklenen kaynakları oluşturduğunu ve kalan ücretsiz kotaya sığdığını doğrulayın. Çıktıdaki gerçek plan OCID'si ile uygulayın:

```sh
python3 scripts/oracle.py apply --variables .local/oracle/operator.json --state .local/oracle/state \
  --reviewed-plan ocid1.ormjob.REPLACE_WITH_REVIEWED_PLAN \
  --always-free-budget-confirmed
```

`--oci-config /absolute/private/config --profile COMMERCE` ile farklı bir profil; `--oci /absolute/path/to/oci` ile farklı CLI seçilebilir. İşler zaman aşımına uğrarsa aynı komutu tekrar çalıştırın: kaydedilmiş iş/tag üzerinden devam edilir. Belirsiz create sonucu körlemesine tekrarlanmaz. Başarısız bir işi Console'da inceleyip sorununu çözdükten sonra `plan --new-plan` ile yeni plan hazırlayın ve onu yeniden inceleyin. Kısmi apply sonrası da yeni plan gerekir.

`.local/oracle/state/outputs.json` sunucu IP ve kaynak kimliğini içerir. Bu klasörü koruyun. Stack/VM girdileri otomatik güncellenmez; imaj, bölge veya SSH kaynak adresi değişikliği açıkça planlanan bir altyapı değişikliğidir. Mevcut kurulum dosyasını silerek tekrar başlamayın. Terraform kaynaklarında `prevent_destroy`, sunucuda ayrıca boot diski koruma ayarı vardır; Console'dan elle silme ve veri kaybına karşı yedek yerine geçmezler.

## 4. Sunucu kimliğini bir kez doğrulayın

Oracle Console'un doğrulanmış instance console bağlantısından sunucunun SSH Ed25519 host key parmak izini okuyun (`ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub`). Yerel `ssh-keyscan -t ed25519 SUNUCU_IP` çıktısının parmak izini bununla karşılaştırın. **Sadece ağdan okunan anahtara güvenerek ilerlemeyin.** Eşleşen kaydı `.local/oracle/known_hosts` içine kaydedip `chmod 600` uygulayın.

Dağıtım `StrictHostKeyChecking=yes` kullanır. Kimliği değişen veya doğrulanmamış sunucuya kaynak kodu/gizli bilgi göndermez; SSH agent forwarding de kapalıdır. Otomasyon için aynı doğrulanmış dosyayı CI'nin özel dosya deposuna taşıyabilirsiniz.

## 5. DNS, TLS ve sağlayıcı girdilerini yerleştirin

Sunucunun ilk açılış kurulumu Ubuntu Docker/Compose, Git, Python ve OpenSSL'i hazırlar. SSH kullanıcısı `ubuntu` olmalı. Uygulama girdilerini şu özel dizinde hazırlayın:

```text
/home/ubuntu/commerce-DEPLOYMENT_ID/inputs/deployment.json
/home/ubuntu/commerce-DEPLOYMENT_ID/inputs/fullchain.pem
/home/ubuntu/commerce-DEPLOYMENT_ID/inputs/privkey.pem
```

Dizinler `0700`, dosyalar `0600` olmalı. Bunları yerelden **doğrulanmış SSH/SCP** ile taşıyın. Üst kurulum dizini önceden yalnızca `inputs/` içermeli; araç ilgisiz bir mevcut kurulumu sahiplenmez. [Production örneğini](../infra/production/deployment.example.json) kopyalayıp gerçek alan adlarını, SMTP ayarlarını ve **sunucudaki mutlak TLS/credential yollarını** yazın. Google/FCM/APNs anahtarları kullanılıyorsa ayrı özel dosyalar olarak gönderilir; Terraform/ZIP/Git içine konmazlar. [Google/Firebase kurulumu](GOOGLE_FIREBASE.md) ve [işletme ekleme rehberi](YENI_ISLETME_EKLEME.md) aynı şekilde geçerlidir.

Portal/identity ve `*.shops` / `*.manage` DNS kayıtlarını sunucu IP'sine yönlendirin. Mevcut ücretsiz Cloudflare full-zone sertifikası derin tenant adlarını kapsamaz; bu adlar için DNS-only kayıtlar ve tarayıcıların güvendiği, ilgili wildcard adlarını kapsayan bir origin sertifikası kullanın. DNS-01 sertifika edinme/yenileme ve SMTP teslimi bu altyapı şablonunun dışında, işletmecinin kurulum sorumluluğudur. [TLS ayrıntıları](LINUX_PRODUCTION.md).

ARM64 A1 sunucusunda mevcut Android paket işçisi çalışmaz. İlk web/Google denemesinde Mobile `Disabled` kullanın. Mac iOS tüketicisi mevcuttur; ancak bu A1 kurulumunda Mobile Disabled olduğu için yeni tenant'larda otomatik mobil teslim başlamaz. Android için ayrı dağıtık derleme kuyruğu henüz yoktur. Bu şablon bütün mobil akışın Oracle'da tamamlandığı iddiasında bulunmaz.

## 6. Commit'i tek çağrıyla dağıtın

Dağıtılacak değişiklikler commit edilmiş olmalı; araç yalnızca yerel **HEAD** commit'ini ve temiz monorepo geçmişini içeren Git bundle gönderir. Çalışma kopyasındaki değişiklikleri, `.local`, `.git/config`, GitHub token'larını veya ignored dosyaları kopyalamaz. İlk receiver dosyası da commit edilmiş HEAD'den okunur.

```sh
python3 scripts/oracle.py deploy --variables .local/oracle/operator.json --state .local/oracle/state \
  --identity .local/oracle/deploy-key --known-hosts .local/oracle/known_hosts
```

Sunucu commit'e ait ayrı kaynak dizinini açar; aynı kalıcı `state/` diziniyle `production.py up` çalıştırır. Sunucu üzerinde doğru UID/GID ve commit etiketiyle imaj derlenir. Mevcut ortak şifreleme anahtarı, kullanıcılar ve veritabanları korunur; aynı sunucudaki eşzamanlı dağıtım kilitle engellenir. Başarı yalnızca mevcut HTTPS/identity/tenant-host doğrulamaları geçerse kaydedilir. Sonuç `.local/oracle/state/deployment.log`, sunucu ayrıntıları kurulum dizinindeki `deploy.log` ve `state/logs/` altında özeldir.

Dağıtım mevcut servisleri yeniden oluşturur; kısa kesinti olabilir. Başarısızlıkta otomatik veri silme veya veritabanı geri alma yoktur. Güncellemeden önce [soğuk yedek](LINUX_PRODUCTION.md) alın; şema değişikliği içeren bir güncellemeyi yalnızca eski commit'e dönerek geri almak güvenli olmayabilir.

## Doğrulama kapsamı

Yerel güvenlik/tekrar deneme testleri `python3 -m unittest discover -s scripts -p test_oracle.py` ile çalıştırılır. Terraform `fmt`, gerçek sabit OCI sağlayıcısıyla `init/validate` ve farklı platformlar için sağlayıcı kilidi ayrıca doğrulanmıştır. Canlı Oracle API kimliği ve Resource Manager planı ayrıca doğrulandı: 6 kaynak ekleme, 0 değiştirme, 0 silme. Frankfurt’taki üç availability domain 2 OCPU/12 GB A1 boyutu için OUT_OF_HOST_CAPACITY döndüğü için apply çalıştırılmadı. İlk açılış ve public HTTPS dağıtımı henüz doğrulanmadı. [Kaynak hash’lerine bağlı kayıt](validation/oracle-plan-20261017.json).

Sabit operatör araçlarının sürüm ve lisans kaynakları: [Oracle toolchain kaydı](licenses/ORACLE_TOOLCHAIN.md). Bu kayıt ana projedeki açık varlık haklarını kapatmaz.
