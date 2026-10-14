import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_jailbreak_detection_platform_interface.dart';

/// An implementation of [FlutterJailbreakDetectionPlatform] that uses method channels.
class MethodChannelFlutterJailbreakDetection
    extends FlutterJailbreakDetectionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_jailbreak_detection');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  Future<bool> get jailbroken async {
    bool? jailbroken = await methodChannel.invokeMethod<bool>('jailbroken');
    return jailbroken ?? true;
  }

  Future<bool> get developerMode async {
    bool? developerMode = await methodChannel.invokeMethod<bool>(
      'developerMode',
    );
    return developerMode ?? true;
  }

  Future<bool> get isRealDevice async {
    bool? developerMode = await methodChannel.invokeMethod<bool>(
      'isRealDevice',
    );
    return developerMode ?? true;
  }

  Future<bool> get hasCorrectlyInstalled async {
    bool? developerMode = await methodChannel.invokeMethod<bool>(
      'hasCorrectlyInstalled',
    );
    return developerMode ?? true;
  }

  Future<List<String>?> get getAppSignature async {
    List<String>? sha256Signature = [];
    var object = await methodChannel.invokeMethod<List<dynamic>?>(
      'getAppSignature',
    );
    if (object != null && object.isNotEmpty) {
      for (var item in object) {
        sha256Signature.add(item.toString());
      }
    }
    return sha256Signature;
  }
}
