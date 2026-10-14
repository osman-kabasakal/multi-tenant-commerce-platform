import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';

import '../../cross_cutting_concerns/decorators/repository_decorator.dart';
import '../../data/events/event_bus.dart';

abstract class BaseRepository {
  final RepositoryDecorator decorator;
  final EventBus eventBus;
  BaseRepository(this.decorator, this.eventBus);

  String generateCacheKey(String operationName,
      [List? parameters, String? userId]) {
    // Maksimum cache key uzunluğu
    const int maxKeyLength = 255;

    // Prefix oluşturma (bu kısmı olduğu gibi koruyoruz)
    var parametersText = '';
    if (parameters != null) {
      for (var parameter in parameters) {
        if (parameter is StoreJsonSerializable) {
          var jsonMap = parameter.toJson();
          jsonMap.removeWhere((key, value) => value == null);
          parametersText += jsonEncode(jsonMap);
        } else {
          parametersText += parameter.toString();
        }
      }
    }

    var currentUser = getIt<AuthService>().currentTokens;
    String prefix =
        '${userId ?? ((currentUser?.email ?? currentUser?.guestId) ?? '')}${(operationName.isEmptyOrNull ? '' : '_$operationName')}';
    prefix = prefix.replaceAll('__', '_').trimRight();

    // Parametre kısmı için tam string
    String fullParameters =
        (parametersText.isEmptyOrNull ? '' : '_$parametersText');

    // Toplam key'i oluştur
    String fullKey = '$prefix$fullParameters'.replaceAll('__', '_').trimRight();

    // Eğer key maksimum uzunluğun altındaysa, olduğu gibi döndür
    if (fullKey.length <= maxKeyLength) {
      return fullKey;
    }

    // Eğer prefix bile maksimum uzunluğu aşıyorsa (çok nadir bir durum)
    if (prefix.length >= maxKeyLength) {
      // Prefix'i kısalt ama operationName'in başlangıcını koru
      int slashIndex = operationName.indexOf('/');
      if (slashIndex >= 0 && slashIndex + 1 < operationName.length) {
        String operationPrefix = operationName.substring(0, slashIndex + 1);
        // Operasyon prefix'inin ilk kısmını koru, geri kalanını hash'le
        return _hashWithPrefix(operationPrefix, fullKey, maxKeyLength);
      } else {
        // Prefix'in ilk karakterlerini koru ve MD5 hash ekle
        return _hashWithPrefix(prefix.substring(0, 10), fullKey, maxKeyLength);
      }
    }

    // Normal durum: Prefix'i koru, parametreleri hash'le
    int remainingLength = maxKeyLength - prefix.length;
    if (remainingLength <= 0) {
      // Çok uzun prefix durumunda basit MD5
      return _hashWithPrefix("", fullKey, maxKeyLength);
    }

    // Prefix'i koru ve parametreleri hash'le
    return _hashWithParameterHash(prefix, fullParameters, maxKeyLength);
  }

// Prefix'i koruyarak parametre kısmını hash'leme
  String _hashWithParameterHash(
      String prefix, String parameters, int maxLength) {
    // Eğer parametre yoksa veya kısaysa, doğrudan birleştir
    if (parameters.length <= 5) {
      return prefix + parameters;
    }

    // Parameters hash'le
    var bytes = utf8.encode(parameters);
    var md5Result = md5.convert(bytes).toString();

    // Kalan uzunluğu hesapla
    int remainingLength =
        maxLength - prefix.length - 1; // 1 karakter ayırıcı için

    if (remainingLength <= 0) {
      return prefix;
    }

    // Hash'i kalan uzunluğa göre kırp
    String hashPart = md5Result.substring(
        0,
        remainingLength < md5Result.length
            ? remainingLength
            : md5Result.length);

    return '$prefix#$hashPart';
  }

// Belirli bir prefix ile hash oluşturma
  String _hashWithPrefix(String prefix, String fullKey, int maxLength) {
    var bytes = utf8.encode(fullKey);
    var md5Result = md5.convert(bytes).toString();

    int prefixLength = prefix.length;
    int hashLength = maxLength - prefixLength - 1; // 1 karakter ayırıcı için

    if (hashLength <= 0) {
      // Prefix çok uzunsa sadece prefix'i kırp
      return prefix.substring(0, maxLength);
    }

    String hashPart = md5Result.substring(
        0, hashLength < md5Result.length ? hashLength : md5Result.length);

    return '$prefix#$hashPart';
  }

// Cache key prefix'i ile silme için yardımcı fonksiyon
  String generateCachePrefixForRemoval(String operationName, [String? userId]) {
    var currentUser = getIt<AuthService>().currentTokens;
    return '${userId ?? ((currentUser?.email ?? currentUser?.guestId) ?? '')}${(operationName.isEmptyOrNull ? '' : '_$operationName')}'
        .replaceAll('__', '_')
        .trimRight();
  }
}
