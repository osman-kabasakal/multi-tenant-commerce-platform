// lib/core/auth/auth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/src/options.dart' as DioOptions;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/storage/cookie_secure_storage.dart';

import '../../config/app_config.dart';
import '../logger/logger_service.dart';
import 'app_tokens_refresh_event.dart';



class AuthTokens {
  final String? bearerToken;
  final String? bearerRefreshToken;
  final DateTime? bearerExpiresAt;
  final String? csrfToken;
  final bool isGuest;
  String? get email => getTokenClaims()?['Email'];
  String? get guestId => getTokenClaims()?['Guid'];

  AuthTokens({
    this.bearerRefreshToken,
    this.bearerToken,
    this.bearerExpiresAt,
    this.csrfToken,
    required this.isGuest,
  });

  DateTime get firstExpiredAt =>bearerExpiresAt ?? DateTime.now().add(Duration(minutes: 1400));

  bool get isExpired => DateTime.now().isAfter(firstExpiredAt);

  bool get shouldRefresh =>
      DateTime.now().add(const Duration(minutes: 5)).isAfter(firstExpiredAt);

  Map<String, dynamic>? _claims;
  Map<String, dynamic>? getTokenClaims() {
    if (_claims != null) return _claims;
    if (bearerToken != null) {
      _claims = JwtDecoder.decode(bearerToken!);
      return _claims;
    }
    return null;
  }
}

abstract class IAuthService {
  Future<AuthTokens?> login(String email, String password);
  Future<AuthTokens?> guestLogin();
  Future<void> logout();
  Future<AuthTokens?> getAccessToken();
  Future<bool> refreshToken();
  Future<bool> isAuthenticated();
  Future<bool> isGuest();
}

class AuthService implements IAuthService {
  static const _keyBearerAccessToken = 'bearer_access_token';
  static const _keyBearerRefreshToken = 'bearer_refresh_token';
  static const _keyBearerExpiresAt = 'bearer_expires_at';
  static const _keyCsrfToken = 'csrf_token';
  static const _isGuestKey = 'is_customer_guest';

  final EventBus eventBus;
  final Dio http;

  // final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage;
  AuthTokens? _tokenBackstage;
  set _currentTokens(AuthTokens? value) {
    if (value != null &&
        (_tokenBackstage == null ||
            _tokenBackstage!.bearerToken != value.bearerToken ||
            _tokenBackstage!.bearerRefreshToken != value.bearerRefreshToken)) {
      eventBus.publish(
        AuthTokensRefreshEvent(entity: value, oldTokens: _tokenBackstage),
      );
    }
    _tokenBackstage = value;
  }

  AuthTokens? get _currentTokens => _tokenBackstage;

  AuthTokens? get currentTokens => _currentTokens;

  Timer? _refreshTimer;

  AuthService(this._secureStorage, this.http, this.eventBus){
    if(kDebugMode){
      var _ = true;
    }
  }

  @override
  Future<AuthTokens?> login(String email, String password) async {
    try {
      var antiforgeryToken = await http.get(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/Antiforgery',
        options: DioOptions.Options(
          headers: {
            'Accept': 'application/json',
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
          },
          extra: {'noCredentials': true},
        ),
      );

      var grandToken = await http.post(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/login',
        options: DioOptions.Options(
          headers: {
            'Accept': 'application/json',
            // 'X-CSRF-TOKEN': antiforgeryToken.data,
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
          },
          extra: {'noCredentials': true},
        ),
        data: {'Email': email, 'Password': base64Encode(utf8.encode(password))},
      );

      //Sepete migrate işlemleri için
      await http.post(
        '${AppConfig.instance.apiBaseUrl}/account/login?returnUrl=/cart',
        options: DioOptions.Options(
          headers: {
            'Accept': 'application/json',
            'X-CSRF-TOKEN': antiforgeryToken.data,
            'Authorization': 'Bearer ${_currentTokens!.bearerToken}',
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
          },
          extra: {'noCredentials': true},
        ),
        data: {'Email': email, 'Password': password},
      );

      final expiresAt = DateTime.now().add(Duration(minutes: 1440));

      final tokens = AuthTokens(
        bearerToken: grandToken.data["AccessToken"],
        bearerRefreshToken: grandToken.data["RefreshToken"],
        bearerExpiresAt: expiresAt,
        csrfToken: antiforgeryToken.data,
        isGuest: false,
      );

      await _saveTokens(tokens);
      _currentTokens = tokens;
      _setupRefreshTimer();

      return tokens;
    } catch (e, stackTrace) {
      LoggerService.error('Login error', e, stackTrace);
    }

    return null;
  }

  Future<void> init() async {
    // Token'ları yükle ve gerekiyorsa yenile
    var tokens = await _loadTokens();
    if (tokens != null) {
      _currentTokens = tokens;
      if (tokens.shouldRefresh) {
        await refreshToken();
        return;
      }
      _setupRefreshTimer();
    } else {
      tokens = await guestLogin();
    }
  }

  
  @override
  Future<AuthTokens?> guestLogin() async {
    try {
      var antiforgeryToken = await http.get(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/Antiforgery',
        options: DioOptions.Options(
          headers: {
            'Accept': 'application/json',
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
          },
          extra: {'noCredentials': true},
        ),
      );

      var grandToken = await http.post(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/guest',
        options: DioOptions.Options(
          headers: {
            'Accept': 'application/json',
            'X-CSRF-TOKEN': antiforgeryToken.data,
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
          },
          extra: {'noCredentials': true},
        ),
      );

      final expiresAt = DateTime.now().add(Duration(minutes: 1400));

      final tokens = AuthTokens(
        bearerToken: grandToken.data["AccessToken"],
        bearerRefreshToken: grandToken.data["RefreshToken"],
        bearerExpiresAt: expiresAt,
        csrfToken: antiforgeryToken.data,
        isGuest: true,
      );

      await _saveTokens(tokens);
      _currentTokens = tokens;
      _setupRefreshTimer();

      return tokens;
    } catch (e, stackTrace) {
      LoggerService.error('Login error', e, stackTrace);
    }

    return null;
  }

  @override
  Future<void> logout() async {
    // (await getIt.getAsync<AccountRepository>())
    var cookieManager = getIt<CookieManager>();
    var cookies = await cookieManager.cookieJar.loadForRequest(
      Uri.parse(AppConfig.instance.apiBaseUrl),
    );
    cookieManager.cookieJar.deleteAll();
    var cookieSecureStoreAge = getIt<CookieSecureStoreage>();
    cookieSecureStoreAge.deleteAll(cookies.map((e) => e.name).toList());
    await _secureStorage.deleteAll();
    // _currentTokens = null;
    _refreshTimer?.cancel();
  }

  @override
  Future<AuthTokens?> getAccessToken() async {
    _currentTokens ??= await _loadTokens();
    if (_currentTokens != null) {
      if (_currentTokens!.shouldRefresh) {
        final refreshed = await refreshToken();
        if (!refreshed) {
          return null;
        }
      }
      _setupRefreshTimer();
      return _currentTokens!;
    }
    return null;
  }

  Completer<bool>? refreshCompleter;

  @override
  Future<bool> refreshToken() async {
    if (refreshCompleter != null) {
      if (!refreshCompleter!.isCompleted) {
        await refreshCompleter!.future;
        if (_currentTokens != null && !_currentTokens!.shouldRefresh) {
          return true;
        }
      }
    } else {
      refreshCompleter = Completer<bool>();
    }
    if (refreshCompleter!.isCompleted) {
      refreshCompleter = Completer<bool>();
    }
    if (_currentTokens?.bearerRefreshToken == null) return false;

    try {
      var antiforgeryToken = await http.get(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/Antiforgery',
        options: DioOptions.Options(
          headers: {
            'Accept': 'application/json',
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
          },
          extra: {'noCredentials': true},
        ),
      );

      try {
        var grandToken = await http.post(
          '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/refresh',
          options: DioOptions.Options(
            headers: {
              'Accept': 'application/json',
              'X-CSRF-TOKEN': antiforgeryToken.data,
              // 'Authorization': 'Bearer ${_currentTokens!.bearerToken}',
              'X-Response-View': 'Json',
              'Content-Type': 'application/json',
              'cookie': '',
            },
            extra: {'noCredentials': true},
          ),
          data: {
            'AccessToken': _currentTokens!.bearerToken,
            'RefreshToken': _currentTokens!.bearerRefreshToken,
          },
        );
        final expiresAt = DateTime.now().add(Duration(minutes: 1440));

        final tokens = AuthTokens(
          bearerToken: grandToken.data["AccessToken"],
          bearerRefreshToken: grandToken.data["RefreshToken"],
          bearerExpiresAt: expiresAt,
          csrfToken: antiforgeryToken.data,
          isGuest: (_currentTokens?.isGuest ?? false),
        );

        await _saveTokens(tokens);
        _currentTokens = tokens;
        _setupRefreshTimer();

        refreshCompleter!.complete(true);

        return true;
      } catch (e) {
        if (_currentTokens != null) {
          await logout();
          await guestLogin();
        }
      }
    } catch (e, stackTrace) {
      LoggerService.error('Token refresh error', e, stackTrace);
    }

    if (!(refreshCompleter?.isCompleted ?? true)) {
      refreshCompleter!.complete(false);
    }
    return false;
  }

  @override
  Future<bool> isAuthenticated() async {
    final tokens = _currentTokens ?? await _loadTokens();
    return tokens != null && !tokens.isExpired;
  }

  @override
  Future<bool> isGuest() async {
    final tokens = _currentTokens ?? await _loadTokens();
    return tokens != null && tokens.isGuest;
  }

  Future<AuthTokens?> _loadTokens() async {
    return _currentTokens;
    final bearerAccessToken = await _secureStorage.read(
      key: _keyBearerAccessToken,
    );

    final bearerRefreshToken = await _secureStorage.read(
      key: _keyBearerRefreshToken,
    );
    final bearerExpiresAtStr = await _secureStorage.read(key: _keyBearerExpiresAt);
    final csrfToken = await _secureStorage.read(key: _keyCsrfToken);
    final isGuest = await _secureStorage.read(key: _isGuestKey);
    if (
        bearerExpiresAtStr != null &&
        bearerAccessToken != null) {
      return AuthTokens(
        csrfToken: csrfToken,
        bearerToken: bearerAccessToken,
        bearerRefreshToken: bearerRefreshToken,
        bearerExpiresAt: DateTime.parse(bearerExpiresAtStr),
        isGuest: (bool.tryParse(isGuest ?? '') ?? true),
      );
    }
    return null;
  }

  Future<void> _saveTokens(AuthTokens tokens) async {
    // await _secureStorage.write(
    //   key: _keyBearerAccessToken,
    //   value: tokens.bearerToken,
    // );

    // await _secureStorage.write(
    //   key: _keyBearerRefreshToken,
    //   value: tokens.bearerRefreshToken,
    // );

    // await _secureStorage.write(
    //   key: _keyBearerExpiresAt,
    //   value: tokens.bearerExpiresAt!.toIso8601String(),
    // );

    // await _secureStorage.write(key: _keyCsrfToken, value: tokens.csrfToken);
    // await _secureStorage.write(
    //   key: _isGuestKey,
    //   value: tokens.isGuest.toString(),
    // );
  }

  void _setupRefreshTimer() {
    _refreshTimer?.cancel();

    if (_currentTokens != null) {
      final timeUntilExpiry = _currentTokens!.firstExpiredAt.difference(
        DateTime.now(),
      );
      final refreshTime = timeUntilExpiry - const Duration(seconds: 30);

      if (refreshTime.isNegative) {
        refreshToken();
      } else {
        _refreshTimer = Timer(refreshTime, () async {
          await refreshToken();
        });
      }
    }
  }

  // Token'dan kullanıcı bilgilerini alma
  Map<String, dynamic>? getTokenClaims() {
    if (_currentTokens?.bearerToken != null) {
      return JwtDecoder.decode(_currentTokens!.bearerToken!);
    }
    return null;
  }

  Future<String?> getCsrfToken() async {
    var accessTokens = await getAccessToken();
    if (accessTokens != null) {
      var antiforgeryToken = await http.get(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/Antiforgery',
        options: DioOptions.Options(
          headers: {
            'Accept': 'application/json',
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
          },
          // Cookielerin doğru şekilde saklanabilmesi için 'noCredentials' false yapılmalı
          extra: {'noCredentials': false},
        ),
      );

      // CSRF tokenı kaydet (yeniden kullanılabilir olması için)
      accessTokens = AuthTokens(
        bearerToken: accessTokens.bearerToken,
        bearerRefreshToken: accessTokens.bearerRefreshToken,
        bearerExpiresAt: accessTokens.bearerExpiresAt,
        csrfToken: antiforgeryToken.data,
        isGuest: accessTokens.isGuest,
      );

      await _saveTokens(accessTokens);
      _currentTokens = accessTokens;

      return antiforgeryToken.data;
    }
    return null;
  }
}
