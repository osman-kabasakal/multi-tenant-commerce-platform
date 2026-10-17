import 'dart:typed_data';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_user_app/core/services/cache/cache_freshness_service.dart';
import 'package:store_user_app/core/services/fcm_service.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';

class _Components extends Fake implements ComponentRepository {}

class _Freshness extends Fake implements CacheFreshnessService {}

class _Server implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  final bodies = <String>[];
  var statusCode = 200;
  var responseBody = '""';
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? stream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    bodies.add(await utf8.decoder.bind(stream!).join());
    return ResponseBody.fromString(
      responseBody,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const configured = String.fromEnvironment('IOS_PUSH_TRANSPORT') == 'Apns';
  if (!configured) {
    test(
      'APNs build registration',
      () {},
      skip:
          'Run with the APNs public build defines documented in docs/MOBILE_NOTIFICATIONS.md.',
    );
    return;
  }
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('multi_tenant_commerce/apns_v1');
  const identity = String.fromEnvironment('MOBILE_IDENTITY_ID');
  late FCMService service;
  late _Server server;
  var authorized = true;
  final logLevel = Logger.level;
  setUpAll(() => Logger.level = Level.off);
  tearDownAll(() => Logger.level = logLevel);
  setUp(() {
    expect(identity, '123456781234123412341234567890ab');
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    FlutterSecureStorage.setMockInitialValues({});
    authorized = true;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      switch (call.method) {
        case 'initialize':
          return {
            'transport': 'Apns',
            'environment': 'Production',
            'bundleId': 'com.example.tenant',
            'developmentTeam': 'ABC123DEFG',
            'authorized': authorized,
            'token': 'AABB',
          };
        case 'permission':
          return authorized;
      }
      return null;
    });
    server = _Server();
    final dio = Dio(BaseOptions(baseUrl: 'https://shop.example.test'))
      ..httpClientAdapter = server;
    service = FCMService(
      _Components(),
      const FlutterSecureStorage(),
      dio,
      _Freshness(),
    );
  });
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });
  test(
    'a versioned native APNs registration reaches the actual receiver endpoint',
    () async {
      await service.initialize();
      expect(service.isInitialized, isTrue);
      expect(server.requests, hasLength(1));
      expect(
        server.requests.single.path,
        '/PushNotifications/ProcessRegistration',
      );
      expect(
        server.requests.single.contentType,
        Headers.formUrlEncodedContentType,
      );
      expect(Uri.splitQueryString(server.bodies.single), {
        'success': 'true',
        'value': 'apns-v2:production:$identity:aabb',
      });
      expect(
        await service.getSecureToken(),
        'apns-v2:production:$identity:aabb',
      );
    },
  );
  test(
    'denying native permission disables the receiver without uploading a device token',
    () async {
      authorized = false;
      await service.initialize();
      expect(server.requests, hasLength(1));
      expect(Uri.splitQueryString(server.bodies.single), {
        'success': 'false',
        'value': 'Permission denied',
      });
    },
  );
  test(
    'a versioned build refuses registrations for a foreign identity or the legacy topic',
    () async {
      await service.initialize();
      server.requests.clear();
      await service.saveTokenToServer(
        'apns-v2:production:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa:aabb',
      );
      await service.saveTokenToServer('apns-v1:production:aabb');
      await service.saveTokenToServer('apns-v2:production:$identity:abc');
      expect(server.requests, isEmpty);
    },
  );
  test(
    'a temporary receiver endpoint failure is retried on the next foreground initialization',
    () async {
      server.statusCode = 503;
      await service.initialize();
      expect(server.requests, hasLength(1));
      server.statusCode = 200;
      await service.initialize();
      expect(server.requests, hasLength(2));
      expect(
        Uri.splitQueryString(server.bodies.last)['value'],
        'apns-v2:production:$identity:aabb',
      );
    },
  );
  test('release diagnostics identify HTTP failure without leaking device or response data', () async {
    final original = debugPrint;
    final messages = <String>[];
    debugPrint = (String? message, {int? wrapWidth}) => messages.add(message ?? '');
    try {
      server.statusCode = 503;
      server.responseBody = '"sensitive-server-body"';
      await service.initialize();
      final output = messages.join('\n');
      expect(output, contains('stage=apns_identity_verified authorized=true'));
      expect(output, contains('stage=receiver_failed'));
      expect(output, contains('status=503'));
      expect(output, isNot(contains('aabb')));
      expect(output, isNot(contains('sensitive-server-body')));
      expect(output, isNot(contains(identity)));
    } finally {
      debugPrint = original;
    }
  });
  test('concurrent startup and foreground refresh register the current customer only once', () async {
    await Future.wait([service.initialize(), service.initialize()]);
    expect(server.requests, hasLength(1));
  });

}
