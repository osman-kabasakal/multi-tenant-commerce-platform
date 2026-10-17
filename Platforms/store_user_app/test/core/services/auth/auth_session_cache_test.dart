import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/storage/cookie_secure_storage.dart';

String token(String id, {int seconds = 3600, int serial = 0}) {
  String part(Map<String, dynamic> data) =>
      base64UrlEncode(utf8.encode(jsonEncode(data))).replaceAll('=', '');
  return '${part({'alg': 'none'})}.${part({'Guid': id, 'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + seconds, 'jti': serial})}.';
}

class Storage extends Fake implements FlutterSecureStorage {
  Completer<void>? gate, writing;
  final values = <String, String>{};
  bool saving = false;
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #deleteAll) {
      return (() async {
        await gate?.future;
        values.clear();
      })();
    }
    if (invocation.memberName == #read) {
      return Future<String?>.value(values[invocation.namedArguments[#key]]);
    }
    if (invocation.memberName == #write) {
      return (() async {
        saving = true;
        await writing?.future;
        values[invocation.namedArguments[#key] as String] =
            invocation.namedArguments[#value] as String;
        saving = false;
      })();
    }
    if (invocation.memberName == #delete) return Future<void>.value();
    return super.noSuchMethod(invocation);
  }
}

class AuthAdapter implements HttpClientAdapter {
  int guests = 0, refreshes = 0, serial = 0;
  Completer<void>? guestGate, refreshGate;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? data,
    Future<void>? cancel,
  ) async {
    Object value = 'local-xsrf';
    if (options.path.endsWith('/guest')) {
      guests++;
      await guestGate?.future;
      value = {
        'AccessToken': token('guest-$guests', serial: serial++),
        'RefreshToken': 'local-fixture',
      };
    }
    if (options.path.endsWith('/refresh')) {
      refreshes++;
      await refreshGate?.future;
      value = {
        'AccessToken': token('guest-$guests', serial: serial++),
        'RefreshToken': 'local-fixture',
      };
    }
    return ResponseBody.fromString(
      jsonEncode(value),
      200,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<void> until(bool Function() condition) async {
  final end = DateTime.now().add(const Duration(seconds: 2));
  while (!condition()) {
    if (DateTime.now().isAfter(end)) {
      fail('The isolated auth fixture timed out.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

void main() {
  late Storage storage;
  late AuthAdapter adapter;
  late AuthService auth;
  late Dio dio;
  late StreamSubscription<dynamic> subscription;
  final events = <dynamic>[];
  setUp(() async {
    await getIt.reset();
    events.clear();
    AppConfig.init(
      apiBaseUrl: 'https://fixture.invalid',
      enableLogging: false,
      environment: 'development',
      cacheExpirationDuration: const Duration(minutes: 10),
      storeLogo: '',
      appTitle: 'Fixture',
      appPackageName: 'dev.fixture',
    );
    storage = Storage();
    adapter = AuthAdapter();
    dio = Dio()..httpClientAdapter = adapter;
    getIt.registerSingleton<CookieManager>(CookieManager(CookieJar()));
    getIt.registerSingleton<CookieSecureStoreage>(
      CookieSecureStoreage(secureStorage: storage),
    );
    auth = AuthService(storage, dio, EventBus());
    subscription = EventBus().stream.listen(events.add);
  });
  tearDown(() async {
    if (storage.gate?.isCompleted == false) storage.gate!.complete();
    if (adapter.guestGate?.isCompleted == false) adapter.guestGate!.complete();
    if (adapter.refreshGate?.isCompleted == false) {
      adapter.refreshGate!.complete();
    }
    await auth.logout();
    await subscription.cancel();
    dio.close(force: true);
    await getIt.reset();
  });
  test('JWT expiry takes precedence over a guessed one-day expiry', () {
    final tokens = AuthTokens(
      bearerToken: token('fixture', seconds: 60),
      bearerExpiresAt: DateTime.now().add(const Duration(days: 1)),
      isGuest: true,
    );
    expect(tokens.shouldRefresh, isTrue);
    expect(
      tokens.firstExpiredAt.difference(DateTime.now()).inSeconds,
      lessThanOrEqualTo(60),
    );
  });
  test(
    'logout exposes no token while credential deletion is still pending',
    () async {
      expect(await auth.guestLogin(), isNotNull);
      storage.gate = Completer<void>();
      final loggingOut = auth.logout();
      await until(() => events.any((event) => event is AuthSessionEndedEvent));
      expect(await auth.getAccessToken(), isNull);
      expect(auth.currentTokens, isNull);
      storage.gate!.complete();
      await loggingOut;
      expect(await auth.getAccessToken(), isNull);
    },
  );
  test(
    'a guest response arriving after logout cannot restore the ended session',
    () async {
      adapter.guestGate = Completer<void>();
      final guest = auth.guestLogin();
      await until(() => adapter.guests == 1);
      await auth.logout();
      adapter.guestGate!.complete();
      expect(await guest, isNull);
      expect(auth.currentTokens, isNull);
    },
  );
  test(
    'an old refresh response cannot overwrite a new customer session',
    () async {
      await auth.guestLogin();
      adapter.refreshGate = Completer<void>();
      final old = auth.refreshToken();
      await until(() => adapter.refreshes == 1);
      await auth.logout();
      final next = await auth.guestLogin();
      expect(next!.guestId, 'guest-2');
      adapter.refreshGate!.complete();
      expect(await old, isFalse);
      expect((await auth.getAccessToken())!.guestId, 'guest-2');
    },
  );
  test(
    'simultaneous refresh callers share one request and are released on logout',
    () async {
      await auth.guestLogin();
      adapter.refreshGate = Completer<void>();
      final first = auth.refreshToken();
      await until(() => adapter.refreshes == 1);
      final second = auth.refreshToken();
      await auth.logout();
      expect(await second, isFalse);
      adapter.refreshGate!.complete();
      expect(await first, isFalse);
      expect(adapter.refreshes, 1);
    },
  );
  test(
    'the next guest event retains the prior identity for existing account cleanup handlers',
    () async {
      await auth.guestLogin();
      await auth.logout();
      await auth.guestLogin();
      await Future<void>.delayed(Duration.zero);
      final refreshed = events.whereType<AuthTokensRefreshEvent>().last;
      expect(refreshed.oldTokens!.guestId, 'guest-1');
      expect(refreshed.entity.guestId, 'guest-2');
    },
  );
  test(
    'a new service instance restores the secure session bundle without creating another guest',
    () async {
      await auth.guestLogin();
      final restarted = AuthService(storage, dio, EventBus());
      expect((await restarted.getAccessToken())!.guestId, 'guest-1');
      expect(adapter.guests, 1);
      await restarted.logout();
    },
  );
  test(
    'a persisted token is never restored for a different store origin',
    () async {
      await auth.guestLogin();
      AppConfig.init(
        apiBaseUrl: 'https://other.invalid',
        enableLogging: false,
        environment: 'development',
        cacheExpirationDuration: const Duration(minutes: 10),
        storeLogo: '',
        appTitle: 'Fixture',
        appPackageName: 'dev.fixture',
      );
      final restarted = AuthService(storage, dio, EventBus());
      expect(await restarted.getAccessToken(), isNull);
      await restarted.logout();
    },
  );
  test(
    'logout deletes a delayed earlier credential write rather than allowing it to resurrect the session',
    () async {
      storage.writing = Completer<void>();
      final signingIn = auth.guestLogin();
      await until(() => storage.saving);
      final loggingOut = auth.logout();
      storage.writing!.complete();
      expect(await signingIn, isNull);
      await loggingOut;
      expect(storage.values, isEmpty);
      expect(
        await AuthService(storage, dio, EventBus()).getAccessToken(),
        isNull,
      );
    },
  );
}
