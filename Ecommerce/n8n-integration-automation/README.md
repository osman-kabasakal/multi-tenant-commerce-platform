# n8n Otomatik Entegrasyon Sistemi

Bu sistem, yeni platform entegrasyonlarını otomatik olarak GrandNode'a bağlamak için tasarlanmıştır.

## Sistem Özellikleri

1. **API Dokümantasyon Analizi**: Verilen API dokümantasyon URL'sinden endpoint'leri ve veri yapılarını otomatik tespit eder
2. **Veri Mapping**: Platform verilerini GrandNode veri yapısına otomatik eşler
3. **Senkronizasyon**: Ürün, kategori ve sipariş verilerini senkronize eder
4. **Hata Yönetimi**: Başarısız işlemleri loglar ve tekrar dener

## Workflow Yapısı

### 1. API Discovery Workflow
- API dokümantasyonunu okur
- Endpoint'leri tespit eder
- Request/Response formatlarını analiz eder
- Authentication metodunu belirler

### 2. Data Mapping Workflow
- Platform veri yapısını analiz eder
- GrandNode karşılıklarını bulur
- Mapping kurallarını oluşturur
- Dönüşüm fonksiyonlarını hazırlar

### 3. Sync Workflows
- Product Sync Workflow
- Category Sync Workflow
- Order Sync Workflow

## Gereksinimler

- n8n v1.0+
- GrandNode API erişimi
- Platform API credentials
- MongoDB (mapping kayıtları için)