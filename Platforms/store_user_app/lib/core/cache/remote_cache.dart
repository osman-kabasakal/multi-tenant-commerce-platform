abstract class RemoteCache {
  /// Verilen anahtarla önbellekten veri getirir
  Future<T?> get<T>(String key);

  /// Verilen anahtarla önbelleğe veri kaydeder
  Future<void> set<T>(String key, T value, [Duration? cacheTime]);

  /// Verilen anahtardaki veriyi önbellekten siler
  Future<void> remove(String key);

  Future<void> removeByPrefix(String prefix);

  /// Önbelleği tamamen temizler
  Future<void> clear();

  /// Verilen anahtarla önbellekte veri olup olmadığını kontrol eder
  Future<bool> contains(String key);

  /// Önbellekteki verinin geçerlilik süresini kontrol eder
  Future<bool> isValid(String key);

  Future<void> dispose();
}
