# ADR-001: Ortak çalışma ortamı, tenant başına ticaret verisi

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Küçük işletmeler için her mağazada ayrı sunucu ve bütün servisleri işletmek sabit maliyeti artırır. GrandNode'un ticaret modeli MongoDB tabanlıdır. Platform, aynı uygulama/altyapı kaynaklarını paylaşırken tenant'ın ticaret verisine erişimi daraltmalıdır.

## Karar

Storefront/admin uygulama süreçleri ve altyapı paylaşılır; her tenant ayrı MongoDB veritabanı ve o veritabanına sınırlı kullanıcı kullanır. Bilinen host ve doğrulanmış tenant kimliği birlikte doğru bağlantıyı seçer. Tenant secretları yalnız yetkili sunucular tarafından çözülür. Yeni tenant oluşturulması yeni VM oluşturulması anlamına gelmez.

## Alternatifler ve farkları

Her tenant için ayrı stack daha güçlü hata/kaynak sınırı sağlayabilir, ancak daha fazla kaynak ve operasyon ister. Tek ortak collection modelinde tenant filtresini her sorguda eksiksiz korumak gerekir. Mevcut DB-per-tenant modeli bu iki seçenek arasında bir sınırdır; diğer seçeneklerin ölçülmüş biçimde kötü olduğu iddia edilmez.

## Sonuçlar ve bedeller

İşletmelerin sabit kaynakları paylaşması mümkündür; kârlılık veya tenant başına ölçülmüş maliyet garanti edilmez. Ortak process/DB sunucusu ve merkezi secret yetkisi hata etki alanı olarak kalır. Gürültülü komşu, tenant bazlı kota, yedek geri alma ve büyüyen bağlantı sayısı ayrıca izlenmelidir.

## Doğrulama ve açık sınır

İki farklı katalog ve Mongo kullanıcısı; yanlış tenant tokenı, değiştirilmiş token, bilinmeyen host ve çapraz tenant erişim kontrolleri gerekir. Bu kontroller tek başına fiziksel izolasyon veya yük kapasitesi kanıtı değildir.

## Kaynaklar

[Mimari](../ARCHITECTURE.md) · [Yerel demo](../../scripts/demo.py) · [Tenant güvenliği](../TENANT_SECURITY.md)

[Karar dizinine dön](README.md).
