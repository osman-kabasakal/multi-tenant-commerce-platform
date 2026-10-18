# ADR-002: SaaS için EF Core, kalıcı işler için açık SQL

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

İşletme/abonelik modeli ile iş sahipliği/lease modeli farklı veri erişimi ihtiyaçları taşır. SaaS modeli ilişkisel değişiklik takibi ve uygulama interceptorları kullanırken, kuyruk kısa ve atomik claim/heartbeat işlemleri gerektirir.

## Karar

SaasManager iş verisi EF Core ve Npgsql üzerinden ApplicationDbContext ile yönetilir. Shared provisioning ve secret deposu Npgsql ile açık SQL kullanır. Lease/checkpoint, fencing ve grant sınırları kendi transactionlarında görünür tutulur. Şema/yetki kurulumu ayrı owner bootstrap ile, günlük erişim sınırlı runtime hesaplarıyla yapılır.

## Alternatifler ve farkları

Her erişimi EF üzerinden yapmak tek teknoloji yüzeyi sunabilir; yine de atomik kuyruk claim'i ve izinlerin açık tasarımı gerekir. Her şeyi elle SQL yapmak ise SaaS mapping/değişiklik takibi katmanını yeniden yazdırır. Mevcut ayrım “PostgreSQL'de EF kullanılmıyor” diye anlatılmaz.

## Sonuçlar ve bedeller

İki veri erişimi yaklaşımı ve şema yönetim yolu bakım gerektirir. Aynı DB motoru kullanılması tüm uygulama/bulut yan etkilerinin tek transaction olduğu anlamına gelmez. Yeni migration veya kuyruk şeması hem owner aracı hem runtime grantleriyle uyumlu olmalıdır.

## Doğrulama ve açık sınır

Gerçek PostgreSQL üzerinde eşzamanlı claim, lease kaybı, tekrar deneme, checkpoint ve salt okunur/owner izin kontrolleri gerekir. EF query testleri SQL kuyruğunun concurrency kanıtı değildir.

## Kaynaklar

[SaaS DI](../../SaasManager/src/Infrastructure/DependencyInjection.cs) · [Kuyruk](../../Shared/Platform.Provisioning/PostgresProvisioningQueue.cs) · [Secret store](../../Shared/Platform.Security/PostgresSecretStore.cs) · [Bootstrap](../DATABASE_BOOTSTRAP.md)

[Karar dizinine dön](README.md).
