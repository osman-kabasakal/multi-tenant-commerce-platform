# ADR-006: BuildType ile host ve eklenti çıktılarını ayırmak

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Aynı commerce modülleri storefront, admin, installer ve görev hostları tarafından kullanılır. Plugin assembly'si derlense bile yanlış BaseDir altında kalırsa ilgili runtime onu yükleyemez. Eksik installer eklentisi başlangıç ayarlarını da eksik bırakabilir.

## Karar

Dotnet build/publish çağrıları doğru BuildType taşır. Plugins altındaki bütün eklentiler bütün projelerde bulunur; Frontend dışındakiler AdminPlugins projelerini de derler. BuildType'a bağlı BaseDir ve çıktı yolu, host publish envanterinde doğrulanır. Descriptor, bağımlılık, logo ve static assetler assembly kadar çıktı sözleşmesinin parçasıdır.

## Alternatifler ve farkları

Yalnız ihtiyaç varmış gibi seçilen küçük bir plugin listesi eski installer/runtime beklentilerini bozabilir. Bütün admin eklentilerini frontend'e kopyalamak ise host sınırını genişletir. Yalnız solution build sonucuna güvenmek gerçek yükleme yolunu doğrulamaz.

## Sonuçlar ve bedeller

Host başına çıktı ve cache maliyeti vardır. MSBuild global property propagation ve ortak çıktı dizinleri yanlış yapılandırılırsa paralel derleme birbirini etkileyebilir. Dosya varlığı yanında runtime discovery ve installer makbuzları da kontrol edilmelidir.

## Doğrulama ve açık sınır

Gerçek BuildType/BaseDir mapping ve beklenen plugin envanteri test edilir. Frontend çıktısında admin pluginleri bulunmamalı; installer vergi/para birimi/adres alanı görevleri tamamlanmalıdır. Son kullanıcı verileri tekrar kurulumla ezilmez.

## Kaynaklar

[Eklenti aracı](../../scripts/build_ecommerce_plugins.py) · [Kurulum rehberi](../TENANT_INITIALIZATION.md) · [Envanter testi](../../scripts/test_tenant_plugins.py)

[Karar dizinine dön](README.md).
