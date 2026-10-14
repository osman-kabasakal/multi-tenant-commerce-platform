# n8n Otomatik Entegrasyon Sistemi - Kurulum Rehberi

## Sistem Gereksinimleri

- n8n v1.0 veya üzeri
- MongoDB (mapping ve log verileri için)
- GrandNode API erişimi
- Platform API credentials

## Kurulum Adımları

### 1. n8n Kurulumu

```bash
npm install -g n8n
# veya Docker ile
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### 2. MongoDB Kurulumu

```bash
# Docker ile MongoDB
docker run --name mongodb -p 27017:27017 -d mongo:latest
```

### 3. Workflow'ları İçe Aktarma

n8n arayüzünde:
1. Settings > Import/Export > Import from File
2. Her workflow JSON dosyasını sırayla içe aktarın:

**AI Destekli Workflow'lar (Önerilen):**
   - `01-api-discovery-ai.json` - AI ile dokümantasyon analizi
   - `02-data-mapping-ai.json` - AI ile field mapping

**Klasik Workflow'lar (Fallback):**
   - `01-api-discovery.json` - Regex tabanlı analiz
   - `02-data-mapping.json` - Manuel mapping

**Senkronizasyon Workflow'ları:**
   - `03-product-sync.json`
   - `04-category-sync.json`
   - `05-order-sync.json`

### 4. Credential'ları Ayarlama

#### OpenAI API Credentials (AI workflow'lar için)
- Credential Type: `OpenAI`
- Name: `openAI`
- API Key: `your-openai-api-key`
- Organization ID: `your-org-id` (opsiyonel)

#### GrandNode API Credentials
- Credential Type: `HTTP Header Auth`
- Name: `grandNodeAPI`
- Header Name: `Authorization`
- Header Value: `Bearer {{token}}`

#### Platform API Credentials
- Her platform için ayrı credential oluşturun
- API key'lerini ve authentication bilgilerini kaydedin

### 5. MongoDB Connection
- Node Type: `MongoDB`
- Connection URL: `mongodb://localhost:27017/n8n_integrations`

## Kullanım

### Yeni Platform Entegrasyonu Ekleme

1. **API Discovery Workflow'unu Çalıştırın**:
```json
POST /webhook/api-discovery
{
  "platformName": "yeni-platform",
  "apiDocUrl": "https://api.yeni-platform.com/docs",
  "credentials": {
    "apiKey": "CHANGE_ME",
    "secret": "your-secret"
  }
}
```

2. **Data Mapping Workflow'unu Çalıştırın**:
```json
POST /webhook/data-mapping
{
  "platformName": "yeni-platform",
  "entityType": "product",
  "sampleEndpoint": "https://api.yeni-platform.com/products?limit=1"
}
```

3. **Integration'ı Aktif Hale Getirin**:
MongoDB'de `integration_mappings` collection'ında:
```json
{
  "platformName": "yeni-platform",
  "active": true,
  "webhookUrl": "https://api.yeni-platform.com/webhook" // opsiyonel
}
```

### Senkronizasyon İzleme

MongoDB'de `sync_logs` collection'ında tüm senkronizasyon loglarını görebilirsiniz:

```javascript
// Başarısız senkronizasyonları görüntüle
db.sync_logs.find({ status: "error" })

// Platform bazında istatistik
db.sync_logs.aggregate([
  { $group: { 
    _id: "$platformName", 
    total: { $sum: 1 },
    success: { $sum: { $cond: [{ $eq: ["$status", "success"] }, 1, 0] } },
    error: { $sum: { $cond: [{ $eq: ["$status", "error"] }, 1, 0] } }
  }}
])
```

## Workflow Detayları

### 1. API Discovery Workflow
- Platform API dokümantasyonunu otomatik analiz eder
- Endpoint'leri kategorilere ayırır (product, category, order)
- Authentication yöntemlerini tespit eder

### 2. Data Mapping Workflow
- Platform veri yapısını analiz eder
- GrandNode field'larıyla otomatik eşleştirme önerir
- Transform fonksiyonları oluşturur

### 3. Product Sync Workflow
- 5 dakikada bir çalışır
- Platform'dan ürün verilerini çeker
- GrandNode formatına dönüştürür
- OData API ile GrandNode'a gönderir

### 4. Category Sync Workflow
- 10 dakikada bir çalışır
- Kategori hiyerarşisini korur
- Parent-child ilişkilerini yönetir

### 5. Order Sync Workflow
- 2 dakikada bir çalışır
- Incremental sync (son senkronizasyondan sonraki siparişler)
- Duplicate order kontrolü yapar
- Platform'a webhook bildirimi gönderir

## Özelleştirme

### Custom Transform Fonksiyonları

Data mapping workflow'unda yeni transform fonksiyonları ekleyebilirsiniz:

```javascript
const customTransforms = {
  'formatPrice': 'value => (parseFloat(value) / 100).toFixed(2)',
  'formatDate': 'value => new Date(value * 1000).toISOString()',
  'booleanFromString': 'value => value === "1" || value === "true"'
};
```

### Platform Özel Ayarlar

MongoDB'de `integration_mappings` collection'ında platform özel ayarlar:

```json
{
  "platformName": "custom-platform",
  "settings": {
    "dateFormat": "unix",
    "priceFormat": "cents",
    "defaultCategory": "uncategorized",
    "customHeaders": {
      "X-API-Version": "v2"
    }
  }
}
```

## Hata Yönetimi

### Log Türleri
- `success`: Başarılı senkronizasyon
- `error`: Hata durumu
- `warning`: Uyarı (veri eksikliği vb.)

### Yaygın Hatalar ve Çözümleri

1. **Authentication Failed**:
   - API credentials'ları kontrol edin
   - Token süresi dolmuş olabilir

2. **Field Mapping Error**:
   - Data mapping workflow'unu tekrar çalıştırın
   - Custom transform fonksiyonları ekleyin

3. **Rate Limit**:
   - Workflow trigger aralıklarını artırın
   - Batch size'ları küçültün

## Performans Optimizasyonu

### Batch İşleme
- Product sync: 10'luk batch'ler
- Category sync: Hiyerarşi sırasına göre
- Order sync: Incremental (son sync'ten sonraki)

### Cache Stratejisi
- API token'ları 1 saat cache'lenir
- Field mapping'ler değişiklik olmadıkça cache'lenir
- Rate limit bilgileri Redis'te saklanır (opsiyonel)

## Monitoring ve Alerting

### Dashboard Metrikleri
- Sync success rate
- Platform response time
- Error frequency
- Data volume trends

### Alert Koşulları
- Consecutive sync failures > 3
- API response time > 30s
- Field mapping confidence < 70%
- Memory usage > 80%