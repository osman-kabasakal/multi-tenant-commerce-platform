import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_jailbreak_detection_method_channel.dart';

abstract class FlutterJailbreakDetectionPlatform extends PlatformInterface {
  /// Constructs a FlutterJailbreakDetectionPlatform.
  FlutterJailbreakDetectionPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterJailbreakDetectionPlatform _instance =
      MethodChannelFlutterJailbreakDetection();

  /// The default instance of [FlutterJailbreakDetectionPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterJailbreakDetection].
  static FlutterJailbreakDetectionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterJailbreakDetectionPlatform] when
  /// they register themselves.
  static set instance(FlutterJailbreakDetectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> get jailbroken async {
    throw UnimplementedError('jailbroken has not been implemented.');
  }

  Future<bool> get developerMode async {
    throw UnimplementedError('developerMode has not been implemented.');
  }

  Future<bool> get isRealDevice async {
    throw UnimplementedError('developerMode has not been implemented.');
  }

  Future<bool> get hasCorrectlyInstalled async {
    throw UnimplementedError('developerMode has not been implemented.');
  }

  Future<List<String>?> get getAppSignature async {
    throw UnimplementedError('developerMode has not been implemented.');
  }
}
