import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_user_app/core/services/apns_notification_bridge.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('multi_tenant_commerce/apns_v1');
  const codec = StandardMethodCodec();
  late List<String> tokens;
  late List<Map<String, dynamic>> opened;
  late List<Map<String, dynamic>> messages;
  late Map<String, dynamic> native;
  late ApnsNotificationBridge bridge;
  var permission = true;
  var getTokenCalls = 0;

  Future<void> event(String method, dynamic arguments) async {
    final response = Completer<void>();
    await binding.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      codec.encodeMethodCall(MethodCall(method, arguments)),
      (data) {
        try {
          codec.decodeEnvelope(data!);
          response.complete();
        } catch (error, stack) {
          response.completeError(error, stack);
        }
      },
    );
    await response.future;
  }

  setUp(() {
    tokens = [];
    opened = [];
    messages = [];
    permission = true;
    getTokenCalls = 0;
    native = {
      'transport': 'Apns',
      'environment': 'Production',
      'bundleId': 'com.example.tenant',
      'developmentTeam': 'ABC123DEFG',
      'authorized': true,
      'token': 'AABB',
    };
    bridge = ApnsNotificationBridge(
      expectedBundle: 'com.example.tenant',
      expectedTeam: 'ABC123DEFG',
      channel: channel,
      onToken: (token) async => tokens.add(token),
      onOpened: (message) async => opened.add(message),
      onMessage: messages.add,
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      switch (call.method) {
        case 'initialize':
          return native;
        case 'permission':
          return permission;
        case 'getToken':
          getTokenCalls++;
          return 'bbcc';
        case 'initialMessage':
          return {
            'data': {'action_link': 'https://shop.example.com/order'},
          };
      }
      return null;
    });
  });
  tearDown(
    () =>
        binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null),
  );

  group('APNs registration codec', () {
    test(
      'canonicalizes variable-length device bytes without a bundle supplied by the client',
      () {
        expect(
          ApnsNotificationBridge.encode('AABB'),
          'apns-v1:production:aabb',
        );
        expect(
          ApnsNotificationBridge.encode('aabbcc'),
          'apns-v1:production:aabbcc',
        );
        for (final value in ['', 'abc', 'aabb/../', 'a' * 514, 'abc\n']) {
          expect(
            () => ApnsNotificationBridge.encode(value),
            throwsFormatException,
          );
        }
      },
    );
  });
  group('Native tenant identity and permission', () {
    test(
      'requires matching installed bundle, team, transport and environment before using a device token',
      () async {
        for (final replacement in [
          {'bundleId': 'com.other.tenant'},
          {'developmentTeam': 'FOREIGN123'},
          {'environment': 'Sandbox'},
          {'transport': 'Fcm'},
          {'authorized': 'true'},
        ]) {
          final original = Map<String, dynamic>.from(native);
          native.addAll(replacement);
          await expectLater(bridge.initialize(), throwsStateError);
          expect(tokens, isEmpty);
          native = original;
        }
      },
    );
    test(
      'uses only a fresh native device token and stops reading it after permission is revoked',
      () async {
        final state = await bridge.initialize();
        expect(state.authorized, isTrue);
        expect(state.token, 'apns-v1:production:aabb');
        expect(await bridge.getToken(), 'apns-v1:production:bbcc');
        permission = false;
        expect(await bridge.getToken(), isNull);
        expect(getTokenCalls, 1);
      },
    );
    test(
      'does not return an old token when native permission is denied',
      () async {
        native['authorized'] = false;
        final state = await bridge.initialize();
        expect(state.authorized, isFalse);
        expect(state.token, isNull);
      },
    );
    test(
      'holds an early registration callback until native identity is verified',
      () async {
        binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          call,
        ) async {
          if (call.method == 'initialize') {
            await event('token', 'ccdd');
            return {...native, 'token': null};
          }
          return null;
        });
        final state = await bridge.initialize();
        expect(state.token, 'apns-v1:production:ccdd');
        expect(tokens, isEmpty);
      },
    );
    test(
      'coalesces concurrent initialization so consent is not requested twice',
      () async {
        final gate = Completer<Map<String, dynamic>>();
        var calls = 0;
        binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          call,
        ) async {
          calls++;
          return gate.future;
        });
        final first = bridge.initialize();
        final second = bridge.initialize();
        await Future<void>.delayed(Duration.zero);
        expect(calls, 1);
        gate.complete(native);
        await Future.wait([first, second]);
      },
    );
  });
  group('Native notification events', () {
    test(
      'routes token renewal, foreground and opened data through the selected native channel',
      () async {
        await bridge.initialize();
        await event('token', 'CCDD');
        await event('message', {
          'data': {'Type': 'order'},
        });
        await event('opened', {
          'data': {'action_link': 'https://shop.example.com/order'},
        });
        expect(tokens, ['apns-v1:production:ccdd']);
        expect(messages.single['data'], {'Type': 'order'});
        expect(opened.single['data'], {
          'action_link': 'https://shop.example.com/order',
        });
        expect((await bridge.initialMessage())?['data'], {
          'action_link': 'https://shop.example.com/order',
        });
      },
    );
  });
}
