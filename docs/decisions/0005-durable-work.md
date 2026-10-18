# ADR-005: Kalıcı kurulum işleri, checkpoint ve fencing

- Tarih: 2026-10-18
- Durum: Mevcut uygulamanın geriye dönük kaydı
- Kapsam: Local demo / Portable; eski Azure davranışları ayrıca belirtilir.

## Bağlam

Kurulum; DB, installer, Keycloak ve seçilmiş bulut API'leri arasında zaman alan yan etkiler üretir. Worker kesintisi veya geçici dış hata, yalnız process belleğinde ya da Redis Pub/Sub'da tutulan akışın kaybolmasına neden olabilir.

## Karar

İşler Postgres'te saklanır. Worker işi süreli lease ile alır, heartbeat yeniler ve her sıralı adımın checkpointini kaydeder. Lease kaybında eski sahip yeni sonuç yazamaz. Completion reconciler portal verisini kalıcı sonuçla uzlaştırır. Geçici/kalıcı hata ayrımı ve özel ayrıntılar için private log sınırı kullanılır.

## Alternatifler ve farkları

Redis Pub/Sub hızlı olay aktarımı içindir; geçmiş teslimi sağlamaz. Tek uzun transaction dış bulut servislerini kapsayamaz. Dağıtık saga ürünü eklemek başka bir işletim bağımlılığı getirir; bu kaynakta iş/adım sözleşmeleri açık tutulur.

## Sonuçlar ve bedeller

Dış sistemlerde “exactly once” garantisi yoktur. Adımlar var olan kaynağı tanımalı ve tekrar denemede ikinci kaynak/kimlik oluşturmamalıdır. Checkpoint, dış etkiyle DB yazısı arasındaki boşluğu tek başına kapatmaz. Kaynak sürümü, plan ve makbuz tutarlılığı ayrıca korunur.

## Doğrulama ve açık sınır

Worker öldürme/yeniden başlatma, lease devri, aynı işe iki worker, adım tekrarları ve completion kesintisi gerçek Postgres ile test edilmelidir. Hata kodu public kalabilir; credential ve provider ham yanıtları public duruma yazılmaz.

## Kaynaklar

[Worker](../../Shared/Platform.Provisioning/ProvisioningWorker.cs) · [Kuyruk](../../Shared/Platform.Provisioning/PostgresProvisioningQueue.cs) · [Onboarding](../PROVISIONING.md)

[Karar dizinine dön](README.md).
