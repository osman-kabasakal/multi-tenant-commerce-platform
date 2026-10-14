import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceSecurityService {
  static Future<bool> isDeviceSecure() async {
    try {
      FlutterJailbreakDetection jailbreakDetection =
          FlutterJailbreakDetection();
      if (Platform.isAndroid || Platform.isIOS) {
        // Check for jailbreak/root
        final jailbroken = await jailbreakDetection.jailbroken;

        // Check for emulator
        final emulatorDetection = await jailbreakDetection.developerMode;

        // Check for tampering
        final tamperingDetection = await _detectTampering(jailbreakDetection);

        // Optional: Allow emulator in debug mode for development
        if (kDebugMode && emulatorDetection) {
          return true;
        }

        return !jailbroken && !tamperingDetection;
      }

      // For other platforms
      return false;
    } catch (ex) {
      return false;
    }
  }

  static Future<bool> _detectTampering(
    FlutterJailbreakDetection jailbreakDetection,
  ) async {
    var connectivity = Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    // Implement app signature verification
    // if (Platform.isAndroid) {
    //   var certSignatureSHA256 = await jailbreakDetection.getAppSignature;
    //   var sha256 = const String.fromEnvironment('APP_SIGNATURE_SHA256');
    //   var sh256Array = sha256.split(',');
    //   return !(await _verifyPackageName()) ||
    //       !(certSignatureSHA256 != null &&
    //           certSignatureSHA256.any((sha) => sh256Array.contains(sha)));
    // }

    //package verification
    return !(await _verifyPackageName());
  }

  static Future<bool> _verifyPackageName() async {
    var packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      return packageInfo.packageName ==
          const String.fromEnvironment('PACKAGE_NAME_ANDROID');
    } else if (Platform.isIOS) {
      return packageInfo.packageName ==
          const String.fromEnvironment('PACKAGE_NAME_IOS');
    }
    return false;
  }
}
