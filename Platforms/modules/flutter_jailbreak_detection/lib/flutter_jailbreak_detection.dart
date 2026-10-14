import 'flutter_jailbreak_detection_platform_interface.dart';

class FlutterJailbreakDetection {
  Future<String?> getPlatformVersion() {
    return FlutterJailbreakDetectionPlatform.instance.getPlatformVersion();
  }

  Future<bool> get jailbroken async {
    bool? jailbroken =
        await FlutterJailbreakDetectionPlatform.instance.jailbroken;
    return jailbroken ?? true;
  }

  Future<bool> get developerMode async {
    bool? developerMode =
        await FlutterJailbreakDetectionPlatform.instance.developerMode;
    return developerMode ?? true;
  }

  Future<bool> get isRealDevice async {
    bool? developerMode =
        await FlutterJailbreakDetectionPlatform.instance.isRealDevice;
    return developerMode ?? true;
  }

  Future<bool> get hasCorrectlyInstalled async {
    bool? developerMode =
        await FlutterJailbreakDetectionPlatform.instance.hasCorrectlyInstalled;
    return developerMode ?? true;
  }

  Future<List<String>?> get getAppSignature async {
    List<String>? developerMode =
        await FlutterJailbreakDetectionPlatform.instance.getAppSignature;
    return developerMode;
  }
}
