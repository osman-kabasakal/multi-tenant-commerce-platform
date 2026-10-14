import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CookieSecureStoreage implements Storage {
  final FlutterSecureStorage secureStorage;
  CookieSecureStoreage({required this.secureStorage});

  @override
  Future<void> delete(String key) {
    return secureStorage.delete(key: key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (var key in keys) {
      await secureStorage.delete(key: key);
    }
  }

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) {
    return Future.value();
  }

  @override
  Future<String?> read(String key) {
    return secureStorage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) {
    return secureStorage.write(key: key, value: value);
  }
}
