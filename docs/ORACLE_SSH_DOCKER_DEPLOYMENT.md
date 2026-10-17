# Oracle üzerinde SSH ve Docker ile dağıtım

Bu projede dağıtımı operatörün Mac veya Linux bilgisayarı başlatır. Oracle Resource Manager, Terraform tarifinden Linux sunucusunu oluşturur. Operatör, commit edilmiş kaynak kodunu doğrulanmış SSH bağlantısıyla bu sunucuya gönderir. Sunucu Docker imajlarını derler ve uygulamaları Docker Compose ile çalıştırır.

GitHub kaynak kodunun saklandığı yerdir. Bu akış GitHub Actions kotası, GitHub Container Registry veya ayrı bir bulut derleme sunucusu gerektirmez. Aşağıdaki işlemler mevcut operatör aracının yaptığı işleri ve aynı kurulumu kendi hesabınızda nasıl tekrarlayacağınızı açıklar. Hesap ve kaynak seçimi için [Oracle kurulum rehberini](ORACLE_DEPLOYMENT.md), uygulama girdileri için [Linux Production rehberini](LINUX_PRODUCTION.md) birlikte kullanın.

## İşlemler nerede çalışıyor

```mermaid
flowchart LR
    M[Operatörün Mac veya Linux bilgisayarı] -->|OCI API ve Terraform planı| R[Oracle Resource Manager]
    R -->|Ağ ve sanal makine| V[Ubuntu sunucusu]
    G[GitHub kaynak deposu] -->|Kaynak sürümünü edinme| M
    M -->|Doğrulanmış SSH ile Git bundle| V
    V --> B[Docker imajlarını derleme]
    B --> C[Docker Compose servisleri]
    U[Kullanıcının tarayıcısı] -->|DNS ve HTTPS| E[Caddy giriş servisi]
    E --> C
```

| İşlem | Çalıştığı yer | Sorumlu dosya |
| --- | --- | --- |
| Oracle kimlik doğrulaması, plan, apply ve SSH dağıtımı | Operatör bilgisayarı | [scripts/oracle.py](../scripts/oracle.py) |
| Sunucu, ağ, disk ve test durdurma kuralının tarifi | Oracle Resource Manager | [infra/oracle](../infra/oracle/) |
| Docker ve işletim sistemi araçlarının ilk kurulumu | Ubuntu ilk açılışı | [cloud-init.yaml](../infra/oracle/cloud-init.yaml) |
| Git bundle alma ve doğru commit dizinini hazırlama | Ubuntu, `ubuntu` kullanıcısı | [oracle_remote.py](../scripts/oracle_remote.py) |
| Özel yapılandırma üretme ve servisleri başlatma | Ubuntu, `ubuntu` kullanıcısı | [production.py](../scripts/production.py), [production_config.py](../scripts/production_config.py) |
| Uygulama imajını temiz Git sürümünden derleme | Sunucudaki Docker | [production_image.py](../scripts/production_image.py), [Dockerfile](../infra/production/Dockerfile) |
| Veritabanı ve özel durumun tutarlı yedeğini alma | Ubuntu | [production_backup.py](../scripts/production_backup.py) |

## Birinci aşama Oracle sunucusunun oluşturulması

Operatörün OCI CLI profili kendi Oracle kullanıcısı, API anahtarı ve tenancy bilgileriyle yapılandırılır. API private key ve profil dosyası operatör bilgisayarında, Git dışında kalır. Sunucuya GitHub token veya OCI API anahtarı kopyalanmaz.

`operator.json` dosyası yalnızca bölge, compartment, availability domain, sabit Ubuntu imajı, deployment adı, SSH public key ve SSH için izin verilen operatör IPv4 adresini içerir. Kredi testinde ayrıca kaynak profili ve kesin UTC durdurma saati vardır. Bu dosyada uygulama parolaları bulunmaz.

Operatör aracı Resource Manager için yalnızca şu dört dosyayı paketler:

```text
main.tf
credit.tf
cloud-init.yaml
.terraform.lock.hcl
```

Terraform şablonu tek VM, VCN, subnet, internet gateway, route table ve security list oluşturur. Kredi profili bunlara izole bir compartment, VM durdurma zamanlayıcısı ve sadece o zamanlayıcıya ait dar kapsamlı politika ekler. Load balancer, NAT gateway ve Kubernetes bu kurulumun parçası değildir.

Varsayılan `always-free-arm` profili A1 üzerinde 2 OCPU ve 12 GB RAM kullanır. Açıkça seçilen `credit-minimal-amd64` test profili E5 üzerinde 1 OCPU, 8 GB RAM ve 100 GB boot disk kullanır. Ücretli profile otomatik geçiş yapılmaz. Kredi testinin durdurma saati en fazla altı saat ileride seçilir; tekrar çalıştırma bu saati uzatmaz. Boyut ve maliyet koşulları [Oracle rehberinde](ORACLE_DEPLOYMENT.md) açıklanır.

İlk hazırlığın ardından aşağıdaki çağrılar operatör bilgisayarında çalışır. Örneklerde OCI profilinin `COMMERCE`, özel dosyaların `.local/oracle/` altında olduğu varsayılır:

```sh
python3 scripts/oracle.py package \
  --variables .local/oracle/operator.json --state .local/oracle/state

python3 scripts/oracle.py plan \
  --variables .local/oracle/operator.json --state .local/oracle/state \
  --oci-config .local/oracle/config --profile COMMERCE
```

`package` buluta bağlanmaz. `plan` bir Resource Manager stack ve plan işi oluşturur; VM oluşturmaz. Operatör planı inceleyip yalnızca beklediği kaynakları içerdiğini gördükten sonra çıktıda verilen gerçek plan kimliğini uygular:

```sh
python3 scripts/oracle.py apply \
  --variables .local/oracle/operator.json --state .local/oracle/state \
  --oci-config .local/oracle/config --profile COMMERCE \
  --reviewed-plan ocid1.ormjob.REPLACE_WITH_REVIEWED_PLAN \
  --trial-credit-use-confirmed
```

Bu son örnek kredi profiline aittir. Ücretsiz profilde bunun yerine `--always-free-budget-confirmed` kullanılır. Sonuçtaki VM kimliği, genel IP, stack ve iş kimlikleri özel state dizinine kaydedilir. Aynı komut kaydedilmiş işi devam ettirir; belirsiz bir oluşturma çağrısı körlemesine tekrarlanmaz.

## İkinci aşama Ubuntu ilk açılışı ve SSH güveni

Oracle, VM açılırken `cloud-init.yaml` dosyasını çalıştırır. Bu dosya Ubuntu paketlerinden Docker, Docker Buildx, Docker Compose, Git, Python ve OpenSSL'i kurar; Docker servisini açar ve `ubuntu` kullanıcısını Docker grubuna ekler. HTTP ve HTTPS için işletim sistemi firewall kuralını kalıcı bir systemd servisiyle hazırlar. Parolayla SSH ve root SSH erişimi kapalıdır.

SSH yalnızca operatör girdisindeki genel IPv4 `/32` adresine açıktır. HTTP 80 ve HTTPS 443 dışarıya açıktır. PostgreSQL, MongoDB, Redis ve Keycloak'un iç HTTP portları internete yayımlanmaz.

İlk SSH bağlantısından önce sunucunun Ed25519 host key kimliği Oracle'ın doğrulanmış console kaydından veya instance console bağlantısından doğrulanır. Ağdan gelen `ssh-keyscan` sonucunu tek başına güvenilir kabul etmek yeterli değildir. Console history içeriği CLI'de varsayılan olarak ilk 10 KB ile sınırlı gelebilir; ilk açılış anahtarlarını okumak için `get-content --length 1048576` kullanılabilir.

Doğrulanan anahtar özel `known_hosts` dosyasına yazılır. Dağıtım aracı şu koşullarla SSH açar:

- `StrictHostKeyChecking=yes` ile sunucu kimliğini kontrol eder.
- Yalnızca açıkça verilen SSH private key ve `known_hosts` dosyasını kullanır.
- Parola sormadan çalışır ve SSH agent forwarding yapmaz.
- Sunucuda root yerine `ubuntu` kullanıcısıyla uygulama işlemlerini yürütür.

Özel anahtar dosyaları `0600`, özel dizinler `0700` olmalıdır. SSH public key Terraform'a girer; SSH private key operatör bilgisayarında kalır.

## Üçüncü aşama alan adı HTTPS ve özel girdiler

Operatör portal, identity ve tenant wildcard DNS kayıtlarını VM'nin IP adresine yönlendirir. Örnek adlar şöyledir:

```text
portal.example.com
identity.example.com
*.shops.example.com
*.manage.example.com
```

Bu çalışmadaki HTTPS sertifikası operatör bilgisayarında Certbot ve Cloudflare DNS doğrulamasıyla alındı. Geçici TXT doğrulama kayıtlarını Certbot oluşturup kaldırdı. Cloudflare token bu işlem için operatör bilgisayarında kaldı. Uygulamanın tenant adları wildcard DNS üzerinden çözüldüğü için her işletme için ayrıca Cloudflare kaydı açılması gerekmez.

Ücretsiz Cloudflare full-zone sertifikası derin tenant adlarını otomatik kapsamaz. Bu dağıtımda DNS-only kayıtlar ve tarayıcıların güvendiği, gerekli wildcard adlarını kapsayan origin sertifikası kullanılır. Sertifikanın süresi dolmadan yenilenmesi işletmecinin sorumluluğundadır.

Operatör sertifika, uygulama deployment girdisi ve seçtiği sağlayıcıların kimlik dosyalarını doğrulanmış SSH/SCP üzerinden ayrı olarak taşır. Bunlar kaynak bundle içine girmez:

```text
/home/ubuntu/commerce-DEPLOYMENT_ID/inputs/
  deployment.json
  fullchain.pem
  privkey.pem
  google-provisioning.json       Google açıksa
  google-notifications.json     FCM açıksa
  apns-key.p8                   Doğrudan APNs açıksa
```

`deployment.json` içindeki dosya yolları sunucudaki mutlak yollardır. Google proje oluşturan hesabın dosyası yalnızca worker servisine bağlanır. Ayrı FCM gönderici hesabı mağaza ve yönetim servislerine bağlanır. APNs anahtarı sadece bildirim gönderen uygulama servislerine verilir. Apple imzalama ve App Store Connect private anahtarları Linux sunucusunun bu web girdilerine dahil değildir.

## Dördüncü aşama kaynak kodunun SSH ile taşınması

Operatör dağıtacağı kaynakları önce commit eder. Sonra aşağıdaki komutu yine kendi bilgisayarında çalıştırır:

```sh
python3 scripts/oracle.py deploy \
  --variables .local/oracle/operator.json --state .local/oracle/state \
  --oci-config .local/oracle/config --profile COMMERCE \
  --identity .local/oracle/deploy-key \
  --known-hosts .local/oracle/known_hosts
```

`oracle.py` önce kayıtlı stack, başarılı apply sonucu ve kredi profilinde gerçek durdurma kuralını doğrular. Git'ten mevcut `HEAD` commit kimliğini alır. `git bundle create ... HEAD` ile bu commit'i ve eriştiği Git geçmişini tek dosyada paketler. Çalışma dizinindeki commit edilmemiş değişiklikler, ignored `.local` dosyaları ve yerel `.git/config` bu pakette bulunmaz.

Araç, receiver programını da aynı commit'ten `git show` ile okur. Doğrulanmış SSH bağlantısında bu programı çalıştırır ve bundle'ı standart giriş üzerinden gönderir. Sunucunun GitHub'a bağlanmasına veya GitHub kimlik bilgisi almasına gerek kalmaz.

Receiver daha önce oluşturduğu kurulum sahiplik kaydını, özel dizinleri ve deployment adını kontrol eder. Aynı kurulumda eşzamanlı iki dağıtımı kilitle engeller. Gönderilen commit için ayrı bir kaynak dizini oluşturup doğru commit'i checkout eder. Mevcut kaynak dizini elle değiştirilmişse onu sessizce kabul etmez.

Sunucudaki kalıcı düzen şöyledir:

```text
/home/ubuntu/commerce-DEPLOYMENT_ID/
  inputs/                    Operatörün özel girdileri
  oracle-installation.json   Receiver sahiplik kaydı
  deploy.lock                Aynı sunucudaki dağıtım kilidi
  deploy.log                 Uygulama kurulumunun özel çıktısı
  sources/
    COMMIT_SHA/              Commit'e ait temiz kaynak dizini
  state/                     Anahtarlar ve kalıcı uygulama durumu
  last-successful-revision   HTTPS kontrolleri geçen son commit
```

## Beşinci aşama sunucuda Docker derlemesi

Receiver, kaynak dizinindeki `production.py up` komutunu özel deployment girdisi ve aynı kalıcı `state/` diziniyle çalıştırır. Uygulama imajı eksikse `production_image.py`, sunucudaki commit'i `git archive` ile temiz derleme girdisine dönüştürür ve Docker'a verir.

Dockerfile birden çok derleme aşaması kullanır. .NET 8 tarafında mağaza, yönetim uygulaması, installer, gateway ve cloud aracı; .NET 9 tarafında SaaS, tenant worker ve bootstrap aracı derlenir. SaaS'ın gerçek Angular arayüzü de bu işlemde hazırlanır. Son runtime imajı .NET 8 ve .NET 9 çalışma ortamlarını içerir ve sunucudaki dağıtım hesabının sayısal UID/GID'siyle root olmadan çalışır.

İmaj `commerce-platform:COMMIT_KISA_KIMLIGI` adıyla sunucuda tutulur. İçindeki `org.opencontainers.image.revision` etiketi tam commit kimliğini taşır. Başlatma aracı bu etiketin kaynak commit'i ve imaj kullanıcısının operatör hesabıyla eşleşmesini kontrol eder. Çalışma zamanı kimlik dosyaları Docker derleme girdisine eklenmez; servisler başlatılırken ayrı, salt okunur bağlarla verilir.

## Altıncı aşama Compose servislerinin açılması

`production_config.py` özel `state/` altında Compose tanımını, servis yapılandırmalarını, Caddy ayarını, Keycloak realm girdisini ve gerekli anahtarları hazırlar. İlk kurulum kaydı anahtarları bir kez üretir. Sonraki çalıştırmalar aynı kaydı kullanır; mevcut ortak şifreleme anahtarı ve parolalar otomatik yenilenmez.

Başlatma sırası şöyledir:

1. PostgreSQL, MongoDB ve Redis açılır; hazır olmaları beklenir.
2. Kurulum sahipliği kontrol edilerek veritabanları ve sınırlı uygulama hesapları hazırlanır.
3. Bootstrap aracı uygulama şemalarını ve deneme planını hazırlar.
4. Keycloak açılır; tenant-provisioner istemcisinin gerçek kimlik doğrulaması sınanır.
5. Yapılandırılmış kullanıcı kaydı ve SMTP politikası mevcut realm'e uygulanır.
6. SaaS, mağaza, yönetim, gateway, worker ve Caddy açılır.
7. Gerçek HTTPS üzerinden portal, identity metadata ve bilinmeyen tenant reddi kontrol edilir.

Sadece konteynerin çalışıyor olması dağıtımı başarılı saydırmaz. Receiver `last-successful-revision` kaydını ancak mevcut uygulama ve HTTPS kontrolleri geçtiğinde yazar.

| Servis | Görevi |
| --- | --- |
| `edge` | Caddy ile HTTPS sonlandırma ve doğru uygulamaya yönlendirme |
| `saas` | İşletme sahibinin portalı ve kayıt işlemleri |
| `keycloak` | Kullanıcı girişi, e-posta doğrulaması ve istemci token'ları |
| `gateway` | Tenant adına göre mağaza veya yönetim servisine yönlendirme |
| `commerce` ve `admin` | Tenant mağazası ve yönetim uygulaması |
| `worker` | Kuyruktan tenant kurulumu ve seçilmiş dış sağlayıcı adımları |
| `postgres` | SaaS, identity, şifrelenmiş tenant secret'ları ve iş kuyruğu |
| `mongo` | Tenant mağazalarının ayrı veritabanları |
| `redis` | Önbellek ve uygulama içi olay iletişimi |

Tenant secret'ları ortak AesGcm sağlayıcısı ve özel PostgreSQL deposuyla kullanılır. Dağıtık servisler aynı korunan master key'e erişir; mağaza ve yönetim için okuma hesabı, worker için gerekli yazma hesabı verilir. Yedekte şifreli veritabanı ile ilgili master key birlikte korunmalıdır.

## Küçük sunucuda Android derleme ayarı

Android mobil profili seçildiğinde Production hazırlığı `state/mobile-cache/gradle/gradle.properties` dosyasını ilk kullanımda özel izinlerle oluşturur. Varsayılan Gradle heap sınırı 2 GB, metaspace sınırı 512 MB ve paralel işçi sayısı birdir. Kotlin derleyicisi aynı Gradle sürecinde çalışır; ayrı bir compiler daemon başlatılmaz. Bu sınırlar diğer uygulama servislerine alan bırakmak içindir; tüm sunucunun toplam RAM kullanımına konulan bir limit değildir.

Gradle kullanıcı dizinindeki bu dosya proje içindeki iş istasyonu ayarlarından önceliklidir. `Platforms/store_user_app/android/gradle.properties` ve mobil kaynağın hash değeri değiştirilmez. Operatör mevcut özel cache dosyasını düzenlediyse `prepare` sonraki dağıtımda onun üzerine yazmaz. Dosya sahibi, izinleri ve sembolik bağlantılar kontrol edilir. Cache diskte tutulur; imza anahtarları ve değişmez APK çıktıları ayrı kalıcı alanlarda korunur.

Gradle öncelik sırası [resmî Gradle belgesinde](https://docs.gradle.org/current/userguide/build_environment.html), Kotlin süreç seçimi [resmî Kotlin belgesinde](https://kotlinlang.org/docs/gradle-compilation-and-caches.html#defining-kotlin-compiler-execution-strategy) açıklanır. Android SDK lisansları ve imza/kalıcı artifact seçenekleri açıkça seçilmeden mobil profil etkinleşmez.

## Kullanıcının isteği sunucuda nasıl ilerliyor

Tarayıcı portalı HTTPS ile açınca Caddy isteği SaaS'a iletir. Giriş gerektiğinde SaaS, kullanıcıyı Keycloak'a yönlendirir. Kimlik servisi tarayıcıya açık HTTPS adresini kullanır; uygulamalar arasındaki kimlik çağrıları standart 443 kurulumunda Docker ağındaki özel edge IP'sine gider. TLS adı ve token issuer aynı kalır.

Bu özel yönlendirme önemlidir: Oracle VM kendi public IP'sine geri dönerken kaynak adresi değişebilir. Keycloak yönetim yoluna böyle gidilirse özel ağ kontrolü 404 döndürebilir. Compose'un `extra_hosts` ayarı bunu sunucu içinde çözer. Dışarıdan Keycloak yönetim yoluna erişim açılmaz. Özel HTTPS portlarında iç dinleyici ve yönlendirme ayrıca eşleştirilmelidir.

Yeni kullanıcı kaydı için `Identity.RegistrationAllowed=true` ve geçerli SMTP ayarları gerekir. `verifyEmail=true` korunur. SMTP doğrulaması, kullanıcı kaydı ve tenant kurulumunun farklı aşamalarıdır: SMTP bağlantı/kimlik kontrolünün geçmesi e-postanın gelen kutusuna ulaştığı anlamına gelmez. Kullanıcı doğrulama bağlantısını açınca işletme formuna devam eder. Ayrıntılı kullanıcı adımları [yeni işletme ekleme rehberindedir](YENI_ISLETME_EKLEME.md).

İşletme kaydı tenant işini kuyruğa yazar. Worker tenant secret'larını, MongoDB ve mağaza kurulumunu, Keycloak client'ını, seçilmişse Google/Firebase projesini ve yayın adımını yürütür. Bir sağlayıcı hatasında aynı iş ve tamamlanmış adımlar korunur. Yeni işletme açarak tekrar denemek yerine sahibi mevcut işin yeniden deneme yolunu kullanır.

## Güncelleme loglar yedek ve durdurma

Uygulama değişikliği commit edildikten sonra aynı `deploy` komutu çağrılır. Receiver yeni commit için kaynak dizini açar, aynı `state/` ile yeni imajı derler ve servisleri günceller. Compose güncellemesinde kısa kesinti olabilir. Bu akışta otomatik push tetikleyicisi veya ayrı bir CI sunucusu kurulmuş değildir; aynı operatör komutu kendi CI çalıştırıcınızdan da çağrılabilir.

Oracle şablonu değişirse araç hash uyuşmazlığını reddeder. Özgün hedef, anahtar, kaynak boyutu ve durdurma saati aynı kalıyorsa `plan --update-template` ile yeni plan hazırlanır; operatör yeni planı ayrıca inceleyip uygular. Bu seçenek girdi değiştirerek başka kaynağı sahiplenme yolu değildir. Uygulama onarımı ile altyapı değişikliği ayrı işlemlerdir.

Operatör bilgisayarında `.local/oracle/state/deployment.log`, sunucuda kurulum kökündeki `deploy.log` ve `state/logs/deployment.log` ayrıntıları içerir. Canlı durumu sunucuda şu şekilde okuyabilirsiniz:

```sh
docker compose --project-name commerce-prod-DEPLOYMENT_ID \
  --file /home/ubuntu/commerce-DEPLOYMENT_ID/state/compose.json ps
```

Loglar ve özel state herkese açık hata raporlarına doğrudan eklenmemelidir. Şema değişikliği içeren güncellemelerden önce [Production yedekleme akışını](LINUX_PRODUCTION.md) kullanın. Önceki commit'e dönmek veritabanını eski şemaya geri döndürmez; geri dönüşte eşleşen state, veritabanı yedeği, UID/GID ve runtime imajları gerekir.

Kredi testini durdurmak için aynı özel girdi ve state ile operatör bilgisayarında çalıştırın:

```sh
python3 scripts/oracle.py stop \
  --variables .local/oracle/operator.json --state .local/oracle/state \
  --oci-config .local/oracle/config --profile COMMERCE
```

Bu işlem yalnızca sahip olunan test VM'sine Oracle API üzerinden stop ister. Ardından Oracle'da `STOPPED` durumu doğrulanmalıdır. Veri, boot disk ve özel state silinmez; saklanan diskin kota veya ücret kullanımı devam edebilir. İşletim sistemi içinden kapatma ile Oracle'ın ölçümü durduran stop işlemi aynı değildir. Durdurma komutu kaynak şablonu güncellenmiş veya test süresi dolmuş olsa da özgün girdi ve uzak sahipliği kontrol ederek çalışabilir.

## Bu canlı denemede doğrulanan bölüm

17 Ekim 2026 denemesinde GitHub Actions kullanılmadan tek E5 sunucuda kaynak kodu derlendi ve Production Compose başlatıldı. Portal ve identity gerçek DNS ve güvenilir HTTPS üzerinden açıldı; bilinmeyen tenant ve dış yönetim yolu reddedildi. Yanlış client secret ile token isteği 401 aldı.

Tek bir sentetik işletme sahibiyle gerçek SaaS giriş ve işletme kaydı yapıldı. İlk tenant işi kimlik yönetimi yolunda başarısız oldu; özel ağ yönlendirmesi düzeltildikten sonra aynı iş yeniden denendi ve gerçek Google/Firebase dahil yayın adımı tamamlandı. Bu denemedeki kullanıcı hesabı operatör tarafından e-postası doğrulanmış test hesabı olarak oluşturuldu; bu sonuç gerçek posta kutusuna yeni kayıt e-postası tesliminin kanıtı değildir.

Oracle profilinde 30, Production yapılandırmasında 14 yerel kontrol geçti. Sunucunun ilk açılışında kesilen paket kurulumu aynı VM'de tamamlandı; eksik Docker Buildx bileşeni sonraki temiz kurulumların tarifine eklendi. Mevcut testte mobil profil `Disabled` seçilidir. Android APK, imzalı iOS IPA ve cihaz bildirimleri ayrı kabul adımlarıdır.

İlk kurulum `oracle.py plan`, `apply` ve `deploy` ile yürütüldü. Bootstrap tarifine sonradan eklenen düzeltme canlı altyapıya otomatik apply edilmedi. Uygulama bağlantısı onarımı, özgün uzak stack/girdiler ve durdurma kuralı yeniden doğrulandıktan sonra aynı `oracle.deploy` yordamı ve SSH receiver üzerinden uygulandı; VM boyutu, Terraform durumu ve son saat korunarak yeni commit dağıtıldı.

SMTP sağlayıcısının geçerli TLS 465 bağlantısı ve kimlik doğrulaması Mac ve Oracle’dan geçti. Keycloak kaydı ile e-posta doğrulaması açıldı ve gerçek Register bağlantısı/kayıt formu okundu. Test aracı kayıt formu göndermedi veya e-posta yollamadı; gerçek posta kutusu teslimi ayrı kontroldür. Kullanıcı portalı incelerken servisler açık tutuldu ve ilk otomatik durdurma saati değiştirilmedi.

Kaynak sürümleri, gerçek altyapı ve uygulama kontrol sonuçları [doğrulama kayıtlarından](VALIDATION.md) takip edilir. [Bu canlı denemenin kaynak kaydı](validation/oracle-credit-20261017.json) ilk kısmi hatayı, onarımları ve doğrulama sınırlarını birlikte saklar. Genel kurulum tarifi kişisel hesap, IP, parola veya private key içermez; her operatör kendi özel girdilerini hazırlar.
