# ADR-011: Tekrarlanan görevleri web süreçlerinden ayırmak

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Mağazanın açılması installer ve periyodik taskların tamamlandığını göstermez. Web/admin processleri görevleri aynı anda başlatırsa aynı tenant için çakışan işler oluşabilir. Kullanıcının önceki modeli tenant başına sıralı task yürütmesidir.

## Karar

TenantManager ayrı schedule hostuyla tenant lease alır ve tenant görevlerini sıralı child process içinde yürütür. Web süreçlerinde task yürütmesi kapalı, görev processinde açık olarak yapılandırılır. İlk kurulumun gerekli makbuzları hazır durumu için kullanılır; sonradan eklenen isteğe bağlı domain makbuzu eski tenant'ı yeniden installer'a göndermez. Etkin olmayan veya dış sağlayıcı girdisi eksik görev sessizce etkinleştirilmez.

## Alternatifler ve farkları

Her web instance'ında scheduler çalıştırmak replica sayısıyla çoğalan yürütme riski taşır. Bütün görevleri tek genel tenant bağlamında çalıştırmak veri sınırını bozar. Her tenant için sürekli ayrı daemon ise düşük kullanımda ek process maliyeti getirir.

## Sonuçlar ve bedeller

Lease süresi, görev timeout'u, process çıkışı ve loglar izlenmelidir. Redis bildirim/cache invalidation subscriberları farklı processlerde doğru kurulmalıdır. Bir test tenant'ında 10 görevin çalışması bütün tenantlarda bütün entegrasyonların hazır olduğu anlamına gelmez.

## Doğrulama ve açık sınır

Gerçek Mongo üzerinde sıralama, kesinti, tenant lease, gerekli installer makbuzları ve Redis olay akışı kontrol edilir. Kullanıcının mevcut görev etkinlik tercihleri korunur; sırf test geçsin diye tüm kapalı görevler açılmaz.

## Kaynaklar

[Schedule host](../../TenantManager/Provisioning/TenantScheduleHost.cs) · [Görev rehberi](../TENANT_BACKGROUND_TASKS.md) · [Installer](../TENANT_INITIALIZATION.md) · [Cache](../TENANT_CACHE.md)

[Karar dizinine dön](README.md).
