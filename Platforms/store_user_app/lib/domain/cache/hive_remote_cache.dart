import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/cache/remote_cache.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/core/utils/extensions/map_extensions.dart';
import 'package:store_user_app/core/utils/extensions/type_extensions.dart';
import 'package:store_user_app/domain/constants/from_json_by_type.dart';
import 'package:synchronized/synchronized.dart';

import '../../core/models/network/api_response.dart';
import '../../core/utils/json_converters/api_response_converter.dart';
import '../../core/utils/json_converters/json_converter.dart';
import '../../core/utils/json_converters/list_converter.dart';
import '../../core/utils/json_converters/primitive_converter.dart';

@Singleton(as: RemoteCache)
class HiveRemoteCache implements RemoteCache {
  final Duration _defaultValidDuration =
      AppConfig.instance.cacheExpirationDuration;
  final Box<DateTime> _validityBox = Hive.box<DateTime>('validity');
  final List<Type> registeredAdapters = [];
  HiveRemoteCache() {
    _registerPrimitiveTypes();
  }

  void _registerPrimitiveTypes() {
    _insertCustomTypes<String>();
    _insertCustomTypes<int>();
    _insertCustomTypes<double>();
    _insertCustomTypes<bool>();
    _insertCustomTypes<num>();
  }

  void _insertCustomTypes<T>() {
    jsonConverters[T] = PrimitiveConverter<T>();
    jsonConverters[List<T>] = ListConverter<T>(PrimitiveConverter<T>());
    jsonConverters[ApiResponse<T>] =
        ApiResponseConverter<T>(PrimitiveConverter<T>());
    jsonConverters[ApiResponse<List<T>>] =
        ApiResponseConverter(ListConverter<T>(PrimitiveConverter<T>()));
  }

  @factoryMethod
  static Future<HiveRemoteCache> getInstance() async {
    await Hive.openBox<DateTime>('validity');

    return HiveRemoteCache();
  }

  final _lock = Lock();
  Future<JsonConverter<T, dynamic>> _getConverter<T>() async {
    // Direkt kayıtlı dönüştürücüyü kontrol et
    return await _lock.synchronized(() async {
      var type = T;
      final converter = jsonConverters[type];
      if (converter != null) {
        return converter as JsonConverter<T, dynamic>;
      }

      // ApiResponse türü için özel kontrol
      if (T.isApiResponse()) {
        final genericType = type.getApiResponseGenericType();
        if (genericType != null && jsonConverters.containsKey(genericType)) {
          final valueConverter = jsonConverters[genericType]!;
          return ApiResponseConverter(valueConverter as PrimitiveConverter)
              as JsonConverter<T, Map<String, dynamic>>;
        }
      }

      throw Exception(
          'No converter registered for type ${T.runtimeType.toString()}');
    });
  }

  Future<LazyBox> _getBox() async {
    // Cache box'ının adını sabit olarak tanımlıyoruz
    const boxName = 'cache';

    // Box açık değilse açıyoruz
    if (!Hive.isBoxOpen(boxName)) {
      // Generic tip ile box'ı açıyoruz
      await Hive.openLazyBox(boxName);
    }

    // Box'ı döndürüyoruz"
    return Hive.lazyBox(boxName);
  }

  // Box'ı dynamic olarak almak için ayrı bir yardımcı metot
  Future<LazyBox> _getDynamicBox() async {
    const boxName = 'cache';
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openLazyBox(boxName);
    }
    return Hive.lazyBox(boxName);
  }

  @override
  Future<void> clear() async {
    final box = await _getDynamicBox();
    await box.clear();
    await _validityBox.clear();
  }

  @override
  Future<bool> contains(String key) async {
    final box = await _getDynamicBox();
    return box.containsKey(key);
  }

  @override
  Future<T?> get<T>(String key) async {
    if (!await isValid(key)) {
      await remove(key);
      return null;
    }

    final box = await _getBox();

    try {
      final converter = await _getConverter<T>();
      final data = await box.get(key);
      if (data != null && (data is Map || data is List)) {
        return converter.fromJson(
            MapExtensions.foldDynamicMap(data)); // Map<String, dynamic>
      } else if (data == null) {
        return null;
      }
      throw Exception('Unexpected data format');
    } catch (e) {
      LoggerService.error('Error converting data for type $T: $e', e);
      //Arkplan işlemlerinde cache silinmiş olabilir ve json dönüşümü hata verebilir
      await remove(key);
      return null;
    }
  }

  @override
  Future<void> set<T>(String key, T value, [Duration? cacheTime]) async {
    final box = await _getBox();

    try {
      final converter = await _getConverter<T>();
      final jsonData = converter.toJson(value);
      await box.put(key, jsonData);

      await _validityBox.put(
        key,
        DateTime.now().add(cacheTime ?? _defaultValidDuration),
      );
    } catch (e) {
      LoggerService.error('Error saving data for type $T: $e', e);
      rethrow;
    }
  }

  @override
  Future<void> remove(String key) async {
    final box = await _getDynamicBox();
    await box.delete(key);
    await _validityBox.delete(key);
  }

  @override
  Future<void> removeByPrefix(String prefix) async {
    final box = await _getBox();
    var keys = _validityBox.keys.where((k) => k.toString().startsWith(prefix));
    if (keys.isNotEmpty) {
      await box.deleteAll(keys);
      await _validityBox.deleteAll(keys);
    }
  }

  // Diğer metodlar aynı kalıyor
  @override
  Future<bool> isValid(String key) async {
    final validTill = _validityBox.get(key);
    if (validTill == null) return false;
    return validTill.isAfter(DateTime.now());
  }

  @override
  Future<void> dispose() async {
    final box = await _getDynamicBox();
    await box.close();
    await _validityBox.close();
    await Hive.close();
  }
}
