# ADR-007: Yerel demo ve açıkça seçilen bulut sağlayıcıları

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Kaynağı inceleyen kişi Azure, Google veya ödeme hesabı vermeden sistemi deneyebilmelidir. Gerçek domain/proje oluşturma ve imzalama ise maliyet ve yetki etkisi taşıyan ayrı operasyonlardır.

## Karar

Local demo Development + açık LocalDemo bayrağıyla çalışır ve loopback'e bağlanır. Portable Production gerçek HTTPS ve özel girdiler kullanır. Google/Firebase, Cloudflare, SMTP ve mobil imzalama sağlayıcıları açıkça seçilir. Google proje oluşturucu kimliği ile FCM runtime göndericisi ayrıdır. OCI test altyapısı Terraform/Resource Manager ve yerel operatör aracıyla kurulabilir; GitHub Actions zorunlu değildir.

## Alternatifler ve farkları

Bulut credentialını varsayılan örneğe koymak güvenli ve tekrarlanabilir değildir. Yerel adaptörü Production'da sessizce çalıştırmak yanıltıcı başarı oluşturur. Sadece GitHub Actions'a bağlı dağıtım hesap kotasında çalışmayı durdurur.

## Sonuçlar ve bedeller

Birden fazla profil/config yolu bakım ister. API kota/billing, region kapasitesi ve dış hizmet sözleşmeleri değişebilir. VM stop işlemi bütün ücretli kaynakları kaldırmaz. Domain API erişimi son kullanıcıya otomatik domain sahipliği vermez.

## Doğrulama ve açık sınır

Kimliksiz/dry-run sınırları, Local'in Production reddi ve gerçek sağlayıcıların ayrı kabul kayıtları bulunmalıdır. Teardown rehberi hem kaynakları hem yerel state/anahtar korumasını açıklamalıdır. Canlı test, kullanıcının seçtiği minimal kaynaklarla sınırlandırılır.

## Kaynaklar

[Portable worker](../../TenantManager/Provisioning/WorkerHost.cs) · [Google/Firebase](../GOOGLE_FIREBASE.md) · [Oracle kurulumu](../ORACLE_DEPLOYMENT.md) · [Test ve kaldırma](../ORACLE_TEST_VE_KALDIRMA.md)

[Karar dizinine dön](README.md).
