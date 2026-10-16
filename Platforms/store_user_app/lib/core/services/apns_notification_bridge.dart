import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ApnsRegistration {
  const ApnsRegistration(this.authorized, this.token);
  final bool authorized;
  final String? token;
}

/// Native APNs registration for the public tenant identity selected at build time.
class ApnsNotificationBridge {
  ApnsNotificationBridge({
    required this.onToken,
    required this.onOpened,
    required this.onMessage,
    this.channel = const MethodChannel('multi_tenant_commerce/apns_v1'),
    this.expectedBundle = const String.fromEnvironment('PACKAGE_NAME_IOS'),
    this.expectedTeam = const String.fromEnvironment('IOS_DEVELOPMENT_TEAM'),
  });

  static bool get enabled =>
      !kIsWeb &&
      defaultTargetPlatform == TargetPlatform.iOS &&
      const String.fromEnvironment('IOS_PUSH_TRANSPORT', defaultValue: 'Fcm') ==
          'Apns';
  static const prefix = 'apns-v1:production:';
  final MethodChannel channel;
  final String expectedBundle;
  final String expectedTeam;
  final Future<void> Function(String) onToken;
  final Future<void> Function(Map<String, dynamic>) onOpened;
  final void Function(Map<String, dynamic>) onMessage;
  bool _verified = false;
  String? _pendingToken;
  Future<ApnsRegistration>? _initializing;

  static String encode(String token) {
    if (token.length < 2 ||
        token.length > 512 ||
        token.length.isOdd ||
        !RegExp(r'^[a-fA-F0-9]+$').hasMatch(token)) {
      throw const FormatException('Invalid APNs device token.');
    }
    return prefix + token.toLowerCase();
  }

  Future<ApnsRegistration> initialize() {
    final pending = _initializing;
    if (pending != null) return pending;
    final operation = _initialize();
    _initializing = operation;
    return operation.whenComplete(() => _initializing = null);
  }

  Future<ApnsRegistration> _initialize() async {
    channel.setMethodCallHandler(_receive);
    final result = await channel.invokeMapMethod<String, dynamic>('initialize');
    if (result == null ||
        result['transport'] != 'Apns' ||
        result['environment'] != 'Production' ||
        expectedBundle.isEmpty ||
        !RegExp(r'^[A-Z0-9]{10}$').hasMatch(expectedTeam) ||
        result['bundleId'] != expectedBundle ||
        result['developmentTeam'] != expectedTeam ||
        result['authorized'] is! bool) {
      _verified = false;
      _pendingToken = null;
      throw StateError(
        'Native APNs identity does not match this tenant build.',
      );
    }
    _verified = true;
    final allowed = result['authorized'] as bool;
    final token = result['token'] ?? _pendingToken;
    _pendingToken = null;
    return ApnsRegistration(
      allowed,
      allowed && token is String ? encode(token) : null,
    );
  }

  Future<void> _receive(MethodCall call) async {
    switch (call.method) {
      case 'token':
        final token = call.arguments;
        if (token is! String) {
          throw const FormatException('Invalid APNs registration event.');
        }
        encode(token);
        if (!_verified) {
          _pendingToken = token;
          return;
        }
        await onToken(encode(token));
      case 'opened':
        if (_verified && call.arguments is Map) {
          await onOpened(Map<String, dynamic>.from(call.arguments as Map));
        }
      case 'message':
        if (_verified && call.arguments is Map) {
          onMessage(Map<String, dynamic>.from(call.arguments as Map));
        }
      case 'registrationError':
        // Keep the application usable; the next foreground initialization retries registration.
        break;
    }
  }

  Future<bool> permission() async =>
      _verified && await channel.invokeMethod<bool>('permission') == true;
  Future<String?> getToken() async {
    if (!await permission()) return null;
    final token = await channel.invokeMethod<String>('getToken');
    return token == null ? null : encode(token);
  }

  Future<Map<String, dynamic>?> initialMessage() async {
    if (!_verified) return null;
    return channel.invokeMapMethod<String, dynamic>('initialMessage');
  }
}
