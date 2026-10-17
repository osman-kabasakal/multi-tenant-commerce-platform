import 'package:store_user_app/core/config/local_demo.dart';
import 'package:synchronized/synchronized.dart';
// lib/core/auth/auth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
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

  DateTime get firstExpiredAt {
    final expiry = getTokenClaims()?['exp'];
    if (expiry is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        expiry.toInt() * 1000,
        isUtc: true,
      );
    }
    return bearerExpiresAt ?? DateTime.now().add(const Duration(minutes: 1400));
  }

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
  static const _sessionKey = 'commerce.auth.session.v1';
  final _credentialWrites = Lock();

  final EventBus eventBus;
  final Dio http;

  // final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage;
  AuthTokens? _tokenBackstage;
  AuthTokens? _endedTokens;
  int _sessionVersion = 0;
  bool _loggingOut = false;
  set _currentTokens(AuthTokens? value) {
    final previous = _tokenBackstage ?? _endedTokens;
    if (value != null &&
        (_tokenBackstage == null ||
            _tokenBackstage!.bearerToken != value.bearerToken ||
            _tokenBackstage!.bearerRefreshToken != value.bearerRefreshToken)) {
      eventBus.publish(
        AuthTokensRefreshEvent(entity: value, oldTokens: previous),
      );
    }
    _tokenBackstage = value;
    if (value != null) _endedTokens = null;
  }

  AuthTokens? get _currentTokens => _tokenBackstage;

  AuthTokens? get currentTokens => _currentTokens;

  Timer? _refreshTimer;

  AuthService(this._secureStorage, this.http, this.eventBus) {
    if (kDebugMode) {
      var _ = true;
    }
  }

  @override
  Future<AuthTokens?> login(String email, String password) async {
    if (_loggingOut) return null;
    final session = ++_sessionVersion;
    try {
      var antiforgeryToken = await http.get(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/Antiforgery',
        options: Options(
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
        options: Options(
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
        options: Options(
          headers: {
            'Accept': 'application/json',
            'X-CSRF-TOKEN': antiforgeryToken.data,
            'Authorization':
                'Bearer ${_currentTokens?.bearerToken ?? grandToken.data["AccessToken"]}',
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

      if (_loggingOut || session != _sessionVersion) return null;
      await _saveTokens(tokens, session);
      if (_loggingOut || session != _sessionVersion) return null;
      _currentTokens = tokens;
      _setupRefreshTimer();

      return tokens;
    } catch (e, stackTrace) {
      LoggerService.error('Login error', e, stackTrace);
    }

    return null;
  }

  Future<void> init() async {
    final session = _sessionVersion;
    // Token'ları yükle ve gerekiyorsa yenile
    var tokens = await _loadTokens();
    if (_loggingOut || session != _sessionVersion) return;
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
    if (_loggingOut) return null;
    final session = ++_sessionVersion;
    try {
      var antiforgeryToken = await http.get(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/Antiforgery',
        options: Options(
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
        options: Options(
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

      if (_loggingOut || session != _sessionVersion) return null;
      await _saveTokens(tokens, session);
      if (_loggingOut || session != _sessionVersion) return null;
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
    _loggingOut = true;
    _sessionVersion++;
    _endedTokens = _tokenBackstage ?? _endedTokens;
    _tokenBackstage = null;
    _refreshTimer?.cancel();
    if (!(refreshCompleter?.isCompleted ?? true)) {
      refreshCompleter!.complete(false);
    }
    refreshCompleter = null;
    eventBus.publish(AuthSessionEndedEvent());
    try {
      final cookieManager = getIt<CookieManager>();
      final cookies = await cookieManager.cookieJar.loadForRequest(
        Uri.parse(AppConfig.instance.apiBaseUrl),
      );
      await cookieManager.cookieJar.deleteAll();
      await getIt<CookieSecureStoreage>().deleteAll(
        cookies.map((e) => e.name).toList(),
      );
      await _credentialWrites.synchronized(() => _secureStorage.deleteAll());
    } finally {
      _loggingOut = false;
    }
  }

  @override
  Future<AuthTokens?> getAccessToken() async {
    if (_loggingOut) return null;
    final session = _sessionVersion;
    if (_currentTokens == null) {
      final loaded = await _loadTokens();
      if (_loggingOut || session != _sessionVersion) return null;
      _currentTokens = loaded;
    }
    if (_currentTokens == null) return null;
    if (_currentTokens!.shouldRefresh && !await refreshToken()) return null;
    if (_loggingOut || session != _sessionVersion) return null;
    _setupRefreshTimer();
    return _currentTokens;
  }

  Completer<bool>? refreshCompleter;

  @override
  Future<bool> refreshToken() async {
    final previous = _currentTokens;
    if (_loggingOut || previous?.bearerRefreshToken == null) return false;
    if (refreshCompleter != null && !refreshCompleter!.isCompleted) {
      return refreshCompleter!.future;
    }
    final session = _sessionVersion;
    final operation = Completer<bool>();
    refreshCompleter = operation;
    var success = false;
    try {
      final antiforgery = await http.get(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/Antiforgery',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
          },
          extra: {'noCredentials': true},
        ),
      );
      final reply = await http.post(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/refresh',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'X-CSRF-TOKEN': antiforgery.data,
            'X-Response-View': 'Json',
            'Content-Type': 'application/json',
            'cookie': '',
          },
          extra: {'noCredentials': true},
        ),
        data: {
          'AccessToken': previous!.bearerToken,
          'RefreshToken': previous.bearerRefreshToken,
        },
      );
      if (_loggingOut || session != _sessionVersion) return false;
      final tokens = AuthTokens(
        bearerToken: reply.data['AccessToken'],
        bearerRefreshToken: reply.data['RefreshToken'],
        bearerExpiresAt: DateTime.now().add(const Duration(minutes: 1440)),
        csrfToken: antiforgery.data,
        isGuest: previous.isGuest,
      );
      await _saveTokens(tokens, session);
      if (_loggingOut || session != _sessionVersion) return false;
      _currentTokens = tokens;
      _setupRefreshTimer();
      success = true;
    } catch (_) {
      if (!_loggingOut &&
          session == _sessionVersion &&
          _currentTokens != null) {
        await logout();
        await guestLogin();
      }
    } finally {
      if (!operation.isCompleted) operation.complete(success);
      if (identical(refreshCompleter, operation)) refreshCompleter = null;
    }
    return success;
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

  String get _storeOrigin =>
      AppConfig.instance.apiBaseUrl.replaceFirst(RegExp(r'/+$'), '');

  Future<AuthTokens?> _loadTokens() async {
    if (_loggingOut) return null;
    return _credentialWrites.synchronized(() async {
      if (_loggingOut) return null;
      final value = await _secureStorage.read(key: _sessionKey);
      if (value == null) return null;
      try {
        final data = jsonDecode(value);
        if (data is! Map<String, dynamic> ||
            data['origin'] != _storeOrigin ||
            data['tenantHost'] !=
                (LocalDemo.enabled ? LocalDemo.tenantHost : '') ||
            data['tenant'] != const String.fromEnvironment('TENANT_ID') ||
            data['bearer'] is! String ||
            (data['bearer'] as String).isEmpty ||
            data['refresh'] is! String ||
            data['guest'] is! bool) {
          return null;
        }
        final tokens = AuthTokens(
          bearerToken: data['bearer'],
          bearerRefreshToken: data['refresh'],
          csrfToken: data['csrf'] as String?,
          isGuest: data['guest'] as bool,
        );
        if (tokens.getTokenClaims()?['exp'] is! num) return null;
        return tokens;
      } catch (_) {
        return null;
      }
    });
  }

  Future<void> _saveTokens(AuthTokens tokens, int session) async {
    await _credentialWrites.synchronized(() async {
      if (_loggingOut || session != _sessionVersion) return;
      await _secureStorage.write(
        key: _sessionKey,
        value: jsonEncode({
          'origin': _storeOrigin,
          'tenantHost': LocalDemo.enabled ? LocalDemo.tenantHost : '',
          'tenant': const String.fromEnvironment('TENANT_ID'),
          'bearer': tokens.bearerToken,
          'refresh': tokens.bearerRefreshToken,
          'csrf': tokens.csrfToken,
          'guest': tokens.isGuest,
        }),
      );
    });
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
    final session = _sessionVersion;
    var accessTokens = await getAccessToken();
    if (accessTokens != null) {
      var antiforgeryToken = await http.get(
        '${AppConfig.instance.apiBaseUrl}/TenantTokenWeb/Antiforgery',
        options: Options(
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

      if (_loggingOut || session != _sessionVersion) return null;
      await _saveTokens(accessTokens, session);
      if (_loggingOut || session != _sessionVersion) return null;
      _currentTokens = accessTokens;

      return antiforgeryToken.data;
    }
    return null;
  }
}
