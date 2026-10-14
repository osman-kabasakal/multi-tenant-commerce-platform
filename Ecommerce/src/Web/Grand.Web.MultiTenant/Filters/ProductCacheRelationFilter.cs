using Grand.Infrastructure.Caching;
using Grand.Infrastructure.Caching.Constants;
using Grand.Infrastructure.Caching.Redis;
using Grand.Infrastructure.Models;
using Grand.Web.Models.Catalog;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;
using System.Collections;
using System.Collections.Concurrent;
using System.Linq;
using System.Reflection;

namespace Grand.Web.MultiTenant.Filters
{
    /// <summary>
    /// Action filter that relates cache keys with product data in JsonResult responses
    /// </summary>
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple = false, Inherited = true)]
    public class ProductCacheRelationFilterAttribute : TypeFilterAttribute
    {
        public ProductCacheRelationFilterAttribute() : base(typeof(ProductCacheRelationFilter))
        {
        }

        internal class ProductCacheRelationFilter : IAsyncResultFilter
        {
            private readonly RedisCacheCoordinator _cacheTracker;
            private readonly ILogger<ProductCacheRelationFilter> _logger;
            private readonly IHttpContextAccessor _httpContextAccessor;
            private readonly ICacheBase _cacheBase;

            // Paralel işlem limiti ve semaphore
            private static readonly SemaphoreSlim
                _throttleSemaphore = new SemaphoreSlim(10, 10); // Max 10 eşzamanlı işlem

            private static readonly ConcurrentQueue<TaskCompletionSource<bool>> _shutdownTasks =
                new ConcurrentQueue<TaskCompletionSource<bool>>();

            private static int _activeTaskCount = 0;
            private static readonly TimeSpan _taskTimeout = TimeSpan.FromSeconds(30); // İşlem zaman aşımı
            private static readonly ILogger _staticLogger;

            public ProductCacheRelationFilter(
                RedisCacheCoordinator cacheTracker,
                ILogger<ProductCacheRelationFilter> logger,
                IHttpContextAccessor httpContextAccessor,
                ICacheBase cacheBase)
            {
                _cacheTracker = cacheTracker;
                _logger = logger;
                _httpContextAccessor = httpContextAccessor;
                _cacheBase = cacheBase;
            }

            // Uygulama kapatılırken tamamlanmamış işlemleri bekle
            public static async Task WaitForPendingTasksAsync(CancellationToken cancellationToken = default)
            {
                var taskCount = Interlocked.CompareExchange(ref _activeTaskCount, 0, 0);
                if (taskCount == 0)
                    return;

                var tcs = new TaskCompletionSource<bool>();
                _shutdownTasks.Enqueue(tcs);

                try
                {
                    // Basit bir timeout ekle
                    await Task.WhenAny(tcs.Task, Task.Delay(TimeSpan.FromSeconds(5)));
                }
                catch (OperationCanceledException)
                {
                    // Zaman aşımı durumunda sessizce devam et
                }
            }

            public async Task OnResultExecutionAsync(ResultExecutingContext context, ResultExecutionDelegate next)
            {
                // Sadece API veya AJAX istekleri için çalış (gereksiz MVC işlemlerini atla)
                if (!IsApiRequest(context))
                {
                    await next();
                    return;
                }

                // Get the correlation ID from the context
                string correlationId = null;
                if (_httpContextAccessor.HttpContext.Items.TryGetValue("CorrelationId", out var corId))
                {
                    correlationId = corId?.ToString();
                }

                // If correlation ID is not available, continue without processing
                if (string.IsNullOrEmpty(correlationId))
                {
                    await next();
                    return;
                }

                // Müşteri ve mağaza bilgilerini önceden al
                string customerId = null;
                if (_httpContextAccessor.HttpContext.Items.TryGetValue("CurrentCustomerId", out var custId))
                {
                    customerId = custId?.ToString();
                }

                string storeId = null;
                if (_httpContextAccessor.HttpContext.Items.TryGetValue("StoreId", out var store))
                {
                    storeId = store?.ToString();
                }

                // Response sonrası asenkron işleme için kapsül hazırla
                object resultValue = null;
                bool containsProducts = false;

                // Check if the result is JsonResult or ObjectResult (optimize the check)
                if (context.Result is JsonResult jsonResult)
                {
                    containsProducts = IsLikelyToContainProducts(jsonResult);
                    if (containsProducts)
                    {
                        resultValue = jsonResult.Value;
                    }
                }
                else if (context.Result is ObjectResult objectResult)
                {
                    containsProducts = IsLikelyToContainProducts(objectResult);
                    if (containsProducts)
                    {
                        resultValue = objectResult.Value;
                    }
                }

                // Önce response pipeline'ını tamamla
                await next();

                context.HttpContext.Response.OnCompleted(async ()  =>
                {
                    // Response sonrası asenkron işlemeyi başlat, ancak limitleme ve güvenli işlem ile
                    if (containsProducts && resultValue != null)
                    {
                        var acquiredSemaphore = false;

                        try
                        {
                            // Aşırı yüklenmeyi önlemek için 100ms timeout ile Semaphore al
                            // Alamazsa arkaplanda işleme atlamak yerine ışık yakmayı tercih et
                            acquiredSemaphore = await _throttleSemaphore.WaitAsync(100);

                            if (!acquiredSemaphore)
                            {
                                _logger.LogWarning(
                                    "Skipping background cache processing due to throttling (too many concurrent tasks)");
                                return;
                            }

                            // Aktif görev sayısını güvenli şekilde artır
                            Interlocked.Increment(ref _activeTaskCount);

                            // CancellationToken ile zaman aşımı koruması - using kullanmadan
                            // cts'yi Task.Run içinde oluştur ki erken dispose edilmesin
                            var localCts = new CancellationTokenSource(_taskTimeout);

                            // Güvenli Task çalıştırma
                            _ = Task.Run(async () =>
                            {
                                // Task içinde CancellationTokenSource oluştur
                                using (localCts)
                                {
                                    try
                                    {
                                        await ProcessJsonResultAsyncDetached(resultValue, correlationId, customerId,
                                            storeId, localCts.Token);
                                    }
                                    catch (OperationCanceledException)
                                    {
                                        _logger.LogWarning(
                                            "Background cache processing timed out after {Timeout} seconds",
                                            _taskTimeout.TotalSeconds);
                                    }
                                    catch (Exception ex)
                                    {
                                        _logger.LogError(ex,
                                            "Error in background processing of product cache relations");
                                    }
                                    finally
                                    {
                                        // Aktif görev sayısını azalt
                                        int remainingTasks = Interlocked.Decrement(ref _activeTaskCount);

                                        // Semaphore'u güvenli şekilde serbest bırak
                                        if (acquiredSemaphore)
                                        {
                                            try { _throttleSemaphore.Release(); }
                                            catch (Exception)
                                            {
                                                /* Ignore semaphore errors during cleanup */
                                            }
                                        }

                                        // Uygulama kapatılma esnasında bekleyen işlemler varsa
                                        if (remainingTasks == 0 && _shutdownTasks.TryDequeue(out var tcs))
                                        {
                                            tcs.TrySetResult(true);
                                        }
                                    }
                                }
                            }, localCts.Token);
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex, "Failed to start background cache processing task");

                            // Hata durumunda semaphore'u serbest bırakmayı unutma
                            if (acquiredSemaphore)
                            {
                                _throttleSemaphore.Release();
                            }
                        }
                    }
                });
            }

            // API veya AJAX isteği olup olmadığını kontrol et
            private bool IsApiRequest(ResultExecutingContext context)
            {
                var request = context.HttpContext.Request;


                // AJAX isteği mi?
                if (request.Headers.TryGetValue("X-Requested-With", out var requestedWith) &&
                    requestedWith == "XMLHttpRequest")
                {
                    return true;
                }

                // Content-Type JSON mu?
                if (request.Headers.TryGetValue("Accept", out var accept) &&
                    accept.ToString().Contains("application/json"))
                {
                    return true;
                }

                // API yolu mu?
                var path = request.Path.ToString().ToLowerInvariant();
                if (path.Contains("/api/") || path.Contains("/odata/"))
                {
                    return true;
                }

                return false;
            }

            // İçeriğin ürün içerme olasılığını kontrol et
            private bool IsLikelyToContainProducts(ActionResult result)
            {
                // JsonResult durumunda
                if (result is JsonResult jsonResult)
                {
                    return IsLikelyProductObject(jsonResult.Value);
                }

                // ObjectResult durumunda
                if (result is ObjectResult objectResult)
                {
                    return IsLikelyProductObject(objectResult.Value);
                }

                if (result is ViewComponentResult viewComponentResult)
                {
                    return IsLikelyProductObject(viewComponentResult.Model);
                }

                return false;
            }

            // Objenin ürün içerme olasılığını kontrol et
            private bool IsLikelyProductObject(object obj)
            {
                if (obj == null)
                    return false;

                var type = obj.GetType();

                // Doğrudan ürün mü?
                if (obj is CollectionModel ||
                    obj is BrandModel ||
                    obj is CategoryModel ||
                    obj is CompareProductsModel ||
                    obj is ProductsByTagModel ||
                    obj is SearchModel ||
                    obj is VendorModel ||
                    type.Name.Contains("Product") ||
                    type.Name.Contains("Catalog"))
                    return true;

                // IEnumerable<T> olup olmadığını reflection ile kontrol et
                if (IsEnumerableOfProducts(type))
                    return true;

                return false;
            }

            // Tür bir IEnumerable<T> mi ve T ürün ile ilişkili mi?
            private bool IsEnumerableOfProducts(Type type)
            {
                // Generic bir IEnumerable mi?
                if (type.IsGenericType)
                {
                    var genericTypeDefinition = type.GetGenericTypeDefinition();
                    if (genericTypeDefinition == typeof(IEnumerable<>) ||
                        genericTypeDefinition == typeof(List<>) ||
                        genericTypeDefinition == typeof(IList<>))
                    {
                        var itemType = type.GetGenericArguments()[0];
                        return itemType.Name.Contains("Product") ||
                               itemType == typeof(ProductOverviewModel) ||
                               itemType.Name.Contains("Catalog");
                    }
                }

                return false;
            }

            /// <summary>
            /// HttpContext içinde çalışan orijinal metod - artık kullanılmıyor
            /// </summary>
            private async Task ProcessJsonResultAsync(object value, string correlationId)
            {
                if (value == null)
                    return;

                try
                {
                    // Process the object recursively to find ProductOverviewModel instances
                    await ProcessObjectAsync(value, correlationId);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing JSON result for cache relation: {Message}", ex.Message);
                }
            }

            /// <summary>
            /// HttpContext dışında, ayrı bir thread'de çalışan detached versiyon
            /// </summary>
            private async Task ProcessJsonResultAsyncDetached(object value, string correlationId, string customerId,
                string storeId, CancellationToken cancellationToken = default)
            {
                if (value == null)
                    return;

                try
                {
                    // İşleme başladığını logla
                    _logger.LogInformation("Starting background cache processing for correlation {CorrelationId}",
                        correlationId);

                    // Thread-static HttpContext olmadığı için explicit müşteri ve mağaza bilgisiyle çalış
                    // Doğrudan gelen token'ı kullan, yeni bir CancellationTokenSource oluşturmak yerine
                    await ProcessObjectAsyncDetached(value, correlationId, customerId, storeId, 0, cancellationToken);

                    // İşlem başarıyla tamamlandı
                    _logger.LogInformation(
                        "Successfully completed background cache processing for correlation {CorrelationId}",
                        correlationId);
                }
                catch (OperationCanceledException)
                {
                    // Zaman aşımı veya iptal durumu - yukarıya propagate et
                    throw;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing detached JSON result for cache relation: {Message}",
                        ex.Message);
                }
            }

            // Maksimum 3 seviye derinlik sınırı
            private async Task ProcessObjectAsync(object obj, string correlationId, int depth = 0)
            {
                if (obj == null || depth > 3) // Derinlik sınırı ekledik
                    return;

                var type = obj.GetType();

                // Handle ProductOverviewModel directly
                if (obj is ProductOverviewModel product)
                {
                    await AddProductCacheRelationsAsync(product, correlationId);
                    return;
                }

                // Handle collections of ProductOverviewModel
                if (obj is IEnumerable<ProductOverviewModel> productList)
                {
                    // Tüm ürün işlemlerini paralel ve tek batch işleminde birleştir
                    var tasks = new List<Task>();
                    var productBatch = new List<ProductOverviewModel>();
                    foreach (var prod in productList)
                    {
                        if (productBatch.Count >= 20)
                        {
                            tasks.Add(AddProductCacheRelationsBatchAsync(productBatch, correlationId));
                            productBatch = new List<ProductOverviewModel>();
                        }

                        productBatch.Add(prod);
                    }

                    if (productBatch.Count > 0)
                    {
                        tasks.Add(AddProductCacheRelationsBatchAsync(productBatch, correlationId));
                    }

                    // Tüm batch'lerin işlemlerini bekle
                    if (tasks.Count > 0)
                    {
                        await Task.WhenAll(tasks);
                    }

                    return;
                }

                // Handle collections
                if (obj is IList list && !(obj is string))
                {
                    // Yalnızca en yüksek 100 öğeyi işle
                    int count = Math.Min(list.Count, 100);
                    for (int i = 0; i < count; i++)
                    {
                        await ProcessObjectAsync(list[i], correlationId, depth + 1);
                    }

                    return;
                }
                // Handle generic enumerable types (koleksiyonları daha verimli işle)
                else if (obj is IEnumerable enumerable && !(obj is string))
                {
                    // Performans için sayaç ekle - maksimum 100 öğe işle
                    int count = 0;
                    foreach (var item in enumerable)
                    {
                        if (count++ >= 100) break;
                        await ProcessObjectAsync(item, correlationId, depth + 1);
                    }

                    return;
                }

                // Bilinen kompleks model tiplerini verimli şekilde kontrol et
                // Sadece bilinen model tiplerine odaklan
                if (IsKnownComplexType(type))
                {
                    try
                    {
                        // Önbellekteki property'leri kullan ve sadece belli değerlere odaklan
                        foreach (var prop in GetCachedProperties(type))
                        {
                            if (prop.CanRead)
                            {
                                var value = prop.GetValue(obj);
                                await ProcessObjectAsync(value, correlationId, depth + 1);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        _logger.LogInformation(ex, "Error processing property during cache relation: {Message}",
                            ex.Message);
                    }
                }
            }

            // Detached thread'de çalışan versiyon - HttpContext'e bağımlılığı kaldırır
            private async Task ProcessObjectAsyncDetached(object obj, string correlationId, string customerId,
                string storeId, int depth = 0, CancellationToken cancellationToken = default)
            {
                if (obj == null || depth > 3) // Derinlik sınırı 
                    return;

                // Belirli aralıklarla iptal kontrolü
                if (cancellationToken.IsCancellationRequested)
                    throw new OperationCanceledException(cancellationToken);

                var type = obj.GetType();

                // Handle ProductOverviewModel directly
                if (obj is ProductOverviewModel product)
                {
                    await AddProductCacheRelationsAsyncDetached(product, correlationId, customerId, storeId,
                        cancellationToken);
                    return;
                }

                // Handle collections of ProductOverviewModel
                if (obj is IEnumerable<ProductOverviewModel> productList)
                {
                    // Tüm ürün işlemlerini paralel ve tek batch işleminde birleştir
                    var tasks = new List<Task>();
                    var productBatch = new List<ProductOverviewModel>();
                    foreach (var prod in productList)
                    {
                        // Aşırı sayıda ürün işlemeyi önlemek için kontrol ekle
                        if (productBatch.Count >= 20)
                        {
                            // CancellationToken kontrolünü her batch'de yap
                            if (cancellationToken.IsCancellationRequested)
                                throw new OperationCanceledException(cancellationToken);

                            tasks.Add(AddProductCacheRelationsBatchAsyncDetached(productBatch, correlationId,
                                customerId, storeId, cancellationToken));
                            productBatch = new List<ProductOverviewModel>();
                        }

                        productBatch.Add(prod);
                    }

                    if (productBatch.Count > 0)
                    {
                        // Son kontrol
                        if (cancellationToken.IsCancellationRequested)
                            throw new OperationCanceledException(cancellationToken);

                        tasks.Add(AddProductCacheRelationsBatchAsyncDetached(productBatch, correlationId, customerId,
                            storeId, cancellationToken));
                    }

                    // Tüm batch'lerin işlemlerini bekle, ancak zaman aşımı ekle
                    if (tasks.Count > 0)
                    {
                        // Kontrol ekle - çok fazla task varsa, az sayıda işle
                        if (tasks.Count > 20)
                        {
                            _logger.LogWarning("Too many product batches ({Count}) to process, limiting to first 20",
                                tasks.Count);
                            await Task.WhenAll(tasks.Take(20));
                        }
                        else
                        {
                            await Task.WhenAll(tasks);
                        }
                    }

                    return;
                }

                // Handle collections
                if (obj is IList list && !(obj is string))
                {
                    // Yalnızca en yüksek 100 öğeyi işle
                    int count = Math.Min(list.Count, 100);
                    for (int i = 0; i < count; i++)
                    {
                        // Her öğede cancellation kontrolü ekle
                        if (cancellationToken.IsCancellationRequested)
                            throw new OperationCanceledException(cancellationToken);

                        await ProcessObjectAsyncDetached(list[i], correlationId, customerId, storeId, depth + 1,
                            cancellationToken);
                    }

                    return;
                }
                // Handle generic enumerable types (koleksiyonları daha verimli işle)
                else if (obj is IEnumerable enumerable && !(obj is string))
                {
                    // Performans için sayaç ekle - maksimum 100 öğe işle
                    int count = 0;
                    foreach (var item in enumerable)
                    {
                        if (count++ >= 100) break;

                        // Her öğede cancellation kontrolü ekle
                        if (cancellationToken.IsCancellationRequested)
                            throw new OperationCanceledException(cancellationToken);

                        await ProcessObjectAsyncDetached(item, correlationId, customerId, storeId, depth + 1,
                            cancellationToken);
                    }

                    return;
                }

                // Bilinen kompleks model tiplerini verimli şekilde kontrol et
                // Sadece bilinen model tiplerine odaklan
                if (IsKnownComplexType(type))
                {
                    try
                    {
                        // Önbellekteki property'leri kullan ve sadece belli değerlere odaklan
                        foreach (var prop in GetCachedProperties(type))
                        {
                            if (prop.CanRead)
                            {
                                var value = prop.GetValue(obj);
                                // Her property'de cancellation kontrolü ekle
                                if (cancellationToken.IsCancellationRequested)
                                    throw new OperationCanceledException(cancellationToken);

                                await ProcessObjectAsyncDetached(value, correlationId, customerId, storeId, depth + 1,
                                    cancellationToken);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        _logger.LogInformation(ex,
                            "Error processing property during detached cache relation: {Message}", ex.Message);
                    }
                }
            }

            // Bilinen model tipleri için önbellek
            private static readonly HashSet<Type> KnownModelTypes = new HashSet<Type> {
                typeof(BaseModel),
                typeof(ProductOverviewModel),
                typeof(CollectionModel),
                typeof(BrandModel),
                typeof(CategoryModel),
                typeof(CompareProductsModel),
                typeof(ProductsByTagModel),
                typeof(SearchModel),
                typeof(VendorModel),
                // Diğer bilinen tipler burada eklenebilir
            };

            // Property bilgilerini önbelleğe alma
            private static readonly ConcurrentDictionary<Type, PropertyInfo[]> PropertyCache =
                new ConcurrentDictionary<Type, PropertyInfo[]>();

            private bool IsKnownComplexType(Type type)
            {
                // Primitive ve basit tipleri hızlıca kontrol et
                if (type.IsPrimitive ||
                    type == typeof(string) ||
                    type == typeof(DateTime) ||
                    type == typeof(decimal) ||
                    type == typeof(Guid) ||
                    type.Name.Contains("AnonymousType"))
                    return false;

                // Bilinen model tiplerinden miras almışsa işle
                foreach (var knownType in KnownModelTypes)
                {
                    if (knownType.IsAssignableFrom(type))
                        return true;
                }

                // Model namespace içindeki tiplere odaklan
                return type.Namespace?.Contains(".Models.") == true;
            }

            private PropertyInfo[] GetCachedProperties(Type type)
            {
                return PropertyCache.GetOrAdd(type, t =>
                    t.GetProperties(BindingFlags.Public | BindingFlags.Instance));
            }

            // Ürünleri toplu olarak işleme
            private async Task AddProductCacheRelationsBatchAsync(List<ProductOverviewModel> products,
                string correlationId)
            {
                if (products == null || products.Count == 0)
                    return;

                try
                {
                    var tasks = new List<Task>();

                    foreach (var product in products)
                    {
                        if (string.IsNullOrEmpty(product.Id))
                            continue;

                        // Add product by ID cache key relation
                        string productCacheKey = string.Format(CacheKey.PRODUCTS_BY_ID_KEY, product.Id);
                        tasks.Add(AddCacheKeyForRequestAsync(correlationId, productCacheKey));

                        // Add URL entity cache key relation if SeName is available
                        if (!string.IsNullOrEmpty(product.SeName))
                        {
                            string seNameCacheKey = string.Format(CacheKey.URLEntity_BY_SLUG_KEY, product.SeName);
                            tasks.Add(AddCacheKeyForRequestAsync(correlationId, seNameCacheKey));
                        }
                    }

                    if (tasks.Count > 0)
                    {
                        await Task.WhenAll(tasks);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error adding product cache relations batch: {Message}", ex.Message);
                }
            }

            // Detached thread için versiyonu
            private async Task AddProductCacheRelationsBatchAsyncDetached(List<ProductOverviewModel> products,
                string correlationId, string customerId, string storeId, CancellationToken cancellationToken = default)
            {
                if (products == null || products.Count == 0)
                    return;

                // Başlangıçta cancellation kontrolü
                if (cancellationToken.IsCancellationRequested)
                    throw new OperationCanceledException(cancellationToken);

                try
                {
                    var tasks = new List<Task>();
                    int processedProducts = 0;

                    foreach (var product in products)
                    {
                        // Batch içinde periyodik kontrol
                        if (++processedProducts % 10 == 0 && cancellationToken.IsCancellationRequested)
                            throw new OperationCanceledException(cancellationToken);

                        if (string.IsNullOrEmpty(product.Id))
                            continue;

                        // Add product by ID cache key relation
                        string productCacheKey = string.Format(CacheKey.PRODUCTS_BY_ID_KEY, product.Id);
                        tasks.Add(AddCacheKeyForRequestAsyncDetached(correlationId, productCacheKey, customerId,
                            storeId));

                        // Add URL entity cache key relation if SeName is available
                        if (!string.IsNullOrEmpty(product.SeName))
                        {
                            string seNameCacheKey = string.Format(CacheKey.URLEntity_BY_SLUG_KEY, product.SeName);
                            tasks.Add(AddCacheKeyForRequestAsyncDetached(correlationId, seNameCacheKey, customerId,
                                storeId));
                        }
                    }

                    // Çok fazla task varsa bazılarını atla - koruma
                    if (tasks.Count > 50)
                    {
                        _logger.LogWarning("Too many cache key tasks ({Count}) for batch, limiting to 50", tasks.Count);
                        tasks = tasks.Take(50).ToList();
                    }

                    if (tasks.Count > 0)
                    {
                        // Son bir kontrol daha
                        if (cancellationToken.IsCancellationRequested)
                            throw new OperationCanceledException(cancellationToken);

                        // Görevleri çalıştır ve zaman aşımına karşı korumalı bekle
                        var timeoutTask = Task.Delay(TimeSpan.FromSeconds(5), cancellationToken);
                        var processingTask = Task.WhenAll(tasks);

                        var completedTask = await Task.WhenAny(processingTask, timeoutTask);
                        if (completedTask == timeoutTask)
                        {
                            _logger.LogWarning("Batch processing timed out for {Count} products", products.Count);
                            throw new TimeoutException($"Batch processing timed out for {products.Count} products");
                        }
                    }
                }
                catch (OperationCanceledException)
                {
                    // İptal edilmiş işlemler için tekrar loglamaya gerek yok
                    throw;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error adding product cache relations batch in detached thread: {Message}",
                        ex.Message);
                    throw; // Yeniden fırlat ki üst task görsün
                }
            }

            private async Task AddProductCacheRelationsAsync(ProductOverviewModel product, string correlationId)
            {
                if (product == null || string.IsNullOrEmpty(product.Id))
                    return;

                try
                {
                    // Add product by ID cache key relation
                    string productCacheKey = string.Format(CacheKey.PRODUCTS_BY_ID_KEY, product.Id);
                    await AddCacheKeyForRequestAsync(correlationId, productCacheKey);

                    // Add product price cache key relation
                    // string productPriceCacheKey = string.Format(CacheKey.CUSTOMER_PRODUCT_PRICE_KEY_ID, "0", product.Id);
                    // await AddCacheKeyForRequestAsync(correlationId, productPriceCacheKey);

                    // Add URL entity cache key relation if SeName is available
                    if (!string.IsNullOrEmpty(product.SeName))
                    {
                        string seNameCacheKey = string.Format(CacheKey.URLEntity_BY_SLUG_KEY, product.SeName);
                        await AddCacheKeyForRequestAsync(correlationId, seNameCacheKey);
                    }

                    // You can add more cache key relations here as needed
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error adding product cache relations: {Message}", ex.Message);
                }
            }

            // Detached thread için versiyonu
            private async Task AddProductCacheRelationsAsyncDetached(ProductOverviewModel product, string correlationId,
                string customerId, string storeId, CancellationToken cancellationToken = default)
            {
                if (product == null || string.IsNullOrEmpty(product.Id))
                    return;

                // İptal kontrolü
                if (cancellationToken.IsCancellationRequested)
                    throw new OperationCanceledException(cancellationToken);

                try
                {
                    // Add product by ID cache key relation
                    string productCacheKey = string.Format(CacheKey.PRODUCTS_BY_ID_KEY, product.Id);
                    await AddCacheKeyForRequestAsyncDetached(correlationId, productCacheKey, customerId, storeId);

                    // Add URL entity cache key relation if SeName is available
                    if (!string.IsNullOrEmpty(product.SeName))
                    {
                        string seNameCacheKey = string.Format(CacheKey.URLEntity_BY_SLUG_KEY, product.SeName);
                        await AddCacheKeyForRequestAsyncDetached(correlationId, seNameCacheKey, customerId, storeId);
                    }

                    // You can add more cache key relations here as needed
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error adding product cache relations in detached thread: {Message}",
                        ex.Message);
                }
            }

            private async Task AddCacheKeyForRequestAsync(string correlationId, string cacheKey)
            {
                // Erken kontrol
                if (string.IsNullOrEmpty(correlationId) || string.IsNullOrEmpty(cacheKey))
                    return;

                if (_httpContextAccessor.HttpContext?.Items.TryGetValue("CurrentCustomerId", out var customerId) ==
                    true)
                {
                    // Cache key prefix'i önceden hesapla
                    var prefixedKey = GetCacheKeyWithTenantPrefix(cacheKey);

                    // Async trackler
                    await _cacheTracker.TrackCacheAccessAsync(
                        correlationId,
                        prefixedKey,
                        customerId?.ToString() ?? "anonymous");
                }
            }

            // Detached thread'de kullanılan versiyon - explicit parametre ile çalışır
            private async Task AddCacheKeyForRequestAsyncDetached(string correlationId, string cacheKey,
                string customerId, string storeId)
            {
                // Erken kontrol
                if (string.IsNullOrEmpty(correlationId) || string.IsNullOrEmpty(cacheKey))
                    return;

                // Detached thread'de HttpContext olmadığı için doğrudan parametre
                if (!string.IsNullOrEmpty(customerId))
                {
                    // Cache key prefix'i explicit olarak hesapla
                    var prefixedKey = GetCacheKeyWithTenantPrefixDetached(cacheKey, storeId);

                    // Async trackler
                    await _cacheTracker.TrackCacheAccessAsync(
                        correlationId,
                        prefixedKey,
                        customerId);
                }
            }

            // TenantId önbelleği ile optimize edilmiş versiyon
            private string GetCacheKeyWithTenantPrefix(string key)
            {
                var tenantId = GetCurrentTenantId();
                if (!string.IsNullOrEmpty(tenantId))
                {
                    return tenantId + "." + key;
                }

                return key;
            }

            // Detached thread için TenantId ile çalışan versiyon
            private string GetCacheKeyWithTenantPrefixDetached(string key, string tenantId)
            {
                if (!string.IsNullOrEmpty(tenantId))
                {
                    return tenantId + "." + key;
                }

                return key;
            }

            // Mevcut tenant ID'sini al ve önbellekle
            private string _cachedTenantId = null;

            private string GetCurrentTenantId()
            {
                if (_cachedTenantId != null)
                    return _cachedTenantId;

                if (_httpContextAccessor.HttpContext?.Items.TryGetValue("StoreId", out var storeId) == true &&
                    storeId != null)
                {
                    _cachedTenantId = storeId.ToString();
                    return _cachedTenantId;
                }

                return string.Empty;
            }
        }
    }
}